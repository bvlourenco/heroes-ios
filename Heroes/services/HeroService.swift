//
//  heroService.swift
//  Heroes
//
//  Created by Bernardo Vala Lourenço on 24/10/2023.
//

import Foundation

enum NetworkError: Error {
    case badUrl
    case serverError
    case decodingError
}

class HeroService {
    
    private func extractImageURL(_ hero: [String: Any]) -> String {
        // TODO: AnyObject = class Object in Java = BAD!!!
        let image = hero["thumbnail"] as AnyObject
        let imagePath = image["path"]! as? String ?? ""
        let imageExtension = image["extension"]! as? String ?? ""
        return imagePath + "." + imageExtension
    }
    
    private func getItemsFromList(_ type: String, _ hero: [String: Any]) -> [HeroCategoryDetails] {
        var heroItems: [HeroCategoryDetails] = []
        let items = (hero[type] as AnyObject)["items"] as? [[String: Any]]
        
        for (index, item) in items!.enumerated() {
            if index == 3 {
                break
            }
            
            let name = item["name"] as? String ?? ""
            let url = item["resourceURI"] as? String ?? ""
            heroItems.append(HeroCategoryDetails(resourceURL: url, name: name, description: nil))
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
                        
                        let heroComics = getItemsFromList("comics", hero)
                        let heroEvents = getItemsFromList("events", hero)
                        let heroStories = getItemsFromList("stories", hero)
                        let heroSeries = getItemsFromList("series", hero)
                        
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
    
    func getCategoryDetails(_ heroCategoryDetails: inout [HeroCategoryDetails]) async throws {
        for (index, categoryDetail) in heroCategoryDetails.enumerated() {
            let data = try await performRequest(resourceURL: categoryDetail.resourceURL)
            let description = try getCategoryDescriptionFromJson(data)
            heroCategoryDetails[index].setDescription(description)
        }
    }
    
    func getHeroDetails(_ hero: inout Hero) async throws {
        // TODO: I can do these requests at the same time!!!
        try await getCategoryDetails(&hero.heroComics)
        try await getCategoryDetails(&hero.heroEvents)
        try await getCategoryDetails(&hero.heroSeries)
        try await getCategoryDetails(&hero.heroStories)
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
