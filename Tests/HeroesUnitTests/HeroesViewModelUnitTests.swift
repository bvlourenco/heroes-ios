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

    func testFetch20Heroes() async throws {
        guard let heroService else { return }
        guard let heroesViewModel else { return }
        let numberOfHeroes = 20
        let expectation = XCTestExpectation(description: "Fetch Heroes")
        
        let heroes = HeroesUnitTestHelpers.createFakeHeroes(numberOfHeroes: numberOfHeroes, startIndex: 0)
        heroService.getHeroesStub = { .success(heroes) }
        heroesViewModel.fetchHeroes(searchQuery: nil, addHeroesToView: {
            expectation.fulfill()
        })
        await fulfillment(of: [expectation], timeout: 5)
        
        XCTAssertEqual(heroesViewModel.numberOfHeroes(), numberOfHeroes)
        for index in 0..<numberOfHeroes {
            HeroesUnitTestHelpers.validateHero(hero: heroesViewModel.getHero(index: index),
                                               name: "name \(index)")
        }
    }
    
    func testFetchMoreThan20Heroes() async throws {
        guard let heroService else { return }
        guard let heroesViewModel else { return }
        let numberOfHeroes = 20
        let expectation1 = XCTestExpectation(description: "Fetch first 20 heroes")
        let expectation2 = XCTestExpectation(description: "Fetch more heroes")
        
        var heroes = HeroesUnitTestHelpers.createFakeHeroes(numberOfHeroes: numberOfHeroes, startIndex: 0)
        heroService.getHeroesStub = { .success(heroes) }
        heroesViewModel.fetchHeroes(searchQuery: nil, addHeroesToView: {
            expectation1.fulfill()
        })
        await fulfillment(of: [expectation1], timeout: 5)
        
        heroes.append(contentsOf: HeroesUnitTestHelpers.createFakeHeroes(numberOfHeroes: numberOfHeroes,
                                                                         startIndex: 20))
        heroService.getHeroesStub = { .success(heroes) }
        heroesViewModel.fetchHeroes(searchQuery: nil, addHeroesToView: {
            expectation2.fulfill()
        })
        await fulfillment(of: [expectation2], timeout: 5)
        
        XCTAssertEqual(heroesViewModel.numberOfHeroes(), numberOfHeroes * 2)
        for index in 0..<numberOfHeroes {
            HeroesUnitTestHelpers.validateHero(hero: heroesViewModel.getHero(index: index),
                                               name: "name \(index)")
        }
    }
    
    func testFetchHeroesInSearch() async throws {
        guard let heroService else { return }
        guard let heroesViewModel else { return }
        let numberOfHeroes = 10
        let expectation = XCTestExpectation(description: "Fetch Heroes in search")
        
        let heroes = HeroesUnitTestHelpers.createFakeHeroes(numberOfHeroes: numberOfHeroes, startIndex: 0)
        heroService.getHeroesSearchStub = { .success(heroes) }
        heroesViewModel.fetchHeroes(searchQuery: "name", addHeroesToView: {
            expectation.fulfill()
        })
        await fulfillment(of: [expectation], timeout: 5)
        
        XCTAssertEqual(heroesViewModel.numberOfHeroes(), numberOfHeroes)
        for index in 0..<numberOfHeroes {
            HeroesUnitTestHelpers.validateHero(hero: heroesViewModel.getHero(index: index),
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
        XCTAssertEqual(heroesViewModel.numberOfHeroes(), 0)
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
        XCTAssertEqual(heroesViewModel.numberOfHeroes(), 0)
    }
}
