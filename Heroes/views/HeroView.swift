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
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    let scrollViewContainer: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let comicsView: CategoryViewComponent
    let seriesView: CategoryViewComponent
    let eventsView: CategoryViewComponent
    let storiesView: CategoryViewComponent
    
    override init(frame: CGRect) {
        self.comicsView = CategoryViewComponent(frame: frame, categoryName: "Comics")
        self.seriesView = CategoryViewComponent(frame: frame, categoryName: "Series")
        self.eventsView = CategoryViewComponent(frame: frame, categoryName: "Events")
        self.storiesView = CategoryViewComponent(frame: frame, categoryName: "Stories")
        super.init(frame: frame)
        backgroundColor = .white
        addSubview(heroDescriptionLabel)
        addSubview(heroImageView)
        addSubview(scrollView)
        scrollView.addSubview(scrollViewContainer)
        scrollViewContainer.addArrangedSubview(comicsView)
        scrollViewContainer.addArrangedSubview(seriesView)
        scrollViewContainer.addArrangedSubview(storiesView)
        scrollViewContainer.addArrangedSubview(eventsView)
        setupConstrains()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // From: https://dev.to/msa_128/how-to-create-custom-views-programmatically-2cfm
    private func setupConstrains() {
        scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: heroDescriptionLabel.bottomAnchor, constant: 16).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        scrollViewContainer.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor,
                                                     constant: 18).isActive = true
        scrollViewContainer.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        scrollViewContainer.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        scrollViewContainer.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        
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
    }
}
