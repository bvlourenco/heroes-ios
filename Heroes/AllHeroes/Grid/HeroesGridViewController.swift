//
//  HeroesGridViewController.swift
//  Heroes
//
//  Created by Bernardo Vala Lourenço on 21/11/2023.
//

import Combine
import UIKit

class HeroesGridViewController: AllHeroesViewController, ViewDelegate {
    
    private enum CollectionViewConstants {
        static let leftPadding: CGFloat = 10
        static let rightPadding: CGFloat = 10
        static let cellHeight: CGFloat = 240
        static let headingHeight: CGFloat = 30
        static let footerIdentifier = "footer"
        static let headerIdentifier = "header"
    }
    
    private let heroesGridView = HeroesGridView()
    
    override init(heroesViewModel: HeroesViewModel) {
        super.init(heroesViewModel: heroesViewModel)
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
    
    func hideSpinner() {}
    
    func reloadView() {
        heroesGridView.update()
    }
    
    func getTopBarIconImage() -> UIImage? {
        return UIImage(named: "icons8-list-50")
    }
    
    func getViewControllers() -> [UIViewController] {
        return [HeroesTableViewController(heroesViewModel: super.getViewModel())]
    }
}

extension HeroesGridViewController: UICollectionViewDataSource, UICollectionViewDelegate,
                                        UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return super.getNumberOfSections()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return super.getNumberOfItemsInSection(section: section)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if isLoadingCell(section: indexPath.section) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.loadingCellIdentifier,
                                                          for: indexPath) as! LoadingGridViewCell
            cell.animateSpinner()
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.cellIdentifier,
                                                          for: indexPath) as! HeroesGridViewCell
            let hero = super.getHero(indexPath: indexPath)
            
            cell.configure(imageURL: hero.thumbnail?.imageURL, name: hero.name)
            cell.storeHero = { aCell in
                let destinationIndex = try super.persistHero(section: indexPath.section,
                                                             hero: hero)
                if indexPath.section == 0 {
                    self.reloadView()
                } else if destinationIndex >= 0 {
                    guard let actualIndexPath = collectionView.indexPath(for: aCell) else { return }
                    collectionView.moveItem(at: actualIndexPath, to: IndexPath(row: destinationIndex, section: 1))
                }
            }
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        super.itemSelected(indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        let lastRowIndex = collectionView.numberOfItems(inSection: 1) - 1
        super.willFetchMoreHeroes(indexPath: indexPath, lastRowIndex: lastRowIndex)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellHeight: CGFloat = CollectionViewConstants.cellHeight
        
        let cellWidth: CGFloat
        if isLoadingCell(section: indexPath.section) {
            cellWidth = collectionView.frame.width
        } else {
            cellWidth = collectionView.frame.width / 2 - (
                CollectionViewConstants.leftPadding +
                CollectionViewConstants.rightPadding)
        }
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            if isDoingASearch() == false {
                return UICollectionReusableView()
            }
            
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                         withReuseIdentifier: CollectionViewConstants.headerIdentifier,
                                                                         for: indexPath) as! HeroesGridHeader
            header.title.text = super.getSectionTitle(section: indexPath.section)
            return header
        case UICollectionView.elementKindSectionFooter:
            if indexPath.section == 1 {
                return collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                       withReuseIdentifier: CollectionViewConstants.footerIdentifier,
                                                                       for: indexPath) as! HeroesGridFooter
            } else {
                return UICollectionReusableView()
            }
        default:
            assert(false, "Unexpected kind in collectionView")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForFooterInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize(width: 0, height: 0)
        } else {
            return CGSize(width: collectionView.frame.width, height: Constants.spinnerHeight)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        if isDoingASearch() == false {
            return CGSize(width: 0, height: 0)
        } else {
            return CGSize(width: collectionView.frame.width, height: CollectionViewConstants.headingHeight)
        }
    }
}
