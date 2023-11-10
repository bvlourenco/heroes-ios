//
//  HeroesSnapshotTests.swift
//  HeroesSnapshotTests
//
//  Created by Bernardo Vala Lourenço on 08/11/2023.
//

import SnapshotTesting
import XCTest
@testable import Heroes

final class HeroesSnapshotTests: XCTestCase {

    func testHeroesTableViewController() {
        let heroService = HeroFakeService()
        let heroesViewModel = HeroesViewModel(heroService: heroService)
        let heroesTableViewController = HeroesTableViewController(heroesViewModel: heroesViewModel)
        let navigationController = UINavigationController(rootViewController: heroesTableViewController)
        print(heroesTableViewController)
        assertSnapshot(matching: navigationController, as: .image)
    }
    
    func _testHeroViewController() async {
        let heroesViewModel = HeroesViewModel(heroService: HeroFakeService())
        let expectation = XCTestExpectation(description: "Fetch Heroes")
        heroesViewModel.fetchHeroes(addHeroesToTableView: {
            expectation.fulfill()
        })
        
        await fulfillment(of: [expectation], timeout: 5)
        
        // TODO: 2 view models
        let heroViewController = await HeroViewController(heroIndex: 0,
                                                          heroViewModel: heroesViewModel,
                                                          loader: ImageLoader())
        await heroViewController.loadView()
        
        DispatchQueue.main.async {
            assertSnapshot(matching: heroViewController, as: .wait(for: 5, on: .image))
        }
    }
}

// TODO: Move to horizontal hierarchy (by functionality)
// TODO: Create 2 files (for snapshot tests and unit tests)
