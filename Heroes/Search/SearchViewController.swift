//
//  SearchViewController.swift
//  Heroes
//
//  Created by Bernardo Vala Lourenço on 15/12/2023.
//

import Combine
import UIKit

class SearchViewController: UIViewController {
    private enum ViewConstants {
        static let navigationTitle = "All Heroes"
        static let searchQueryMinimumLength = 2
        static let secondsToWait = 1
    }
    
    private let searchView = SearchView()
    private let searchViewModel: HeroesViewModel
    private let encoder = JSONEncoder()
    private let loader: ImageLoader = ImageLoader()
    private var isLoadingData: Bool = false
    private var cancellables: Set<AnyCancellable> = []
    
    @Published
    private var searchQuery = ""
    
    init(searchViewModel: HeroesViewModel) {
        self.searchViewModel = searchViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = searchView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearch()
    }
    
    private func setupSearch() {
        searchView.setSearchDelegate(viewController: self)
        searchView.setResultsDataSourceAndDelegate(viewController: self)

        $searchQuery
            .debounce(for: .seconds(ViewConstants.secondsToWait), scheduler: DispatchQueue.main)
            .filter { $0.count > ViewConstants.searchQueryMinimumLength }
            .removeDuplicates()
            .sink { [weak self] text in
                self?.searchForHeroes(searchQuery: text)
            }
            .store(in: &cancellables)
    }
    
    func updateLoading(to value: Bool) {
        self.isLoadingData = value
    }
    
    private func searchForHeroes(searchQuery text: String) {
        searchViewModel.clearHeroes()
        searchViewModel.fetchHeroes(searchQuery: text) { [weak self] in
            self?.searchView.spinnerHidden(to: true)
            self?.searchView.hideKeyboard()
            self?.addHeroesToView()
        }
    }
    
    func addHeroesToView() {
        searchView.spinnerHidden(to: true)
        searchView.updateResults()
        updateLoading(to: false)
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            searchView.spinnerHidden(to: true)
        } else {
            searchView.spinnerHidden(to: false)
        }
        searchViewModel.clearHeroes()
        searchView.updateResults()
        self.searchQuery = searchText
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let text = searchBar.text ?? ""
        if text.isEmpty == false && text.count > ViewConstants.searchQueryMinimumLength {
            searchBar.resignFirstResponder()
            searchForHeroes(searchQuery: text)
        } else {
            self.present(searchView.getAlert(), animated: true, completion: nil)
        }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        self.searchQuery = ""
        searchView.spinnerHidden(to: true)
        searchViewModel.clearHeroes()
        searchView.updateResults()
        searchBar.resignFirstResponder()
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchViewModel.numberOfHeroes()
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier,
                                                 for: indexPath) as! HeroesTableViewCell
        let hero = searchViewModel.getHero(index: indexPath.row)
        
        cell.configure(imageURL: hero.thumbnail?.imageURL, name: hero.name)
        cell.storeHero = { aCell in
            guard let name = hero.name else { return }

            if UserDefaults.standard.data(forKey: name) != nil {
                UserDefaults.standard.removeObject(forKey: name)
            } else {
                let data = try self.encoder.encode(hero)
                UserDefaults.standard.set(data, forKey: name)
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let hero = searchViewModel.getHero(index: indexPath.row)
        let heroDetailViewModel = HeroDetailViewModel(heroService: searchViewModel.heroService, hero: hero)
        let heroIndex = indexPath.section == 1 ? indexPath.row: nil
        let destination = HeroDetailViewController(hero: hero,
                                                   heroIndex: heroIndex,
                                                   heroDetailViewModel: heroDetailViewModel,
                                                   loader: loader)
        destination.delegate = self
        navigationController?.pushViewController(destination, animated: true)
    }
    
    func tableView(_ tableView: UITableView,
                   willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {
        let lastRowIndex = tableView.numberOfRows(inSection: 0) - 1
        let numberOfHeroes = searchViewModel.numberOfHeroes()
        if numberOfHeroes < Constants.numberOfHeroesPerRequest {
            return
        }
        
        let batchMiddleRowIndex = Constants.numberOfHeroesPerRequest / 2
        let rowIndexLoadMoreHeroes = lastRowIndex - batchMiddleRowIndex
        if self.isLoadingData == false && indexPath.row >= rowIndexLoadMoreHeroes {
            searchView.spinnerHidden(to: false)
            updateLoading(to: true)
            
            searchViewModel.fetchHeroes(searchQuery: searchView.getSearchText()) { [weak self] in
                self?.addHeroesToView()
            }
        } else {
            searchView.spinnerHidden(to: true)
        }
    }
}

extension SearchViewController: HeroViewControllerDelegate {
    func updateHeroInView(heroIndex: Int, hero: Hero) {
        searchViewModel.setHero(at: heroIndex, hero: hero)
    }
    
    func updateView(isFavourite: Bool, hero: Hero) {
    }
}
