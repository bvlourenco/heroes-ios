//
//  HeroesGridViewCell.swift
//  Heroes
//
//  Created by Bernardo Vala Lourenço on 21/11/2023.
//

import UIKit

class HeroesGridViewCell: UICollectionViewCell, CellDelegate {
    private let allHeroesCell = HeroesCell()
    var storeHero: (() throws -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black
        allHeroesCell.delegate = self
        allHeroesCell.addViews(view: contentView)
        allHeroesCell.setupConstraints(view: contentView, type: ViewType.GridView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        allHeroesCell.prepareCellForReuse()
    }
    
    func configure(imageURL: URL?, name: String?, hideFavouriteButton: Bool = false) {
        allHeroesCell.configure(imageURL: imageURL, name: name, hideFavouriteButton: hideFavouriteButton)
    }
    
    func favouriteHero() throws {
        try storeHero?()
    }
}
