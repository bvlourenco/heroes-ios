//
//  HeroesGridViewController.swift
//  Heroes
//
//  Created by Bernardo Vala Lourenço on 21/11/2023.
//

import Combine
import UIKit

class HeroesGridViewController: AllHeroesViewController {
    
    private enum CollectionViewConstants {
        static let leftPadding: CGFloat = 10
        static let rightPadding: CGFloat = 10
        static let cellHeight: CGFloat = 300
        static let headingHeight: CGFloat = 30
    }
    
    private let heroesGridView = HeroesGridView()
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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = heroesGridView
    }
    
    override func viewDidLoad() {
        heroesGridView.setGridDataSourceAndDelegate(viewController: self)
        super.viewDidLoad()
        
        heroesViewModel.fetchHeroes(searchQuery: nil) { [weak self] numberOfNewHeroes in
            self?.addHeroesToGridView(numberOfNewHeroes: numberOfNewHeroes)
        }
        
        var image = UIImage(named: "icons8-list-50")
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
        let viewControllers = [HeroesTableViewController(heroesViewModel: heroesViewModel)]
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
            self?.addHeroesToGridView(numberOfNewHeroes: numberOfNewHeroes)
            self?.isInSearch = false
        }
    }
    
    private func addHeroesToGridView(numberOfNewHeroes: Int) {
        reloadGridViewData()
        super.updateLoading(to: false)
    }
    
    private func reloadGridViewData() {
        heroesGridView.update()
    }
}

extension HeroesGridViewController: UICollectionViewDataSource, UICollectionViewDelegate, 
                                        UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return isInSearch ? max(1, heroesViewModel.numberOfHeroesInSearch()) : 
                                heroesViewModel.numberOfHeroesInSearch()
        } else {
            return heroesViewModel.numberOfHeroes()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            if isInSearch && heroesViewModel.numberOfHeroesInSearch() == 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "loadingCell",
                                                              for: indexPath) as! LoadingGridViewCell
                cell.animateSpinner()
                return cell
            } else {
                let numberOfHeroes = heroesViewModel.numberOfHeroesInSearch()
                if indexPath.row >= numberOfHeroes {
                    return UICollectionViewCell()
                }
                
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell",
                                                              for: indexPath) as! HeroesGridViewCell
                
                let hero = heroesViewModel.getHeroInSearchAtIndex(index: indexPath.row)
                
                cell.configure(imageURL: hero.thumbnail?.imageURL, name: hero.name, indexPath: indexPath)
                
                return cell
            }
        } else {
            let numberOfHeroes = heroesViewModel.numberOfHeroes()
            if indexPath.row >= numberOfHeroes {
                return UICollectionViewCell()
            }
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell",
                                                          for: indexPath) as! HeroesGridViewCell
            
            let hero = heroesViewModel.getHeroAtIndex(index: indexPath.row)
            
            cell.configure(imageURL: hero.thumbnail?.imageURL, name: hero.name, indexPath: indexPath)
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let numberOfHeroes: Int
        let hero: Hero
        
        if isInSearch && indexPath.section == 0 {
            return
        }
        
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
        
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let heroDetailViewModel = HeroDetailViewModel(heroService: heroesViewModel.heroService, hero: hero)
        
        let heroIndex = indexPath.section == 0 ? -1 : indexPath.row
        let destination = HeroDetailViewController(hero: hero,
                                                   heroIndex: heroIndex,
                                                   heroDetailViewModel: heroDetailViewModel,
                                                   loader: super.getLoader())
        destination.delegate = self
        navigationController?.pushViewController(destination, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let numberOfHeroes = heroesViewModel.numberOfHeroes()
            if numberOfHeroes < Constants.numberOfHeroesPerRequest {
                return
            }
            
            let lastRowIndex = max(0, collectionView.numberOfItems(inSection: 1) - 1)
            let batchMiddleRowIndex = Constants.numberOfHeroesPerRequest / 2
            let rowIndexLoadMoreHeroes = lastRowIndex - batchMiddleRowIndex
            if super.loadingStatus() == false && indexPath.row >= rowIndexLoadMoreHeroes {
                super.updateLoading(to: true)
                heroesViewModel.fetchHeroes(searchQuery: nil) { [weak self] numberOfNewHeroes in
                    self?.addHeroesToGridView(numberOfNewHeroes: numberOfNewHeroes)
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellHeight: CGFloat = CollectionViewConstants.cellHeight
        
        let cellWidth: CGFloat
        if indexPath.section == 0 && isInSearch && heroesViewModel.numberOfHeroesInSearch() == 0 {
            cellWidth = collectionView.frame.width
        } else {
            cellWidth = collectionView.frame.width / 2 - (
                CollectionViewConstants.leftPadding +
                CollectionViewConstants.rightPadding)
        }
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            if indexPath.section == 0 && heroesViewModel.numberOfHeroesInSearch() == 0 && isInSearch == false {
                return UICollectionReusableView()
            }
            
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                         withReuseIdentifier: "header",
                                                                         for: indexPath) as! HeroesGridHeader
            if indexPath.section == 0 {
                header.title.text = "Heroes Search Result"
            } else {
                header.title.text = "All Heroes"
            }
            return header
        case UICollectionView.elementKindSectionFooter:
            if indexPath.section == 1 {
                return collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                       withReuseIdentifier: "footer",
                                                                       for: indexPath) as! HeroesGridFooter
            } else {
                return UICollectionReusableView()
            }
        default:
            assert(false, "Unexpected kind in collectionView")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, 
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForFooterInSection section: Int) -> CGSize {
        if section == 1 {
            return CGSize(width: collectionView.frame.width, height: Constants.spinnerHeight)
        } else {
            return CGSize(width: 0, height: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 && heroesViewModel.numberOfHeroesInSearch() == 0 && isInSearch == false {
            return CGSize(width: 0, height: 0)
        } else {
            return CGSize(width: collectionView.frame.width, height: CollectionViewConstants.headingHeight)
        }
    }
}

extension HeroesGridViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if self.isInSearch == false {
            self.isInSearch = true
            reloadGridViewData()
        }
        
        self.searchQuery = searchText
        
        if searchText == "" {
            self.isInSearch = false
            heroesViewModel.clearHeroesInSearch()
            reloadGridViewData()
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
        self.isInSearch = false
        navigationItem.titleView = nil
        navigationItem.rightBarButtonItems = self.rightBarButtonItems
        reloadGridViewData()
    }
}

extension HeroesGridViewController: HeroViewControllerDelegate {
    func updateHeroInTableView(heroIndex: Int, hero: Hero) {
        heroesViewModel.setHeroAtIndex(at: heroIndex, hero: hero)
    }
    
    func updateView(heroIndex: Int, hero: Hero) {
        heroesViewModel.setHeroAtIndex(at: heroIndex, hero: hero)
        reloadGridViewData()
    }
}
