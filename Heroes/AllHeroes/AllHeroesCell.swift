//
//  AllHeroesCell.swift
//  Heroes
//
//  Created by Bernardo Vala Lourenço on 11/12/2023.
//

import UIKit

enum ViewType {
    case TableView, GridView
}

class AllHeroesCell: UIView {
    private enum CellConstants {
        static let spacing: CGFloat = 10
    }
    
    private let heroName = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 3
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    private let heroImage = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let heroFavouriteButton = {
        let button = UIButton()
        button.tintColor = .systemYellow
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var onReuse: () -> Void = {}
    weak var delegate: CellDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func prepareCellForReuse() {
        heroImage.image = nil
        heroImage.cancelImageLoad()
    }
    
    func addViews(view: UIView) {
        view.addSubview(heroImage)
        view.addSubview(heroName)
        view.addSubview(heroFavouriteButton)
    }
    
    func configure(imageURL: URL?, name: String?) {
        heroName.text = name
        
        loadImage(imageURL: imageURL)
        loadStarImage(name: name)
    }
    
    func loadImage(imageURL: URL?) {
        if let imageURL = imageURL {
            if imageURL.absoluteString.hasSuffix(Constants.notAvailableImageName) == false {
                heroImage.loadImage(at: imageURL)
            } else {
                heroImage.image = UIImage(named: "placeholder")
            }
        } else {
            heroImage.image = UIImage(named: "placeholder")
        }
        heroImage.widthAnchor.constraint(equalTo: heroImage.heightAnchor).isActive = true
    }
    
    func loadStarImage(name: String?) {
        guard let name = name else { return }
        
        if UserDefaults.standard.data(forKey: name) != nil {
            heroFavouriteButton.setImage(UIImage(named: "star"), for: .normal)
        } else {
            heroFavouriteButton.setImage(UIImage(named: "star_add"), for: .normal)
        }
    }
    
    @objc
    func favouriteButtonPressed() {
        guard let name = heroName.text else { return }
        
        do {
            try delegate?.favouriteHero()
            loadStarImage(name: name)
        } catch {
            print(error)
        }
    }
    
    func setupConstraints(view: UIView, type: ViewType) {
        heroFavouriteButton.addTarget(self, action: #selector(favouriteButtonPressed), for: .touchUpInside)
        
        if type == .GridView {
            NSLayoutConstraint.activate([
                heroImage.topAnchor.constraint(equalTo: view.topAnchor),
                heroImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                heroImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                heroName.topAnchor.constraint(equalTo: heroImage.bottomAnchor,
                                              constant: CellConstants.spacing),
                heroName.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                heroName.trailingAnchor.constraint(equalTo: heroFavouriteButton.leadingAnchor),
                heroFavouriteButton.trailingAnchor.constraint(equalTo: heroImage.trailingAnchor),
                heroFavouriteButton.centerYAnchor.constraint(equalTo: heroName.centerYAnchor),
                heroFavouriteButton.heightAnchor.constraint(equalToConstant: Constants.favouriteIconHeight),
                heroFavouriteButton.widthAnchor.constraint(equalTo: heroFavouriteButton.heightAnchor),
            ])
            heroImage.contentMode = .scaleAspectFit
        } else if type == .TableView {
            NSLayoutConstraint.activate([
                heroImage.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                   constant: Constants.mediumPadding),
                heroImage.heightAnchor.constraint(equalToConstant: Constants.tableViewImageHeight),
                heroImage.widthAnchor.constraint(equalTo: heroImage.heightAnchor),
                heroImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                heroName.leadingAnchor.constraint(equalTo: heroImage.trailingAnchor,
                                                  constant: Constants.smallPadding),
                heroName.trailingAnchor.constraint(equalTo: heroFavouriteButton.leadingAnchor),
                heroName.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                heroFavouriteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                              constant: -Constants.mediumPadding),
                heroFavouriteButton.heightAnchor.constraint(equalToConstant: Constants.favouriteIconHeight),
                heroFavouriteButton.widthAnchor.constraint(equalTo: heroFavouriteButton.heightAnchor),
                heroFavouriteButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
        }
    }
}
