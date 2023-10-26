//
//  heroService.swift
//  Heroes
//
//  Created by Bernardo Vala Lourenço on 24/10/2023.
//

import Foundation

enum NetworkError: Error {
    case badUrl, serverError, decodingError, resourceNotFound,
         badRequest, internalError
}

enum CategoryTypes: String {
    case comics, stories, series, events
}

class HeroService {
    let decoder = JSONDecoder()
    
    func getHeroes(offset: Int) async throws -> [Hero] {
        let data = try await performRequest(resourceURL: 
                            "http://gateway.marvel.com/v1/public/characters",
                                            limit: 20, offset: offset)
        let heroes = try decoder.decode(Heroes.self, from: data)
        return heroes.heroes
    }
    
    func getCategoryDescriptionFromJson(_ data: Data) throws -> String? {
        if let json = try JSONSerialization.jsonObject(with: data, 
                                                       options: [])
                                                            as? [String: Any] {
            if let data = json["data"] as? AnyObject,
               let results = data["results"] as? AnyObject {
                return (results[0] as AnyObject)["description"] as? String
            }
        }
        throw NetworkError.decodingError
    }
    
    func getCategoryDetails(_ resourceURL: String,
                            _ categoryDetail: HeroCategoryDetails)
                                                      async throws -> String? {
        let data = try await performRequest(resourceURL: resourceURL,
                                            limit: nil,
                                            offset: nil)
        return try getCategoryDescriptionFromJson(data)
    }
    
    func getHeroDetails(_ hero: inout Hero) async throws {
        // Task group
        try await withThrowingTaskGroup(of: (String, String, String?).self, 
                                        body: { group in
            
            for (resourceURL, comic) in hero.heroComics {
                group.addTask { [self] in
                    return (resourceURL, 
                            CategoryTypes.comics.rawValue,
                            try await self.getCategoryDetails(resourceURL, 
                                                              comic))
                }
            }
            
            for (resourceURL, story) in hero.heroStories {
                group.addTask { [self] in
                    return (resourceURL, 
                            CategoryTypes.stories.rawValue,
                            try await self.getCategoryDetails(resourceURL, 
                                                              story))
                }
            }
            
            for (resourceURL, series) in hero.heroSeries {
                group.addTask { [self] in
                    return (resourceURL, 
                            CategoryTypes.series.rawValue,
                            try await self.getCategoryDetails(resourceURL, 
                                                              series))
                }
            }
            
            for (resourceURL, event) in hero.heroEvents {
                group.addTask { [self] in
                    return (resourceURL,
                            CategoryTypes.events.rawValue,
                            try await self.getCategoryDetails(resourceURL,
                                                              event))
                }
            }
            
            for try await (resourceURL, type, category) in group {
                switch type {
                case CategoryTypes.comics.rawValue:
                    hero.heroComics[resourceURL]!.description = category
                case CategoryTypes.stories.rawValue:
                    hero.heroStories[resourceURL]!.description = category
                case CategoryTypes.series.rawValue:
                    hero.heroSeries[resourceURL]!.description = category
                case CategoryTypes.events.rawValue:
                    hero.heroEvents[resourceURL]!.description = category
                default:
                    break
                }
            }
        })
    }
    
    func performRequest(resourceURL url: String, limit: Int?, offset: Int?) 
    async throws -> Data {
        guard var urlComponents = URLComponents(string: url) else {
            throw NetworkError.badUrl
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "apikey", value: Constants.apiKey),
            URLQueryItem(name: "hash", value: Constants.hash),
            URLQueryItem(name: "ts", value: Constants.timestamp)
        ]
        
        if let limit = limit {
            let queryItem = URLQueryItem(name: "limit", value: String(limit))
            urlComponents.queryItems?.append(queryItem)
        }
        if let offset = offset {
            let queryItem = URLQueryItem(name: "offset", value: String(offset))
            urlComponents.queryItems?.append(queryItem)
        }
        
        let (data, response) = try await URLSession.shared
            .data(from: urlComponents.url!)
        
        let httpResponse = response as? HTTPURLResponse
        switch httpResponse?.statusCode {
        case 200:
            break
        case 400:
            throw NetworkError.badRequest
        case 404:
            throw NetworkError.resourceNotFound
        case 500:
            throw NetworkError.serverError
        default:
            throw NetworkError.internalError
        }
        
        return data
    }
}
