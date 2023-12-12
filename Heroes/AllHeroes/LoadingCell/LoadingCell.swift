//
//  LoadingCell.swift
//  Heroes
//
//  Created by Bernardo Vala Lourenço on 11/12/2023.
//

import UIKit

class LoadingCell {
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.startAnimating()
        spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0),
                               width: UIScreen.main.bounds.width,
                               height: CGFloat(Constants.spinnerHeight))
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    func setView(view: UIView) {
        view.addSubview(spinner)
        setupConstraints(view: view)
    }
    
    func animateSpinner() {
        spinner.startAnimating()
    }
    
    private func setupConstraints(view: UIView) {
        NSLayoutConstraint.activate([
            spinner.topAnchor.constraint(equalTo: view.topAnchor),
            spinner.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            spinner.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            spinner.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
