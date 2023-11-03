//
//  ViewController.swift
//  Heroes
//
//  Created by Bernardo Vala Lourenço on 24/10/2023.
//

import UIKit

class HeroesTableViewController: UIViewController {
    private var heroes: [Hero] = []
    private let heroService = HeroService()
    lazy var heroesTableView = HeroesTableView()
    var loadingData = false
    
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
                var additionalHeroes = try await self.heroService.getHeroes(offset: offset)
                additionalHeroes = try await self.heroService.downloadImages(heroes: additionalHeroes)
                self.heroes.append(contentsOf: additionalHeroes)
                let indexPaths = (self.heroes.count - Constants.numberOfHeroesPerRequest
                                  ..< self.heroes.count)
                    .map { IndexPath(row: $0, section: 0) }
                heroesTableView.tableView.beginUpdates()
                heroesTableView.tableView.tableFooterView?.isHidden = true
                heroesTableView.tableView.insertRows(at: indexPaths, with: .none)
                heroesTableView.tableView.endUpdates()
                loadingData = false
            } catch {
                print(error)
            }
        }
    }
}

extension HeroesTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return self.heroes.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",
                                                 for: indexPath)
        
        if let imageData = self.heroes[indexPath.row].imageData {
            cell.imageView?.image = UIImage(data: imageData)
        } else {
            cell.imageView?.image = UIImage(named: "placeholder")
        }
        cell.imageView?.contentMode = .scaleAspectFit
        cell.textLabel?.text = self.heroes[indexPath.row].name

        return cell
    }
    
    func tableView(_ tableView: UITableView, 
                   didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)

        let destination = HeroViewController(hero: self.heroes[indexPath.row])
        navigationController?.pushViewController(destination, animated: true)
    }
    
    // From: https://stackoverflow.com/a/42457571
    func tableView(_ tableView: UITableView,
                   willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {
        let lastRowIndex = tableView.numberOfRows(inSection: 0) - 1
        let batchMiddleRowIndex = Constants.numberOfHeroesPerRequest / 2
        let rowIndexLoadMoreHeroes = lastRowIndex - batchMiddleRowIndex
        if loadingData == false && indexPath.row >= rowIndexLoadMoreHeroes {
            heroesTableView.tableView.tableFooterView?.isHidden = false
            loadingData = true
            fetchHeroes(offset: self.heroes.count)
        }
    }
}
