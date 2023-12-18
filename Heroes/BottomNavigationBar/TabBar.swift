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
        delegate = self
        createTabBarViewControllers()
    }
    
    func createTabBarViewControllers() {
        let heroService = HeroService()
        let heroesViewModel = HeroesViewModel(heroService: heroService)
        let searchViewModel = HeroesViewModel(heroService: heroService)
        let favouritesViewModel = FavouritesViewModel()
        viewControllers = [
            createNavController(for: SearchViewController(searchViewModel: searchViewModel,
                                                          favouritesViewModel: favouritesViewModel),
                                title: "Search",
                                image: UIImage(systemName: "magnifyingglass")!),
            createNavController(for: HeroesTableViewController(heroesViewModel: heroesViewModel,
                                                               favouritesViewModel: favouritesViewModel),
                                title: "Home",
                                image: UIImage(systemName: "house")!),
            createNavController(for: FavouritesViewController(favouritesViewModel: favouritesViewModel,
                                                              heroService: heroService),
                                title: "Favourites",
                                image: UIImage(systemName: "star")!),
            createNavController(for: HeroesGridViewController(heroesViewModel: heroesViewModel,
                                                              favouritesViewModel: favouritesViewModel),
                                title: "Grid View",
                                image: UIImage(systemName: "square.grid.2x2")!)
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

// From: https://stackoverflow.com/questions/44346280/how-to-animate-tab-bar-tab-switch-with-a-crossdissolve-slide-transition
extension TabBar: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard let fromView = selectedViewController?.view, let toView = viewController.view else {
            return false
        }
        
        if fromView != toView {
            UIView.transition(from: fromView,
                              to: toView,
                              duration: 0.3,
                              options: .transitionCrossDissolve,
                              completion: nil)
        }
        
        return true
    }
}
