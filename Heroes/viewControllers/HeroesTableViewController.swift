//
//  ViewController.swift
//  Heroes
//
//  Created by Bernardo Vala Lourenço on 24/10/2023.
//

import UIKit

class HeroesTableViewController: UIViewController {
    let heroesViewModel: HeroesViewModel
    private lazy var heroesTableView = HeroesTableView()
    
    init(heroService: HeroServiceProtocol = HeroService()) {
        self.heroesViewModel = HeroesViewModel(heroService: heroService)
        super.init(nibName: "HeroesTableViewController", bundle: Bundle.main)
        heroesTableView.tableView.delegate = self
        heroesTableView.tableView.dataSource = self
        view = heroesTableView
        navigationItem.title = "All heroes"
        heroesViewModel.fetchHeroes(addHeroesToTableView: addHeroesToTableView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addHeroesToTableView() {
        heroesTableView.tableView.reloadData()
        heroesViewModel.changeLoadingDataStatus(status: false)
    }
}

extension HeroesTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return heroesViewModel.numberOfHeroes()
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let numberOfHeroes = heroesViewModel.numberOfHeroes()
        if indexPath.row >= numberOfHeroes {
            return UITableViewCell()
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",
                                                 for: indexPath) as! HeroesTableViewCell
        let hero = heroesViewModel.getHeroAtIndex(index: indexPath.row)
        
        if let imageData = hero.imageData {
            cell.heroImage.image = UIImage(data: imageData)
        } else {
            cell.heroImage.image = UIImage(named: "placeholder")
        }
        cell.heroName.text = hero.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        
        let numberOfHeroes = heroesViewModel.numberOfHeroes()
        if indexPath.row >= numberOfHeroes {
            return
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let destination = HeroViewController(heroIndex: indexPath.row,
                                             heroViewModel: heroesViewModel)
        navigationController?.pushViewController(destination, animated: true)
    }
    
    // From: https://stackoverflow.com/a/42457571
    func tableView(_ tableView: UITableView,
                   willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {
        
        let numberOfHeroes = heroesViewModel.numberOfHeroes()
        if numberOfHeroes < Constants.numberOfHeroesPerRequest {
            return
        }
        
        let lastRowIndex = tableView.numberOfRows(inSection: 0) - 1
        let batchMiddleRowIndex = Constants.numberOfHeroesPerRequest / 2
        let rowIndexLoadMoreHeroes = lastRowIndex - batchMiddleRowIndex
        if heroesViewModel.isLoadingData() == false
            && indexPath.row >= rowIndexLoadMoreHeroes {
            heroesTableView.tableView.tableFooterView?.isHidden = false
            heroesViewModel.changeLoadingDataStatus(status: true)
            heroesViewModel.fetchHeroes(addHeroesToTableView: addHeroesToTableView)
        }
    }
    
    func tableView(_ tableView: UITableView, 
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let numberOfHeroes = heroesViewModel.numberOfHeroes()
        if indexPath.row >= numberOfHeroes {
            return 0
        }
        
        return Constants.tableViewImageHeight
    }
}
