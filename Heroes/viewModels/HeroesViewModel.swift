//
//  HeroesTableViewModel.swift
//  Heroes
//
//  Created by Bernardo Vala Lourenço on 06/11/2023.
//

import Foundation

class HeroesViewModel {
    private var heroes: [Hero] = []
    private var descriptionsLoaded: [Bool] = []
    private let heroService: HeroServiceProtocol
    private var loadingData = false
    
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
                
                self.descriptionsLoaded.append(contentsOf:
                                                repeatElement(false,
                                                              count: additionalHeroes.count))
                
                DispatchQueue.main.async {
                    addHeroesToTableView()
                }
            } catch {
                print(error)
            }
        }
    }
    
    func getDescriptions(heroIndex: Int) async -> Hero {
        var hero = self.heroes[heroIndex]
        
        if descriptionsLoaded[heroIndex] == false {
            do {
                hero = try await self.heroService.getHeroDetails(hero: hero)
            } catch {
                print(error)
            }
            descriptionsLoaded[heroIndex] = true
            setHero(index: heroIndex, hero: hero)
        }
        return hero
    }
    
    func numberOfHeroes() -> Int {
        return self.heroes.count
    }
    
    func getHero(index: Int) -> Hero {
        return self.heroes[index]
    }
    
    func setHero(index: Int, hero: Hero) {
        if index >= 0 && index < self.heroes.count {
            self.heroes[index] = hero
        } else if index >= 0 {
            self.heroes.append(hero)
        }
    }
    
    func isLoadingData() -> Bool {
        return self.loadingData
    }
    
    func changeLoadingDataStatus(status: Bool) {
        self.loadingData = status
    }
    
    func getHeroAtIndex(index: Int) -> Hero {
        return self.heroes[index]
    }
}
