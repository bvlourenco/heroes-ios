//
//  heroService.swift
//  Heroes
//
//  Created by Bernardo Vala Lourenço on 24/10/2023.
//

import Foundation
import UIKit

enum NetworkError: Error {
    case badUrl, serverError, decodingError, resourceNotFound,
         badRequest, internalError
}

enum CategoryTypes: String {
    case comics, stories, series, events
}

class HeroService {
    private let decoder = JSONDecoder()
    
    func getHeroes(offset: Int) async throws -> [Hero] {
        let data = try await performRequest(resourceURL:
                                                "http://gateway.marvel.com/v1/public/characters",
                                            limit: Constants.numberOfHeroesPerRequest,
                                            offset: offset)
        let heroes = try decoder.decode(Heroes.self, from: data)
        return heroes.heroes
    }
    
    func downloadImages(heroes: [Hero]) async throws -> [Hero] {
        return try await withThrowingTaskGroup(of: (Hero, Data?).self,
                                               body: { group in
            for hero in heroes {
                group.addTask { [self] in
                    let imageData = try await self.downloadImage(imageURL:
                                                                    hero.imageURL)
                    return (hero, imageData)
                }
            }
            
            var heroes: [Hero] = []
            for try await (var hero, imageData) in group {
                hero.imageData = imageData
                heroes.append(hero)
            }
            return heroes
        })
    }
    
    func getHeroDetails(hero: Hero) async throws -> Hero {
        // Task group
        return try await withThrowingTaskGroup(of: (String, String, String?).self,
                                        body: { group in
            
            addTasksToTaskGroup(heroCategory: hero.heroComics,
                                categoryType: CategoryTypes.comics,
                                group: &group)
            
            addTasksToTaskGroup(heroCategory: hero.heroStories,
                                categoryType: CategoryTypes.stories,
                                group: &group)
            
            addTasksToTaskGroup(heroCategory: hero.heroSeries,
                                categoryType: CategoryTypes.series,
                                group: &group)
            
            addTasksToTaskGroup(heroCategory: hero.heroEvents,
                                categoryType: CategoryTypes.events,
                                group: &group)
            
            var hero = hero
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
            
            return hero
        })
    }
    
    private func downloadImage(imageURL: String) async throws -> Data? {
        if imageURL.hasSuffix("image_not_available.jpg") {
            return nil
        } else if let url = URL(string: imageURL) {
            let (imageData, _) = try await URLSession.shared.data(from: url)
            return imageData
        } else {
            throw NetworkError.badUrl
        }
    }
    
    private func getCategoryDescriptionFromJson(data: Data) throws -> String? {
        if let json = try JSONSerialization.jsonObject(with: data,
                                                       options: []) as? [String: Any] {
            if let data = json["data"] as? AnyObject,
               let results = data["results"] as? AnyObject {
                return (results[0] as AnyObject)["description"] as? String
            }
        }
        throw NetworkError.decodingError
    }
    
    private func getCategoryDetails(resourceURL: String,
                                    categoryDetail: HeroCategoryDetails)
    async throws -> String? {
        let data = try await performRequest(resourceURL: resourceURL,
                                            limit: nil,
                                            offset: nil)
        return try getCategoryDescriptionFromJson(data: data)
    }
    
    private func addTasksToTaskGroup(heroCategory: [String:HeroCategoryDetails],
                                     categoryType: CategoryTypes,
                                     group: inout ThrowingTaskGroup<(String, String, String?), Error>) {
        for (resourceURL, category) in heroCategory {
            group.addTask { [self] in
                return (resourceURL,
                        categoryType.rawValue,
                        try await self.getCategoryDetails(resourceURL: resourceURL,
                                                          categoryDetail: category))
            }
        }
    }
    
    private func performRequest(resourceURL url: String, limit: Int?, offset: Int?)
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
