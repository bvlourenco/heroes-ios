//
//  HeroesViewModelUnitTests.swift
//  HeroesTests
//
//  Created by Bernardo Vala Lourenço on 06/11/2023.
//

import XCTest
@testable import Heroes

final class HeroesViewModelUnitTests: XCTestCase {
    var heroService: HeroFakeService?
    var heroesViewModel: HeroesViewModel?
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        let domainName = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domainName)
        heroService = HeroFakeService()
        guard let heroService else { return }
        heroesViewModel = HeroesViewModel(heroService: heroService)
    }

    override func tearDownWithError() throws {
        heroService = nil
        heroesViewModel = nil
        try super.tearDownWithError()
    }
    
    private func createFakeHeroes(numberOfHeroes: Int, startIndex: Int) -> [Hero] {
        var heroes: [Hero] = []
        for index in 0..<numberOfHeroes {
            heroes.append(Hero.mock(name: "name \(startIndex + index)"))
        }
        return heroes
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
        guard let heroService else { return }
        guard let heroesViewModel else { return }
        let numberOfHeroes = 20
        let expectation = XCTestExpectation(description: "Fetch Heroes")
        
        let heroes = createFakeHeroes(numberOfHeroes: numberOfHeroes, startIndex: 0)
        heroService.getHeroesStub = { .success(heroes) }
        heroesViewModel.fetchHeroes(searchQuery: nil, addHeroesToView: {
            expectation.fulfill()
        })
        await fulfillment(of: [expectation], timeout: 5)
        
        XCTAssertEqual(heroesViewModel.numberOfHeroes(inSearch: false), 20)
        for index in 0..<numberOfHeroes {
            validateHero(hero: heroesViewModel.getHero(inSearch: false, index: index),
                         name: "name \(index)")
        }
    }
    
    func testFetchMoreThan20Heroes() async throws {
        guard let heroService else { return }
        guard let heroesViewModel else { return }
        let numberOfHeroes = 20
        let expectation1 = XCTestExpectation(description: "Fetch first 20 heroes")
        let expectation2 = XCTestExpectation(description: "Fetch more heroes")
        
        var heroes = createFakeHeroes(numberOfHeroes: numberOfHeroes, startIndex: 0)
        heroService.getHeroesStub = { .success(heroes) }
        heroesViewModel.fetchHeroes(searchQuery: nil, addHeroesToView: {
            expectation1.fulfill()
        })
        await fulfillment(of: [expectation1], timeout: 5)
        
        heroes.append(contentsOf: createFakeHeroes(numberOfHeroes: numberOfHeroes, startIndex: 20))
        heroService.getHeroesStub = { .success(heroes) }
        heroesViewModel.fetchHeroes(searchQuery: nil, addHeroesToView: {
            expectation2.fulfill()
        })
        await fulfillment(of: [expectation2], timeout: 5)
        
        XCTAssertEqual(heroesViewModel.numberOfHeroes(inSearch: false), 40)
        for index in 0..<numberOfHeroes {
            validateHero(hero: heroesViewModel.getHero(inSearch: false, index: index),
                         name: "name \(index)")
        }
    }
    
    func testFetchHeroesInSearch() async throws {
        guard let heroService else { return }
        guard let heroesViewModel else { return }
        let numberOfHeroes = 20
        let expectation = XCTestExpectation(description: "Fetch Heroes in search")
        
        let heroes = createFakeHeroes(numberOfHeroes: numberOfHeroes, startIndex: 0)
        heroService.getHeroesSearchStub = { .success(heroes) }
        heroesViewModel.fetchHeroes(searchQuery: "name", addHeroesToView: {
            expectation.fulfill()
        })
        await fulfillment(of: [expectation], timeout: 5)
        
        XCTAssertEqual(heroesViewModel.numberOfHeroes(inSearch: true), 20)
        for index in 0..<numberOfHeroes {
            validateHero(hero: heroesViewModel.getHero(inSearch: true, index: index),
                         name: "name \(index)")
        }
    }

    func testFetch0Heroes() async throws {
        guard let heroService else { return }
        guard let heroesViewModel else { return }
        let expectation = XCTestExpectation(description: "Fetch Heroes")
        heroService.getHeroesStub = { .success([]) }
        heroesViewModel.fetchHeroes(searchQuery: nil, addHeroesToView: {
            expectation.fulfill()
        })
        await fulfillment(of: [expectation], timeout: 5)
        XCTAssertEqual(heroesViewModel.numberOfHeroes(inSearch: false), 0)
    }

    func testFetchHeroesWithError() async throws {
        guard let heroService else { return }
        guard let heroesViewModel else { return }
        let expectation = XCTestExpectation(description: "Fetch Heroes")
        heroService.getHeroesStub = { .failure(HeroError.serverError) }
        do {
            let heroes = try await heroService.getHeroes(offset: 0, numberOfHeroesPerRequest: 20, searchQuery: nil).get()
            XCTFail("No error was thrown.")
        } catch {
            XCTAssertEqual(error as! HeroError, HeroError.serverError)
        }
        heroesViewModel.fetchHeroes(searchQuery: nil, addHeroesToView: {
            expectation.fulfill()
        })
        await fulfillment(of: [expectation], timeout: 5)
        XCTAssertEqual(heroesViewModel.numberOfHeroes(inSearch: false), 0)
    }
}
