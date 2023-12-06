//
//  ViewController.swift
//  Heroes
//
//  Created by Bernardo Vala Lourenço on 24/10/2023.
//

import Combine
import UIKit

class HeroesTableViewController: AllHeroesViewController {
    private let heroesTableView = HeroesTableView()
    private let heroesViewModel: HeroesViewModel
    private var cancellables: Set<AnyCancellable> = []
    private var rightBarButtonItems: [UIBarButtonItem] = []
    private var isInSearch: Bool = false
    
    private var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.showsCancelButton = true
        searchBar.sizeToFit()
        return searchBar
    }()
    
    @Published
    private var searchQuery = ""

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
        
        heroesViewModel.fetchHeroes(searchQuery: nil) { [weak self] numberOfNewHeroes in
            self?.addHeroesToTableView()
        }
        
        var image = UIImage(named: "icons8-grid-2-50")
        image = image?.imageWith(newSize: CGSize(width: Constants.iconWidthSize,
                                                 height: Constants.iconHeightSize))
        
        let searchButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(displaySearchController))
        let gridButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(changeViewController))
        
        self.rightBarButtonItems = [gridButton, searchButton]
        navigationItem.rightBarButtonItems = self.rightBarButtonItems
        
        searchBar.delegate = self
        
        $searchQuery
            .debounce(for: .seconds(5), scheduler: DispatchQueue.main)
            .filter { $0.count > 2 }
            .removeDuplicates()
            .sink { [weak self] text in
                self?.searchForHeroes(searchQuery: text)
            }
            .store(in: &cancellables)
    }
    
    @objc
    func changeViewController(sender: UIBarButtonItem) {
        let viewControllers = [HeroesGridViewController(heroesViewModel: heroesViewModel)]
        self.navigationController?.setViewControllers(viewControllers, animated: true)
    }
    
    @objc
    func displaySearchController() {
        navigationItem.titleView = searchBar
        navigationItem.rightBarButtonItems = []
    }
    
    private func searchForHeroes(searchQuery text: String) {
        heroesViewModel.clearHeroesInSearch()
        heroesViewModel.fetchHeroes(searchQuery: text) { [weak self] numberOfNewHeroes in
            self?.isInSearch = false
            self?.addHeroesToTableView()
        }
    }
    
    private func addHeroesToTableView() {
        reloadTableViewData()
        heroesTableView.isSpinnerHidden(to: true)
        super.updateLoading(to: false)
    }
    
    private func reloadTableViewData() {
        heroesTableView.update()
    }
}

extension HeroesTableViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if isInSearch || heroesViewModel.numberOfHeroesInSearch() > 0 {
            return section == 0 ? "Heroes Search Result" : "All Heroes"
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return isInSearch ? max(1, heroesViewModel.numberOfHeroesInSearch()) : heroesViewModel.numberOfHeroesInSearch()
        } else {
            return heroesViewModel.numberOfHeroes()
        }
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if isInSearch {
                return LoadingTableViewCell()
            } else {
                let numberOfHeroes = heroesViewModel.numberOfHeroesInSearch()
                if indexPath.row >= numberOfHeroes {
                    return UITableViewCell()
                }
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell",
                                                         for: indexPath) as! HeroesTableViewCell
                
                let hero = heroesViewModel.getHeroInSearchAtIndex(index: indexPath.row)
                
                cell.configure(imageURL: hero.thumbnail?.imageURL, name: hero.name)
                cell.moveRowActionBlock = { aCell in
                    self.heroesViewModel.setHeroAtIndex(at: -1, hero: hero)
                }
                
                return cell
            }
        } else {
            let numberOfHeroes = heroesViewModel.numberOfHeroes()
            if indexPath.row >= numberOfHeroes {
                return UITableViewCell()
            }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell",
                                                     for: indexPath) as! HeroesTableViewCell
            
            let hero = heroesViewModel.getHeroAtIndex(index: indexPath.row)
            
            cell.configure(imageURL: hero.thumbnail?.imageURL, name: hero.name)
            cell.moveRowActionBlock = { aCell in
                let actualIndexPath = tableView.indexPath(for: aCell)!
                self.heroesViewModel.setHeroAtIndex(at: -1, hero: hero)
                tableView.moveRow(at: actualIndexPath, to: IndexPath(row: 0, section: 1))
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        let numberOfHeroes: Int
        let hero: Hero
        if indexPath.section == 0 {
            numberOfHeroes = heroesViewModel.numberOfHeroesInSearch()
            hero = heroesViewModel.getHeroInSearchAtIndex(index: indexPath.row)
        } else {
            numberOfHeroes = heroesViewModel.numberOfHeroes()
            hero = heroesViewModel.getHeroAtIndex(index: indexPath.row)
        }
        
        if indexPath.row >= numberOfHeroes {
            return
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let heroDetailViewModel = HeroDetailViewModel(heroService: heroesViewModel.heroService, hero: hero)
        
        let heroIndex = indexPath.section == 0 ? -1 : indexPath.row
        let destination = HeroDetailViewController(hero: hero,
                                                   heroIndex: heroIndex,
                                                   heroDetailViewModel: heroDetailViewModel,
                                                   loader: super.getLoader())
        destination.delegate = self
        navigationController?.pushViewController(destination, animated: true)
    }
    
    // From: https://stackoverflow.com/a/42457571
    func tableView(_ tableView: UITableView,
                   willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let numberOfHeroes = heroesViewModel.numberOfHeroes()
            if numberOfHeroes < Constants.numberOfHeroesPerRequest {
                return
            }
            
            let lastRowIndex = tableView.numberOfRows(inSection: 1) - 1
            let batchMiddleRowIndex = Constants.numberOfHeroesPerRequest / 2
            let rowIndexLoadMoreHeroes = lastRowIndex - batchMiddleRowIndex
            if super.loadingStatus() == false && indexPath.row >= rowIndexLoadMoreHeroes {
                heroesTableView.isSpinnerHidden(to: false)
                super.updateLoading(to: true)
                heroesViewModel.fetchHeroes(searchQuery: nil) { [weak self] numberOfNewHeroes in
                    self?.addHeroesToTableView()
                }
            }
        }
    }
}

extension HeroesTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if self.isInSearch == false {
            self.isInSearch = true
            heroesTableView.update()
        }
        
        self.searchQuery = searchText
        
        if searchText == "" {
            self.isInSearch = false
            heroesViewModel.clearHeroesInSearch()
            reloadTableViewData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let text = searchBar.text ?? ""
        if text.isEmpty == false && text.count > 2 {
            searchBar.resignFirstResponder()
            searchForHeroes(searchQuery: text)
        }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        self.searchQuery = ""
        heroesViewModel.clearHeroesInSearch()
        navigationItem.titleView = nil
        navigationItem.rightBarButtonItems = self.rightBarButtonItems
        self.isInSearch = false
        reloadTableViewData()
    }
}

extension HeroesTableViewController: HeroViewControllerDelegate {
    func updateHeroInTableView(heroIndex: Int, hero: Hero) {
        heroesViewModel.setHeroAtIndex(at: heroIndex, hero: hero)
    }
    
    func updateView(heroIndex: Int, hero: Hero) {
        heroesViewModel.setHeroAtIndex(at: heroIndex, hero: hero)
        reloadTableViewData()
    }
}
