//
//  HeroesTableViewModel.swift
//  Heroes
//
//  Created by Bernardo Vala Lourenço on 06/11/2023.
//

import Foundation

// TODO: Mock view model for unit tests
class HeroesTableViewModel {
    private var heroes: [Hero] = []
    let heroService: HeroServiceProtocol
    
    init(heroService: HeroServiceProtocol) {
        self.heroService = heroService
    }
    
    func fetchHeroes(addHeroesToTableView: @escaping () -> Void) {
        Task {
            do {
                let additionalHeroes = try await self.heroService
                    .getHeroes(offset: self.heroes.count,
                               numberOfHeroesPerRequest: Constants.numberOfHeroesPerRequest)
                self.heroes.append(contentsOf: additionalHeroes)
                
                DispatchQueue.main.async {
                    addHeroesToTableView()
                }
            } catch {
                print(error)
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
