//
//  HeroesCell.swift
//  Heroes
//
//  Created by Bernardo Vala Lourenço on 11/12/2023.
//

import UIKit

enum ViewType {
    case TableView, GridView
}

class HeroesCell: UIView {
    private enum CellConstants {
        static let spacing: CGFloat = 10
    }
    
    private let heroName = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 3
        label.lineBreakMode = .byTruncatingTail
        label.textColor = .white
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
    
    weak var delegate: CellDelegate?
    
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
        loadStarImage(name: name)
        loadImage(imageURL: imageURL)
    }
    
    func loadImage(imageURL: URL?) {
        guard let imageURL else { return }
        
        heroImage.loadImage(at: imageURL)
        heroImage.widthAnchor.constraint(equalTo: heroImage.heightAnchor).isActive = true
    }
    
    func loadStarImage(name: String?) {
        guard let name = name else { return }
        
        heroFavouriteButton.setImage(UIImage(named: UserDefaults.standard.data(forKey: name) != nil ?
                                             Constants.favouriteImageName : Constants.addFavouriteImageName),
                                     for: .normal)
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
        
        NSLayoutConstraint.activate([
            heroFavouriteButton.heightAnchor.constraint(equalToConstant: Constants.favouriteIconHeight),
            heroFavouriteButton.widthAnchor.constraint(equalTo: heroFavouriteButton.heightAnchor),
            heroName.trailingAnchor.constraint(equalTo: heroFavouriteButton.leadingAnchor)
        ])
        
        if type == .GridView {
            NSLayoutConstraint.activate([
                heroImage.topAnchor.constraint(equalTo: view.topAnchor),
                heroImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                heroImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                heroName.topAnchor.constraint(equalTo: heroImage.bottomAnchor,
                                              constant: CellConstants.spacing),
                heroName.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                heroFavouriteButton.trailingAnchor.constraint(equalTo: heroImage.trailingAnchor),
                heroFavouriteButton.centerYAnchor.constraint(equalTo: heroName.centerYAnchor),
            ])
        } else if type == .TableView {
            NSLayoutConstraint.activate([
                heroImage.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                   constant: Constants.mediumPadding),
                heroImage.heightAnchor.constraint(equalToConstant: Constants.tableViewImageHeight),
                heroName.leadingAnchor.constraint(equalTo: heroImage.trailingAnchor,
                                                  constant: Constants.smallPadding),
                heroName.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                heroFavouriteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                              constant: -Constants.mediumPadding),
                heroFavouriteButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
        }
    }
}
