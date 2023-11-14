//
//  ViewController.swift
//  Heroes
//
//  Created by Bernardo Vala Lourenço on 24/10/2023.
//

import UIKit

class HeroesTableViewController: UIViewController {
    private let heroesTableViewModel: HeroesTableViewModel
    private let loader: ImageLoader = ImageLoader()
    private let heroesTableView = HeroesTableView()
    private let spinner: UIActivityIndicatorView
    private var isLoadingData: Bool = false
    
    init(heroesTableViewModel: HeroesTableViewModel) {
        self.heroesTableViewModel = heroesTableViewModel
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
        super.viewDidLoad()
        heroesTableView.setTableDataSourceAndDelegate(viewController: self)
        navigationItem.title = "All heroes"
        
        heroesTableViewModel.fetchHeroes(addHeroesToTableView: { [weak self] in
            self?.addHeroesToTableView()
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addHeroesToTableView() {
        var beginIndex = 0
        let numberOfHeroes = heroesTableViewModel.numberOfHeroes()
        if numberOfHeroes >= Constants.numberOfHeroesPerRequest {
            beginIndex = numberOfHeroes - Constants.numberOfHeroesPerRequest
        }
        let indexPaths = (beginIndex..<numberOfHeroes)
                            .map { IndexPath(row: $0, section: 0) }
        heroesTableView.update(indexPaths: indexPaths)
        heroesTableView.isSpinnerHidden(to: true)
        self.isLoadingData = false
    }
}

extension HeroesTableViewController: HeroViewControllerDelegate {
    func updateHeroInTableView(heroIndex: Int, hero: Hero) {
        heroesTableViewModel.setHeroAtIndex(at: heroIndex, hero: hero)
    }
}

extension HeroesTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return heroesTableViewModel.numberOfHeroes()
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let numberOfHeroes = heroesTableViewModel.numberOfHeroes()
        if indexPath.row >= numberOfHeroes {
            return UITableViewCell()
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",
                                                 for: indexPath) as! HeroesTableViewCell
        let hero = heroesTableViewModel.getHeroAtIndex(index: indexPath.row)
        
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
        
        let numberOfHeroes = heroesTableViewModel.numberOfHeroes()
        if indexPath.row >= numberOfHeroes {
            return
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let hero = heroesTableViewModel.getHeroAtIndex(index: indexPath.row)
        let heroDetailViewModel = HeroDetailViewModel(heroService: heroesTableViewModel.heroService, hero: hero)
        
        let destination = HeroDetailViewController(hero: hero,
                                                   heroIndex: indexPath.row,
                                                   heroDetailViewModel: heroDetailViewModel,
                                                   loader: loader)
        destination.delegate = self
        navigationController?.pushViewController(destination, animated: true)
    }
    
    // From: https://stackoverflow.com/a/42457571
    func tableView(_ tableView: UITableView,
                   willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {
        
        let numberOfHeroes = heroesTableViewModel.numberOfHeroes()
        if numberOfHeroes < Constants.numberOfHeroesPerRequest {
            return
        }
        
        let lastRowIndex = tableView.numberOfRows(inSection: 0) - 1
        let batchMiddleRowIndex = Constants.numberOfHeroesPerRequest / 2
        let rowIndexLoadMoreHeroes = lastRowIndex - batchMiddleRowIndex
        if self.isLoadingData == false && indexPath.row >= rowIndexLoadMoreHeroes {
            heroesTableView.isSpinnerHidden(to: false)
            self.isLoadingData = true
            heroesTableViewModel.fetchHeroes(addHeroesToTableView: { [weak self] in
                self?.addHeroesToTableView()
            })
        }
    }
}
