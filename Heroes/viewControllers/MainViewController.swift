//
//  ViewController.swift
//  Heroes
//
//  Created by Bernardo Vala Lourenço on 24/10/2023.
//

import UIKit

class MainViewController: UIViewController {
    private var heroes: [Hero] = [] {
        didSet {
            if isViewLoaded {
                customView.tableView.reloadData()
            }
        }
    }
    private let heroService = HeroService()
    lazy var customView = CustomView()
    
    override func loadView() {
        customView.tableView.delegate = self
        customView.tableView.dataSource = self
        view = customView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchHeroes(offset: 0)
    }
    
    private func fetchHeroes(offset: Int) {
        Task {
            do {
                self.heroes.append(contentsOf: try await self.heroService
                    .getHeroes(offset: offset))
            } catch {
                print(error)
            }
        }
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return self.heroes.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",
                                                 for: indexPath)
        
        // Since we are reusing cells, this instruction will remove the image
        // associated to the reusable cell.
        cell.imageView?.image = UIImage(named: "placeholder")
        cell.textLabel?.text = self.heroes[indexPath.row].name
        
        // If imageURL points to a not available image, use a placeholder
        if self.heroes[indexPath.row].imageURL
            .hasSuffix("image_not_available.jpg") == false {
            // Source: https://stackoverflow.com/a/52416497
            ImageCache.imageForUrl(urlString:
                                    self.heroes[indexPath.row].imageURL,
                                   completionHandler: {
                (image, url, isNotLoaded) in
                if image != nil {
                    cell.imageView!.alpha = 0
                    cell.imageView?.image = image
                    UIView.animate(withDuration: 1,
                                   delay: 0,
                                   options: UIView.AnimationOptions
                        .showHideTransitionViews,
                                   animations: { () -> Void in
                        cell.imageView!.alpha = 1 }
                    )
                }
            })
        }
        
        return cell
    }
    
    // From: https://stackoverflow.com/a/42457571
    func tableView(_ tableView: UITableView,
                   willDisplay cell: UITableViewCell,
                   forRowAt indexPath: IndexPath) {
        let lastSectionIndex = tableView.numberOfSections - 1
        let lastRowIndex = tableView.numberOfRows(inSection:
                                                    lastSectionIndex) - 1
        if indexPath.section == lastSectionIndex
            && indexPath.row == lastRowIndex {
            let spinner = UIActivityIndicatorView(style: .medium)
            spinner.startAnimating()
            spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0),
                                   width: tableView.bounds.width,
                                   height: CGFloat(44))
            
            customView.tableView.tableFooterView = spinner
            customView.tableView.tableFooterView?.isHidden = false
            
            fetchHeroes(offset: self.heroes.count)
        } else {
            customView.tableView.tableFooterView?.isHidden = true
            customView.tableView.tableFooterView = nil
        }
    }
}
