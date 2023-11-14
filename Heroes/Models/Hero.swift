//
//  hero.swift
//  Heroes
//
//  Created by Bernardo Vala Lourenço on 24/10/2023.
//

import Foundation

typealias HeroThumbnail = Hero.Thumbnail
typealias Stories = Category
typealias Comics = Category
typealias Events = Category
typealias Series = Category

struct Hero: Decodable {
    let name: String?
    let description: String?
    let thumbnail: Thumbnail?
    var stories: Stories?
    var comics: Comics?
    var events: Events?
    var series: Series?
    
    private enum CodingKeys : String, CodingKey {
        case name, description, thumbnail, stories, comics,
             events, series
    }
    
    struct Thumbnail: Decodable {
        let path: String
        let `extension`: String
        
        var imageURL: URL {
            URL(string: "\(path).\(`extension`)")!
        }
    }
}

extension Hero {
    static let notFoundImagePath = "https://i.annihil.us/u/prod/marvel/i/mg/b/40/image_not_available"
    static let notFoundImageExtension = "jpg"
    
    enum HeroError: Error {
        case cannotCreateCategory
        case cannotUpdateCategory
        case noCategory
    }
    
    static func mock(name: String = "name 1",
                     description: String = "description 1",
                     thumbnail: HeroThumbnail = HeroThumbnail(path: notFoundImagePath,
                                                              extension: notFoundImageExtension),
                     stories: Stories = Stories(items: []),
                     comics: Comics = Comics(items: []),
                     events: Events = Events(items: []),
                     series: Series = Series(items: [])
                    ) -> Hero {
        return Hero(name: name,
                    description: description,
                    thumbnail: thumbnail,
                    stories: stories,
                    comics: comics,
                    events: events,
                    series: series)
    }
    
    static func createCategoryMock(resourceURIs: [String],
                                   names: [String]) throws -> Category {
        if resourceURIs.count != names.count {
            throw HeroError.cannotCreateCategory
        }
        
        var items: [Category.Item] = []
        for index in 0..<names.count {
            let item = Category.Item(resourceURI: resourceURIs[index],
                                     name: names[index])
            items.append(item)
        }
        return Category(items: items)
    }
    
    static func createHeroThumbnailMock(path: String,
                                        extension: String) -> HeroThumbnail {
        return HeroThumbnail(path: path, extension: `extension`)
    }
    
    static func updateHeroCategoryDescription(descriptions: [String],
                                              category: Category?) throws -> Category {
        guard var category = category else { throw HeroError.noCategory }
        
        if category.items.count != descriptions.count {
            throw HeroError.cannotUpdateCategory
        }
        
        for index in 0..<category.items.count {
            category.items[index].description = descriptions[index]
        }
        
        return category
    }
}
