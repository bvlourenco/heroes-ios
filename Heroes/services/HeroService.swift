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
         badRequest, appError
}

enum CategoryTypes: String {
    case comics, stories, series, events
}

class HeroService: HeroServiceProtocol {
    private let decoder = JSONDecoder()
    
    func getHeroes(offset: Int, numberOfHeroesPerRequest: Int) async -> [Hero] {
        var heroes: [Hero] = []
        
        await performRequest(resourceURL: Constants.heroesURLRequest,
                             limit: numberOfHeroesPerRequest,
                             offset: offset) { result in
            switch result {
            case .success(let jsonData):
                do {
                    let response = try self.decoder.decode(HeroResponse.self, from: jsonData)
                    let filteredHeroes = self.limitNumberOfCategoryItems(heroesWithAllCategories:
                                                                         response.data.heroes)
                    heroes.append(contentsOf: filteredHeroes)
                } catch {
                    print(error.localizedDescription)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        return heroes
    }
    
    func getHeroDetails(hero: Hero) async throws -> Hero {
        // Task group
        return try await withThrowingTaskGroup(of: (String, String, String?).self,
                                               body: { group in
            
            addTasksToTaskGroup(heroCategory: hero.comics,
                                categoryType: CategoryTypes.comics,
                                group: &group)
            
            addTasksToTaskGroup(heroCategory: hero.stories,
                                categoryType: CategoryTypes.stories,
                                group: &group)
            
            addTasksToTaskGroup(heroCategory: hero.series,
                                categoryType: CategoryTypes.series,
                                group: &group)
            
            addTasksToTaskGroup(heroCategory: hero.events,
                                categoryType: CategoryTypes.events,
                                group: &group)
            
            var hero = hero
            for try await (resourceURL, type, category) in group {
                switch type {
                case CategoryTypes.comics.rawValue:
                    if let index = hero.comics?.items.firstIndex(where: {$0.resourceURI == resourceURL}) {
                        hero.comics?.items[index].description = category
                    }
                case CategoryTypes.stories.rawValue:
                    if let index = hero.stories?.items.firstIndex(where: {$0.resourceURI == resourceURL}) {
                        hero.stories?.items[index].description = category
                    }
                case CategoryTypes.series.rawValue:
                    if let index = hero.series?.items.firstIndex(where: {$0.resourceURI == resourceURL}) {
                        hero.series?.items[index].description = category
                    }
                case CategoryTypes.events.rawValue:
                    if let index = hero.events?.items.firstIndex(where: {$0.resourceURI == resourceURL}) {
                        hero.events?.items[index].description = category
                    }
                default:
                    break
                }
            }
            
            return hero
        })
    }
    
    private func limitNumberOfCategoryItems(heroesWithAllCategories: [Hero]) -> [Hero] {
        var heroes: [Hero] = []
        for var hero in heroesWithAllCategories {
            if hero.comics!.items.count > 3 {
                let heroComics = Array(hero.comics!.items[0..<3])
                hero.comics?.items = heroComics
            }
            if hero.series!.items.count > 3 {
                let heroSeries = Array(hero.series!.items[0..<3])
                hero.series?.items = heroSeries
            }
            if hero.stories!.items.count > 3 {
                let heroStories = Array(hero.stories!.items[0..<3])
                hero.stories?.items = heroStories
            }
            if hero.events!.items.count > 3 {
                let heroEvents = Array(hero.events!.items[0..<3])
                hero.events?.items = heroEvents
            }
            
            heroes.append(hero)
        }
        return heroes
    }
    
    private func getCategoryDetails(resourceURL: String,
                                    categoryDetail: Category.Item)
    async -> String? {
        var description: String = ""
        
        await performRequest(resourceURL: resourceURL,
                             limit: nil,
                             offset: nil) { result in
            switch result {
            case .success(let jsonData):
                do {
                    let response = try self.decoder.decode(DescriptionResponse.self, from: jsonData)
                    description = response.data.results[0].description ?? "No description :("
                } catch {
                    print(error.localizedDescription)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        return description
    }
    
    private func addTasksToTaskGroup(heroCategory: Category?,
                                     categoryType: CategoryTypes,
                                     group: inout ThrowingTaskGroup<(String, String, String?), Error>) {
        if let heroCategory = heroCategory {
            for category in heroCategory.items {
                group.addTask { [self] in
                    return (category.resourceURI,
                            categoryType.rawValue,
                            await self.getCategoryDetails(resourceURL: category.resourceURI,
                                                          categoryDetail: category))
                }
            }
        }
    }
    
    private func performRequest(resourceURL url: String,
                                limit: Int?,
                                offset: Int?,
                                completionHandler: @escaping (Result<Data, NetworkError>) -> Void)
    async {
        guard var urlComponents = URLComponents(string: url) else {
            completionHandler(.failure(.badUrl))
            return
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
        
        do {
            let (data, response) = try await URLSession.shared
                .data(from: urlComponents.url!)
            
            let httpResponse = response as? HTTPURLResponse
            switch httpResponse?.statusCode {
            case 200:
                completionHandler(.success(data))
            case 400:
                completionHandler(.failure(.badRequest))
            case 404:
                completionHandler(.failure(.resourceNotFound))
            case 500:
                completionHandler(.failure(.serverError))
            default:
                completionHandler(.failure(.appError))
            }
            
        } catch {
            completionHandler(.failure(.appError))
        }
    }
}
