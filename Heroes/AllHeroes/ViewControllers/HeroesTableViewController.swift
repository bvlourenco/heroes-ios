//
//  HeroesTableViewController.swift
//  Heroes
//
//  Created by Bernardo Vala Lourenço on 24/10/2023.
//

import Combine
import UIKit

class HeroesTableViewController: HeroesViewController, ViewControllerDelegate {
    
    private enum TableViewConstants {
        static let gridIconName = "icons8-grid-2-50"
    }
    
    private let heroesTableView = HeroesTableView()

    override init(heroesViewModel: HeroesViewModel, firstInitialization: Bool = true) {
        super.init(heroesViewModel: heroesViewModel, firstInitialization: firstInitialization)
        super.delegate = self
        heroesTableView.addSpinnerToBottom(spinner: super.spinner)
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
        heroesTableView.isSpinnerHidden(to: true)
        super.updateLoading(to: false)
    }
    
    func hideSpinner() {
        heroesTableView.isSpinnerHidden(to: false)
    }
    
    func reloadView() {
        heroesTableView.update()
    }
    
    func getTopBarIconImage() -> UIImage? {
        return UIImage(named: TableViewConstants.gridIconName)
    }
    
    func getViewControllers() -> [UIViewController] {
        return [HeroesGridViewController(heroesViewModel: super.heroesViewModel, firstInitialization: false)]
    }
}

extension HeroesTableViewController: UITableViewDelegate, UITableViewDataSource {
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
