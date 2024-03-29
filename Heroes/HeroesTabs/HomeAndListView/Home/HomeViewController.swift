//
//  HeroesGridViewController.swift
//  Heroes
//
//  Created by Bernardo Vala Lourenço on 21/11/2023.
//

import Combine
import UIKit

class HomeViewController: HeroesViewController, ViewControllerDelegate {
    private let gridView = GridView()
    
    override init(heroesViewModel: HeroesViewModel,
                  favouritesViewModel: FavouritesViewModel) {
        super.init(heroesViewModel: heroesViewModel, 
                   favouritesViewModel: favouritesViewModel)
        super.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = gridView
    }
    
    override func viewDidLoad() {
        gridView.setGridDataSourceAndDelegate(viewController: self)
        super.viewDidLoad()
    }
    
    func addHeroesToView() {
        reloadView()
        super.updateLoading(to: false)
    }
    
    func reloadView() {
        gridView.update()
    }
    
    func spinnerHidden(to value: Bool) {
        gridView.isSpinnerHidden(to: value)
    }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate,
                                UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return super.getNumberOfItems()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GlobalConstants.cellIdentifier,
                                                      for: indexPath) as! HeroesGridViewCell
        let hero = super.heroesViewModel.getHero(index: indexPath.row)
        
        cell.configure(imageURL: hero.thumbnail?.imageURL, name: hero.name)
        cell.storeHero = {
            try super.changeHeroPersistanceStatus(hero: hero)
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
        let cellHeight: CGFloat = UIDevice.current.orientation.isLandscape ? GridConstants.cellHeightLandscape :
                                                                             GridConstants.cellHeight
        let cellWidthPortrait = collectionView.frame.width / 2 - (GridConstants.leftPadding + GridConstants.rightPadding)
        let cellWidth = UIDevice.current.orientation.isLandscape ? GridConstants.cellWidthLandscape : cellWidthPortrait
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        gridView.updateLayout()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionFooter:
            return collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                   withReuseIdentifier: GridConstants.footerIdentifier,
                                                                   for: indexPath) as! HomeFooter
        default:
            assert(false, "Unexpected kind in collectionView")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: GlobalConstants.spinnerHeight)
    }
}
