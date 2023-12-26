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
    
    private func createHero() -> Hero {
        do {
            let stories = try Hero.createCategoryMock(resourceURIs: [""], names: ["story 1 name"])
            let comics = try Hero.createCategoryMock(resourceURIs: [""], names: ["comic 1 name"])
            let events = try Hero.createCategoryMock(resourceURIs: [""], names: ["event 1 name"])
            let series = try Hero.createCategoryMock(resourceURIs: [""], names: ["series 1 name"])
            
            return Hero.mock(stories: stories, comics: comics, events: events, series: series)
        } catch {
            print(error)
            return Hero.mock()
        }
    }
    
    private func createHeroService() -> HeroFakeService {
        let heroService = HeroFakeService()
        
        heroService.comicsDescription = ["comic description"]
        heroService.eventsDescription = ["event description"]
        heroService.storiesDescription = ["story description"]
        heroService.seriesDescription = ["series description"]
        
        return heroService
    }
    
    private func persistHero(hero: Hero) {
        do {
            guard let name = hero.name else { return }
            
            let data = try JSONEncoder().encode(hero)
            UserDefaults.standard.set(data, forKey: name)
        } catch {
            print(error)
        }
    }
    
    private func cleanUserDefaults() {
        let domainName = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domainName)
    }
    
    @MainActor
    func testHeroViewController() async {
        cleanUserDefaults()
        let heroService = createHeroService()
        
        var hero = createHero()
        let heroDetailViewModel = HeroDetailViewModel(heroService: heroService, hero: hero)
        let favouritesViewModel = FavouritesViewModel()

        hero = await heroDetailViewModel.getHeroDescriptions()
        
        let heroViewController = HeroDetailViewController(hero: hero,
                                                          heroIndex: 0,
                                                          heroDetailViewModel: heroDetailViewModel,
                                                          favouritesViewModel: favouritesViewModel,
                                                          isSnapshotTest: true)
        let navigationController = UINavigationController(rootViewController: heroViewController)
        
        assertSnapshot(matching: navigationController, as: .image)
    }
    
    @MainActor
    func testHeroPersistanceViewController() async {
        cleanUserDefaults()
        let heroService = createHeroService()
        
        var hero = createHero()
        let heroDetailViewModel = HeroDetailViewModel(heroService: heroService, hero: hero)
        let favouritesViewModel = FavouritesViewModel()

        hero = await heroDetailViewModel.getHeroDescriptions()
        
        persistHero(hero: hero)
        
        let heroViewController = HeroDetailViewController(hero: hero,
                                                          heroIndex: 0,
                                                          heroDetailViewModel: heroDetailViewModel,
                                                          favouritesViewModel: favouritesViewModel,
                                                          isSnapshotTest: true)
        let navigationController = UINavigationController(rootViewController: heroViewController)
        
        assertSnapshot(matching: navigationController, as: .image)
    }
}
