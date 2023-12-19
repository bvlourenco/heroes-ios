//
//  HeroesTableViewController.swift
//  Heroes
//
//  Created by Bernardo Vala Lourenço on 24/10/2023.
//

import Combine
import UIKit

class HomeViewController: HeroesViewController, ViewControllerDelegate {
    private let heroesTableView = HeroesTableView(spinnerHidden: false)

    override init(heroesViewModel: HeroesViewModel,
                  favouritesViewModel: FavouritesViewModel,
                  firstInitialization: Bool = true) {
        super.init(heroesViewModel: heroesViewModel,
                   favouritesViewModel: favouritesViewModel,
                   firstInitialization: firstInitialization)
        super.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = heroesTableView
    }
    
    override func viewDidLoad() {
        heroesTableView.setTableDataSourceAndDelegate(viewController: self)
        super.viewDidLoad()
    }
    
    func addHeroesToView() {
        reloadView()
        super.updateLoading(to: false)
    }
    
    func reloadView() {
        heroesTableView.update()
    }
    
    func spinnerHidden(to value: Bool) {
        heroesTableView.isSpinnerHidden(to: value)
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return super.getNumberOfItems()
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier,
                                                 for: indexPath) as! HeroesTableViewCell
        let hero = super.heroesViewModel.getHero(index: indexPath.row)
        
        cell.configure(imageURL: hero.thumbnail?.imageURL, name: hero.name)
        cell.storeHero = { aCell in
            try super.persistHero(hero: hero)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        super.itemSelected(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView,
                   willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {
        let lastRowIndex = tableView.numberOfRows(inSection: 0) - 1
        super.willFetchMoreHeroes(indexPath: indexPath, lastRowIndex: lastRowIndex)
    }
}
