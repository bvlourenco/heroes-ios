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
        label.textColor = .white
        return label
    }()
    
    private let heroImageView: UIImageView = {
        let placeholderImage = UIImage(named: GlobalConstants.placeholderImageName)
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
    
    private var categoriesView: [String:CategoryViewComponent] = [:]
    
    init() {
        self.categoriesView["comics"] = CategoryViewComponent(categoryName: "Comics")
        self.categoriesView["series"] = CategoryViewComponent(categoryName: "Series")
        self.categoriesView["events"] = CategoryViewComponent(categoryName: "Events")
        self.categoriesView["stories"] = CategoryViewComponent(categoryName: "Stories")
        super.init(frame: CGRectZero)
        backgroundColor = .black
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
                   stories: Category?,
                   viewController: HeroDetailViewController) {
        for category in categoriesView.values {
            category.setGridDataSourceAndDelegate(viewController: viewController)
        }
        
        if let description, description.isEmpty == false {
            heroDescriptionLabel.text = description
        }
        
        guard let imageURL else { return }
        heroImageView.loadImage(at: imageURL)
    }
    
    func reloadCategories() {
        for category in categoriesView.values {
            category.reload()
        }
    }
    
    func configure(hasElements: Bool, for key: String) {
        let categoryView = self.categoriesView[key]
        
        guard let categoryView else { return }
        
        if hasElements == false {
            categoryView.addPlaceholderView()
        }
        
        categoryView.setHasElements(hasElements: hasElements)
        categoryView.setViewIntrinsicHeight()
    }
    
    func isCategoryCollectionViews(collectionView: UICollectionView, category key: String) -> Bool {
        let categoryView = self.categoriesView[key]
        guard let categoryView else { return false }
        return collectionView == categoryView.getGridView().getCollectionView()
    }
    
    func updateLayoutAfterRotation() {
        let safeAreaWidth = UIDevice.current.orientation.isLandscape ? UIScreen.main.bounds.width - 9*GlobalConstants.mediumPadding :
                                                                       UIScreen.main.bounds.width - GlobalConstants.mediumPadding
        
        if let constraint = (stackView.constraints.filter{$0.firstAttribute == .width}.first) {
            constraint.constant = safeAreaWidth
        }
        
        for category in categoriesView.values {
            category.updateLayoutAfterRotation()
        }
    }
    
    private func addElementsToView() {
        addSubview(scrollView)
        scrollView.addSubview(stackView)
        
        stackView.addArrangedSubview(heroImageView)
        stackView.addArrangedSubview(heroDescriptionLabel)
        stackView.addArrangedSubview(categoriesView["comics"] ?? UIView())
        stackView.addArrangedSubview(categoriesView["series"] ?? UIView())
        stackView.addArrangedSubview(categoriesView["events"] ?? UIView())
        stackView.addArrangedSubview(categoriesView["stories"] ?? UIView())
    }
    
    // From: https://dev.to/msa_128/how-to-create-custom-views-programmatically-2cfm
    // and: https://gist.github.com/moraei/08f1c1841f7bb73bb5c9e89ac428e027
    private func setupConstrains() {
        let safeAreaWidth = UIDevice.current.orientation.isLandscape ? UIScreen.main.bounds.width - 9*GlobalConstants.mediumPadding :
                                                                       UIScreen.main.bounds.width - GlobalConstants.mediumPadding
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor,
                                               constant: GlobalConstants.smallPadding),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor,
                                                constant: -GlobalConstants.smallPadding),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            stackView.widthAnchor.constraint(equalToConstant: safeAreaWidth)
        ])
        
        // Used to remove white space inside scroll view with image view (when having images
        // with aspect ratio of 1:1 approximately)
        guard let image = heroImageView.image else { return }
        let height = (heroImageView.frame.width * image.size.height) /  image.size.width
        heroImageView.heightAnchor.constraint(equalToConstant: height).isActive = true
    }
}
