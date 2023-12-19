    //
//  HeroesGridViewController.swift
//  Heroes
//
//  Created by Bernardo Vala Lourenço on 21/11/2023.
//

import Combine
import UIKit

class HeroesGridViewController: HeroesViewController, ViewControllerDelegate {
    
    private enum GridConstants {
        static let leftPadding: CGFloat = 10
        static let rightPadding: CGFloat = 10
        static let cellHeight: CGFloat = 240
        static let headingHeight: CGFloat = 30
        static let footerIdentifier = "footer"
        static let headerIdentifier = "header"
    }
    
    private let heroesGridView = HeroesGridView()
    
    override init(heroesViewModel: HeroesViewModel,
                  favouritesViewModel: FavouritesViewModel,
                  firstInitialization: Bool = true) {
        super.init(heroesViewModel: heroesViewModel, 
                   favouritesViewModel: favouritesViewModel,
                   firstInitialization: firstInitialization)
        super.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = heroesGridView
    }
    
    override func viewDidLoad() {
        heroesGridView.setGridDataSourceAndDelegate(viewController: self)
        super.viewDidLoad()
    }
    
    func addHeroesToView() {
        reloadView()
        super.updateLoading(to: false)
    }
    
    func reloadView() {
        heroesGridView.update()
    }
    
    func spinnerHidden(to value: Bool) {
        heroesGridView.isSpinnerHidden(to: value)
    }
}

extension HeroesGridViewController: UICollectionViewDataSource, UICollectionViewDelegate,
                                        UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return super.getNumberOfItems()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.cellIdentifier,
                                                      for: indexPath) as! HeroesGridViewCell
        let hero = super.heroesViewModel.getHero(index: indexPath.row)
        
        cell.configure(imageURL: hero.thumbnail?.imageURL, name: hero.name)
        cell.storeHero = { aCell in
            try super.persistHero(hero: hero)
//            guard let destinationIndex else { return }
//            guard let actualIndexPath = collectionView.indexPath(for: aCell) else { return }
//            collectionView.moveItem(at: actualIndexPath, to: IndexPath(row: destinationIndex, section: 0))
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        super.itemSelected(indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        let lastRowIndex = collectionView.numberOfItems(inSection: 0) - 1
        super.willFetchMoreHeroes(indexPath: indexPath, lastRowIndex: lastRowIndex)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellHeight: CGFloat = GridConstants.cellHeight
        
        let cellWidth = collectionView.frame.width / 2 - (
                GridConstants.leftPadding +
                GridConstants.rightPadding)
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionFooter:
            return collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                   withReuseIdentifier: GridConstants.footerIdentifier,
                                                                   for: indexPath) as! HeroesGridFooter
        default:
            assert(false, "Unexpected kind in collectionView")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: Constants.spinnerHeight)
    }
}
