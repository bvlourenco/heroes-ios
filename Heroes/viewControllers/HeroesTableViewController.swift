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
    
    override func loadView() {
        heroesTableView.tableView.delegate = self
        heroesTableView.tableView.dataSource = self
        view = heroesTableView
        navigationItem.title = "All heroes"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchHeroes(offset: 0)
    }
    
    private func fetchHeroes(offset: Int) {
        Task {
            do {
                let additionalHeroes = try await self.heroService.getHeroes(offset: offset)
                self.heroes.append(contentsOf: additionalHeroes)
                let indexPaths = (self.heroes.count - additionalHeroes.count ..< self.heroes.count)
                    .map { IndexPath(row: $0, section: 0) }
                heroesTableView.tableView.beginUpdates()
                heroesTableView.tableView.insertRows(at: indexPaths, with: .automatic)
                heroesTableView.tableView.endUpdates()
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
        
        // Since we are reusing cells, this instruction will remove the image
        // associated to the reusable cell.
        cell.imageView?.image = UIImage(named: "placeholder")
        cell.textLabel?.text = self.heroes[indexPath.row].name
        
        // If imageURL points to a not available image, use a placeholder
        if self.heroes[indexPath.row].imageURL
            .hasSuffix("image_not_available.jpg") == false {
            // Source: https://stackoverflow.com/a/52416497
            ImageCache.imageForUrl(urlString:
                                    self.heroes[indexPath.row].imageURL,
                                   completionHandler: {
                (image, url, isNotLoaded) in
                if image != nil {
                    cell.imageView!.alpha = 0
                    cell.imageView?.image = image
                    UIView.animate(withDuration: 1,
                                   delay: 0,
                                   options: UIView.AnimationOptions
                        .showHideTransitionViews,
                                   animations: { () -> Void in
                        cell.imageView!.alpha = 1 }
                    )
                }
            })
        }
        
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
        let lastSectionIndex = tableView.numberOfSections - 1
        let lastRowIndex = tableView.numberOfRows(inSection:
                                                    lastSectionIndex) - 1
        if indexPath.section == lastSectionIndex
            && indexPath.row == lastRowIndex {
            let spinner = UIActivityIndicatorView(style: .medium)
            spinner.startAnimating()
            spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0),
                                   width: tableView.bounds.width,
                                   height: CGFloat(44))
            
            heroesTableView.tableView.tableFooterView = spinner
            heroesTableView.tableView.tableFooterView?.isHidden = false
            
            fetchHeroes(offset: self.heroes.count)
        } else {
            heroesTableView.tableView.tableFooterView?.isHidden = true
            heroesTableView.tableView.tableFooterView = nil
        }
    }
}
