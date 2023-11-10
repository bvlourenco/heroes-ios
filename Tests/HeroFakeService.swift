//
//  HeroFakeServiceProtocol.swift
//  Heroes
//
//  Created by Bernardo Vala Lourenço on 06/11/2023.
//

import Foundation
import UIKit

struct TestConstants {
    static let hero1Name = "name 1"
    static let hero2Name = "name 2"
    static let hero3Name = "name 3"
    
    static let hero1Description = "description 1"
    static let hero2Description = "description 2"
    static let hero3Description = "description 3"
    
    static let image1Path = "https://i.annihil.us/u/prod/marvel/i/mg/b/40/image_not_available"
    static let image2Path = "https://i.annihil.us/u/prod/marvel/i/mg/b/40/image_not_available"
    static let image3Path = "https://i.annihil.us/u/prod/marvel/i/mg/b/40/image_not_available"
    
    static let imageExtension = "jpg"
    
    static let comic1Name = "comic 1 name"
    static let comic2Name = "comic 2 name"
    static let comic3Name = "comic 3 name"
    
    static let comicDescription = "comic description"
    
    static let event1Name = "event 1 name"
    static let event2Name = "event 2 name"
    static let event3Name = "event 3 name"
    
    static let eventDescription = "event description"
    
    static let series1Name = "series 1 name"
    static let series2Name = "series 2 name"
    static let series3Name = "series 3 name"
    
    static let seriesDescription = "series description"
    
    static let story1Name = "story 1 name"
    static let story2Name = "story 2 name"
    static let story3Name = "story 3 name"
    
    static let storyDescription = "story description"
}

enum HeroOptions {
    case emptyArray
    case error
    case fetchHeroes
}

class HeroFakeService: HeroServiceProtocol {
    
    func simulateGetHeroesWithOption(offset: Int,
                                     numberOfHeroesPerRequest: Int,
                                     option: HeroOptions) async throws -> [Hero] {
        switch option {
        case .emptyArray:
            return []
        case .error:
            throw NetworkError.appError
        case .fetchHeroes:
            return try await getHeroes(offset: offset,
                                       numberOfHeroesPerRequest: numberOfHeroesPerRequest)
        }
    }
    
    func getHeroes(offset: Int, numberOfHeroesPerRequest: Int) async throws -> [Hero] {
        var heroes: [Hero] = []
        
        let hero1Thumbnail = HeroThumbnail(path: TestConstants.image1Path,
                                           extension: TestConstants.imageExtension)
        let hero2Thumbnail = HeroThumbnail(path: TestConstants.image2Path,
                                           extension: TestConstants.imageExtension)
        let hero3Thumbnail = HeroThumbnail(path: TestConstants.image3Path,
                                           extension: TestConstants.imageExtension)
        
        let hero1ComicItems = [Comics.Item(resourceURI: "",
                                           name: TestConstants.comic1Name)]
        let hero2ComicItems = [Comics.Item(resourceURI: "",
                                           name: TestConstants.comic2Name)]
        let hero3ComicItems = [Comics.Item(resourceURI: "",
                                           name: TestConstants.comic3Name)]
        
        let hero1EventItems = [Events.Item(resourceURI: "",
                                           name: TestConstants.event1Name)]
        let hero2EventItems = [Events.Item(resourceURI: "",
                                           name: TestConstants.event2Name)]
        let hero3EventItems = [Events.Item(resourceURI: "",
                                           name: TestConstants.event3Name)]
        
        let hero1SeriesItems = [Series.Item(resourceURI: "",
                                            name: TestConstants.series1Name)]
        let hero2SeriesItems = [Series.Item(resourceURI: "",
                                            name: TestConstants.series2Name)]
        let hero3SeriesItems = [Series.Item(resourceURI: "",
                                            name: TestConstants.series3Name)]
        
        let hero1StoryItems = [Stories.Item(resourceURI: "",
                                            name: TestConstants.story1Name)]
        let hero2StoryItems = [Stories.Item(resourceURI: "",
                                            name: TestConstants.story2Name)]
        let hero3StoryItems = [Stories.Item(resourceURI: "",
                                            name: TestConstants.story3Name)]
        
        let hero1Comics = Comics(items: hero1ComicItems)
        let hero2Comics = Comics(items: hero2ComicItems)
        let hero3Comics = Comics(items: hero3ComicItems)
        
        let hero1Events = Events(items: hero1EventItems)
        let hero2Events = Events(items: hero2EventItems)
        let hero3Events = Events(items: hero3EventItems)
        
        let hero1Series = Series(items: hero1SeriesItems)
        let hero2Series = Series(items: hero2SeriesItems)
        let hero3Series = Series(items: hero3SeriesItems)
        
        let hero1Stories = Stories(items: hero1StoryItems)
        let hero2Stories = Stories(items: hero2StoryItems)
        let hero3Stories = Stories(items: hero3StoryItems)

        var hero: Hero
        // TODO: Refactor this to allow me to choose the number of heroes!
        for i in 0...19 {
            if i % 3 == 0 {
                hero = Hero(name: TestConstants.hero1Name,
                            description: TestConstants.hero1Description,
                            thumbnail: hero1Thumbnail,
                            stories: hero1Stories,
                            comics: hero1Comics,
                            events: hero1Events,
                            series: hero1Series)
            } else if i % 3 == 1 {
                hero = Hero(name: TestConstants.hero2Name,
                            description: TestConstants.hero2Description,
                            thumbnail: hero2Thumbnail,
                            stories: hero2Stories,
                            comics: hero2Comics,
                            events: hero2Events,
                            series: hero2Series)
            } else {
                hero = Hero(name: TestConstants.hero3Name,
                            description: TestConstants.hero3Description,
                            thumbnail: hero3Thumbnail,
                            stories: hero3Stories,
                            comics: hero3Comics,
                            events: hero3Events,
                            series: hero3Series)
            }
            heroes.append(hero)
        }
        return heroes
    }
    
    func getHeroDetails(hero: Hero) async throws -> Hero {
        
        var hero = hero
        
        if let comics = hero.comics {
            for index in 0..<comics.items.count {
                hero.comics?.items[index].description = TestConstants.comicDescription
            }
        }
        
        if let events = hero.events {
            for index in 0..<events.items.count {
                hero.events?.items[index].description = TestConstants.eventDescription
            }
        }
        
        if let series = hero.series {
            for index in 0..<series.items.count {
                hero.series?.items[index].description = TestConstants.seriesDescription
            }
        }
        
        if let stories = hero.stories {
            for index in 0..<stories.items.count {
                hero.stories?.items[index].description = TestConstants.storyDescription
            }
        }
        
        return hero
    }
    
    func getHeroIndex(heroIndex: Int) -> Hero {
        let hero1Thumbnail = HeroThumbnail(path: TestConstants.image1Path,
                                           extension: TestConstants.imageExtension)
        let hero2Thumbnail = HeroThumbnail(path: TestConstants.image2Path,
                                           extension: TestConstants.imageExtension)
        let hero3Thumbnail = HeroThumbnail(path: TestConstants.image3Path,
                                           extension: TestConstants.imageExtension)
        
        let hero1ComicItems = [Comics.Item(resourceURI: "",
                                           name: TestConstants.comic1Name)]
        let hero2ComicItems = [Comics.Item(resourceURI: "",
                                           name: TestConstants.comic2Name)]
        let hero3ComicItems = [Comics.Item(resourceURI: "",
                                           name: TestConstants.comic3Name)]
        
        let hero1EventItems = [Events.Item(resourceURI: "",
                                           name: TestConstants.event1Name)]
        let hero2EventItems = [Events.Item(resourceURI: "",
                                           name: TestConstants.event2Name)]
        let hero3EventItems = [Events.Item(resourceURI: "",
                                           name: TestConstants.event3Name)]
        
        let hero1SeriesItems = [Series.Item(resourceURI: "",
                                            name: TestConstants.series1Name)]
        let hero2SeriesItems = [Series.Item(resourceURI: "",
                                            name: TestConstants.series2Name)]
        let hero3SeriesItems = [Series.Item(resourceURI: "",
                                            name: TestConstants.series3Name)]
        
        let hero1StoryItems = [Stories.Item(resourceURI: "",
                                            name: TestConstants.story1Name)]
        let hero2StoryItems = [Stories.Item(resourceURI: "",
                                            name: TestConstants.story2Name)]
        let hero3StoryItems = [Stories.Item(resourceURI: "",
                                            name: TestConstants.story3Name)]
        
        let hero1Comics = Comics(items: hero1ComicItems)
        let hero2Comics = Comics(items: hero2ComicItems)
        let hero3Comics = Comics(items: hero3ComicItems)
        
        let hero1Events = Events(items: hero1EventItems)
        let hero2Events = Events(items: hero2EventItems)
        let hero3Events = Events(items: hero3EventItems)
        
        let hero1Series = Series(items: hero1SeriesItems)
        let hero2Series = Series(items: hero2SeriesItems)
        let hero3Series = Series(items: hero3SeriesItems)
        
        let hero1Stories = Stories(items: hero1StoryItems)
        let hero2Stories = Stories(items: hero2StoryItems)
        let hero3Stories = Stories(items: hero3StoryItems)
        
        if heroIndex % 3 == 0 {
            return Hero(name: TestConstants.hero1Name,
                        description: TestConstants.hero1Description,
                        thumbnail: hero1Thumbnail,
                        stories: hero1Stories,
                        comics: hero1Comics,
                        events: hero1Events,
                        series: hero1Series)
        } else if heroIndex % 3 == 1 {
            return Hero(name: TestConstants.hero2Name,
                        description: TestConstants.hero2Description,
                        thumbnail: hero2Thumbnail,
                        stories: hero2Stories,
                        comics: hero2Comics,
                        events: hero2Events,
                        series: hero2Series)
        } else {
            return Hero(name: TestConstants.hero3Name,
                        description: TestConstants.hero3Description,
                        thumbnail: hero3Thumbnail,
                        stories: hero3Stories,
                        comics: hero3Comics,
                        events: hero3Events,
                        series: hero3Series)
        }
    }
}
