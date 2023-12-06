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
                
                DispatchQueue.main.async {
                    var count = 0
                    if searchQuery != nil {
                        self.heroesInSearch.append(contentsOf: additionalHeroes)
                        count = additionalHeroes.count
                    } else {
                        for hero in additionalHeroes {
                            if self.heroes.contains(hero) == false {
                                self.heroes.append(hero)
                                count += 1
                            }
                        }
                    }
                    
                    addHeroesToTableView(count)
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
        if index >= 0 {
            self.heroes[index] = hero
        } else {
            guard let index = self.heroes.firstIndex(of: hero) else { return }
            self.heroes.remove(at: index)
            self.heroes.insert(hero, at: 0)
        }
    }
    
    func clearHeroesInSearch() {
        self.heroesInSearch = []
    }
    
    func addHeroes(hero: Hero) {
        self.heroes.append(hero)
    }
}
