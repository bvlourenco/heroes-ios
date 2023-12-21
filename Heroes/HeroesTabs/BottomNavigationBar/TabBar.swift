//
//  TabBar.swift
//  Heroes
//
//  Created by Bernardo Vala Lourenço on 15/12/2023.
//

import UIKit

class TabBar: UITabBarController {
    
    private enum TabConstants {
        static let searchTitle = "Search"
        static let searchIconName = "magnifyingglass"
        static let homeTitle = "Home"
        static let homeIconName = "house"
        static let favouritesTitle = "Favourites"
        static let favouritesIconName = "star"
        static let listViewTitle = "List View"
        static let listViewIconName = "list.bullet"
    }
    
    private let heroService: HeroServiceProtocol
    
    init(heroService: HeroServiceProtocol) {
        self.heroService = heroService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        UITabBar.appearance().barTintColor = .black
        tabBar.tintColor = .white
        tabBar.unselectedItemTintColor = .lightGray
        delegate = self
        createTabBarViewControllers()
    }
    
    func createTabBarViewControllers() {
        let heroesViewModel = HeroesViewModel(heroService: heroService)
        let searchViewModel = HeroesViewModel(heroService: heroService)
        let favouritesViewModel = FavouritesViewModel()
        viewControllers = [
            createNavigationController(for: SearchViewController(searchViewModel: searchViewModel,
                                                                 favouritesViewModel: favouritesViewModel),
                                       title: TabConstants.searchTitle,
                                       image: UIImage(systemName: TabConstants.searchIconName)!),
            createNavigationController(for: HomeViewController(heroesViewModel: heroesViewModel,
                                                               favouritesViewModel: favouritesViewModel),
                                       title: TabConstants.homeTitle,
                                       image: UIImage(systemName: TabConstants.homeIconName)!),
            createNavigationController(for: FavouritesViewController(favouritesViewModel: favouritesViewModel,
                                                                     heroService: heroService),
                                       title: TabConstants.favouritesTitle,
                                       image: UIImage(systemName: TabConstants.favouritesIconName)!),
            createNavigationController(for: ListViewController(heroesViewModel: heroesViewModel,
                                                               favouritesViewModel: favouritesViewModel),
                                       title: TabConstants.listViewTitle,
                                       image: UIImage(systemName: TabConstants.listViewIconName)!)
        ]
    }
    
    private func createNavigationController(for rootViewController: UIViewController,
                                            title: String,
                                            image: UIImage) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = image
        navController.navigationBar.prefersLargeTitles = true
        navController.navigationBar.barStyle = .black
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
                              duration: Constants.animationDuration,
                              options: .transitionCrossDissolve,
                              completion: nil)
        }
        
        return true
    }
}
