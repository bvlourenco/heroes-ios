//
//  HeroesUnitTestHelpers.swift
//  HeroesUnitTests
//
//  Created by Bernardo Vala Lourenço on 19/12/2023.
//

import XCTest
@testable import Heroes

class HeroesUnitTestHelpers {
    static func createFakeHeroes(numberOfHeroes: Int, startIndex: Int) -> [Hero] {
        var heroes: [Hero] = []
        for index in 0..<numberOfHeroes {
            heroes.append(Hero.mock(name: "name \(startIndex + index)"))
        }
        return heroes
    }
    
    static func validateHero(hero: Hero,
                             name: String = "name 1",
                             description: String = "description 1",
                             imagePath: String = Hero.notFoundImagePath,
                             imageExtension: String = Hero.notFoundImageExtension,
                             comicNames: [String] = [],
                             eventNames: [String] = [],
                             seriesNames: [String] = [],
                             storyNames: [String] = [],
                             numberOfComics: Int = 0,
                             numberOfEvents: Int = 0,
                             numberOfSeries: Int = 0,
                             numberOfStories: Int = 0) {
        XCTAssertEqual(hero.name, name)
        XCTAssertEqual(hero.description, description)
        XCTAssertEqual(hero.thumbnail?.path, imagePath)
        XCTAssertEqual(hero.thumbnail?.extension, imageExtension)
        XCTAssertEqual(hero.comics?.items.count, numberOfComics)
        XCTAssertEqual(hero.events?.items.count, numberOfEvents)
        XCTAssertEqual(hero.series?.items.count, numberOfSeries)
        XCTAssertEqual(hero.stories?.items.count, numberOfStories)
        
        for index in 0..<numberOfComics {
            XCTAssertEqual(hero.comics?.items[index].name, comicNames[index])
        }
        
        for index in 0..<numberOfEvents {
            XCTAssertEqual(hero.events?.items[index].name, eventNames[index])
        }
        
        for index in 0..<numberOfStories {
            XCTAssertEqual(hero.stories?.items[index].name, storyNames[index])
        }
        
        for index in 0..<numberOfSeries {
            XCTAssertEqual(hero.series?.items[index].name, seriesNames[index])
        }
    }
}
