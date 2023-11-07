//
//  ServiceProtocol.swift
//  Heroes
//
//  Created by Bernardo Vala Lourenço on 06/11/2023.
//

import Foundation

protocol HeroServiceProtocol {
    func getHeroes(offset: Int) async throws -> [Hero]
    func downloadImages(heroes: [Hero]) async throws -> [Hero]
    func getHeroDetails(hero: Hero) async throws -> Hero
}
