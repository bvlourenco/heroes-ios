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
    private let encoder = JSONEncoder()
    
    func getFavouriteHeroes() {
        for heroName in UserDefaults.standard.dictionaryRepresentation().keys {
            do {
                if let data = UserDefaults.standard.data(forKey: heroName) {
                    let newHero = try decoder.decode(Hero.self, from: data)
                    if favouriteHeroes.contains(newHero) == false {
                        favouriteHeroes.append(newHero)
                    }
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
    
    private func removeHero(hero: Hero) {
        guard let index = self.favouriteHeroes.firstIndex(of: hero) else { return }
        self.favouriteHeroes.remove(at: index)
    }
    
    func numberOfFavouriteHeroes() -> Int {
        return self.favouriteHeroes.count
    }
    
    func getHero(index: Int) -> Hero {
        return self.favouriteHeroes[index]
    }
    
    func changeHeroPersistanceStatus(hero: Hero) {
        guard let name = hero.name else { return }
        
        if UserDefaults.standard.data(forKey: name) != nil {
            UserDefaults.standard.removeObject(forKey: name)
            
            guard let index = self.favouriteHeroes.firstIndex(of: hero) else { return }
            self.favouriteHeroes.remove(at: index)
        } else {
            do {
                let data = try self.encoder.encode(hero)
                UserDefaults.standard.set(data, forKey: name)
                self.favouriteHeroes.append(hero)
            } catch {
                print(error)
            }
        }
    }
}
