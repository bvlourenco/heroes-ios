//
//  HeroesTableViewModel.swift
//  Heroes
//
//  Created by Bernardo Vala Lourenço on 06/11/2023.
//

import Foundation

class HeroesTableViewModel {
    var heroes: [Hero] = []
    private let heroService = HeroService()
    var loadingData = false
    
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
    
    func numberOfHeroes() -> Int {
        return self.heroes.count
    }
}
