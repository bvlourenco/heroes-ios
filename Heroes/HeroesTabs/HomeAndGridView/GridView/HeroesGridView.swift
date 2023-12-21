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
    
    private let collectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: GridPadding.topPadding,
                                           left: GridPadding.leftPadding,
                                           bottom: GridPadding.bottomPadding,
                                           right: GridPadding.rightPadding)
        
        let collectionView = UICollectionView(frame: CGRectZero,
                                              collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .black
        
        return collectionView
    }()
    
    init() {
        super.init(frame: CGRectZero)
        backgroundColor = .black
        addSubview(collectionView)
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
    
    private func configureCollectionView() {
        collectionView.register(HeroesGridViewCell.self, 
                                forCellWithReuseIdentifier: Constants.cellIdentifier)
        collectionView.register(HeroesGridFooter.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                withReuseIdentifier: Constants.footerIdentifier)
    }
    
    func updateLayout() {
        collectionView.collectionViewLayout.invalidateLayout()
    }
}
