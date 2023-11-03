//
//  hero.swift
//  Heroes
//
//  Created by Bernardo Vala Lourenço on 24/10/2023.
//

import Foundation

struct HeroCategoryDetails: Decodable {
    let name: String
    var description: String?
    
    mutating func setDescription(_ description: String?) {
        self.description = description
    }
}

struct Hero: Decodable {
    let name: String
    let description: String
    let imageURL: String
    var imageData: Data?
    var heroComics: [String: HeroCategoryDetails]
    var heroEvents: [String: HeroCategoryDetails]
    var heroStories: [String: HeroCategoryDetails]
    var heroSeries: [String: HeroCategoryDetails]
    
    mutating func setHeroImage(image: Data) {
        self.imageData = image
    }
}

struct Heroes: Decodable {
    var heroes: [Hero]
    
    enum CodingKeys: String, CodingKey {
        case data
        
        enum DataKeys: String, CodingKey {
            case results
            
            enum ResultKeys: String, CodingKey {
                case name, description, thumbnail, comics,
                     series, stories, events
                
                enum ThumbnailKeys: String, CodingKey {
                    case path, ext = "extension"
                }
                
                enum CategoryKeys: String, CodingKey {
                    case items
                    
                    enum ItemsKeys: String, CodingKey {
                        case resourceURI, name
                    }
                }
            }
        }
    }
    
    private func parseCategory(key: CodingKeys.DataKeys.ResultKeys,
                               heroContainer: KeyedDecodingContainer<CodingKeys
        .DataKeys.ResultKeys>)
    throws -> [String:HeroCategoryDetails] {
        var heroCategoryItems: [String:HeroCategoryDetails] = [:]
        let categoryContainer = try heroContainer
            .nestedContainer(keyedBy: CodingKeys
                .DataKeys
                .ResultKeys
                .CategoryKeys
                .self,
                             forKey: key)
        var categoryItemsContainer = try categoryContainer
            .nestedUnkeyedContainer(forKey: .items)
        
        var numItems = 0
        while categoryItemsContainer.isAtEnd == false && numItems < 3 {
            let itemContainer = try categoryItemsContainer
                .nestedContainer(keyedBy: CodingKeys
                    .DataKeys
                    .ResultKeys
                    .CategoryKeys
                    .ItemsKeys.self)
            let categoryName = try itemContainer.decode(String.self,
                                                        forKey: .name)
            let categoryURL = try itemContainer.decode(String.self,
                                                       forKey: .resourceURI)
            let heroCategory = HeroCategoryDetails(name: categoryName)
            heroCategoryItems[categoryURL] = heroCategory
            numItems += 1
        }
        return heroCategoryItems
    }
    
    init(from decoder: Decoder) throws {
        self.heroes = []
        
        let rootContainer = try decoder.container(keyedBy: CodingKeys.self)
        let dataContainer = try rootContainer
            .nestedContainer(keyedBy: CodingKeys.DataKeys
                .self,
                             forKey: .data)
        var resultsContainer = try dataContainer
            .nestedUnkeyedContainer(forKey: .results)
        
        while resultsContainer.isAtEnd == false {
            let heroContainer = try resultsContainer
                .nestedContainer(keyedBy: CodingKeys
                    .DataKeys
                    .ResultKeys
                    .self)
            let heroName = try heroContainer.decode(String.self, forKey: .name)
            let heroDescription = try heroContainer.decode(String.self,
                                                           forKey: .description)
            
            let thumbnailContainer = try heroContainer
                .nestedContainer(keyedBy: CodingKeys
                    .DataKeys
                    .ResultKeys
                    .ThumbnailKeys
                    .self,
                                 forKey: .thumbnail)
            let heroImagePath = try thumbnailContainer.decode(String.self,
                                                              forKey: .path)
            let heroImageExtension = try thumbnailContainer.decode(String.self,
                                                                   forKey: .ext)
            let heroImageURL = heroImagePath + "." + heroImageExtension
            
            let heroComics = try parseCategory(key: CodingKeys.DataKeys
                .ResultKeys.comics,
                                               heroContainer: heroContainer)
            let heroSeries = try parseCategory(key: CodingKeys.DataKeys
                .ResultKeys.series,
                                               heroContainer: heroContainer)
            let heroEvents = try parseCategory(key: CodingKeys.DataKeys
                .ResultKeys.events,
                                               heroContainer: heroContainer)
            let heroStories = try parseCategory(key: CodingKeys.DataKeys
                .ResultKeys.stories,
                                                heroContainer: heroContainer)
            
            let hero = Hero(name: heroName,
                            description: heroDescription,
                            imageURL: heroImageURL,
                            heroComics: heroComics,
                            heroEvents: heroEvents,
                            heroStories: heroStories,
                            heroSeries: heroSeries)
            
            heroes.append(hero)
        }
    }
}
