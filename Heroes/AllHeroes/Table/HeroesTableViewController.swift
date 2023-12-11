//
//  HeroesTableViewController.swift
//  Heroes
//
//  Created by Bernardo Vala Lourenço on 24/10/2023.
//

import Combine
import UIKit

class HeroesTableViewController: AllHeroesViewController, ViewDelegate {
    private let heroesTableView = HeroesTableView()

    override init(heroesViewModel: HeroesViewModel) {
        super.init(heroesViewModel: heroesViewModel)
        super.delegate = self
        heroesTableView.addSpinnerToBottom(spinner: super.getSpinner())
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
        return UIImage(named: "icons8-grid-2-50")
    }
    
    func getViewControllers() -> [UIViewController] {
        return [HeroesGridViewController(heroesViewModel: super.getViewModel())]
    }
}

extension HeroesTableViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return super.getNumberOfSections()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return isDoingASearch() ? super.getSectionTitle(section: section) : nil
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return super.getNumberOfItemsInSection(section: section)
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isLoadingCell(section: indexPath.section) {
            return tableView.dequeueReusableCell(withIdentifier: Constants.loadingCellIdentifier,
                                                 for: indexPath) as! LoadingTableViewCell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier,
                                                     for: indexPath) as! HeroesTableViewCell
            let hero = super.getHero(indexPath: indexPath)
            
            cell.configure(imageURL: hero.thumbnail?.imageURL, name: hero.name)
            cell.storeHero = { aCell in
                let destinationIndex = try super.persistHero(section: indexPath.section,
                                                             hero: hero)
                if indexPath.section == 0 {
                    self.reloadView()
                } else if destinationIndex >= 0 {
                    let actualIndexPath = tableView.indexPath(for: aCell)!
                    tableView.moveRow(at: actualIndexPath, to: IndexPath(row: destinationIndex, section: 1))
                }
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        super.itemSelected(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView,
                   willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {
        let lastRowIndex = tableView.numberOfRows(inSection: 1) - 1
        super.willFetchMoreHeroes(indexPath: indexPath, lastRowIndex: lastRowIndex)
    }
}
