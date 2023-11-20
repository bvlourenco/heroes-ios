//
//  HeroDetailSnapshotTests.swift
//  HeroesSnapshotTests
//
//  Created by Bernardo Vala Lourenço on 13/11/2023.
//

import SnapshotTesting
import XCTest
@testable import Heroes

final class HeroDetailSnapshotTests: XCTestCase {
    
    @MainActor
    func testHeroViewController() async {
        let heroService = HeroFakeService()
        
        heroService.comicsDescription = ["comic description"]
        heroService.eventsDescription = ["event description"]
        heroService.storiesDescription = ["story description"]
        heroService.seriesDescription = ["series description"]
        
        do {
            let stories = try Hero.createCategoryMock(resourceURIs: [""], names: ["story 1 name"])
            let comics = try Hero.createCategoryMock(resourceURIs: [""], names: ["comic 1 name"])
            let events = try Hero.createCategoryMock(resourceURIs: [""], names: ["event 1 name"])
            let series = try Hero.createCategoryMock(resourceURIs: [""], names: ["series 1 name"])
            
            var hero = Hero.mock(stories: stories, comics: comics, events: events, series: series)
            let heroDetailViewModel = HeroDetailViewModel(heroService: heroService, hero: hero)

            hero = await heroDetailViewModel.getHeroDescriptions()
            
            let heroViewController = HeroDetailViewController(hero: hero,
                                                              heroIndex: 0,
                                                              heroDetailViewModel: heroDetailViewModel,
                                                              loader: ImageLoader(),
                                                              isSnapshotTest: true)
            
            assertSnapshot(matching: heroViewController, as: .image)
        } catch {
            print(error)
        }
    }
}
