//
//  HeroDetailViewModelUnitTests.swift
//  HeroesUnitTests
//
//  Created by Bernardo Vala Lourenço on 13/11/2023.
//

import XCTest
@testable import Heroes

final class HeroDetailViewModelUnitTests: XCTestCase {
    var heroService: HeroFakeService?
    var heroDetailViewModel: HeroDetailViewModel?
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        heroService = HeroFakeService()
        guard let heroService else { return }
        
        do {
            let stories = try Hero.createCategoryMock(resourceURIs: [""], names: ["story 1 name"])
            let comics = try Hero.createCategoryMock(resourceURIs: [""], names: ["comic 1 name"])
            let events = try Hero.createCategoryMock(resourceURIs: [""], names: ["event 1 name"])
            let series = try Hero.createCategoryMock(resourceURIs: [""], names: ["series 1 name"])
            let hero = Hero.mock(stories: stories, comics: comics, events: events, series: series)
            heroDetailViewModel = HeroDetailViewModel(heroService: heroService, hero: hero)
        } catch {
            print(error)
        }
    }
    
    override func tearDownWithError() throws {
        heroService = nil
        heroDetailViewModel = nil
        try super.tearDownWithError()
    }
    
    func testGetHeroCategoriesDescriptions() async throws {
        guard let heroService else { return }
        guard let heroDetailViewModel else { return }
        
        heroService.comicsDescription = ["comic description"]
        heroService.eventsDescription = ["event description"]
        heroService.storiesDescription = ["story description"]
        heroService.seriesDescription = ["series description"]
        
        let hero = await heroDetailViewModel.getHeroDescriptions()
        
        XCTAssertEqual(hero.comics?.items[0].description, "comic description")
        XCTAssertEqual(hero.events?.items[0].description, "event description")
        XCTAssertEqual(hero.series?.items[0].description, "series description")
        XCTAssertEqual(hero.stories?.items[0].description, "story description")
    }
}
