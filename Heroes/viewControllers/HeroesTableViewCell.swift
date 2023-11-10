//
//  HeroesTableViewCell.swift
//  Heroes
//
//  Created by Bernardo Vala Lourenço on 03/11/2023.
//

import UIKit

class HeroesTableViewCell: UITableViewCell {
    
    let heroName = UILabel()
    let heroImage = UIImageView()
    var onReuse: () -> Void = {}
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(heroImage)
        contentView.addSubview(heroName)
        
        setupConstraints()
    }
    
    override func prepareForReuse() {
        heroImage.image = nil
        heroImage.cancelImageLoad()
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
