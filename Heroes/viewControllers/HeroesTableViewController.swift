//
//  ViewController.swift
//  Heroes
//
//  Created by Bernardo Vala Lourenço on 24/10/2023.
//

import UIKit

class HeroesTableViewController: UIViewController {
    private let heroesTableViewModel = HeroesTableViewModel()
    private lazy var heroesTableView = HeroesTableView()
    
    override func loadView() {
        heroesTableView.tableView.delegate = self
        heroesTableView.tableView.dataSource = self
        view = heroesTableView
        navigationItem.title = "All heroes"
        heroesTableViewModel.fetchHeroes(addHeroesToTableView: addHeroesToTableView)
    }
    
    private func addHeroesToTableView() {
        let numberOfHeroes = heroesTableViewModel.numberOfHeroes()
        let indexPaths = (numberOfHeroes - Constants.numberOfHeroesPerRequest
                          ..< numberOfHeroes)
            .map { IndexPath(row: $0, section: 0) }
        heroesTableView.tableView.beginUpdates()
        heroesTableView.tableView.tableFooterView?.isHidden = true
        heroesTableView.tableView.insertRows(at: indexPaths, with: .none)
        heroesTableView.tableView.endUpdates()
        heroesTableViewModel.loadingData = false
    }
}

extension HeroesTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return heroesTableViewModel.numberOfHeroes()
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",
                                                 for: indexPath) as! HeroesTableViewCell
        
        if let imageData = heroesTableViewModel.heroes[indexPath.row].imageData {
            cell.heroImage.image = UIImage(data: imageData)
        } else {
            cell.heroImage.image = UIImage(named: "placeholder")
        }
        cell.heroName.text = heroesTableViewModel.heroes[indexPath.row].name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let destination = HeroViewController(hero:heroesTableViewModel.heroes[indexPath.row])
        navigationController?.pushViewController(destination, animated: true)
    }
    
    // From: https://stackoverflow.com/a/42457571
    func tableView(_ tableView: UITableView,
                   willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {
        let lastRowIndex = tableView.numberOfRows(inSection: 0) - 1
        let batchMiddleRowIndex = Constants.numberOfHeroesPerRequest / 2
        let rowIndexLoadMoreHeroes = lastRowIndex - batchMiddleRowIndex
        if heroesTableViewModel.loadingData == false
            && indexPath.row >= rowIndexLoadMoreHeroes {
            heroesTableView.tableView.tableFooterView?.isHidden = false
            heroesTableViewModel.loadingData = true
            heroesTableViewModel.fetchHeroes(addHeroesToTableView: addHeroesToTableView)
        }
    }
}
