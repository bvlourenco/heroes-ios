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
        
        let hero = Hero.mock()
        let numberOfHeroes = 20
        
        var heroes: [Hero] = []
        for _ in 0..<numberOfHeroes {
            heroes.append(hero)
        }
        
        heroService.getHeroesStub = { .success(heroes) }
        
        let heroesViewModel = HeroesTableViewModel(heroService: heroService)
        let heroesTableViewController = HeroesTableViewController(heroesTableViewModel: heroesViewModel)
        let navigationController = UINavigationController(rootViewController: heroesTableViewController)
        assertSnapshot(matching: navigationController, as: .image)
    }
}

