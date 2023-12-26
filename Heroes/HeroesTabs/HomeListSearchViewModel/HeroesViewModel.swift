//
//  HeroesViewModel.swift
//  Heroes
//
//  Created by Bernardo Vala Lourenço on 06/11/2023.
//

import Foundation

class HeroesViewModel {
    private var heroes: [Hero] = []
    let heroService: HeroServiceProtocol
    
    init(heroService: HeroServiceProtocol) {
        self.heroService = heroService
    }
    
    func fetchHeroes(searchQuery: String?, addHeroesToView: @escaping () -> Void) {
        Task {
            let result = await self.heroService.getHeroes(offset: self.heroes.count,
                                                          numberOfHeroesPerRequest: GlobalConstants.numberOfHeroesPerRequest,
                                                          searchQuery: searchQuery)
            
            if let additionalHeroes = try? result.get() {
                for hero in additionalHeroes {
                    if self.heroes.contains(hero) == false {
                        self.heroes.append(hero)
                    }
                }
            }
                
            DispatchQueue.main.async {
                addHeroesToView()
            }
        }
    }
    
    func numberOfHeroes() -> Int {
        return self.heroes.count
    }
    
    func getHero(index: Int) -> Hero {
        return self.heroes[index]
    }
    
    func setHero(at index: Int, hero: Hero) {
        self.heroes[index] = hero
    }
    
    func addHero(hero: Hero) {
        self.heroes.append(hero)
    }
    
    func clearHeroes() {
        self.heroes = []
    }
}
