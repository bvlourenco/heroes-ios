//
//  HeroViewController.swift
//  Heroes
//
//  Created by Bernardo Vala Lourenço on 26/10/2023.
//

import UIKit

class HeroViewController: UIViewController {
    private let heroView: HeroView
    private let heroService: HeroServiceProtocol
    private var hero: Hero
    private let heroViewModel: HeroesTableViewModel
    private let heroIndex: Int
    
    init(hero: Hero, service: HeroServiceProtocol, 
         heroIndex: Int, heroViewModel: HeroesTableViewModel) {
        self.hero = hero
        self.heroIndex = heroIndex
        self.heroView = HeroView()
        self.heroViewModel = heroViewModel
        self.heroService = service
        super.init(nibName: "HeroViewController", bundle: Bundle.main)
        getCategoriesDescriptions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = heroView
        navigationItem.title = self.hero.name
        
        if self.hero.description.isEmpty == false {
            heroView.heroDescriptionLabel.text = self.hero.description
        }
        
        if let imageData = self.hero.imageData {
            heroView.heroImageView.image = UIImage(data: imageData)
        }
    }
    
    private func getCategoriesDescriptions() {
        Task {
            if self.hero.descriptionsLoaded == false {
                do {
                    self.hero = try await heroService.getHeroDetails(hero: self.hero)
                    self.hero.descriptionsLoaded = true
                    heroViewModel.setHero(index: self.heroIndex, hero: self.hero)
                } catch {
                    print(error)
                }
            }
            addCategory(categoryValues: self.hero.heroComics.values,
                        viewCategory: self.heroView.comicsView)
            
            addCategory(categoryValues: self.hero.heroEvents.values,
                        viewCategory: self.heroView.eventsView)
            
            addCategory(categoryValues: self.hero.heroSeries.values,
                        viewCategory: self.heroView.seriesView)
            
            addCategory(categoryValues: self.hero.heroStories.values,
                        viewCategory: self.heroView.storiesView)
        }
    }
    
    private func addCategory(categoryValues: Dictionary<String,
                             HeroCategoryDetails>.Values,
                             viewCategory: CategoryViewComponent) {
        if categoryValues.count == 0 {
            viewCategory.addPlaceholderView()
        } else {
            for category in categoryValues {
                let description = category.description ?? "No description :("
                viewCategory.addCategoryNameAndDescription(name: category.name,
                                                           description: description)
            }
        }
        viewCategory.setViewIntrinsicHeight()
    }
}
