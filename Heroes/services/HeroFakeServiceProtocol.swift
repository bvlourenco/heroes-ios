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
    
    static let image1URL = "url 1"
    static let image2URL = "url 2"
    static let image3URL = "url 3"
    
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

class HeroFakeServiceProtocol: HeroServiceProtocol {
    
    func getHeroes(offset: Int) async throws -> [Hero] {
        let hero1Comics = ["comic": HeroCategoryDetails(name: TestConstants.comic1Name)]
        let hero2Comics = ["comic": HeroCategoryDetails(name: TestConstants.comic2Name)]
        let hero3Comics = ["comic": HeroCategoryDetails(name: TestConstants.comic3Name)]
        
        let hero1Events = ["event": HeroCategoryDetails(name: TestConstants.event1Name)]
        let hero2Events = ["event": HeroCategoryDetails(name: TestConstants.event2Name)]
        let hero3Events = ["event": HeroCategoryDetails(name: TestConstants.event3Name)]
        
        let hero1Series = ["series": HeroCategoryDetails(name: TestConstants.series1Name)]
        let hero2Series = ["series": HeroCategoryDetails(name: TestConstants.series2Name)]
        let hero3Series = ["series": HeroCategoryDetails(name: TestConstants.series3Name)]
        
        let hero1Stories = ["story": HeroCategoryDetails(name: TestConstants.story1Name)]
        let hero2Stories = ["story": HeroCategoryDetails(name: TestConstants.story2Name)]
        let hero3Stories = ["story": HeroCategoryDetails(name: TestConstants.story3Name)]
        
        return [
            Hero(name: TestConstants.hero1Name,
                 description: TestConstants.hero1Description,
                 imageURL: TestConstants.image1URL,
                 heroComics: hero1Comics,
                 heroEvents: hero1Events,
                 heroStories: hero1Series,
                 heroSeries: hero1Stories),
            Hero(name: TestConstants.hero2Name,
                 description: TestConstants.hero2Description,
                 imageURL: TestConstants.image2URL,
                 heroComics: hero2Comics,
                 heroEvents: hero2Events,
                 heroStories: hero2Series,
                 heroSeries: hero2Stories),
            Hero(name: TestConstants.hero3Name,
                 description: TestConstants.hero3Description,
                 imageURL: TestConstants.image3URL,
                 heroComics: hero3Comics,
                 heroEvents: hero3Events,
                 heroStories: hero3Series,
                 heroSeries: hero3Stories)
        ]
    }
    
    func downloadImages(heroes: [Hero]) async throws -> [Hero] {
        let placeholderImage = UIImage(named: "placeholder")!
        let imageData = placeholderImage.pngData()
        
        for var hero in heroes {
            hero.imageData = imageData
        }
        
        return heroes
    }
    
    func getHeroDetails(hero: Hero) async throws -> Hero {
        
        setCategoryDescription(categoryValues: hero.heroComics.values,
                               description: TestConstants.comicDescription)
        
        setCategoryDescription(categoryValues: hero.heroEvents.values,
                               description: TestConstants.eventDescription)
        
        setCategoryDescription(categoryValues: hero.heroSeries.values,
                               description: TestConstants.seriesDescription)
        
        setCategoryDescription(categoryValues: hero.heroStories.values,
                               description: TestConstants.storyDescription)
        
        return hero
    }
    
    private func setCategoryDescription(categoryValues: Dictionary<String, HeroCategoryDetails>.Values,
                                        description: String) {
        for var category in categoryValues {
            category.description = description
        }
    }
}
