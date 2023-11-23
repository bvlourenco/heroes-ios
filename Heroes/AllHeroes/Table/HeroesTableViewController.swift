//
//  ViewController.swift
//  Heroes
//
//  Created by Bernardo Vala Lourenço on 24/10/2023.
//

import UIKit

class HeroesTableViewController: AllHeroesViewController {
    private let heroesTableView = HeroesTableView()
    private let heroesViewModel: HeroesViewModel

    override init(heroesViewModel: HeroesViewModel) {
        self.heroesViewModel = heroesViewModel
        super.init(heroesViewModel: heroesViewModel)
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
        
        heroesViewModel.fetchHeroes(addHeroesToTableView: { [weak self] numberOfNewHeroes in
            self?.addHeroesToTableView(numberOfNewHeroes: numberOfNewHeroes)
        })
        
        var image = UIImage(named: "icons8-grid-2-50")
        image = image?.imageWith(newSize: CGSize(width: Constants.iconWidthSize,
                                                 height: Constants.iconHeightSize))
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: image,
                                                                 style: .plain,
                                                                 target: self,
                                                                 action: #selector(changeViewController))
    }
    
    @objc
    func changeViewController(sender: UIBarButtonItem) {
        let viewControllers = [HeroesGridViewController(heroesViewModel: heroesViewModel)]
        self.navigationController?.setViewControllers(viewControllers, animated: true)
    }
    
    private func addHeroesToTableView(numberOfNewHeroes: Int) {
        var beginIndex = 0
        
        let numberOfHeroes = heroesViewModel.numberOfHeroes()
        if numberOfHeroes >= Constants.numberOfHeroesPerRequest {
            beginIndex = numberOfHeroes - numberOfNewHeroes
        }
        let indexPaths = (beginIndex..<numberOfHeroes)
                            .map { IndexPath(row: $0, section: 0) }
        heroesTableView.update(indexPaths: indexPaths)
        heroesTableView.isSpinnerHidden(to: true)
        super.updateLoading(to: false)
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
        
        cell.loadImage(imageURL: hero.thumbnail?.imageURL)
        cell.setName(name: hero.name)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        
        let numberOfHeroes = heroesViewModel.numberOfHeroes()
        if indexPath.row >= numberOfHeroes {
            return
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let hero = heroesViewModel.getHeroAtIndex(index: indexPath.row)
        let heroDetailViewModel = HeroDetailViewModel(heroService: heroesViewModel.heroService, hero: hero)
        
        let destination = HeroDetailViewController(hero: hero,
                                                   heroIndex: indexPath.row,
                                                   heroDetailViewModel: heroDetailViewModel,
                                                   loader: super.getLoader())
        destination.delegate = self
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
        if super.loadingStatus() == false && indexPath.row >= rowIndexLoadMoreHeroes {
            heroesTableView.isSpinnerHidden(to: false)
            super.updateLoading(to: true)
            heroesViewModel.fetchHeroes(addHeroesToTableView: { [weak self] numberOfNewHeroes in
                self?.addHeroesToTableView(numberOfNewHeroes: numberOfNewHeroes)
            })
        }
    }
}
