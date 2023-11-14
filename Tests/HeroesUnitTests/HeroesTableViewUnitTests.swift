//
//  HeroesTests.swift
//  HeroesTests
//
//  Created by Bernardo Vala Lourenço on 06/11/2023.
//

import XCTest
@testable import Heroes

final class HeroesTableViewUnitTests: XCTestCase {
    var heroService: HeroFakeService?
    var heroesTableViewModel: HeroesTableViewModel?
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        heroService = HeroFakeService()
        if let heroService = heroService {
            heroesTableViewModel = HeroesTableViewModel(heroService: heroService)
        }
    }

    override func tearDownWithError() throws {
        heroService = nil
        heroesTableViewModel = nil
        try super.tearDownWithError()
    }
    
    func validateHero(hero: Hero,
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

    func testFetch20Heroes() async throws {
        if let heroService = heroService,
           let heroesTableViewModel = heroesTableViewModel {
            let numberOfHeroes = 20
            let expectation = XCTestExpectation(description: "Fetch Heroes")
            
            let hero = Hero.mock()
            
            var heroes: [Hero] = []
            for _ in 0..<numberOfHeroes {
                heroes.append(hero)
            }
            
            heroService.getHeroesStub = { .success(heroes) }
            
            heroesTableViewModel.fetchHeroes(addHeroesToTableView: {
                expectation.fulfill()
            })
            
            await fulfillment(of: [expectation], timeout: 5)
            
            XCTAssertEqual(heroesTableViewModel.numberOfHeroes(), 20)
            
            for index in 0..<numberOfHeroes {
                validateHero(hero: heroesTableViewModel.getHeroAtIndex(index: index))
            }
        }
    }
    
    func testFetchMoreThan20Heroes() async throws {
        if let heroService = heroService,
           let heroesTableViewModel = heroesTableViewModel {
            let numberOfHeroes = 20
            let expectation1 = XCTestExpectation(description: "Fetch first 20 heroes")
            let expectation2 = XCTestExpectation(description: "Fetch more heroes")
            
            let hero = Hero.mock()
            
            var heroes: [Hero] = []
            for _ in 0..<numberOfHeroes {
                heroes.append(hero)
            }
            
            heroService.getHeroesStub = { .success(heroes) }
            
            heroesTableViewModel.fetchHeroes(addHeroesToTableView: {
                expectation1.fulfill()
            })
            
            await fulfillment(of: [expectation1], timeout: 5)
            
            heroesTableViewModel.fetchHeroes(addHeroesToTableView: {
                expectation2.fulfill()
            })
            
            await fulfillment(of: [expectation2], timeout: 5)
            
            let totalNumberOfHeroes = heroesTableViewModel.numberOfHeroes()
            
            XCTAssertEqual(totalNumberOfHeroes, 40)
            
            for index in 0..<numberOfHeroes {
                validateHero(hero: heroesTableViewModel.getHeroAtIndex(index: index))
            }
        }
    }

    func testFetch0Heroes() async throws {
        if let heroService = heroService,
           let heroesTableViewModel = heroesTableViewModel {
            let expectation = XCTestExpectation(description: "Fetch Heroes")
            
            heroService.getHeroesStub = { .success([]) }
            
            heroesTableViewModel.fetchHeroes(addHeroesToTableView: {
                expectation.fulfill()
            })
            
            await fulfillment(of: [expectation], timeout: 5)
            
            XCTAssertEqual(heroesTableViewModel.numberOfHeroes(), 0)
        }
    }

    func testFetchHeroesWithError() async throws {
        if let heroService = heroService,
           let heroesTableViewModel = heroesTableViewModel {
            let expectation = XCTestExpectation(description: "Fetch Heroes")
            
            heroService.getHeroesStub = { .failure(HeroError.serverError) }
            
            do {
                let heroes = try await heroService.getHeroes(offset: 0, numberOfHeroesPerRequest: 20).get()
                XCTFail("No error was thrown.")
            } catch {
                XCTAssertEqual(error as! HeroError, HeroError.serverError)
            }
            
            heroesTableViewModel.fetchHeroes(addHeroesToTableView: {
                expectation.fulfill()
            })
            
            await fulfillment(of: [expectation], timeout: 5)
            
            XCTAssertEqual(heroesTableViewModel.numberOfHeroes(), 0)
        }
    }
}
