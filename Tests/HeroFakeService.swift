//
//  HeroFakeServiceProtocol.swift
//  Heroes
//
//  Created by Bernardo Vala Lourenço on 06/11/2023.
//

import Foundation
import UIKit

class HeroFakeService: HeroServiceProtocol {
    
    var getHeroesStub: () -> Result<[Hero], HeroError> = { return .success([]) }
    var getHeroesSearchStub: () -> Result<[Hero], HeroError> = { return .success([]) }
    var comicsDescription: [String] = []
    var eventsDescription: [String] = []
    var storiesDescription: [String] = []
    var seriesDescription: [String] = []
    
    func getHeroes(offset: Int, numberOfHeroesPerRequest: Int, searchQuery: String?) async -> Result<[Hero], HeroError> {
        if searchQuery != nil {
            return self.getHeroesSearchStub()
        } else {
            return self.getHeroesStub()
        }
    }

    func getHeroDetails(hero: Hero) async -> Result<Hero, HeroError> {
        var hero = hero
        
        do {
            hero.comics = try Hero.updateHeroCategoryDescription(descriptions: comicsDescription,
                                                                 category: hero.comics)
            hero.events = try Hero.updateHeroCategoryDescription(descriptions: eventsDescription,
                                                                 category: hero.events)
            hero.stories = try Hero.updateHeroCategoryDescription(descriptions: storiesDescription,
                                                                  category: hero.stories)
            hero.series = try Hero.updateHeroCategoryDescription(descriptions: seriesDescription,
                                                                 category: hero.series)
        } catch {
            print(error)
            return .failure(HeroError.networkError)
        }
        
        return .success(hero)
    }
}
