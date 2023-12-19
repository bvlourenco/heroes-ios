//
//  FavouritesViewModelUnitTests.swift
//  HeroesUnitTests
//
//  Created by Bernardo Vala Lourenço on 19/12/2023.
//

import XCTest
@testable import Heroes

final class FavouritesViewModelUnitTests: XCTestCase {
    var favouritesViewModel: FavouritesViewModel?
    private let encoder = JSONEncoder()
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        let domainName = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domainName)
        
        favouritesViewModel = FavouritesViewModel()
    }
    
    override func tearDownWithError() throws {
        favouritesViewModel = nil
        try super.tearDownWithError()
    }
    
    private func order(heroes: [Hero]) -> [Hero] {
        return heroes.sorted { $0.name ?? "" < $1.name ?? "" }
    }
    
    func testFavourite20Heroes() throws {
        guard let favouritesViewModel else { return }
        let numberOfHeroes = 20
        
        var heroes = HeroesUnitTestHelpers.createFakeHeroes(numberOfHeroes: numberOfHeroes, startIndex: 0)
        heroes = order(heroes: heroes)
        for hero in heroes {
            guard let name = hero.name else { return }
            let data = try self.encoder.encode(hero)
            UserDefaults.standard.set(data, forKey: name)
        }
        
        favouritesViewModel.getFavouriteHeroes()
        
        XCTAssertEqual(favouritesViewModel.numberOfFavouriteHeroes(), numberOfHeroes)
        for index in 0..<numberOfHeroes {
            HeroesUnitTestHelpers.validateHero(hero: favouritesViewModel.getHero(index: index),
                                               name: heroes[index].name ?? "")
        }
    }
    
    func testFavourite0Heroes() {
        guard let favouritesViewModel else { return }
        favouritesViewModel.getFavouriteHeroes()
        XCTAssertEqual(favouritesViewModel.numberOfFavouriteHeroes(), 0)
    }
}
