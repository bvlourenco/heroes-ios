//
//  ViewController.swift
//  Heroes
//
//  Created by Bernardo Vala Lourenço on 24/10/2023.
//

import UIKit

class HeroesTableViewController: UIViewController {
    private var heroes: [Hero] = []
    private var loadingData = false
    private lazy var heroesTableView = HeroesTableView()
    private let heroService: HeroServiceProtocol
    
    init(heroService: HeroServiceProtocol = HeroService()) {
        self.heroService = heroService
        super.init(nibName: "HeroesTableViewController", bundle: Bundle.main)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        heroesTableView.tableView.delegate = self
        heroesTableView.tableView.dataSource = self
        view = heroesTableView
        navigationItem.title = "All heroes"
        fetchHeroes(offset: 0)
    }
    
    private func fetchHeroes(offset: Int) {
        Task {
            do {
                var additionalHeroes = try await self.heroService
                    .getHeroes(offset: offset)
                additionalHeroes = try await self.heroService
                    .downloadImages(heroes: additionalHeroes)
                self.heroes.append(contentsOf: additionalHeroes)
                addHeroesToTableView()
            } catch {
                print(error)
            }
        }
    }
    
    private func addHeroesToTableView() {
        var beginIndex = 0
        if self.heroes.count >= Constants.numberOfHeroesPerRequest {
            beginIndex = self.heroes.count - Constants.numberOfHeroesPerRequest
        }
        let indexPaths = (beginIndex..<self.heroes.count)
                         .map { IndexPath(row: $0, section: 0) }
        heroesTableView.tableView.beginUpdates()
        heroesTableView.tableView.tableFooterView?.isHidden = true
        heroesTableView.tableView.insertRows(at: indexPaths, with: .none)
        heroesTableView.tableView.endUpdates()
        loadingData = false
    }
}

extension HeroesTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return self.heroes.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row >= self.heroes.count {
            return UITableViewCell()
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",
                                                 for: indexPath) as! HeroesTableViewCell
        
        if let imageData = self.heroes[indexPath.row].imageData {
            cell.heroImage.image = UIImage(data: imageData)
        } else {
            cell.heroImage.image = UIImage(named: "placeholder")
        }
        cell.heroName.text = self.heroes[indexPath.row].name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row >= self.heroes.count {
            return
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let destination = HeroViewController(hero: self.heroes[indexPath.row],
                                             service: heroService)
        navigationController?.pushViewController(destination, animated: true)
    }
    
    // From: https://stackoverflow.com/a/42457571
    func tableView(_ tableView: UITableView,
                   willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {
        
        if self.heroes.count < Constants.numberOfHeroesPerRequest {
            return
        }
        
        let lastRowIndex = tableView.numberOfRows(inSection: 0) - 1
        let batchMiddleRowIndex = Constants.numberOfHeroesPerRequest / 2
        let rowIndexLoadMoreHeroes = lastRowIndex - batchMiddleRowIndex
        if loadingData == false
            && indexPath.row >= rowIndexLoadMoreHeroes {
            heroesTableView.tableView.tableFooterView?.isHidden = false
            loadingData = true
            fetchHeroes(offset: self.heroes.count)
        }
    }
    
    func tableView(_ tableView: UITableView, 
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row >= self.heroes.count {
            return 0
        }
        
        return Constants.tableViewImageHeight
    }
}
