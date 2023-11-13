//
//  HeroViewModel.swift
//  Heroes
//
//  Created by Bernardo Vala Lourenço on 13/11/2023.
//

import Foundation

class HeroDetailViewModel {
    private var hero: Hero
    private let heroService: HeroServiceProtocol
    
    init(heroService: HeroServiceProtocol, hero: Hero) {
        self.heroService = heroService
        self.hero = hero
    }
    
    func getHeroDescriptions() async -> Hero {
        let descriptionLoaded = isHeroDescriptionsLoaded()
        
        if descriptionLoaded == false {
            do {
                self.hero = try await self.heroService.getHeroDetails(hero: hero)
            } catch {
                print(error)
            }
        }
        return hero
    }
    
    private func isHeroDescriptionsLoaded() -> Bool {
        if categoryDescriptionIsLoaded(for: hero.comics) ||
           categoryDescriptionIsLoaded(for: hero.events) ||
           categoryDescriptionIsLoaded(for: hero.stories) ||
           categoryDescriptionIsLoaded(for: hero.series) {
            return true
        }
        return false
    }
    
    private func categoryDescriptionIsLoaded(for category: Category?) -> Bool {
        if let category = category {
            for item in category.items {
                if item.description != nil {
                    return true
                }
            }
        }
        return false
    }
}
