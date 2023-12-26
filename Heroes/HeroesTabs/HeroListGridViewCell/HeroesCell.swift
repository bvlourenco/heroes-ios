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
    private enum Constants {
        static let spacing: CGFloat = 10
        static let borderRadius: CGFloat = 15.0
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
        image.layer.cornerRadius = Constants.borderRadius
        image.layer.masksToBounds = true
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
    
    func configure(imageURL: URL?, name: String?, hideFavouriteButton: Bool = false) {
        heroName.text = name
        loadStarImage(name: name)
        loadImage(imageURL: imageURL)
        heroFavouriteButton.isHidden = hideFavouriteButton
    }
    
    func loadImage(imageURL: URL?) {
        guard let imageURL else { return }
        
        heroImage.loadImage(at: imageURL)
        heroImage.widthAnchor.constraint(equalTo: heroImage.heightAnchor).isActive = true
    }
    
    func loadStarImage(name: String?) {
        guard let name = name else { return }
        
        heroFavouriteButton.setImage(UIImage(named: UserDefaults.standard.data(forKey: name) != nil ?
                                             GlobalConstants.favouriteImageName : GlobalConstants.addFavouriteImageName),
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
            heroFavouriteButton.heightAnchor.constraint(equalToConstant: GlobalConstants.favouriteIconHeight),
            heroFavouriteButton.widthAnchor.constraint(equalTo: heroFavouriteButton.heightAnchor),
            heroName.trailingAnchor.constraint(equalTo: heroFavouriteButton.leadingAnchor)
        ])
        
        if type == .GridView {
            heroImage.addOverlay()
            
            NSLayoutConstraint.activate([
                heroImage.topAnchor.constraint(equalTo: view.topAnchor),
                heroImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                heroImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                heroName.bottomAnchor.constraint(equalTo: heroImage.bottomAnchor,
                                                 constant: -Constants.spacing),
                heroName.leadingAnchor.constraint(equalTo: heroImage.leadingAnchor,
                                                  constant: GlobalConstants.smallPadding),
                heroFavouriteButton.trailingAnchor.constraint(equalTo: heroImage.trailingAnchor,
                                                              constant: -GlobalConstants.smallPadding),
                heroFavouriteButton.topAnchor.constraint(equalTo: heroImage.topAnchor,
                                                         constant: GlobalConstants.smallPadding),
            ])
        } else if type == .TableView {
            NSLayoutConstraint.activate([
                heroImage.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                   constant: GlobalConstants.mediumPadding),
                heroImage.heightAnchor.constraint(equalToConstant: GlobalConstants.tableViewImageHeight),
                heroName.leadingAnchor.constraint(equalTo: heroImage.trailingAnchor,
                                                  constant: GlobalConstants.smallPadding),
                heroName.centerYAnchor.constraint(equalTo: heroImage.centerYAnchor),
                heroFavouriteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                              constant: -GlobalConstants.mediumPadding),
                heroFavouriteButton.centerYAnchor.constraint(equalTo: heroImage.centerYAnchor),
            ])
        }
    }
}


private extension UIImageView {
    func addOverlay(color: UIColor = .black, alpha : CGFloat = 0.6) {
        let overlay = UIView()
        overlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        overlay.frame = bounds
        overlay.backgroundColor = color
        overlay.alpha = alpha
        addSubview(overlay)
    }
}
