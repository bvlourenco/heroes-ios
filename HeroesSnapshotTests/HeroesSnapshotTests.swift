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
    var navigationController: UINavigationController?
    var heroesTableViewController: HeroesTableViewController?
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        heroesTableViewController = HeroesTableViewController(heroService: HeroFakeService())
        
        if let heroesTableViewController = heroesTableViewController {
            navigationController = UINavigationController(rootViewController:
                                                            heroesTableViewController)
        }
    }
    
    override func tearDownWithError() throws {
        heroesTableViewController = nil
        navigationController = nil
        try super.tearDownWithError()
    }
    
    func testHeroesTableViewController() {
        if let navigationController = navigationController {
            assertSnapshot(matching: navigationController, as: .image)
        } else {
            XCTFail("Navigation controller was not initialized")
        }
    }
    
    func testHeroViewController() {
        if let navigationController = navigationController,
           let heroesTableViewController = heroesTableViewController {
            let destination = HeroViewController(heroIndex: 0,
                                                 heroViewModel: heroesTableViewController.heroesViewModel)
            navigationController.pushViewController(destination, animated: false)
            
            assertSnapshot(matching: navigationController, as: .image)
        } else {
            XCTFail("Navigation controller and/or heroes table view controller"
                    + "was not initialized")
        }
    }
}
