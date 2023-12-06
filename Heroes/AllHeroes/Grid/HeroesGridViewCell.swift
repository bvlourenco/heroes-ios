//
//  HeroesGridViewCell.swift
//  Heroes
//
//  Created by Bernardo Vala Lourenço on 21/11/2023.
//

import UIKit

class HeroesGridViewCell: UICollectionViewCell {
    
    private enum CellConstants {
        static let imageHeight: CGFloat = 250
        static let spacing: CGFloat = 10
    }
    
    private let heroName = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 3
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    let heroImage = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let heroFavouriteButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(gridCellFavouriteButtonPressed), for: .touchUpInside)
        button.tintColor = .systemYellow
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var onReuse: () -> Void = {}
    var storeHero: ((UICollectionViewCell) throws -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
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
        heroImage.widthAnchor.constraint(equalTo: heroImage.heightAnchor).isActive = true
    }
    
    private func loadStarImage(name: String?) {
        guard let name = name else { return }
        
        if UserDefaults.standard.data(forKey: name) != nil {
            heroFavouriteButton.setImage(UIImage(named: "star"), for: .normal)
        } else {
            heroFavouriteButton.setImage(UIImage(named: "star_add"), for: .normal)
        }
    }
    
    @objc
    private func gridCellFavouriteButtonPressed() {
        guard let name = heroName.text else { return }
        
        do {
            try storeHero?(self)
            loadStarImage(name: name)
        } catch {
            print(error)
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            heroImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            heroImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            heroImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            heroName.topAnchor.constraint(equalTo: heroImage.bottomAnchor,
                                          constant: CellConstants.spacing),
            heroName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            heroName.trailingAnchor.constraint(equalTo: heroFavouriteButton.leadingAnchor),
            heroFavouriteButton.trailingAnchor.constraint(equalTo: heroImage.trailingAnchor),
            heroFavouriteButton.centerYAnchor.constraint(equalTo: heroName.centerYAnchor),
            heroFavouriteButton.heightAnchor.constraint(equalToConstant: Constants.favouriteIconHeight),
            heroFavouriteButton.widthAnchor.constraint(equalTo: heroFavouriteButton.heightAnchor),
        ])
        heroImage.contentMode = .scaleAspectFit
    }
}
