//
//  ViewController.swift
//  Heroes
//
//  Created by Bernardo Vala Lourenço on 24/10/2023.
//

import UIKit

class HeroesTableViewController: UIViewController {
    private let heroesViewModel: HeroesViewModel
    private let loader: ImageLoader = ImageLoader()
    private let heroesTableView = HeroesTableView()
    private let spinner: UIActivityIndicatorView
    
    init(heroesViewModel: HeroesViewModel) {
        self.heroesViewModel = heroesViewModel
        self.spinner = UIActivityIndicatorView(style: .medium)
        self.spinner.startAnimating()
        self.spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0),
                                    width: UIScreen.main.bounds.width,
                                    height: CGFloat(Constants.spinnerHeight))
        heroesTableView.addSpinnerToBottom(spinner: spinner)
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        view = heroesTableView
    }
    
    override func viewDidLoad() {
        heroesTableView.setTableDataSourceAndDelegate(viewController: self)
        navigationItem.title = "All heroes"
        
        heroesViewModel.fetchHeroes(addHeroesToTableView: { [weak self] in
            self?.addHeroesToTableView()
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addHeroesToTableView() {
        var beginIndex = 0
        let numberOfHeroes = heroesViewModel.numberOfHeroes()
        if numberOfHeroes >= Constants.numberOfHeroesPerRequest {
            beginIndex = numberOfHeroes - Constants.numberOfHeroesPerRequest
        }
        let indexPaths = (beginIndex..<numberOfHeroes)
                            .map { IndexPath(row: $0, section: 0) }
        heroesTableView.update(indexPaths: indexPaths)
        heroesTableView.isSpinnerHidden(to: true)
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
        
        let imageURL = hero.thumbnail?.imageURL
        
        if let imageURL = imageURL {
            if imageURL.absoluteString.hasSuffix(Constants.notAvailableImageName) == false {
                cell.heroImage.loadImage(at: imageURL)
            } else {
                cell.heroImage.image = UIImage(named: "placeholder")
            }
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
                                             heroViewModel: heroesViewModel,
                                             loader: loader)
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
            heroesTableView.isSpinnerHidden(to: false)
            heroesViewModel.changeLoadingDataStatus(status: true)
            heroesViewModel.fetchHeroes(addHeroesToTableView: { [weak self] in
                self?.addHeroesToTableView()
            })
        }
    }
}
