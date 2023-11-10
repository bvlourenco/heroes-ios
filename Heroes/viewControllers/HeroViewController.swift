//
//  HeroViewController.swift
//  Heroes
//
//  Created by Bernardo Vala Lourenço on 26/10/2023.
//

import UIKit

class HeroViewController: UIViewController {
    private let heroView: HeroView
    private var hero: Hero
    private let heroViewModel: HeroesViewModel
    private let heroIndex: Int
    private let loader: ImageLoader
    
    init(heroIndex: Int, heroViewModel: HeroesViewModel, loader: ImageLoader) {
        self.hero = heroViewModel.getHeroAtIndex(index: heroIndex)
        self.heroIndex = heroIndex
        self.heroView = HeroView()
        self.heroViewModel = heroViewModel
        self.loader = loader
        super.init(nibName: "HeroViewController", bundle: Bundle.main)
        getCategoriesDescriptions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = heroView
        navigationItem.title = self.hero.name
        
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
    }
    
    private func getCategoriesDescriptions() {
        Task {
            self.hero = await heroViewModel.getDescriptions(heroIndex: heroIndex)
            
            updateDescriptionInView(categoryValues: self.hero.comics,
                                    viewCategory: self.heroView.comicsView)
            
            updateDescriptionInView(categoryValues: self.hero.events,
                                    viewCategory: self.heroView.eventsView)
            
            updateDescriptionInView(categoryValues: self.hero.series,
                                    viewCategory: self.heroView.seriesView)
            
            updateDescriptionInView(categoryValues: self.hero.stories,
                                    viewCategory: self.heroView.storiesView)
        }
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
