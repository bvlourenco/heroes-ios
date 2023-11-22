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
    
    func fetchHeroes(addHeroesToTableView: @escaping (_ numberOfNewHeroes: Int) -> Void) {
        Task {
            let result = await self.heroService.getHeroes(offset: self.heroes.count,
                                                     numberOfHeroesPerRequest: Constants.numberOfHeroesPerRequest)
            if let additionalHeroes = try? result.get() {
                self.heroes.append(contentsOf: additionalHeroes)
                
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
    
    func getHeroAtIndex(index: Int) -> Hero {
        return self.heroes[index]
    }
    
    func setHeroAtIndex(at index: Int, hero: Hero) {
        self.heroes[index] = hero
    }
}
