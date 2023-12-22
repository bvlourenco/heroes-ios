//
//  HeroesGridView.swift
//  Heroes
//
//  Created by Bernardo Vala Lourenço on 21/11/2023.
//

import UIKit

class GridView: UIView {
    
    private enum GridPadding {
        static let topPadding: CGFloat = 10
        static let leftPadding: CGFloat = 10
        static let bottomPadding: CGFloat = 10
        static let rightPadding: CGFloat = 10
    }
    
    var collectionView: UICollectionView
    
    init(scrollDirection: UICollectionView.ScrollDirection = .vertical) {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = scrollDirection
        layout.sectionInset = UIEdgeInsets(top: GridPadding.topPadding,
                                           left: GridPadding.leftPadding,
                                           bottom: GridPadding.bottomPadding,
                                           right: GridPadding.rightPadding)
        
        collectionView = UICollectionView(frame: CGRectZero,
                                          collectionViewLayout: layout)
        collectionView.register(HeroesGridViewCell.self,
                                forCellWithReuseIdentifier: Constants.cellIdentifier)
        collectionView.register(HomeFooter.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                withReuseIdentifier: Constants.footerIdentifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .black
        
        super.init(frame: CGRectZero)
        backgroundColor = .black
        addSubview(collectionView)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setGridDataSourceAndDelegate(viewController: HomeViewController) {
        collectionView.delegate = viewController
        collectionView.dataSource = viewController
    }
    
    func setGridDataSourceAndDelegate(viewController: HeroDetailViewController) {
        collectionView.delegate = viewController
        collectionView.dataSource = viewController
    }
    
    func update() {
        collectionView.reloadData()
        isSpinnerHidden(to: true)
    }
    
    func isSpinnerHidden(to value: Bool) {
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func updateLayout() {
        collectionView.collectionViewLayout.invalidateLayout()
    }
}
