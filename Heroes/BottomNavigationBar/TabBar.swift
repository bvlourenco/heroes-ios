//
//  TabBar.swift
//  Heroes
//
//  Created by Bernardo Vala Lourenço on 15/12/2023.
//

import UIKit

class TabBar: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        UITabBar.appearance().barTintColor = .systemBackground
        tabBar.tintColor = .label
        setupVCs()
    }
    
    func setupVCs() {
        let heroesViewModel = HeroesViewModel(heroService: HeroService())
        viewControllers = [
            createNavController(for: HeroesTableViewController(heroesViewModel: heroesViewModel),
                                title: "Search",
                                image: UIImage(systemName: "magnifyingglass")!),
            createNavController(for: HeroesTableViewController(heroesViewModel: heroesViewModel),
                                title: "Home",
                                image: UIImage(systemName: "house")!),
            createNavController(for: HeroesTableViewController(heroesViewModel: heroesViewModel),
                                title: "Favourites",
                                image: UIImage(systemName: "star")!),
//            createNavController(for: HeroesGridViewController(heroesViewModel: heroesViewModel),
//                                title: "Grid View",
//                                image: UIImage(systemName: "square.grid.2x2")!)
        ]
    }
    
    fileprivate func createNavController(for rootViewController: UIViewController,
                                         title: String,
                                         image: UIImage) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        navController.navigationBar.prefersLargeTitles = true
        rootViewController.navigationItem.title = title
        return navController
    }
}
