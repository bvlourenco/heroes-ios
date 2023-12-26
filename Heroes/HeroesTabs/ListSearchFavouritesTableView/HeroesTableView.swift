//
//  HeroesTableView.swift
//  Heroes
//
//  Created by Bernardo Vala Lourenço on 25/10/2023.
//

import UIKit

class HeroesTableView: UIView {
    private let tableView: UITableView = {
        let tableView = UITableView(frame: CGRectZero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(HeroesTableViewCell.self, forCellReuseIdentifier: GlobalConstants.cellIdentifier)
        tableView.backgroundColor = .black
        
        // Assigning rowHeight property since a table view row initially does not have
        // the image (because of loading) and so, estimatedRowHeight would produce a
        // warning about suggesting a row height of 0
        tableView.rowHeight = GlobalConstants.tableViewImageHeight + GlobalConstants.smallPadding
        
        return tableView
    }()
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.color = .white
        spinner.startAnimating()
        return spinner
    }()
    
    init(spinnerHidden value: Bool) {
        super.init(frame: CGRectZero)
        backgroundColor = .black
        addSubview(tableView)
        setupConstraints()
        addSpinnerToBottom(spinnerHidden: value)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTableDataSourceAndDelegate(viewController: ListViewController) {
        tableView.delegate = viewController
        tableView.dataSource = viewController
    }
    
    func setTableDataSourceAndDelegate(viewController: SearchViewController) {
        tableView.delegate = viewController
        tableView.dataSource = viewController
    }
    
    func setTableDataSourceAndDelegate(viewController: FavouritesViewController) {
        tableView.delegate = viewController
        tableView.dataSource = viewController
    }
    
    func update() {
        tableView.reloadData()
    }
    
    func addSpinnerToBottom(spinnerHidden value: Bool) {
        tableView.tableFooterView = spinner
        tableView.tableFooterView?.isHidden = value
    }
    
    func isSpinnerHidden(to value: Bool) {
        tableView.tableFooterView?.isHidden = value
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
