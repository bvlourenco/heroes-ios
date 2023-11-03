//
//  HeroView.swift
//  Heroes
//
//  Created by Bernardo Vala Lourenço on 26/10/2023.
//

import UIKit

class HeroView: UIView {
    var heroDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "There is no description for this hero :("
        label.textAlignment = .left
        label.textColor = .black
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let heroImageView: UIImageView = {
        let placeholderImage = UIImage(named: "placeholder")
        let imageView = UIImageView(image: placeholderImage)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let stackView: UIStackView = {
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
        addElementsToView()
        setupConstrains()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addElementsToView() {
        addSubview(scrollView)
        scrollView.addSubview(stackView)
        
        stackView.addArrangedSubview(heroImageView)
        stackView.addArrangedSubview(heroDescriptionLabel)
        stackView.addArrangedSubview(comicsView)
        stackView.addArrangedSubview(seriesView)
        stackView.addArrangedSubview(eventsView)
        stackView.addArrangedSubview(storiesView)
    }
    
    // From: https://dev.to/msa_128/how-to-create-custom-views-programmatically-2cfm
    // and: https://gist.github.com/moraei/08f1c1841f7bb73bb5c9e89ac428e027
    private func setupConstrains() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.topAnchor),
            scrollView.leftAnchor.constraint(equalTo: self.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: self.rightAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leftAnchor.constraint(equalTo: scrollView.leftAnchor,
                                            constant: Constants.smallPadding),
            stackView.rightAnchor.constraint(equalTo: scrollView.rightAnchor,
                                             constant: -Constants.smallPadding),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            heroDescriptionLabel.widthAnchor.constraint(equalToConstant: UIScreen
                .main.bounds.width - Constants.mediumPadding)
        ])
        
        // Used to remove white space inside scroll view with image view (when having images
        // with aspect ratio of 1:1 approximately)
        if let image = heroImageView.image {
            let height = (heroImageView.frame.width * image.size.height) /  image.size.width
            heroImageView.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
}
