//
//  HeroesTableViewCell.swift
//  Heroes
//
//  Created by Bernardo Vala Lourenço on 03/11/2023.
//

import UIKit

class HeroesTableViewCell: UITableViewCell, CellDelegate {
    private let allHeroesCell = HeroesCell()
    var storeHero: (() throws -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .black
        allHeroesCell.delegate = self
        allHeroesCell.addViews(view: contentView)
        allHeroesCell.setupConstraints(view: contentView, type: ViewType.TableView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        allHeroesCell.prepareCellForReuse()
    }
    
    func configure(imageURL: URL?, name: String?) {
        allHeroesCell.configure(imageURL: imageURL, name: name)
    }
    
    func favouriteHero() throws {
        try storeHero?()
    }
}
