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
    private let heroIndex: Int
    private let heroViewModel: HeroDetailViewModel
    private let loader: ImageLoader
    // TODO: Try to remove the distinction between snapshot test and normal program execution
    private let isSnapshotTest: Bool
    weak var delegate: HeroViewControllerDelegate?
    
    init(hero: Hero, 
         heroIndex: Int,
         heroDetailViewModel: HeroDetailViewModel,
         loader: ImageLoader,
         isSnapshotTest: Bool = false) {
        self.hero = hero
        self.heroView = HeroDetailView()
        self.heroViewModel = heroDetailViewModel
        self.loader = loader
        self.heroIndex = heroIndex
        self.isSnapshotTest = isSnapshotTest
        super.init(nibName: "HeroViewController", bundle: Bundle.main)
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
        
        if let description = self.hero.description {
            if description.isEmpty == false {
                heroView.heroDescriptionLabel.text = self.hero.description
            }
        }
        
        let imageURL = hero.thumbnail?.imageURL
        
        if let imageURL = imageURL {
            if imageURL.absoluteString.hasSuffix(Constants.notAvailableImageName) == false {
                heroView.heroImageView.loadImage(at: imageURL)
            } else {
                heroView.heroImageView.image = UIImage(named: "placeholder")
            }
        } else {
            heroView.heroImageView.image = UIImage(named: "placeholder")
        }
        
        addCategory(categoryValues: self.hero.comics,
                    viewCategory: self.heroView.comicsView)
        
        addCategory(categoryValues: self.hero.events,
                    viewCategory: self.heroView.eventsView)
        
        addCategory(categoryValues: self.hero.series,
                    viewCategory: self.heroView.seriesView)
        
        addCategory(categoryValues: self.hero.stories,
                    viewCategory: self.heroView.storiesView)
        
        getCategoriesDescriptions()
    }
    
    private func createTitleLabel() -> UILabel {
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
            delegate?.updateHeroInTableView(heroIndex: heroIndex, hero: self.hero)
            
            if isSnapshotTest == false {
                self.updateAllDescriptions()
            }
        }
        
        if isSnapshotTest {
            self.updateAllDescriptions()
        }
    }
    
    private func updateAllDescriptions() {
        updateDescriptionInView(categoryValues: self.hero.comics,
                                viewCategory: self.heroView.comicsView)
        
        updateDescriptionInView(categoryValues: self.hero.events,
                                viewCategory: self.heroView.eventsView)
        
        updateDescriptionInView(categoryValues: self.hero.series,
                                viewCategory: self.heroView.seriesView)
        
        updateDescriptionInView(categoryValues: self.hero.stories,
                                viewCategory: self.heroView.storiesView)
    }
    
    private func addCategory(categoryValues: Category?,
                             viewCategory: CategoryViewComponent) {
        if let categoryValues = categoryValues {
            if categoryValues.items.count == 0 {
                viewCategory.addPlaceholderView()
            } else {
                for category in categoryValues.items {
                    let description = "Loading..."
                    viewCategory.addCategoryNameAndDescription(name: category.name,
                                                               description: description)
                }
            }
            viewCategory.setViewIntrinsicHeight()
        }
    }
    
    private func updateDescriptionInView(categoryValues: Category?,
                                         viewCategory: CategoryViewComponent) {
        if let categoryValues = categoryValues {
            for (index, category) in categoryValues.items.enumerated() {
                var description = category.description ?? "No description :("
                if description == "" {
                    description = "No description :("
                }
                viewCategory.updateDescription(atIndex: index, description: description)
            }
        }
    }
}
