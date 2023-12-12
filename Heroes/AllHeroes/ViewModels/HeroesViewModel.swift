//
//  HeroesViewModel.swift
//  Heroes
//
//  Created by Bernardo Vala Lourenço on 06/11/2023.
//

import Foundation

class HeroesViewModel {
    private var heroes: [Hero] = []
    private var heroesInSearch: [Hero] = []
    var numberOfFavouriteHeroes: Int = 0
    let heroService: HeroServiceProtocol
    
    init(heroService: HeroServiceProtocol) {
        self.heroService = heroService
    }
    
    func fetchHeroes(searchQuery: String?, addHeroesToView: @escaping () -> Void) {
        Task {
            let offset = searchQuery != nil ? 0 : self.heroes.count
            
            let result = await self.heroService.getHeroes(offset: offset,
                                                          numberOfHeroesPerRequest: Constants.numberOfHeroesPerRequest,
                                                          searchQuery: searchQuery)
            
            DispatchQueue.main.async { [weak self] in
                if let additionalHeroes = try? result.get() {
                    if searchQuery != nil {
                        self?.heroesInSearch.append(contentsOf: additionalHeroes)
                    } else {
                        for hero in additionalHeroes {
                            if self?.heroes.contains(hero) == false {
                                self?.heroes.append(hero)
                            }
                        }
                    }
                }
                
                addHeroesToView()
            }
        }
    }
    
    func numberOfHeroes(inSearch: Bool) -> Int {
        if inSearch {
            return self.heroesInSearch.count
        } else {
            return self.heroes.count
        }
    }
    
    func getHero(inSearch: Bool, index: Int) -> Hero {
        if inSearch {
            return self.heroesInSearch[index]
        } else {
            return self.heroes[index]
        }
    }
    
    func setHero(at index: Int, hero: Hero) {
        self.heroes[index] = hero
    }
    
    func moveHero(hero: Hero, to newIndex: Int) {
        guard let index = self.heroes.firstIndex(of: hero) else { return }
        self.heroes.remove(at: index)
        self.heroes.insert(hero, at: newIndex)
    }
    
    func clearHeroesInSearch() {
        self.heroesInSearch = []
    }
    
    func addHeroes(hero: Hero) {
        self.heroes.append(hero)
    }
}
