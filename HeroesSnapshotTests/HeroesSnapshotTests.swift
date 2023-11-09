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

    override func setUpWithError() throws {
        try super.setUpWithError()
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }
    
    func testHeroesTableViewController() {
        let heroesTableViewController = HeroesTableViewController(heroService: HeroFakeService())
        let navigationController = UINavigationController(rootViewController:
                                                        heroesTableViewController)
        assertSnapshot(matching: navigationController, as: .wait(for: 5, on: .image))
    }
    
    func testHeroViewController() async {
        let heroesViewModel = HeroesViewModel(heroService: HeroFakeService())
        let expectation = XCTestExpectation(description: "Fetch Heroes")
        heroesViewModel.fetchHeroes(addHeroesToTableView: {
            expectation.fulfill()
        })
        
        await fulfillment(of: [expectation], timeout: 5)
        
        let heroViewController = await HeroViewController(heroIndex: 0,
                                                    heroViewModel: heroesViewModel)
        await heroViewController.loadView()
        
        DispatchQueue.main.async {
            assertSnapshot(matching: heroViewController, as: .wait(for: 5, on: .image))
        }
    }
}
