//
//  SearchView.swift
//  Heroes
//
//  Created by Bernardo Vala Lourenço on 18/12/2023.
//

import UIKit

class SearchView: UIView {
    private enum Constants {
        static let alertTitle = "Cannot perform search"
        static let alertMessage = "Your search query has less than 3 characters. Insert more characters"
        static let alertButtonTitle = "Ok"
        static let searchPlaceholder = "Search for heroes"
    }
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.showsCancelButton = true
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.backgroundImage = UIImage()
        searchBar.placeholder = Constants.searchPlaceholder
        searchBar.tintColor = .white
        searchBar.searchTextField.textColor = .white
        searchBar.barStyle = .black
        return searchBar
    }()
    
    private let results: HeroesTableView = {
        let heroesTableView = HeroesTableView(spinnerHidden: true)
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
    
    private let alert: UIAlertController = {
        let alert = UIAlertController(title: Constants.alertTitle,
                                      message: Constants.alertMessage,
                                      preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: Constants.alertButtonTitle,
                                      style: UIAlertAction.Style.default,
                                      handler: nil))
        return alert
    }()
    
    init() {
        super.init(frame: CGRectZero)
        backgroundColor = .black
        addSubview(stackView)
        stackView.addArrangedSubview(searchBar)
        stackView.addArrangedSubview(results)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    func setSearchDelegate(viewController: SearchViewController) {
        searchBar.delegate = viewController
    }
    
    func setResultsDataSourceAndDelegate(viewController: SearchViewController) {
        results.setTableDataSourceAndDelegate(viewController: viewController)
    }
    
    func hideKeyboard() {
        searchBar.resignFirstResponder()
    }
    
    func updateResults() {
        results.update()
    }
    
    func getAlert() -> UIAlertController {
        return alert
    }
    
    func spinnerHidden(to value: Bool) {
        results.isSpinnerHidden(to: value)
    }
    
    func getSearchText() -> String? {
        return searchBar.text
    }
}
