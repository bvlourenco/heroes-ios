//
//  HeroesGridHeader.swift
//  Heroes
//
//  Created by Bernardo Vala Lourenço on 30/11/2023.
//

import UIKit

class HeroesGridHeader: UICollectionReusableView {
    
    private enum HeaderConstants {
        static let headerFontSize: CGFloat = 16
    }
    
    private (set) var title: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: HeaderConstants.headerFontSize)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    
    init() {
        super.init(frame: CGRectZero)
        self.backgroundColor = UIColor.systemGray6
        setupHeader()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupHeader() {
        addSubview(title)
        
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: self.topAnchor),
            title.leadingAnchor.constraint(equalTo: self.leadingAnchor,
                                           constant: Constants.mediumPadding),
            title.trailingAnchor.constraint(equalTo: self.trailingAnchor,
                                            constant: -Constants.mediumPadding),
            title.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
}
