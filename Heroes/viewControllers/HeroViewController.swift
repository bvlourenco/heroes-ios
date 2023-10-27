//
//  HeroViewController.swift
//  Heroes
//
//  Created by Bernardo Vala Lourenço on 26/10/2023.
//

import UIKit

class HeroViewController: UIViewController {
    let heroView: HeroView
    let hero: Hero
    
    init(hero: Hero) {
        self.hero = hero
        self.heroView = HeroView()
        super.init(nibName: "HeroViewController", bundle: Bundle.main)
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
        
        // TODO: Improve handling of non-existant images
        if self.hero.imageURL
            .hasSuffix("image_not_available.jpg") == false {
            // TODO: Repeated code
            ImageCache.imageForUrl(urlString: self.hero.imageURL,
                                   completionHandler: {
                (image, url, isNotLoaded) in
                if image != nil {
                    self.heroView.heroImageView.alpha = 0
                    self.heroView.heroImageView.image = image
                    UIView.animate(withDuration: 1,
                                   delay: 0,
                                   options: UIView.AnimationOptions
                        .showHideTransitionViews,
                                   animations: { () -> Void in
                        self.heroView.heroImageView.alpha = 1 }
                    )
                }
            })
        }
        
        addCategory(categoryValues: self.hero.heroComics.values)
        addCategory(categoryValues: self.hero.heroEvents.values)
        addCategory(categoryValues: self.hero.heroSeries.values)
        addCategory(categoryValues: self.hero.heroStories.values)
    }
    
    func addCategory(categoryValues: Dictionary<String, HeroCategoryDetails>.Values) {
        for category in categoryValues {
            let description = category.description ?? "No description :("
            self.heroView.comicsView.addCategoryNameAndDescription(name: category.name,
                                                                   description: description)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
