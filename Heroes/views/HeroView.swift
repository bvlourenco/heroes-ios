//
//  HeroView.swift
//  Heroes
//
//  Created by Bernardo Vala Lourenço on 26/10/2023.
//

import UIKit

class HeroView: UIView {
    lazy var heroDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "There is no description for this hero :("
        label.textAlignment = .left
        label.textColor = .black
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var heroImageView: UIImageView = {
        let placeholderImage = UIImage(named: "placeholder")
        let imageView = UIImageView(image: placeholderImage)
        imageView.contentMode = .scaleAspectFit
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
        addSubview(scrollView)
        scrollView.addSubview(scrollViewContainer)
        scrollViewContainer.addArrangedSubview(heroImageView)
        scrollViewContainer.addArrangedSubview(heroDescriptionLabel)
        scrollViewContainer.addArrangedSubview(comicsView)
        scrollViewContainer.addArrangedSubview(seriesView)
        scrollViewContainer.addArrangedSubview(eventsView)
        scrollViewContainer.addArrangedSubview(storiesView)
        setupConstrains()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // From: https://dev.to/msa_128/how-to-create-custom-views-programmatically-2cfm
    // and: https://gist.github.com/moraei/08f1c1841f7bb73bb5c9e89ac428e027
    private func setupConstrains() {
        scrollView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        scrollViewContainer.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 8).isActive = true
        scrollViewContainer.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -8).isActive = true
        scrollViewContainer.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        scrollViewContainer.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true

        heroDescriptionLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 16).isActive = true
        
        // Used to remove white space inside scroll view with image view (when having images
        // with aspect ratio of 1:1 approximately)
        if let image = heroImageView.image {
            let height = (heroImageView.frame.width * heroImageView.image!.size.height) /  heroImageView.image!.size.width
            heroImageView.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
}
