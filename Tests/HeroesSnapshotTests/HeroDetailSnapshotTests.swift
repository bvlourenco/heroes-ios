//
//  HeroDetailSnapshotTests.swift
//  HeroesSnapshotTests
//
//  Created by Bernardo Vala Lourenço on 13/11/2023.
//

import SnapshotTesting
import XCTest
@testable import Heroes

// TODO: this snapshot test is weird. Always passing...
final class HeroDetailSnapshotTests: XCTestCase {
    func testHeroViewController() async {
        let heroService = HeroFakeService()
        let hero = heroService.getHeroIndex(heroIndex: 0)
        let heroViewController = await HeroDetailViewController(hero: hero,
                                                                heroIndex: 0,
                                                                heroService: heroService,
                                                                loader: ImageLoader())
        await heroViewController.viewDidLoad()

        DispatchQueue.main.async {
            assertSnapshot(matching: heroViewController, as: .wait(for: 10, on: .image))
        }
    }
}
