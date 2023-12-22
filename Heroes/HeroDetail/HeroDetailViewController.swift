//
//  HeroViewController.swift
//  Heroes
//
//  Created by Bernardo Vala Lourenço on 26/10/2023.
//

import UIKit

class HeroDetailViewController: UIViewController {
    
    private enum GridConstants {
        static let leftPadding: CGFloat = 10
        static let rightPadding: CGFloat = 10
        static let cellHeight: CGFloat = 190
        static let cellHeightLandscape: CGFloat = 220
        static let cellWidthLandscape: CGFloat = 200
    }
    
    private let heroView: HeroDetailView
    private var hero: Hero
    private let heroIndex: Int?
    private let heroViewModel: HeroDetailViewModel
    private let favouritesViewModel: FavouritesViewModel
    private let loader: ImageLoader
    // TODO: Try to remove the distinction between snapshot test and normal program execution
    private let isSnapshotTest: Bool
    weak var delegate: HeroViewControllerDelegate?
    
    init(hero: Hero, 
         heroIndex: Int?,
         heroDetailViewModel: HeroDetailViewModel,
         loader: ImageLoader,
         favouritesViewModel: FavouritesViewModel,
         isSnapshotTest: Bool = false) {
        self.hero = hero
        self.heroView = HeroDetailView()
        self.heroViewModel = heroDetailViewModel
        self.loader = loader
        self.heroIndex = heroIndex
        self.isSnapshotTest = isSnapshotTest
        self.favouritesViewModel = favouritesViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = heroView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.titleView = createTitleLabel()
        navigationItem.largeTitleDisplayMode = .never

        createStarButtonOnNavigationBar()
        
        heroView.setupView(description: self.hero.description,
                           imageURL: hero.thumbnail?.imageURL,
                           comics: self.hero.comics,
                           events: self.hero.events,
                           series: self.hero.series,
                           stories: self.hero.stories,
                           viewController: self)
        
        getCategoriesDescriptions()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    private func createStarButtonOnNavigationBar() {
        let button = UIButton()
        button.addTarget(self, action: #selector(favouriteHeroButtonPressed), for: .touchUpInside)
        button.tintColor = .systemYellow
        loadStarImage(button: button)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
    }
    
    private func createTitleLabel() -> UILabel {
        // The frame arguments allows to have a very long name being shown completely
        let label = UILabel(frame: CGRect(x: CGFloat(0), y: CGFloat(0),
                                          width: UIScreen.main.bounds.width,
                                          height: CGFloat(Constants.navigationTitleFrameSize)))
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: label.font.pointSize)
        label.text = self.hero.name
        return label
    }
    
    private func getCategoriesDescriptions() {
        Task {
            self.hero = await heroViewModel.getHeroDescriptions()
            
            if let index = heroIndex {
                delegate?.updateHeroInView(heroIndex: index, hero: self.hero)
            }
            
            heroView.comicsView.gridView.collectionView.reloadData()
            heroView.eventsView.gridView.collectionView.reloadData()
            heroView.seriesView.gridView.collectionView.reloadData()
            heroView.storiesView.gridView.collectionView.reloadData()
            
            var hasComicElements = false
            var hasSeriesElements = false
            var hasEventsElements = false
            var hasStoriesElements = false
            
            if let comics = self.hero.comics?.items {
                hasComicElements = comics.count > 0
            }
            if let series = self.hero.series?.items {
                hasSeriesElements = series.count > 0
            }
            if let events = self.hero.events?.items {
                hasEventsElements = events.count > 0
            }
            if let stories = self.hero.stories?.items {
                hasStoriesElements = stories.count > 0
            }
            
            if hasComicElements == false {
                heroView.comicsView.addPlaceholderView()
            }
            if hasSeriesElements == false {
                heroView.seriesView.addPlaceholderView()
            }
            if hasEventsElements == false {
                heroView.eventsView.addPlaceholderView()
            }
            if hasStoriesElements == false {
                heroView.storiesView.addPlaceholderView()
            }
            
            heroView.comicsView.setViewIntrinsicHeight(hasElements: hasComicElements)
            heroView.eventsView.setViewIntrinsicHeight(hasElements: hasEventsElements)
            heroView.seriesView.setViewIntrinsicHeight(hasElements: hasSeriesElements)
            heroView.storiesView.setViewIntrinsicHeight(hasElements: hasStoriesElements)
            
//            if isSnapshotTest == false {
//                heroView.updateAllDescriptions(comics: self.hero.comics,
//                                               events: self.hero.events,
//                                               series: self.hero.series,
//                                               stories: self.hero.stories)
//            }
        }
        
//        if isSnapshotTest {
//            heroView.updateAllDescriptions(comics: self.hero.comics,
//                                           events: self.hero.events,
//                                           series: self.hero.series,
//                                           stories: self.hero.stories)
//        }
    }
    
    private func loadStarImage(button: UIButton) {
        guard let name = hero.name else { return }
        
        var image = UIImage(named: UserDefaults.standard.data(forKey: name) != nil ? "star" : "star_add")
        image = image?.imageWith(newSize: CGSize(width: Constants.iconWidthSize,
                                                 height: Constants.iconHeightSize))
        button.setImage(image, for: .normal)
    }
    
    @objc
    private func favouriteHeroButtonPressed(sender: UIBarButtonItem) {
        favouritesViewModel.changeHeroPersistanceStatus(hero: hero)
        let button = navigationItem.rightBarButtonItem?.customView as! UIButton
        loadStarImage(button: button)
        guard let name = hero.name else { return }
        delegate?.updateView(isFavourite: UserDefaults.standard.data(forKey: name) != nil, hero: hero)
    }
}

extension HeroDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate,
                                        UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == heroView.comicsView.gridView.collectionView {
            return self.hero.comics?.items.count ?? 0
        } else if collectionView == heroView.seriesView.gridView.collectionView {
            return self.hero.series?.items.count ?? 0
        } else if collectionView == heroView.eventsView.gridView.collectionView {
            return self.hero.events?.items.count ?? 0
        } else if collectionView == heroView.storiesView.gridView.collectionView {
            return self.hero.stories?.items.count ?? 0
        } else {
            assert(false, "Error building collection view in hero detail page")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.cellIdentifier,
                                                      for: indexPath) as! HeroesGridViewCell
        if collectionView == heroView.comicsView.gridView.collectionView {
            cell.configure(imageURL: hero.comics?.items[indexPath.row].thumbnail?.imageURL,
                           name: hero.comics?.items[indexPath.row].name,
                           hideFavouriteButton: true)
            return cell
        } else if collectionView == heroView.seriesView.gridView.collectionView {
            cell.configure(imageURL: hero.series?.items[indexPath.row].thumbnail?.imageURL,
                           name: hero.series?.items[indexPath.row].name,
                           hideFavouriteButton: true)
            return cell
        } else if collectionView == heroView.eventsView.gridView.collectionView {
            cell.configure(imageURL: hero.events?.items[indexPath.row].thumbnail?.imageURL,
                           name: hero.events?.items[indexPath.row].name,
                           hideFavouriteButton: true)
            return cell
        } else if collectionView == heroView.storiesView.gridView.collectionView {
            cell.configure(imageURL: hero.stories?.items[indexPath.row].thumbnail?.imageURL,
                           name: hero.stories?.items[indexPath.row].name,
                           hideFavouriteButton: true)
            return cell
        } else {
            assert(false, "Error building collection view in hero detail page")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        var destination: CategoryDetailViewController?
        
        if collectionView == heroView.comicsView.gridView.collectionView {
            destination = CategoryDetailViewController(category: self.hero.comics?.items[indexPath.row], loader: loader)
        } else if collectionView == heroView.seriesView.gridView.collectionView {
            destination = CategoryDetailViewController(category: self.hero.series?.items[indexPath.row], loader: loader)
        } else if collectionView == heroView.eventsView.gridView.collectionView {
            destination = CategoryDetailViewController(category: self.hero.events?.items[indexPath.row], loader: loader)
        } else if collectionView == heroView.storiesView.gridView.collectionView {
            destination = CategoryDetailViewController(category: self.hero.stories?.items[indexPath.row], loader: loader)
        }
        
        guard let destination else { assert(false, "Error building collection view in hero detail page") }
        
        destination.modalPresentationStyle = .pageSheet
        if let presentationController = destination.presentationController as? UISheetPresentationController {
            presentationController.detents = [.medium()]
        }
        self.present(destination, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellHeight: CGFloat = UIDevice.current.orientation.isLandscape ? GridConstants.cellHeightLandscape :
                                                                             GridConstants.cellHeight
        let cellWidthPortrait = collectionView.frame.width / 2 - (GridConstants.leftPadding + GridConstants.rightPadding)
        let cellWidth = UIDevice.current.orientation.isLandscape ? GridConstants.cellWidthLandscape : cellWidthPortrait
        return CGSize(width: cellWidth, height: cellHeight)
    }
}
