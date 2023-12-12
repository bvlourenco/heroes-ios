//
//  HeroesSnapshotTests.swift
//  HeroesSnapshotTests
//
//  Created by Bernardo Vala Lourenço on 08/11/2023.
//

import SnapshotTesting
import XCTest
@testable import Heroes

final class AllHeroesViewSnapshotTests: XCTestCase {
    
    private func createHeroesViewModel() -> HeroesViewModel {
        let domainName = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domainName)
        
        let heroService = HeroFakeService()
        let numberOfHeroes = 20
        var heroes: [Hero] = []
        for index in 0..<numberOfHeroes {
            heroes.append(Hero.mock(name: "name \(index)"))
        }
        
        heroService.getHeroesStub = { .success(heroes) }
        
        return HeroesViewModel(heroService: heroService)
    }
    
    func testHeroesTableViewController() {
        let heroesViewModel = createHeroesViewModel()
        let heroesTableViewController = HeroesTableViewController(heroesViewModel: heroesViewModel)
        let navigationController = UINavigationController(rootViewController: heroesTableViewController)
        
        assertSnapshot(matching: navigationController, as: .image)
    }
    
    func testHeroesGridViewController() {
        let heroesViewModel = createHeroesViewModel()
        let heroesGridViewController = HeroesGridViewController(heroesViewModel: heroesViewModel)
        let navigationController = UINavigationController(rootViewController: heroesGridViewController)
        
        assertSnapshot(matching: navigationController, as: .image)
    }
}

