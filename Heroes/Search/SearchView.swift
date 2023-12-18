//
//  SearchView.swift
//  Heroes
//
//  Created by Bernardo Vala Lourenço on 18/12/2023.
//

import UIKit

class SearchView: UIView {
    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.showsCancelButton = true
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.backgroundImage = UIImage()
        searchBar.placeholder = "Search for heroes"
        return searchBar
    }()
    
    let results: HeroesTableView = {
        let heroesTableView = HeroesTableView()
        heroesTableView.translatesAutoresizingMaskIntoConstraints = false
        return heroesTableView
    }()
    
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.startAnimating()
        spinner.isHidden = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(stackView)
        stackView.addArrangedSubview(searchBar)
        stackView.addArrangedSubview(spinner)
        stackView.addArrangedSubview(results)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setSearchDelegate(viewController: SearchViewController) {
        searchBar.delegate = viewController
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    func getSearchText() -> String? {
        return searchBar.text
    }
    
    func spinnerHidden(to value: Bool) {
        spinner.isHidden = value
    }
}
