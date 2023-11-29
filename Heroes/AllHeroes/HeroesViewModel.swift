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
    let heroService: HeroServiceProtocol
    
    init(heroService: HeroServiceProtocol) {
        self.heroService = heroService
    }
    
    func fetchHeroes(searchQuery: String?, addHeroesToTableView: @escaping (_ numberOfNewHeroes: Int) -> Void) {
        Task {
            let offset = searchQuery != nil ? 0 : self.heroes.count
            
            let result = await self.heroService.getHeroes(offset: offset,
                                                          numberOfHeroesPerRequest: Constants.numberOfHeroesPerRequest,
                                                          searchQuery: searchQuery)
            if let additionalHeroes = try? result.get() {
                
                if searchQuery != nil {
                    self.heroesInSearch.append(contentsOf: additionalHeroes)
                } else {
                    self.heroes.append(contentsOf: additionalHeroes)
                }
                
                DispatchQueue.main.async {
                    addHeroesToTableView(additionalHeroes.count)
                }
            } else {
                DispatchQueue.main.async {
                    addHeroesToTableView(0)
                }
            }
        }
    }
    
    func numberOfHeroes() -> Int {
        return self.heroes.count
    }
    
    func numberOfHeroesInSearch() -> Int {
        return self.heroesInSearch.count
    }
    
    func getHeroAtIndex(index: Int) -> Hero {
        return self.heroes[index]
    }
    
    func getHeroInSearchAtIndex(index: Int) -> Hero {
        return self.heroesInSearch[index]
    }
    
    func setHeroAtIndex(at index: Int, hero: Hero) {
        self.heroes[index] = hero
    }
    
    func clearHeroesInSearch() {
        self.heroesInSearch = []
    }
}
