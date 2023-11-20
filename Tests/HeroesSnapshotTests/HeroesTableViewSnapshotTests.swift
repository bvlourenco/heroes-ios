//
//  HeroesSnapshotTests.swift
//  HeroesSnapshotTests
//
//  Created by Bernardo Vala Lourenço on 08/11/2023.
//

import SnapshotTesting
import XCTest
@testable import Heroes

final class HeroesTableViewSnapshotTests: XCTestCase {
    
    func testHeroesTableViewController() {
        let heroService = HeroFakeService()
        
        let thumbnail1 = Hero.createHeroThumbnailMock(path: "http://i.annihil.us/u/prod/marvel/i/mg/b/40/image_not_available",
                                                      extension: "jpg")
        let thumbnail2 = Hero.createHeroThumbnailMock(path: "http://i.annihil.us/u/prod/marvel/i/mg/b/40/image_not_available",
                                                      extension: "jpg")
        let thumbnail3 = Hero.createHeroThumbnailMock(path: "http://i.annihil.us/u/prod/marvel/i/mg/b/40/image_not_available",
                                                      extension: "jpg")
        let hero1 = Hero.mock(thumbnail: thumbnail1)
        let hero2 = Hero.mock(name: "name 2", description: "description 2", thumbnail: thumbnail2)
        let hero3 = Hero.mock(name: "name 3", description: "description 3", thumbnail: thumbnail3)
        let numberOfHeroes = 20
        
        var heroes: [Hero] = []
        for i in 0..<numberOfHeroes {
            if i % 3 == 0 {
                heroes.append(hero1)
            } else if i % 3 == 1 {
                heroes.append(hero2)
            } else {
                heroes.append(hero3)
            }
        }
        
        heroService.getHeroesStub = { .success(heroes) }
        
        let heroesViewModel = HeroesTableViewModel(heroService: heroService)
        let heroesTableViewController = HeroesTableViewController(heroesTableViewModel: heroesViewModel)
        let navigationController = UINavigationController(rootViewController: heroesTableViewController)
        
        assertSnapshot(matching: navigationController, as: .image)
    }
}

