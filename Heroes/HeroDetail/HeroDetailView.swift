//
//  HeroView.swift
//  Heroes
//
//  Created by Bernardo Vala Lourenço on 26/10/2023.
//

import UIKit

class HeroDetailView: UIView {
    private var heroDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "There is no description for this hero :("
        label.textAlignment = .left
        label.textColor = .black
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let heroImageView: UIImageView = {
        let placeholderImage = UIImage(named: Constants.placeholderImageName)
        let imageView = UIImageView(image: placeholderImage)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
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
    
    private let comicsView: CategoryViewComponent
    private let seriesView: CategoryViewComponent
    private let eventsView: CategoryViewComponent
    private let storiesView: CategoryViewComponent
    
    init() {
        self.comicsView = CategoryViewComponent(categoryName: "Comics")
        self.seriesView = CategoryViewComponent(categoryName: "Series")
        self.eventsView = CategoryViewComponent(categoryName: "Events")
        self.storiesView = CategoryViewComponent(categoryName: "Stories")
        super.init(frame: CGRectZero)
        backgroundColor = .white
        addElementsToView()
        setupConstrains()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(description: String?,
                   imageURL: URL?,
                   comics: Category?,
                   events: Category?,
                   series: Category?,
                   stories: Category?) {
        if let description, description.isEmpty == false {
            heroDescriptionLabel.text = description
        }
        
        addCategoryNames(categoryValues: comics, viewCategory: comicsView)
        addCategoryNames(categoryValues: events, viewCategory: eventsView)
        addCategoryNames(categoryValues: series, viewCategory: seriesView)
        addCategoryNames(categoryValues: stories, viewCategory: storiesView)
        
        guard let imageURL else { return }
        heroImageView.loadImage(at: imageURL)
    }
    
    private func addCategoryNames(categoryValues: Category?,
                                  viewCategory: CategoryViewComponent) {
        guard let categoryValues else { return }

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
    
    func updateAllDescriptions(comics: Category?,
                               events: Category?,
                               series: Category?,
                               stories: Category?) {
        updateDescriptionInView(category: comics, view: comicsView)
        updateDescriptionInView(category: events, view: eventsView)
        updateDescriptionInView(category: series, view: seriesView)
        updateDescriptionInView(category: stories, view: storiesView)
    }
    
    private func updateDescriptionInView(category: Category?,
                                         view: CategoryViewComponent) {
        guard let category else { return }
        
        var description: String
        for (index, category) in category.items.enumerated() {
            if let categoryDescription = category.description, 
                categoryDescription.isEmpty == false {
                description = categoryDescription
            } else {
                description = "No description :("
            }
            view.updateDescription(at: index, description: description)
        }
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
        guard let image = heroImageView.image else { return }
        let height = (heroImageView.frame.width * image.size.height) /  image.size.width
        heroImageView.heightAnchor.constraint(equalToConstant: height).isActive = true
    }
}
