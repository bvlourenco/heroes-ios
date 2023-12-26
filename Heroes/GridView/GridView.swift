//
//  HeroesGridView.swift
//  Heroes
//
//  Created by Bernardo Vala Lourenço on 21/11/2023.
//

import UIKit

class GridView: UIView {
    
    private enum Constants {
        static let topPadding: CGFloat = 10
        static let leftPadding: CGFloat = 10
        static let bottomPadding: CGFloat = 10
        static let rightPadding: CGFloat = 10
    }
    
    private let scrollDirection: UICollectionView.ScrollDirection
    private lazy var collectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = self.scrollDirection
        layout.sectionInset = UIEdgeInsets(top: Constants.topPadding,
                                           left: Constants.leftPadding,
                                           bottom: Constants.bottomPadding,
                                           right: Constants.rightPadding)
        collectionView = UICollectionView(frame: CGRectZero,
                                          collectionViewLayout: layout)
        
        collectionView.register(HeroesGridViewCell.self,
                                forCellWithReuseIdentifier: GlobalConstants.cellIdentifier)
        collectionView.register(HomeFooter.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                withReuseIdentifier: GlobalConstants.footerIdentifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .black
        return collectionView
    }()
    
    init(scrollDirection: UICollectionView.ScrollDirection = .vertical) {
        self.scrollDirection = scrollDirection
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
    
    func getCollectionView() -> UICollectionView {
        return collectionView
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
