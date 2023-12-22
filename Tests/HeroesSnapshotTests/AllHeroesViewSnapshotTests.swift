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
    
    private func createHeroService(numberOfFavouriteHeroes: Int = 0) -> HeroServiceProtocol {
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
        
        return heroService
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
    
    func testHeroesHomeViewController() {
        let home = TabBar(heroService: createHeroService())
        home.selectedIndex = 1
        assertSnapshot(matching: home, as: .image)
    }
    
    func testHeroesListViewController() {
        let home = TabBar(heroService: createHeroService())
        home.selectedIndex = 3
        assertSnapshot(matching: home, as: .image)
    }
    
    func testHeroesHomeViewPersistance() {
        let home = TabBar(heroService: createHeroService(numberOfFavouriteHeroes: 2))
        home.selectedIndex = 1
        assertSnapshot(matching: home, as: .image)
    }
    
    func testHeroesListViewPersistance() {
        let home = TabBar(heroService: createHeroService(numberOfFavouriteHeroes: 2))
        home.selectedIndex = 3
        assertSnapshot(matching: home, as: .image)
    }
    
    func testHeroesFavouriteViewWith4FavouriteHeroes() {
        let home = TabBar(heroService: createHeroService(numberOfFavouriteHeroes: 4))
        home.selectedIndex = 2
        assertSnapshot(matching: home, as: .image)
    }
    
    func testHeroesFavouriteViewWith0FavouriteHeroes() {
        let home = TabBar(heroService: createHeroService())
        home.selectedIndex = 2
        assertSnapshot(matching: home, as: .image)
    }
    
    func testHeroesSearchWith0Heroes() {
        let home = TabBar(heroService: createHeroService())
        home.selectedIndex = 0
        assertSnapshot(matching: home, as: .image)
    }
}

