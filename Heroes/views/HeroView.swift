//
//  HeroView.swift
//  Heroes
//
//  Created by Bernardo Vala Lourenço on 26/10/2023.
//

import UIKit

class HeroView: UIView {
    lazy var heroDescriptionLabel: UILabel = {
        // internal label, not the same as the external label
        let label = UILabel()
        label.text = "There is no description for this hero :("
        label.textAlignment = .center
        label.textColor = .black
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    lazy var heroImageView: UIImageView = {
        let placeholderImage = UIImage(named: "placeholder")
        let imageView = UIImageView(image: placeholderImage)
        return imageView
    }()
    
    let comicsView: CategoryViewComponent
    let seriesView: CategoryViewComponent
    let eventsView: CategoryViewComponent
    let storiesView: CategoryViewComponent
    
    override init(frame: CGRect) {
        self.comicsView = CategoryViewComponent(frame: frame, categoryName: "comics")
        self.seriesView = CategoryViewComponent(frame: frame, categoryName: "series")
        self.eventsView = CategoryViewComponent(frame: frame, categoryName: "events")
        self.storiesView = CategoryViewComponent(frame: frame, categoryName: "stories")
        super.init(frame: frame)
        backgroundColor = .yellow
        addSubview(heroDescriptionLabel)
        addSubview(heroImageView)
        addSubview(comicsView)
        addSubview(seriesView)
        addSubview(storiesView)
        addSubview(eventsView)
        setupConstrains()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // From: https://dev.to/msa_128/how-to-create-custom-views-programmatically-2cfm
    private func setupConstrains() {
        // Needed to avoid auto layout conflicts
        heroDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        heroImageView.translatesAutoresizingMaskIntoConstraints = false
        
        heroDescriptionLabel.topAnchor.constraint(equalTo: self.heroImageView
            .bottomAnchor,
                                                  constant: 16).isActive = true
        heroDescriptionLabel.leftAnchor.constraint(equalTo:
                                                    self.safeAreaLayoutGuide.leftAnchor,
                                                   constant: 18).isActive = true
        heroDescriptionLabel.rightAnchor.constraint(equalTo:
                                                        self.safeAreaLayoutGuide.rightAnchor,
                                                    constant: -18).isActive = true
        
        heroImageView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor,
                                           constant: 16).isActive = true
        heroImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        heroImageView.heightAnchor.constraint(equalToConstant:
                                                UIScreen.main.bounds.height / 4).isActive = true
        heroImageView.widthAnchor.constraint(equalTo: heroImageView.heightAnchor,
                                             multiplier: 1).isActive = true
        
        comicsView.topAnchor.constraint(equalTo: self.heroDescriptionLabel
                                                     .bottomAnchor,
                                        constant: 32).isActive = true
        seriesView.topAnchor.constraint(equalTo: self.comicsView.bottomAnchor,
                                        constant: 32).isActive = true
        storiesView.topAnchor.constraint(equalTo: self.seriesView.bottomAnchor,
                                         constant: 32).isActive = true
        eventsView.topAnchor.constraint(equalTo: self.storiesView.bottomAnchor,
                                        constant: 32).isActive = true
    }
}
