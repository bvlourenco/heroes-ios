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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(heroImage)
        contentView.addSubview(heroName)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        heroImage.image = nil
        heroImage.cancelImageLoad()
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
    }
    
    func setName(name: String?) {
        heroName.text = name
    }
    
    private func setupConstraints() {
        heroImage.translatesAutoresizingMaskIntoConstraints = false
        heroName.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            heroImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                               constant: Constants.mediumPadding),
            heroImage.heightAnchor.constraint(equalToConstant: Constants.tableViewImageHeight),
            heroImage.widthAnchor.constraint(equalTo: heroImage.heightAnchor),
            heroImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            heroName.leadingAnchor.constraint(equalTo: heroImage.trailingAnchor,
                                              constant: Constants.smallPadding),
            heroName.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
