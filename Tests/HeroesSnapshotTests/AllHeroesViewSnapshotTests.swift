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
    
    private func createHeroesViewModel(numberOfFavouriteHeroes: Int = 0) -> HeroesViewModel {
        let domainName = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domainName)
        
        let heroService = HeroFakeService()
        let numberOfHeroes = 20
        var heroes: [Hero] = []
        for index in 0..<numberOfHeroes {
            heroes.append(Hero.mock(name: "name \(index)"))
        }
        
        if numberOfFavouriteHeroes > 0 {
            persistHeroes(numberOfFavouriteHeroes: numberOfFavouriteHeroes, heroes: heroes)
        }
        
        heroService.getHeroesStub = { .success(heroes) }
        
        return HeroesViewModel(heroService: heroService)
    }
    
    private func persistHeroes(numberOfFavouriteHeroes: Int, heroes: [Hero]) {
        let encoder = JSONEncoder()
        do {
            for index in 0..<numberOfFavouriteHeroes {
                guard let name = heroes[index].name else { continue }
                
                let data = try encoder.encode(heroes[index])
                UserDefaults.standard.set(data, forKey: name)
            }
        } catch {
            print(error)
        }
    }
    
    func testHeroesTableViewController() {
        let heroesTableViewController = HeroesTableViewController(heroesViewModel: createHeroesViewModel())
        let navigationController = UINavigationController(rootViewController: heroesTableViewController)
        
        assertSnapshot(matching: navigationController, as: .image)
    }
    
    func testHeroesGridViewController() {
        let heroesGridViewController = HeroesGridViewController(heroesViewModel: createHeroesViewModel())
        let navigationController = UINavigationController(rootViewController: heroesGridViewController)
        
        assertSnapshot(matching: navigationController, as: .image)
    }
    
    func testHeroesTableViewPersistance() {
        let heroesViewModel = createHeroesViewModel(numberOfFavouriteHeroes: 2)
        let heroesTableViewController = HeroesTableViewController(heroesViewModel: heroesViewModel)
        let navigationController = UINavigationController(rootViewController: heroesTableViewController)
        
        assertSnapshot(matching: navigationController, as: .image)
    }
    
    func testHeroesGridViewPersistance() {
        let heroesViewModel = createHeroesViewModel(numberOfFavouriteHeroes: 2)
        let heroesTableViewController = HeroesGridViewController(heroesViewModel: heroesViewModel)
        let navigationController = UINavigationController(rootViewController: heroesTableViewController)
        
        assertSnapshot(matching: navigationController, as: .image)
    }
}

