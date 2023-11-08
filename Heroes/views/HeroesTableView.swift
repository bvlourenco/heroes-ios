//
//  CustomView.swift
//  Heroes
//
//  Created by Bernardo Vala Lourenço on 25/10/2023.
//

import UIKit

class HeroesTableView: UIView {
    let tableView: UITableView = {
        let tableView = UITableView(frame: CGRectZero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(HeroesTableViewCell.self, forCellReuseIdentifier: "cell")
        
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.startAnimating()
        spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0),
                               width: tableView.bounds.width,
                               height: CGFloat(Constants.spinnerHeight))
        tableView.tableFooterView = spinner
        tableView.tableFooterView?.isHidden = false
        
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
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.topAnchor),
            tableView.leftAnchor.constraint(equalTo: self.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: self.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}
