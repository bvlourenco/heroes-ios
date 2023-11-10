//
//  ViewController.swift
//  Heroes
//
//  Created by Bernardo Vala Lourenço on 24/10/2023.
//

import UIKit

class HeroesTableViewController: UIViewController {
    //    private let heroesViewModel: HeroesViewModel
    //    private let loader: ImageLoader = ImageLoader()
    private lazy var heroesTableView = HeroesTableView()
    
    init(heroesViewModel: HeroesViewModel) {
        //self.heroesViewModel = heroesViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
    //        // delegate and dataSource in init/viewDidLoad
    //        // this func only should have view = ...
    //        heroesTableView.tableView.delegate = self
    //        heroesTableView.tableView.dataSource = self
              view = heroesTableView
    //        navigationItem.title = "All heroes"
    //        // TODO: reference cycle. Put weak self
    //        // So depois do viewDidLoad should be loaded
    //        heroesViewModel.fetchHeroes(addHeroesToTableView: { [weak self] in
    //            self?.addHeroesToTableView()
    //        })
    }
    
    deinit {
        print("Goodbye!")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    private func addHeroesToTableView() {
//        print(#function, self)
//        var beginIndex = 0
//        let numberOfHeroes = heroesViewModel.numberOfHeroes()
//        if numberOfHeroes >= Constants.numberOfHeroesPerRequest {
//            beginIndex = numberOfHeroes - Constants.numberOfHeroesPerRequest
//        }
//        let indexPaths = (beginIndex..<numberOfHeroes)
//                            .map { IndexPath(row: $0, section: 0) }
//        heroesTableView.tableView.beginUpdates()
//        heroesTableView.tableView.tableFooterView?.isHidden = true
//        heroesTableView.tableView.insertRows(at: indexPaths, with: .none)
//        heroesTableView.tableView.endUpdates()
//        heroesViewModel.changeLoadingDataStatus(status: false)
//    }
//}
//
//extension HeroesTableViewController: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView,
//                   numberOfRowsInSection section: Int) -> Int {
//        return heroesViewModel.numberOfHeroes()
//    }
//    
//    func tableView(_ tableView: UITableView,
//                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        
//        let numberOfHeroes = heroesViewModel.numberOfHeroes()
//        if indexPath.row >= numberOfHeroes {
//            return UITableViewCell()
//        }
//        
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",
//                                                 for: indexPath) as! HeroesTableViewCell
//        let hero = heroesViewModel.getHeroAtIndex(index: indexPath.row)
//        
//        let imageURL = hero.thumbnail?.imageURL
//        
//        if let imageURL = imageURL {
//            if imageURL.absoluteString.hasSuffix(Constants.notAvailableImageName) == false {
//                cell.heroImage.loadImage(at: imageURL)
//            } else {
//                cell.heroImage.image = UIImage(named: "placeholder")
//            }
//        } else {
//            cell.heroImage.image = UIImage(named: "placeholder")
//        }
//        
//        cell.heroName.text = hero.name
//        
//        return cell
//    }
//    
//    func tableView(_ tableView: UITableView,
//                   didSelectRowAt indexPath: IndexPath) {
//        
//        let numberOfHeroes = heroesViewModel.numberOfHeroes()
//        if indexPath.row >= numberOfHeroes {
//            return
//        }
//        
//        tableView.deselectRow(at: indexPath, animated: true)
//        
//        let destination = HeroViewController(heroIndex: indexPath.row,
//                                             heroViewModel: heroesViewModel,
//                                             loader: loader)
//        navigationController?.pushViewController(destination, animated: true)
//    }
//    
//    // From: https://stackoverflow.com/a/42457571
//    func tableView(_ tableView: UITableView,
//                   willDisplay cell: UITableViewCell,
//                   forRowAt indexPath: IndexPath) {
//        
//        let numberOfHeroes = heroesViewModel.numberOfHeroes()
//        if numberOfHeroes < Constants.numberOfHeroesPerRequest {
//            return
//        }
//        
//        let lastRowIndex = tableView.numberOfRows(inSection: 0) - 1
//        let batchMiddleRowIndex = Constants.numberOfHeroesPerRequest / 2
//        let rowIndexLoadMoreHeroes = lastRowIndex - batchMiddleRowIndex
//        if heroesViewModel.isLoadingData() == false
//            && indexPath.row >= rowIndexLoadMoreHeroes {
//            heroesTableView.tableView.tableFooterView?.isHidden = false
//            heroesViewModel.changeLoadingDataStatus(status: true)
//            heroesViewModel.fetchHeroes(addHeroesToTableView: { [weak self] in
//                self?.addHeroesToTableView()
//            })
//        }
//    }
//    
//    func tableView(_ tableView: UITableView, 
//                   heightForRowAt indexPath: IndexPath) -> CGFloat {
//        
//        let numberOfHeroes = heroesViewModel.numberOfHeroes()
//        if indexPath.row >= numberOfHeroes {
//            return 0
//        }
//        
//        return Constants.tableViewImageHeight
//    }
//}
