//
//  FavouritesView.swift
//  Heroes
//
//  Created by Bernardo Vala Lourenço on 18/12/2023.
//

import UIKit

class FavouritesView: UIView {
    private let favourites: HeroesTableView = {
        let heroesTableView = HeroesTableView(spinnerHidden: true)
        heroesTableView.translatesAutoresizingMaskIntoConstraints = false
        return heroesTableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(favourites)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            favourites.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            favourites.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            favourites.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            favourites.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    func setDataSourceAndDelegate(viewController: FavouritesViewController) {
        favourites.setTableDataSourceAndDelegate(viewController: viewController)
    }
}
