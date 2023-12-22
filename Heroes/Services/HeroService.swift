//
//  heroService.swift
//  Heroes
//
//  Created by Bernardo Vala Lourenço on 24/10/2023.
//

import Foundation
import UIKit

enum CategoryTypes: String {
    case comics, stories, series, events
}

class HeroService: HeroServiceProtocol {
    private let decoder = JSONDecoder()
    
    func getHeroes(offset: Int,
                   numberOfHeroesPerRequest: Int,
                   searchQuery: String?) async -> Result<[Hero], HeroError> {
        var heroes: [Hero] = []
        
        let result = await performRequest(resourceURL: .heroesURLRequest,
                                          limit: numberOfHeroesPerRequest,
                                          offset: offset,
                                          searchQuery: searchQuery)
        
        switch result {
        case .success(let jsonData):
            do {
                let response = try self.decoder.decode(HeroResponse.self, from: jsonData)
                let filteredHeroes = self.limitNumberOfCategoryItems(allHeroes: response.data.heroes)
                heroes.append(contentsOf: filteredHeroes)
                return .success(heroes)
            } catch {
                return .failure(HeroError.decodingError)
            }
        case .failure(let error):
            print(error)
            return .failure(HeroError.networkError)
        }
    }
    
    func getHeroDetails(hero: Hero) async -> Result<Hero, HeroError> {
        do {
            return try await withThrowingTaskGroup(of: (String, String, String?, Thumbnail?).self,
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
                for try await (resourceURL, type, description, thumbnail) in group {
                    switch type {
                    case CategoryTypes.comics.rawValue:
                        setItem(category: &hero.comics,
                                resourceURL: resourceURL,
                                description: description,
                                thumbnail: thumbnail)
                    case CategoryTypes.stories.rawValue:
                        setItem(category: &hero.stories,
                                resourceURL: resourceURL,
                                description: description,
                                thumbnail: thumbnail)
                    case CategoryTypes.series.rawValue:
                        setItem(category: &hero.series,
                                resourceURL: resourceURL,
                                description: description,
                                thumbnail: thumbnail)
                    case CategoryTypes.events.rawValue:
                        setItem(category: &hero.events,
                                resourceURL: resourceURL,
                                description: description,
                                thumbnail: thumbnail)
                    default:
                        break
                    }
                }
                
                return .success(hero)
            })
        } catch {
            return .failure(HeroError.taskGroupError)
        }
    }
    
    private func setItem(category: inout Category?, resourceURL: String,
                         description: String?, thumbnail: Thumbnail?) {
        if let index = category?.items.firstIndex(where: {$0.resourceURI == resourceURL}) {
            category?.items[index].description = description
            category?.items[index].thumbnail = thumbnail
        }
    }
    
    private func limitNumberOfCategoryItems(allHeroes: [Hero]) -> [Hero] {
        var heroes: [Hero] = []
        for var hero in allHeroes {
            limitCategory(category: &hero.comics)
            limitCategory(category: &hero.series)
            limitCategory(category: &hero.stories)
            limitCategory(category: &hero.events)
            heroes.append(hero)
        }
        return heroes
    }
    
    private func limitCategory(category: inout Category?) {
        if category != nil {
            if category!.items.count > .numberOfItemsPerCategory {
                category!.items = Array(category!.items[0..<Int.numberOfItemsPerCategory])
            }
        }
    }
    
    private func addTasksToTaskGroup(heroCategory: Category?,
                                     categoryType: CategoryTypes,
                                     group: inout ThrowingTaskGroup<(String, String, String?, Thumbnail?), Error>) {
        if let heroCategory = heroCategory {
            for category in heroCategory.items {
                group.addTask { [weak self] in
                    let response = await self?.getCategoryDetails(resourceURL: category.resourceURI,
                                                                  categoryDetail: category)
                    return (category.resourceURI,
                            categoryType.rawValue,
                            response?.description,
                            response?.thumbnail)
                }
            }
        }
    }
    
    private func getCategoryDetails(resourceURL: String,
                                    categoryDetail: Category.Item)
    async -> (description: String?, thumbnail: Thumbnail?) {
        var description: String = "No description :("
        var thumbnail: Thumbnail = Hero.createThumbnailMock()
        
        let result = await performRequest(resourceURL: resourceURL,
                                          limit: nil,
                                          offset: nil,
                                          searchQuery: nil)
        
        switch result {
        case .success(let jsonData):
            do {
                let response = try self.decoder.decode(DescriptionResponse.self, from: jsonData)
                description = response.data.results[0].description ?? description
                thumbnail = response.data.results[0].thumbnail ?? thumbnail
                return (description: description, thumbnail: thumbnail)
            } catch {
               print(HeroError.decodingError)
            }
        case .failure(let error):
            print(error)
        }
        
        return (description: description, thumbnail: thumbnail)
    }
    
    private func performRequest(resourceURL url: String,
                                limit: Int?,
                                offset: Int?,
                                searchQuery: String?) async -> Result<Data, NetworkError> {
        guard var urlComponents = URLComponents(string: url) else {
            return .failure(.badUrl)
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "apikey", value: .apiKey),
            URLQueryItem(name: "hash", value: .hash),
            URLQueryItem(name: "ts", value: .timestamp)
        ]
        
        if let limit = limit {
            let queryItem = URLQueryItem(name: "limit", value: String(limit))
            urlComponents.queryItems?.append(queryItem)
        }
        if let offset = offset {
            let queryItem = URLQueryItem(name: "offset", value: String(offset))
            urlComponents.queryItems?.append(queryItem)
        }
        if let searchQuery = searchQuery {
            let queryItem = URLQueryItem(name: "nameStartsWith", value: searchQuery)
            urlComponents.queryItems?.append(queryItem)
        }
        
        do {
            let (data, response) = try await URLSession.shared
                .data(from: urlComponents.url!)
            
            guard let httpResponse = response as? HTTPURLResponse else { return .failure(.appError) }
            
            switch httpResponse.statusCode {
            case .httpStatusCodeOk:
                return .success(data)
            case .httpStatusCodeBadRequest:
                return .failure(.badRequest)
            case .httpStatusCodeNotFound:
                return .failure(.resourceNotFound)
            case .httpStatusCodeInternalServerError:
                return .failure(.serverError)
            default:
                return .failure(.appError)
            }
            
        } catch {
            return .failure(.appError)
        }
    }
}

private extension String {
    static let apiKey = "19ebd69fcbd349517059711384948e26"
    static let hash = "5c8ac737e471fcf0b6f8486503f2656b"
    static let timestamp = "1698146291"
    static let heroesURLRequest = "http://gateway.marvel.com/v1/public/characters"
}

private extension Int {
    static let numberOfItemsPerCategory = 3
    
    static let httpStatusCodeOk = 200
    static let httpStatusCodeBadRequest = 400
    static let httpStatusCodeNotFound = 404
    static let httpStatusCodeInternalServerError = 500
}
