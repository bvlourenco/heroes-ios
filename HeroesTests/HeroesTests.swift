//
//  HeroesTests.swift
//  HeroesTests
//
//  Created by Bernardo Vala Lourenço on 06/11/2023.
//

import XCTest
@testable import Heroes

final class HeroesTests: XCTestCase {
    var heroesViewModel: HeroesViewModel?
    var expectation: XCTestExpectation?
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        let heroService = HeroFakeServiceProtocol()
        heroesViewModel = HeroesViewModel(heroService: heroService)
        
        expectation = XCTestExpectation(description: "Fetch Heroes")
    }

    override func tearDownWithError() throws {
        heroesViewModel = nil
        try super.tearDownWithError()
    }
    
    func validateHero(hero: Hero,
                      name: String,
                      description: String,
                      imageURL: String,
                      comicName: String,
                      eventName: String,
                      seriesName: String,
                      storiesName: String,
                      numberOfComics: Int = 1,
                      numberOfEvents: Int = 1,
                      numberOfSeries: Int = 1,
                      numberOfStories: Int = 1) {
        XCTAssertEqual(hero.name, name)
        XCTAssertEqual(hero.description, description)
        XCTAssertEqual(hero.imageURL, imageURL)
        
        XCTAssertEqual(hero.heroComics.count, numberOfComics)
        XCTAssertEqual(hero.heroEvents.count, numberOfEvents)
        XCTAssertEqual(hero.heroSeries.count, numberOfSeries)
        XCTAssertEqual(hero.heroStories.count, numberOfStories)
        
        XCTAssertEqual(hero.heroComics["comic"]?.name, comicName)
        XCTAssertEqual(hero.heroEvents["event"]?.name, eventName)
        XCTAssertEqual(hero.heroSeries["series"]?.name, seriesName)
        XCTAssertEqual(hero.heroStories["story"]?.name, storiesName)
    }

    func testFetch20Heroes() async throws {
        if let heroesViewModel = heroesViewModel,
           let expectation = expectation {
            heroesViewModel.fetchHeroes(addHeroesToTableView: {
                expectation.fulfill()
            })
            
            await fulfillment(of: [expectation], timeout: 5)
            
            XCTAssertEqual(heroesViewModel.numberOfHeroes(), 20)
            
            // Only validating the first three heroes since the remaining ones
            // are either equal to hero1, hero2 or hero3.
            // List of heroes: [hero1, hero2, hero3, hero1, hero2, hero3, ...]
            let hero1 = heroesViewModel.getHero(index: 0)
            let hero2 = heroesViewModel.getHero(index: 1)
            let hero3 = heroesViewModel.getHero(index: 2)
            
            validateHero(hero: hero1,
                         name: "name 1",
                         description: "description 1",
                         imageURL: "url 1",
                         comicName: "comic 1 name",
                         eventName: "event 1 name",
                         seriesName: "series 1 name",
                         storiesName: "story 1 name")
            
            validateHero(hero: hero2,
                         name: "name 2",
                         description: "description 2",
                         imageURL: "url 2",
                         comicName: "comic 2 name",
                         eventName: "event 2 name",
                         seriesName: "series 2 name",
                         storiesName: "story 2 name")
            
            validateHero(hero: hero3,
                         name: "name 3",
                         description: "description 3",
                         imageURL: "url 3",
                         comicName: "comic 3 name",
                         eventName: "event 3 name",
                         seriesName: "series 3 name",
                         storiesName: "story 3 name")
        }
    }
    
    func testDownloadHeroImage() async throws {
        if let heroesViewModel = heroesViewModel,
           let expectation = expectation {
            heroesViewModel.fetchHeroes(addHeroesToTableView: {
                expectation.fulfill()
            })
            
            await fulfillment(of: [expectation], timeout: 5)
            
            XCTAssertEqual(heroesViewModel.numberOfHeroes(), 20)
            
            let hero1 = heroesViewModel.getHero(index: 0)
            
            XCTAssertNotNil(hero1.imageData)
        }
    }
    
    func testGetHeroCategoriesDescriptions() async throws {
        if let heroesViewModel = heroesViewModel,
           let expectation = expectation {
            heroesViewModel.fetchHeroes(addHeroesToTableView: {
                expectation.fulfill()
            })
            
            await fulfillment(of: [expectation], timeout: 5)
            
            XCTAssertEqual(heroesViewModel.numberOfHeroes(), 20)
            
            let hero = await heroesViewModel.getDescriptions(heroIndex: 0)
            
            XCTAssertEqual(hero.heroComics["comic"]?.description, "comic description")
            XCTAssertEqual(hero.heroEvents["event"]?.description, "event description")
            XCTAssertEqual(hero.heroSeries["series"]?.description, "series description")
            XCTAssertEqual(hero.heroStories["story"]?.description, "story description")
        }
    }
    
    func testFetchMoreThan20Heroes() async throws {
        if let heroesViewModel = heroesViewModel,
           let expectation = expectation {
            heroesViewModel.fetchHeroes(addHeroesToTableView: {})
            
            heroesViewModel.fetchHeroes(addHeroesToTableView: {
                expectation.fulfill()
            })
            
            await fulfillment(of: [expectation], timeout: 10)
            
            XCTAssertEqual(heroesViewModel.numberOfHeroes(), 40)
        }
    }
}
