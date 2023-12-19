//
//  FavouritesViewController.swift
//  Heroes
//
//  Created by Bernardo Vala Lourenço on 15/12/2023.
//

import UIKit

class FavouritesViewController: UIViewController {
    private let favouritesView = FavouritesView()
    private let favouritesViewModel: FavouritesViewModel
    private let heroService: HeroServiceProtocol
    private let loader: ImageLoader = ImageLoader()
    private let encoder = JSONEncoder()
    
    init(favouritesViewModel: FavouritesViewModel, heroService: HeroServiceProtocol) {
        self.favouritesViewModel = favouritesViewModel
        self.heroService = heroService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = favouritesView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        favouritesView.update()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        favouritesView.setDataSourceAndDelegate(viewController: self)
        favouritesViewModel.getFavouriteHeroes()
    }
}

extension FavouritesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favouritesViewModel.numberOfFavouriteHeroes()
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier,
                                                 for: indexPath) as! HeroesTableViewCell
        let hero = favouritesViewModel.getHero(index: indexPath.row)
        cell.configure(imageURL: hero.thumbnail?.imageURL, name: hero.name)
        cell.storeHero = { aCell in
            guard let name = hero.name else { return }

            if UserDefaults.standard.data(forKey: name) != nil {
                UserDefaults.standard.removeObject(forKey: name)
                self.favouritesViewModel.removeHero(hero: hero)
            } else {
                let data = try self.encoder.encode(hero)
                UserDefaults.standard.set(data, forKey: name)
                self.favouritesViewModel.addFavourite(hero: hero)
            }
            
            self.favouritesView.update()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let hero = favouritesViewModel.getHero(index: indexPath.row)
        let heroDetailViewModel = HeroDetailViewModel(heroService: heroService, hero: hero)
        let destination = HeroDetailViewController(hero: hero,
                                                   heroIndex: indexPath.row,
                                                   heroDetailViewModel: heroDetailViewModel,
                                                   loader: loader, 
                                                   favouritesViewModel: favouritesViewModel)
        navigationController?.pushViewController(destination, animated: true)
    }
}
