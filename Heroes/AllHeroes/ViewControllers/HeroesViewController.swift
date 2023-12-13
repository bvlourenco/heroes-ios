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
        static let alertTitle = "Cannot perform search"
        static let alertMessage = "Your search query has less than 3 characters. Insert more characters"
        static let alertButtonTitle = "Ok"
        static let navigationTitle = "All Heroes"
        static let searchQueryMinimumLength = 2
        static let secondsToWait = 5
    }
    
    let heroesViewModel: HeroesViewModel
    private let loader: ImageLoader = ImageLoader()
    private var isLoadingData: Bool = false
    private let transition = Transition()
    
    private var cancellables: Set<AnyCancellable> = []
    private var rightBarButtonItems: [UIBarButtonItem] = []
    private let encoder = JSONEncoder()
    private var isInSearch: Bool = false
    private var firstInitialization: Bool
    weak var delegate: ViewControllerDelegate?
    
    let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.startAnimating()
        return spinner
    }()
    
    private var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.showsCancelButton = true
        searchBar.sizeToFit()
        return searchBar
    }()
    
    private let alert: UIAlertController = {
        let alert = UIAlertController(title: ViewConstants.alertTitle,
                                      message: ViewConstants.alertMessage,
                                      preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: ViewConstants.alertButtonTitle,
                                      style: UIAlertAction.Style.default,
                                      handler: nil))
        return alert
    }()
    
    @Published
    private var searchQuery = ""
    
    init(heroesViewModel: HeroesViewModel, firstInitialization: Bool) {
        self.heroesViewModel = heroesViewModel
        self.firstInitialization = firstInitialization
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = ViewConstants.navigationTitle
        navigationController?.delegate = self
        
        if firstInitialization {
            loadFavouriteHeroes()
            heroesViewModel.fetchHeroes(searchQuery: nil, addHeroesToView: delegate?.addHeroesToView ?? {})
        }
        
        loadNavigationBarButtons()
        setupSearch()
    }
    
    private func loadFavouriteHeroes() {
        let decoder = JSONDecoder()
        for heroName in UserDefaults.standard.dictionaryRepresentation().keys {
            do {
                if let data = UserDefaults.standard.data(forKey: heroName) {
                    let newHero = try decoder.decode(Hero.self, from: data)
                    heroesViewModel.addHeroes(hero: newHero)
                    heroesViewModel.numberOfFavouriteHeroes += 1
                }
            } catch {
                print(error)
            }
        }
        heroesViewModel.orderHeroes()
    }
    
    private func loadNavigationBarButtons() {
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
    }
    
    private func setupSearch() {
        searchBar.delegate = self
        
        $searchQuery
            .debounce(for: .seconds(ViewConstants.secondsToWait), scheduler: DispatchQueue.main)
            .filter { $0.count > ViewConstants.searchQueryMinimumLength }
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
    
    func updateLoading(to value: Bool) {
        self.isLoadingData = value
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
        if isInSearch {
            // Loading Cell only
            return 1
        } else {
            return heroesViewModel.numberOfHeroes(inSearch: section == 0)
        }
    }
    
    func isDoingASearch() -> Bool {
        return isInSearch || heroesViewModel.numberOfHeroes(inSearch: true) > 0
    }
    
    func getSectionTitle(section: Int) -> String {
        if section == 0 {
            return ViewConstants.heroSearchSectionTitle
        } else {
            return ViewConstants.heroesSectionTitle
        }
    }
    
    func isLoadingCell(section: Int) -> Bool {
        return section == 0 && isInSearch && heroesViewModel.numberOfHeroes(inSearch: true) == 0
    }
    
    // Returns the index to where the hero will be moved in the view (table or grid view)
    func persistHero(hero: Hero) throws -> Int? {
        guard let name = hero.name else { return nil }

        if UserDefaults.standard.data(forKey: name) != nil {
            UserDefaults.standard.removeObject(forKey: name)
            self.heroesViewModel.numberOfFavouriteHeroes -= 1
            self.heroesViewModel.moveHero(hero: hero, to: self.heroesViewModel.numberOfFavouriteHeroes)
            return self.heroesViewModel.numberOfFavouriteHeroes
        } else {
            let data = try self.encoder.encode(hero)
            UserDefaults.standard.set(data, forKey: name)
            self.heroesViewModel.numberOfFavouriteHeroes += 1
            self.heroesViewModel.moveHero(hero: hero, to: 0)
            return 0
        }
    }
    
    func willFetchMoreHeroes(indexPath: IndexPath, lastRowIndex: Int) {
        if indexPath.section == 1 {
            let numberOfHeroes = heroesViewModel.numberOfHeroes(inSearch: false)
            if numberOfHeroes < Constants.numberOfHeroesPerRequest {
                return
            }
            
            let batchMiddleRowIndex = Constants.numberOfHeroesPerRequest / 2
            let rowIndexLoadMoreHeroes = lastRowIndex - batchMiddleRowIndex
            if self.isLoadingData == false && indexPath.row >= rowIndexLoadMoreHeroes {
                delegate?.hideSpinner()
                updateLoading(to: true)
                
                heroesViewModel.fetchHeroes(searchQuery: nil) { [weak self] in
                    self?.delegate?.addHeroesToView()
                }
            }
        }
    }
    
    func itemSelected(indexPath: IndexPath) {
        let hero = heroesViewModel.getHero(inSearch: indexPath.section == 0, index: indexPath.row)
        let heroDetailViewModel = HeroDetailViewModel(heroService: heroesViewModel.heroService, hero: hero)
        let heroIndex = indexPath.section == 1 ? indexPath.row: nil
        let destination = HeroDetailViewController(hero: hero,
                                                   heroIndex: heroIndex,
                                                   heroDetailViewModel: heroDetailViewModel,
                                                   loader: loader)
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
        if text.isEmpty == false && text.count > ViewConstants.searchQueryMinimumLength {
            searchBar.resignFirstResponder()
            searchForHeroes(searchQuery: text)
        } else {
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
        heroesViewModel.setHero(at: heroIndex, hero: hero)
    }
    
    func updateView(isFavourite: Bool, hero: Hero) {
        if isFavourite {
            self.heroesViewModel.numberOfFavouriteHeroes += 1
        } else {
            self.heroesViewModel.numberOfFavouriteHeroes -= 1
        }
        heroesViewModel.moveHero(hero: hero,
                                 to: isFavourite ? 0 : heroesViewModel.numberOfFavouriteHeroes)
        delegate?.reloadView()
    }
}
