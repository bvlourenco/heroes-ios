//
//  HeroesViewController.swift
//  Heroes
//
//  Created by Bernardo Vala Lourenço on 21/11/2023.
//

import Combine
import UIKit

class HeroesViewController: UIViewController {
    
    private enum ViewConstants {
        static let navigationTitle = "All Heroes"
    }
    
    let heroesViewModel: HeroesViewModel
    private let favouritesViewModel: FavouritesViewModel
    private let loader: ImageLoader = ImageLoader()
    private var isLoadingData: Bool = false
    weak var delegate: ViewControllerDelegate?
    
    init(heroesViewModel: HeroesViewModel, 
         favouritesViewModel: FavouritesViewModel) {
        self.heroesViewModel = heroesViewModel
        self.favouritesViewModel = favouritesViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        delegate?.reloadView()
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = ViewConstants.navigationTitle
        navigationController?.delegate = self
        heroesViewModel.fetchHeroes(searchQuery: nil, addHeroesToView: delegate?.addHeroesToView ?? {})
    }
    
    func updateLoading(to value: Bool) {
        self.isLoadingData = value
    }
    
    func getNumberOfItems() -> Int {
        return heroesViewModel.numberOfHeroes()
    }
    
    func changeHeroPersistanceStatus(hero: Hero) throws {
        favouritesViewModel.changeHeroPersistanceStatus(hero: hero)
    }
    
    func willFetchMoreHeroes(indexPath: IndexPath, lastRowIndex: Int) {
        let numberOfHeroes = heroesViewModel.numberOfHeroes()
        if numberOfHeroes < Constants.numberOfHeroesPerRequest {
            delegate?.spinnerHidden(to: true)
            return
        }
        
        let batchMiddleRowIndex = Constants.numberOfHeroesPerRequest / 2
        let rowIndexLoadMoreHeroes = lastRowIndex - batchMiddleRowIndex
        if self.isLoadingData == false && indexPath.row >= rowIndexLoadMoreHeroes {
            delegate?.spinnerHidden(to: false)
            updateLoading(to: true)
            
            heroesViewModel.fetchHeroes(searchQuery: nil) { [weak self] in
                self?.delegate?.addHeroesToView()
                self?.delegate?.spinnerHidden(to: true)
            }
        }
    }
    
    func itemSelected(indexPath: IndexPath) {
        let hero = heroesViewModel.getHero(index: indexPath.row)
        let heroDetailViewModel = HeroDetailViewModel(heroService: heroesViewModel.heroService, hero: hero)
        let destination = HeroDetailViewController(hero: hero,
                                                   heroIndex: indexPath.row,
                                                   heroDetailViewModel: heroDetailViewModel,
                                                   loader: loader,
                                                   favouritesViewModel: favouritesViewModel)
        destination.delegate = self
        navigationController?.pushViewController(destination, animated: true)
    }
}

extension HeroesViewController: HeroViewControllerDelegate {
    func updateHeroInView(heroIndex: Int, hero: Hero) {
        heroesViewModel.setHero(at: heroIndex, hero: hero)
    }
    
    func updateView(isFavourite: Bool, hero: Hero) {
        delegate?.reloadView()
    }
}
