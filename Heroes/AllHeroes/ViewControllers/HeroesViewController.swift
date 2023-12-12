//
//  HeroesViewController.swift
//  Heroes
//
//  Created by Bernardo Vala Lourenço on 21/11/2023.
//

import Combine
import UIKit

class HeroesViewController: UIViewController, UINavigationControllerDelegate {
    
    private enum ViewConstants {
        static let numberOfSections = 2
        static let heroSearchSectionTitle = "Heroes Search Result"
        static let heroesSectionTitle = "All Heroes"
    }
    
    private let heroesViewModel: HeroesViewModel
    private let loader: ImageLoader = ImageLoader()
    private let spinner: UIActivityIndicatorView
    private var isLoadingData: Bool = false
    private let transition = Transition()
    
    private var cancellables: Set<AnyCancellable> = []
    private var rightBarButtonItems: [UIBarButtonItem] = []
    private let encoder = JSONEncoder()
    private var isInSearch: Bool = false
    weak var delegate: ViewControllerDelegate?
    
    private var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.showsCancelButton = true
        searchBar.sizeToFit()
        return searchBar
    }()
    
    @Published
    private var searchQuery = ""
    
    init(heroesViewModel: HeroesViewModel) {
        self.heroesViewModel = heroesViewModel
        self.spinner = UIActivityIndicatorView(style: .medium)
        self.spinner.startAnimating()
        self.spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0),
                                    width: UIScreen.main.bounds.width,
                                    height: CGFloat(Constants.spinnerHeight))
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "All heroes"
        navigationController?.delegate = self
        
        let decoder = JSONDecoder()
        var numberOfFavouriteHeroes = 0
        for heroName in UserDefaults.standard.dictionaryRepresentation().keys {
            do {
                if let data = UserDefaults.standard.data(forKey: heroName) {
                    let newHero = try decoder.decode(Hero.self, from: data)
                    heroesViewModel.addHeroes(hero: newHero)
                    numberOfFavouriteHeroes += 1
                }
            } catch {
                print(error)
            }
        }
        heroesViewModel.numberOfFavouriteHeroes = numberOfFavouriteHeroes
        
        heroesViewModel.fetchHeroes(searchQuery: nil, addHeroesToView: delegate?.addHeroesToView ?? {})
        
        var image = delegate?.getTopBarIconImage()
        image = image?.imageWith(newSize: CGSize(width: Constants.iconWidthSize,
                                                 height: Constants.iconHeightSize))
        
        let searchButton = UIBarButtonItem(barButtonSystemItem: .search,
                                           target: self,
                                           action: #selector(displaySearchController))
        let listButton = UIBarButtonItem(image: image,
                                         style: .plain,
                                         target: self,
                                         action: #selector(changeViewController))
        
        self.rightBarButtonItems = [listButton, searchButton]
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
        let viewControllers = delegate?.getViewControllers() ?? []
        self.navigationController?.setViewControllers(viewControllers, animated: true)
    }
    
    @objc
    func displaySearchController() {
        navigationItem.titleView = searchBar
        navigationItem.rightBarButtonItems = []
    }
    
    func navigationController(_ navigationController: UINavigationController,
                              animationControllerFor operation: UINavigationController.Operation,
                              from fromVC: UIViewController,
                              to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch operation {
        case .push:
            return transition
        case .pop:
            return nil
        default:
            return nil
        }
    }
    
    func getViewModel() -> HeroesViewModel {
        return heroesViewModel
    }
    
    func getSpinner() -> UIActivityIndicatorView {
        return spinner
    }
    
    func updateLoading(to value: Bool) {
        self.isLoadingData = value
    }
    
    func getLoader() -> ImageLoader {
        return loader
    }
    
    func loadingStatus() -> Bool {
        return self.isLoadingData
    }
    
    private func searchForHeroes(searchQuery text: String) {
        heroesViewModel.clearHeroesInSearch()
        heroesViewModel.fetchHeroes(searchQuery: text) { [weak self] in
            self?.isInSearch = false
            self?.delegate?.addHeroesToView()
        }
    }
    
    func getNumberOfSections() -> Int {
        return ViewConstants.numberOfSections
    }
    
    func getNumberOfItemsInSection(section: Int) -> Int {
        if section == 0 {
            return isInSearch ? max(1, heroesViewModel.numberOfHeroesInSearch()) : heroesViewModel.numberOfHeroesInSearch()
        } else {
            return heroesViewModel.numberOfHeroes()
        }
    }
    
    func isDoingASearch() -> Bool {
        return isInSearch || heroesViewModel.numberOfHeroesInSearch() > 0
    }
    
    func getSectionTitle(section: Int) -> String {
        if section == 0 {
            return ViewConstants.heroSearchSectionTitle
        } else {
            return ViewConstants.heroesSectionTitle
        }
    }
    
    func isLoadingCell(section: Int) -> Bool {
        return section == 0 && isInSearch && heroesViewModel.numberOfHeroesInSearch() == 0
    }
    
    func getHero(indexPath: IndexPath) -> Hero {
        if indexPath.section == 0 {
            return heroesViewModel.getHeroInSearchAtIndex(index: indexPath.row)
        } else {
            return heroesViewModel.getHeroAtIndex(index: indexPath.row)
        }
    }
    
    func persistHero(section: Int, hero: Hero) throws -> Int {
        guard let name = hero.name else { return -1 }
        
        var destinationIndex: Int
        if UserDefaults.standard.data(forKey: name) != nil {
            UserDefaults.standard.removeObject(forKey: name)
            self.heroesViewModel.changeNumberOfFavouriteHeroes(moreFavouriteHeroes: false)
            let numberOfFavouriteHeroes = self.heroesViewModel.numberOfFavouriteHeroes
            self.heroesViewModel.setHeroAtIndex(at: -1, hero: hero, newIndex: numberOfFavouriteHeroes)
            destinationIndex = numberOfFavouriteHeroes
        } else {
            let data = try self.encoder.encode(hero)
            UserDefaults.standard.set(data, forKey: name)
            self.heroesViewModel.changeNumberOfFavouriteHeroes(moreFavouriteHeroes: true)
            self.heroesViewModel.setHeroAtIndex(at: -1, hero: hero)
            destinationIndex = 0
        }
        return destinationIndex
    }
    
    func willFetchMoreHeroes(indexPath: IndexPath, lastRowIndex: Int) {
        if indexPath.section == 1 {
            let numberOfHeroes = heroesViewModel.numberOfHeroes()
            if numberOfHeroes < Constants.numberOfHeroesPerRequest {
                return
            }
            
            let batchMiddleRowIndex = Constants.numberOfHeroesPerRequest / 2
            let rowIndexLoadMoreHeroes = lastRowIndex - batchMiddleRowIndex
            if loadingStatus() == false && indexPath.row >= rowIndexLoadMoreHeroes {
                delegate?.hideSpinner()
                updateLoading(to: true)
                
                heroesViewModel.fetchHeroes(searchQuery: nil) { [weak self] in
                    self?.delegate?.addHeroesToView()
                }
            }
        }
    }
    
    func itemSelected(indexPath: IndexPath) {
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
        
        let heroDetailViewModel = HeroDetailViewModel(heroService: heroesViewModel.heroService, hero: hero)
        
        let heroIndex = indexPath.section == 0 ? -1 : indexPath.row
        let destination = HeroDetailViewController(hero: hero,
                                                   heroIndex: heroIndex,
                                                   heroDetailViewModel: heroDetailViewModel,
                                                   loader: getLoader())
        destination.delegate = self
        navigationController?.pushViewController(destination, animated: true)
    }
}

extension HeroesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            self.isInSearch = false
            heroesViewModel.clearHeroesInSearch()
            delegate?.reloadView()
        } else if self.isInSearch == false {
            self.isInSearch = true
            delegate?.reloadView()
        }
        
        self.searchQuery = searchText
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let text = searchBar.text ?? ""
        if text.isEmpty == false && text.count > 2 {
            searchBar.resignFirstResponder()
            searchForHeroes(searchQuery: text)
        } else {
            let alert = UIAlertController(title: "Cannot perform search",
                                          message: "Your search query has less than 3 characters. Insert more characters",
                                          preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        self.searchQuery = ""
        heroesViewModel.clearHeroesInSearch()
        navigationItem.titleView = nil
        navigationItem.rightBarButtonItems = self.rightBarButtonItems
        self.isInSearch = false
        delegate?.reloadView()
    }
}

extension HeroesViewController: HeroViewControllerDelegate {
    func updateHeroInView(heroIndex: Int, hero: Hero) {
        heroesViewModel.setHeroAtIndex(at: heroIndex, hero: hero)
    }
    
    func updateView(isFavourite: Bool, hero: Hero) {
        self.heroesViewModel.changeNumberOfFavouriteHeroes(moreFavouriteHeroes: isFavourite)
        heroesViewModel.setHeroAtIndex(at: -1,
                                       hero: hero,
                                       newIndex: isFavourite ? 0 : heroesViewModel.numberOfFavouriteHeroes)
        delegate?.reloadView()
    }
}
