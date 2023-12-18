//
//  FavouritesViewModel.swift
//  Heroes
//
//  Created by Bernardo Vala Lourenço on 18/12/2023.
//

import Foundation

class FavouritesViewModel {
    private var favouriteHeroes: [Hero] = []
    private let decoder = JSONDecoder()
    
    func getFavouriteHeroes() {
        for heroName in UserDefaults.standard.dictionaryRepresentation().keys {
            do {
                if let data = UserDefaults.standard.data(forKey: heroName) {
                    let newHero = try decoder.decode(Hero.self, from: data)
                    favouriteHeroes.append(newHero)
                }
            } catch {
                print(error)
            }
        }
        orderHeroes()
    }
    
    private func orderHeroes() {
        self.favouriteHeroes = self.favouriteHeroes.sorted { $0.name ?? "" < $1.name ?? "" }
    }
    
    func numberOfFavouriteHeroes() -> Int {
        return self.favouriteHeroes.count
    }
    
    func getHero(index: Int) -> Hero {
        return self.favouriteHeroes[index]
    }
}
