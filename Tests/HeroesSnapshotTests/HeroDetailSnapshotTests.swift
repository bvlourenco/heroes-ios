//
//  HeroDetailSnapshotTests.swift
//  HeroesSnapshotTests
//
//  Created by Bernardo Vala Lourenço on 13/11/2023.
//

import SnapshotTesting
import XCTest
@testable import Heroes

final class HeroDetailSnapshotTests: XCTestCase {
    func testHeroViewController() async {
        let heroService = HeroFakeService()
        let hero = Hero.mock()
        let heroDetailViewModel = HeroDetailViewModel(heroService: heroService, hero: hero)
        let heroViewController = await HeroDetailViewController(hero: hero,
                                                                heroIndex: 0,
                                                                heroDetailViewModel: heroDetailViewModel,
                                                                loader: ImageLoader())
        await heroViewController.viewDidLoad()

        DispatchQueue.main.async {
            assertSnapshot(matching: heroViewController, as: .image)
        }
    }
}
