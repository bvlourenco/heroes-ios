//
//  LoadingCollectionViewCell.swift
//  Heroes
//
//  Created by Bernardo Vala Lourenço on 30/11/2023.
//

import UIKit

class LoadingGridViewCell: UICollectionViewCell {
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.startAnimating()
        spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0),
                               width: UIScreen.main.bounds.width,
                               height: CGFloat(Constants.spinnerHeight))
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(spinner)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animateSpinner() {
        spinner.startAnimating()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            spinner.topAnchor.constraint(equalTo: self.topAnchor),
            spinner.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            spinner.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            spinner.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}
