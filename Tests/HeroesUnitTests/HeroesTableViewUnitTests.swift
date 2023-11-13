//
//  HeroesTests.swift
//  HeroesTests
//
//  Created by Bernardo Vala Lourenço on 06/11/2023.
//

import XCTest
@testable import Heroes

// TODO: Check mocks for tests
// TODO: UI tests
final class HeroesTableViewUnitTests: XCTestCase {
    var heroService: HeroFakeService?
    var heroesViewModel: HeroesTableViewModel?
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        heroService = HeroFakeService()
        if let heroService = heroService {
            heroesViewModel = HeroesTableViewModel(heroService: heroService)
        }
    }

    override func tearDownWithError() throws {
        heroService = nil
        heroesViewModel = nil
        try super.tearDownWithError()
    }
    
    func validateHero(hero: Hero,
                      name: String,
                      description: String,
                      imagePath: String,
                      imageExtension: String,
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
        XCTAssertEqual(hero.thumbnail?.path, imagePath)
        XCTAssertEqual(hero.thumbnail?.extension, imageExtension)
        
        XCTAssertEqual(hero.comics?.items.count, numberOfComics)
        XCTAssertEqual(hero.events?.items.count, numberOfEvents)
        XCTAssertEqual(hero.series?.items.count, numberOfSeries)
        XCTAssertEqual(hero.stories?.items.count, numberOfStories)
        
        XCTAssertEqual(hero.comics?.items[0].name, comicName)
        XCTAssertEqual(hero.events?.items[0].name, eventName)
        XCTAssertEqual(hero.series?.items[0].name, seriesName)
        XCTAssertEqual(hero.stories?.items[0].name, storiesName)
    }

    func testFetch20Heroes() async throws {
        let expectation = XCTestExpectation(description: "Fetch Heroes")
        
        if let heroesViewModel = heroesViewModel {
            heroesViewModel.fetchHeroes(addHeroesToTableView: {
                expectation.fulfill()
            })
            
            await fulfillment(of: [expectation], timeout: 5)
            
            XCTAssertEqual(heroesViewModel.numberOfHeroes(), 20)
            
            // Only validating the first three heroes since the remaining ones
            // are either equal to hero1, hero2 or hero3.
            // List of heroes: [hero1, hero2, hero3, hero1, hero2, hero3, ...]
            let hero1 = heroesViewModel.getHeroAtIndex(index: 0)
            let hero2 = heroesViewModel.getHeroAtIndex(index: 1)
            let hero3 = heroesViewModel.getHeroAtIndex(index: 2)
            
            validateHero(hero: hero1,
                         name: "name 1",
                         description: "description 1",
                         imagePath: "https://i.annihil.us/u/prod/marvel/i/mg/b/40/image_not_available",
                         imageExtension: "jpg",
                         comicName: "comic 1 name",
                         eventName: "event 1 name",
                         seriesName: "series 1 name",
                         storiesName: "story 1 name")
            
            validateHero(hero: hero2,
                         name: "name 2",
                         description: "description 2",
                         imagePath: "https://i.annihil.us/u/prod/marvel/i/mg/b/40/image_not_available",
                         imageExtension: "jpg",
                         comicName: "comic 2 name",
                         eventName: "event 2 name",
                         seriesName: "series 2 name",
                         storiesName: "story 2 name")
            
            validateHero(hero: hero3,
                         name: "name 3",
                         description: "description 3",
                         imagePath: "https://i.annihil.us/u/prod/marvel/i/mg/b/40/image_not_available",
                         imageExtension: "jpg",
                         comicName: "comic 3 name",
                         eventName: "event 3 name",
                         seriesName: "series 3 name",
                         storiesName: "story 3 name")
        }
    }
    
    func testFetchMoreThan20Heroes() async throws {
        let expectation1 = XCTestExpectation(description: "Fetch first 20 heroes")
        let expectation2 = XCTestExpectation(description: "Fetch more heroes")
        
        if let heroesViewModel = heroesViewModel {
            heroesViewModel.fetchHeroes(addHeroesToTableView: {
                expectation1.fulfill()
            })
            
            await fulfillment(of: [expectation1], timeout: 5)
            
            heroesViewModel.fetchHeroes(addHeroesToTableView: {
                expectation2.fulfill()
            })
            
            await fulfillment(of: [expectation2], timeout: 5)
            
            XCTAssertEqual(heroesViewModel.numberOfHeroes(), 40)
        }
    }
    
    func testFetch0Heroes() async throws {
        if let heroService = heroService {
            let heroes = try await heroService.simulateGetHeroesWithOption(
                offset: 0, 
                numberOfHeroesPerRequest: Constants.numberOfHeroesPerRequest,
                option: HeroOptions.emptyArray)
            
            XCTAssertEqual(heroes.count, 0)
        }
    }
    
    func testFetchHeroesWithError() async throws {
        if let heroService = heroService {
            do {
                let _ = try await heroService.simulateGetHeroesWithOption(
                    offset: 0, 
                    numberOfHeroesPerRequest: Constants.numberOfHeroesPerRequest,
                    option: HeroOptions.error)
                XCTFail("No error was thrown.")
            } catch {
                XCTAssertEqual(error as! NetworkError, NetworkError.appError)
            }
        }
    }
}
