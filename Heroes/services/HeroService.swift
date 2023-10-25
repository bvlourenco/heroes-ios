//
//  heroService.swift
//  Heroes
//
//  Created by Bernardo Vala Lourenço on 24/10/2023.
//

import Foundation

enum NetworkError: Error {
    case badUrl, serverError, decodingError
}

enum CategoryTypes: String {
    case comics, stories, series, events
}

class HeroService {
    
    private func extractImageURL(_ hero: [String: Any]) -> String {
        // TODO: AnyObject = class Object in Java = BAD!!!
        let image = hero["thumbnail"] as AnyObject
        let imagePath = image["path"]! as? String ?? ""
        let imageExtension = image["extension"]! as? String ?? ""
        return imagePath + "." + imageExtension
    }
    
    private func getItemsFromList(_ type: String, _ hero: [String: Any]) -> [String:HeroCategoryDetails] {
        var heroItems: [String:HeroCategoryDetails] = [:]
        let items = (hero[type] as AnyObject)["items"] as? [[String: Any]]
        
        for (index, item) in items!.enumerated() {
            if index == 3 {
                break
            }
            
            let name = item["name"] as? String ?? ""
            let url = item["resourceURI"] as? String ?? ""
            heroItems[url] = HeroCategoryDetails(name: name, description: nil)
        }
        return heroItems
    }
    
    private func getHeroesFromJson(_ data: Data) -> [Hero] {
        var heroes: [Hero] = []
        
        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                if let data = json["data"] as? [String: Any],
                   let results = data["results"] as? [[String: Any]] {
                    for hero in results {
                        let name = hero["name"] as? String ?? ""
                        let description = hero["description"] as? String ?? ""
                        let imageURL = extractImageURL(hero)
                        
                        let heroComics = getItemsFromList(CategoryTypes.comics.rawValue, hero)
                        let heroEvents = getItemsFromList(CategoryTypes.events.rawValue, hero)
                        let heroStories = getItemsFromList(CategoryTypes.stories.rawValue, hero)
                        let heroSeries = getItemsFromList(CategoryTypes.series.rawValue, hero)
                        
                        heroes.append(Hero(name: name, 
                                           description: description,
                                           imageURL: imageURL,
                                           heroComics: heroComics,
                                           heroEvents: heroEvents,
                                           heroStories: heroStories,
                                           heroSeries: heroSeries))
                    }
                }
            }
        } catch {
            print("Could not parse JSON. Error: \(error)")
        }
        
        return heroes
    }
    
    func getHeroes() async throws -> [Hero] {
        let data = try await performRequest(resourceURL: "http://gateway.marvel.com/v1/public/characters")
        
        let heroes = getHeroesFromJson(data)
        
        return heroes
    }
    
    func getCategoryDescriptionFromJson(_ data: Data) throws -> String? {
        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
            if let data = json["data"] as? AnyObject,
               let results = data["results"] as? AnyObject {
                return (results[0] as AnyObject)["description"] as? String
            }
        }
        throw NetworkError.decodingError
    }
    
    func getCategoryDetails(_ resourceURL: String, _ categoryDetail: HeroCategoryDetails) async throws -> String? {
        let data = try await performRequest(resourceURL: resourceURL)
        return try getCategoryDescriptionFromJson(data)
    }
    
    func getHeroDetails(_ hero: inout Hero) async throws {
        // Task group
        try await withThrowingTaskGroup(of: (String, String, String?).self, body: { group in
            
            for (resourceURL, comic) in hero.heroComics {
                group.addTask { [self] in
                    return (resourceURL, CategoryTypes.comics.rawValue, try await self.getCategoryDetails(resourceURL, comic))
                }
            }
            
            for (resourceURL, story) in hero.heroStories {
                group.addTask { [self] in
                    return (resourceURL, CategoryTypes.stories.rawValue, try await self.getCategoryDetails(resourceURL, story))
                }
            }
            
            for (resourceURL, series) in hero.heroSeries {
                group.addTask { [self] in
                    return (resourceURL, CategoryTypes.series.rawValue, try await self.getCategoryDetails(resourceURL, series))
                }
            }
            
            for (resourceURL, event) in hero.heroEvents {
                group.addTask { [self] in
                    return (resourceURL, CategoryTypes.events.rawValue, try await self.getCategoryDetails(resourceURL, event))
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
    
    func performRequest(resourceURL url: String) async throws -> Data {
        guard var urlComponents = URLComponents(string: url) else {
            throw NetworkError.badUrl
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "apikey", value: Constants.apiKey),
            URLQueryItem(name: "hash", value: Constants.hash),
            URLQueryItem(name: "ts", value: Constants.timestamp)
        ]
        
        let (data, response) = try await URLSession.shared.data(from: urlComponents.url!)
        
        // TODO: Handle better other status code (400, 500, etc...)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw NetworkError.serverError
        }
        
        return data
    }
}
