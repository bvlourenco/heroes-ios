//
//  HeroesTableViewModel.swift
//  Heroes
//
//  Created by Bernardo Vala Lourenço on 06/11/2023.
//

import Foundation

class HeroesViewModel {
    private var heroes: [Hero] = []
    private let heroService: HeroServiceProtocol
    private var loadingData = false
    
    init(heroService: HeroServiceProtocol) {
        self.heroService = heroService
    }
    
    func fetchHeroes(addHeroesToTableView: @escaping () -> Void) {
        Task {
            do {
                var additionalHeroes = try await self.heroService
                    .getHeroes(offset: self.heroes.count)
                additionalHeroes = try await self.heroService
                    .downloadImages(heroes: additionalHeroes)
                self.heroes.append(contentsOf: additionalHeroes)
                
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
        
        if hero.descriptionsLoaded == false {
            do {
                hero = try await self.heroService.getHeroDetails(hero: hero)
            } catch {
                print(error)
            }
            hero.descriptionsLoaded = true
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
        self.heroes[index] = hero
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
