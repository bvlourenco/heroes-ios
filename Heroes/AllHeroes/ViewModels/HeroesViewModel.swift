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
    
    func setHeroAtIndex(at index: Int, hero: Hero, newIndex: Int = 0) {
        if index >= 0 {
            self.heroes[index] = hero
        } else {
            guard let index = self.heroes.firstIndex(of: hero) else { return }
            self.heroes.remove(at: index)
            self.heroes.insert(hero, at: newIndex)
        }
    }
    
    func clearHeroesInSearch() {
        self.heroesInSearch = []
    }
    
    func addHeroes(hero: Hero) {
        self.heroes.append(hero)
    }
    
    func changeNumberOfFavouriteHeroes(moreFavouriteHeroes: Bool) {
        if moreFavouriteHeroes {
            numberOfFavouriteHeroes += 1
        } else {
            numberOfFavouriteHeroes -= 1
        }
    }
}
