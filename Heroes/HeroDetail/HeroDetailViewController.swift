//
//  HeroViewController.swift
//  Heroes
//
//  Created by Bernardo Vala Lourenço on 26/10/2023.
//

import UIKit

class HeroDetailViewController: UIViewController {
    
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
                           stories: self.hero.stories)
        
        getCategoriesDescriptions()
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
            
            if isSnapshotTest == false {
                heroView.updateAllDescriptions(comics: self.hero.comics,
                                               events: self.hero.events,
                                               series: self.hero.series,
                                               stories: self.hero.stories)
            }
        }
        
        if isSnapshotTest {
            heroView.updateAllDescriptions(comics: self.hero.comics,
                                           events: self.hero.events,
                                           series: self.hero.series,
                                           stories: self.hero.stories)
        }
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
