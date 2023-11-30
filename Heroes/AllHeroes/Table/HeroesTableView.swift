//
//  CustomView.swift
//  Heroes
//
//  Created by Bernardo Vala Lourenço on 25/10/2023.
//

import UIKit

class HeroesTableView: UIView {
    private let tableView: UITableView = {
        let tableView = UITableView(frame: CGRectZero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(HeroesTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(LoadingTableViewCell.self, forCellReuseIdentifier: "loading")
        
        // Assigning rowHeight property since a table view row initially does not have
        // the image (because of loading) and so, estimatedRowHeight would produce a
        // warning about suggesting a row height of 0
        tableView.rowHeight = Constants.tableViewImageHeight
        
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(tableView)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTableDataSourceAndDelegate(viewController: HeroesTableViewController) {
        tableView.delegate = viewController
        tableView.dataSource = viewController
    }
    
    func update() {
        tableView.reloadData()
        tableView.tableFooterView?.isHidden = true
    }
    
    func addSpinnerToBottom(spinner: UIActivityIndicatorView) {
        tableView.tableFooterView = spinner
        tableView.tableFooterView?.isHidden = false
    }
    
    func isSpinnerHidden(to status: Bool) {
        tableView.tableFooterView?.isHidden = status
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.topAnchor),
            tableView.leftAnchor.constraint(equalTo: self.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: self.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}
