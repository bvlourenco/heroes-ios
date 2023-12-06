//
//  HeroesTableViewCell.swift
//  Heroes
//
//  Created by Bernardo Vala Lourenço on 03/11/2023.
//

import UIKit

class HeroesTableViewCell: UITableViewCell {
    
    private let heroName = UILabel()
    private let heroImage = UIImageView()
    var onReuse: () -> Void = {}
    private let heroFavouriteButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(tableCellFavouriteButtonPressed), for: .touchUpInside)
        button.tintColor = .systemYellow
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(heroImage)
        contentView.addSubview(heroName)
        contentView.addSubview(heroFavouriteButton)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        heroImage.image = nil
        heroImage.cancelImageLoad()
    }
    
    func configure(imageURL: URL?, name: String?) {
        heroName.text = name
        heroName.numberOfLines = 0
        
        loadImage(imageURL: imageURL)
        loadStarImage(name: name)
    }
    
    private func loadImage(imageURL: URL?) {
        if let imageURL = imageURL {
            if imageURL.absoluteString.hasSuffix(Constants.notAvailableImageName) == false {
                heroImage.loadImage(at: imageURL)
            } else {
                heroImage.image = UIImage(named: "placeholder")
            }
        } else {
            heroImage.image = UIImage(named: "placeholder")
        }
    }
    
    private func loadStarImage(name: String?) {
        guard let name = name else { return }
        
        if UserDefaults.standard.bool(forKey: name) {
            heroFavouriteButton.setImage(UIImage(named: "star"), for: .normal)
        } else {
            heroFavouriteButton.setImage(UIImage(named: "star_add"), for: .normal)
        }
    }
    
    private func changeHeroStatus(name: String) {
        if UserDefaults.standard.bool(forKey: name) {
            UserDefaults.standard.removeObject(forKey: name)
        } else {
            UserDefaults.standard.set(true, forKey: name)
        }
    }
    
    @objc
    private func tableCellFavouriteButtonPressed() {
        guard let name = heroName.text else { return }
        
        changeHeroStatus(name: name)
        loadStarImage(name: name)
    }
    
    private func setupConstraints() {
        heroImage.translatesAutoresizingMaskIntoConstraints = false
        heroName.translatesAutoresizingMaskIntoConstraints = false
        heroFavouriteButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            heroImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                               constant: Constants.mediumPadding),
            heroImage.heightAnchor.constraint(equalToConstant: Constants.tableViewImageHeight),
            heroImage.widthAnchor.constraint(equalTo: heroImage.heightAnchor),
            heroImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            heroName.leadingAnchor.constraint(equalTo: heroImage.trailingAnchor,
                                              constant: Constants.smallPadding),
            heroName.trailingAnchor.constraint(equalTo: heroFavouriteButton.leadingAnchor),
            heroName.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            heroFavouriteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                          constant: -Constants.mediumPadding),
            heroFavouriteButton.heightAnchor.constraint(equalToConstant: Constants.favouriteIconHeight),
            heroFavouriteButton.widthAnchor.constraint(equalTo: heroFavouriteButton.heightAnchor),
            heroFavouriteButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
