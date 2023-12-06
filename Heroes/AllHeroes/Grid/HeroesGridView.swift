//
//  HeroesGridView.swift
//  Heroes
//
//  Created by Bernardo Vala Lourenço on 21/11/2023.
//

import UIKit

class HeroesGridView: UIView {
    
    private enum GridPadding {
        static let topPadding: CGFloat = 10
        static let leftPadding: CGFloat = 10
        static let bottomPadding: CGFloat = 10
        static let rightPadding: CGFloat = 10
    }
    
    private let collectionView: UICollectionView
    
    override init(frame: CGRect) {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: GridPadding.topPadding,
                                           left: GridPadding.leftPadding,
                                           bottom: GridPadding.bottomPadding,
                                           right: GridPadding.rightPadding)
        
        collectionView = UICollectionView(frame: frame,
                                          collectionViewLayout: layout)
        super.init(frame: frame)
        configureCollectionView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setGridDataSourceAndDelegate(viewController: HeroesGridViewController) {
        collectionView.delegate = viewController
        collectionView.dataSource = viewController
    }
    
    func update() {
        collectionView.reloadData()
    }
    
    private func setupConstraints() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: self.topAnchor),
            collectionView.leftAnchor.constraint(equalTo: self.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: self.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    private func configureCollectionView() {
        collectionView.register(HeroesGridViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(LoadingGridViewCell.self, forCellWithReuseIdentifier: "loadingCell")
        collectionView.register(HeroesGridFooter.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                withReuseIdentifier: "footer")
        collectionView.register(HeroesGridHeader.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: "header")
        collectionView.backgroundColor = UIColor.white
        
        addSubview(collectionView)
    }
}
