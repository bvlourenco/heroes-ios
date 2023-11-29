//
//  HeroesGridViewController.swift
//  Heroes
//
//  Created by Bernardo Vala Lourenço on 21/11/2023.
//

import UIKit

class HeroesGridViewController: AllHeroesViewController {
    
    private enum CollectionViewConstants {
        static let leftPadding: CGFloat = 10
        static let rightPadding: CGFloat = 10
        static let cellHeight: CGFloat = 250
    }
    
    private let heroesGridView = HeroesGridView()
    private let heroesViewModel: HeroesViewModel
    
    override init(heroesViewModel: HeroesViewModel) {
        self.heroesViewModel = heroesViewModel
        super.init(heroesViewModel: heroesViewModel)
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
        
        heroesViewModel.fetchHeroes(searchQuery: nil) { [weak self] numberOfNewHeroes in
            self?.addHeroesToGridView(numberOfNewHeroes: numberOfNewHeroes)
        }
        
        var image = UIImage(named: "icons8-list-50")
        image = image?.imageWith(newSize: CGSize(width: Constants.iconWidthSize,
                                                 height: Constants.iconHeightSize))
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: image,
                                                                 style: .plain,
                                                                 target: self,
                                                                 action: #selector(changeViewController))
    }
    
    @objc
    func changeViewController(sender: UIBarButtonItem) {
        let viewControllers = [HeroesTableViewController(heroesViewModel: heroesViewModel)]
        self.navigationController?.setViewControllers(viewControllers, animated: true)
    }
    
    private func addHeroesToGridView(numberOfNewHeroes: Int) {
        var beginIndex = 0
        
        let numberOfHeroes = heroesViewModel.numberOfHeroes()
        if numberOfHeroes >= Constants.numberOfHeroesPerRequest {
            beginIndex = numberOfHeroes - numberOfNewHeroes
        }
        let indexPaths = (beginIndex..<numberOfHeroes)
            .map { IndexPath(row: $0, section: 0) }
        heroesGridView.update(indexPaths: indexPaths)
        super.updateLoading(to: false)
    }
}

extension HeroesGridViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return heroesViewModel.numberOfHeroes()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let numberOfHeroes = heroesViewModel.numberOfHeroes()
        if indexPath.row >= numberOfHeroes {
            return UICollectionViewCell()
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell",
                                                      for: indexPath) as! HeroesGridViewCell
        
        let hero = heroesViewModel.getHeroAtIndex(index: indexPath.row)
        
        cell.loadImage(imageURL: hero.thumbnail?.imageURL)
        cell.setName(name: hero.name)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let numberOfHeroes = heroesViewModel.numberOfHeroes()
        if indexPath.row >= numberOfHeroes {
            return
        }
        
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let hero = heroesViewModel.getHeroAtIndex(index: indexPath.row)
        let heroDetailViewModel = HeroDetailViewModel(heroService: heroesViewModel.heroService, hero: hero)
        
        let destination = HeroDetailViewController(hero: hero,
                                                   heroIndex: indexPath.row,
                                                   heroDetailViewModel: heroDetailViewModel,
                                                   loader: super.getLoader())
        destination.delegate = self
        navigationController?.pushViewController(destination, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        let numberOfHeroes = heroesViewModel.numberOfHeroes()
        if numberOfHeroes < Constants.numberOfHeroesPerRequest {
            return
        }
        
        let lastRowIndex = max(0, collectionView.numberOfItems(inSection: 0) - 1)
        let batchMiddleRowIndex = Constants.numberOfHeroesPerRequest / 2
        let rowIndexLoadMoreHeroes = lastRowIndex - batchMiddleRowIndex
        if super.loadingStatus() == false && indexPath.row >= rowIndexLoadMoreHeroes {
            super.updateLoading(to: true)
            heroesViewModel.fetchHeroes(searchQuery: nil) { [weak self] numberOfNewHeroes in
                self?.addHeroesToGridView(numberOfNewHeroes: numberOfNewHeroes)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellHeight: CGFloat = CollectionViewConstants.cellHeight
        
        let cellWidth = collectionView.frame.width / 2 - (
                        CollectionViewConstants.leftPadding +
                        CollectionViewConstants.rightPadding)
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionFooter:
            return collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                   withReuseIdentifier: "footer",
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
