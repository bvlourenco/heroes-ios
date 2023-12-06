//
//  AllHeroesViewController.swift
//  Heroes
//
//  Created by Bernardo Vala Lourenço on 21/11/2023.
//

import UIKit

class AllHeroesViewController: UIViewController, UINavigationControllerDelegate {
    private let heroesViewModel: HeroesViewModel
    private let loader: ImageLoader = ImageLoader()
    private let spinner: UIActivityIndicatorView
    private var isLoadingData: Bool = false
    private let transition = Transition()
    
    init(heroesViewModel: HeroesViewModel) {
        self.heroesViewModel = heroesViewModel
        self.spinner = UIActivityIndicatorView(style: .medium)
        self.spinner.startAnimating()
        self.spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0),
                                    width: UIScreen.main.bounds.width,
                                    height: CGFloat(Constants.spinnerHeight))
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "All heroes"
        navigationController?.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func navigationController(_ navigationController: UINavigationController,
                              animationControllerFor operation: UINavigationController.Operation,
                              from fromVC: UIViewController,
                              to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch operation {
        case .push:
            return transition
        case .pop:
            return nil
        default:
            return nil
        }
        
    }
    
    func getSpinner() -> UIActivityIndicatorView {
        return spinner
    }
    
    func updateLoading(to value: Bool) {
        self.isLoadingData = value
    }
    
    func getLoader() -> ImageLoader {
        return loader
    }
    
    func loadingStatus() -> Bool {
        return self.isLoadingData
    }
}
