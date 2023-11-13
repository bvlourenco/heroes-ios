//
//  HeroesTableView.swift
//  HeroesUnitTests
//
//  Created by Bernardo Vala Lourenço on 13/11/2023.
//

import XCTest
@testable import Heroes

final class HeroDetailUnitTests: XCTestCase {
    var heroService: HeroFakeService?
    var heroDetailViewModel: HeroDetailViewModel?
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        heroService = HeroFakeService()
        if let heroService = heroService {
            let hero = heroService.getHeroIndex(heroIndex: 0)
            heroDetailViewModel = HeroDetailViewModel(heroService: heroService,
                                                      hero: hero)
        }
    }

    override func tearDownWithError() throws {
        heroService = nil
        heroDetailViewModel = nil
        try super.tearDownWithError()
    }
    
    func testGetHeroCategoriesDescriptions() async throws {
        let expectation = XCTestExpectation(description: "Fetch Heroes")
        
        if let heroDetailViewModel = heroDetailViewModel {
            let hero = await heroDetailViewModel.getHeroDescriptions()
            
            XCTAssertEqual(hero.comics?.items[0].description, "comic description")
            XCTAssertEqual(hero.events?.items[0].description, "event description")
            XCTAssertEqual(hero.series?.items[0].description, "series description")
            XCTAssertEqual(hero.stories?.items[0].description, "story description")
        }
    }
}
