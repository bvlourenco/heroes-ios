//
//  CategoryViewDetail.swift
//  Heroes
//
//  Created by Bernardo Vala Lourenço on 22/12/2023.
//

import UIKit

class CategoryDetailView: UIView {
    let closeButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Close", for: .normal)
        return button
    }()
    
    private var categoryDescription: UILabel = {
        let label = UILabel()
        label.text = "No description :("
        label.textAlignment = .center
        label.textColor = .black
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        return label
    }()
    
    private lazy var categoryName: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textAlignment = .center
        label.textColor = .black
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: Constants.categoryTitleFontSize)
        return label
    }()
    
    private let categoryImageView: UIImageView = {
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
    
    init() {
        super.init(frame: CGRectZero)
        backgroundColor = .black
        addElementsToView()
        setupConstrains()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(name: String?, description: String?, imageURL: URL?) {
        if let name, name.isEmpty == false {
            categoryName.text = name
        }
        
        if let description, description.isEmpty == false {
            categoryDescription.text = description
        }
        
        guard let imageURL else { return }
        categoryImageView.loadImage(at: imageURL)
    }
    
    func updateLayoutAfterRotation() {
        let safeAreaWidth = UIDevice.current.orientation.isLandscape ? UIScreen.main.bounds.width - 9*Constants.mediumPadding :
        UIScreen.main.bounds.width - Constants.mediumPadding
        
        if let constraint = (stackView.constraints.filter{$0.firstAttribute == .width}.first) {
            constraint.constant = safeAreaWidth
        }
    }
    
    private func addElementsToView() {
        addSubview(scrollView)
        scrollView.addSubview(stackView)
        stackView.addArrangedSubview(categoryImageView)
        stackView.addArrangedSubview(categoryName)
        stackView.addArrangedSubview(categoryDescription)
        addSubview(closeButton)
    }
    
    // From: https://dev.to/msa_128/how-to-create-custom-views-programmatically-2cfm
    // and: https://gist.github.com/moraei/08f1c1841f7bb73bb5c9e89ac428e027
    private func setupConstrains() {
        let safeAreaWidth = UIDevice.current.orientation.isLandscape ? UIScreen.main.bounds.width - 9*Constants.mediumPadding :
                                                                       UIScreen.main.bounds.width - Constants.mediumPadding
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor,
                                           constant: Constants.mediumPadding),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor,
                                               constant: Constants.smallPadding),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor,
                                                constant: -Constants.smallPadding),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            stackView.widthAnchor.constraint(equalToConstant: safeAreaWidth),
            
            closeButton.topAnchor.constraint(equalTo: self.topAnchor),
            closeButton.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor)
        ])
        
        // Used to remove white space inside scroll view with image view (when having images
        // with aspect ratio of 1:1 approximately)
        guard let image = categoryImageView.image else { return }
        let height = (categoryImageView.frame.width * image.size.height) /  image.size.width
        categoryImageView.heightAnchor.constraint(equalToConstant: height).isActive = true
    }
}
