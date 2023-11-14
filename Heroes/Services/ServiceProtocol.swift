//
//  ServiceProtocol.swift
//  Heroes
//
//  Created by Bernardo Vala Lourenço on 06/11/2023.
//

import Foundation

enum HeroError: Error {
    case networkError, decodingError, taskGroupError, serverError
}

enum NetworkError: Error {
    case badUrl, serverError, resourceNotFound,
         badRequest, appError
}

protocol HeroServiceProtocol {
    func getHeroes(offset: Int, numberOfHeroesPerRequest: Int) async -> Result<[Hero], HeroError>
    func getHeroDetails(hero: Hero) async -> Result<Hero, HeroError>
}
