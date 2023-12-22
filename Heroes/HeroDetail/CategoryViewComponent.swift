//
//  CategoryView.swift
//  Heroes
//
//  Created by Bernardo Vala Lourenço on 27/10/2023.
//

import UIKit

class CategoryViewComponent: UIView {
    private lazy var categoryLabel: UILabel = {
        let label = getNewLabel(textLabel: "")
        label.font = UIFont.boldSystemFont(ofSize: Constants.categoryTitleFontSize)
        return label
    }()
    
    let gridView = GridView(scrollDirection: .horizontal)
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.color = .white
        spinner.startAnimating()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    private var placeholderLabel: UILabel? = nil
    private var hasElements: Bool = false
    
    init(categoryName: String) {
        super.init(frame: CGRectZero)
        backgroundColor = .black
        categoryLabel.text = categoryName
        addSubview(spinner)
        addSubview(gridView)
        setupConstraints()
    }
    
    func setHasElements(hasElements: Bool) {
        self.hasElements = hasElements
        spinner.isHidden = true
    }
    
    func setViewIntrinsicHeight() {
        let gridViewHeight: CGFloat = hasElements ? 190 : 0
        var totalHeight: CGFloat = gridViewHeight + 20 + Constants.mediumPadding
        
        if hasElements {
            gridView.heightAnchor.constraint(equalToConstant: gridViewHeight).isActive = true
        } else {
            totalHeight += 40
        }
        
        // Updating height constraint
        if let constraint = (self.constraints.filter{$0.firstAttribute == .height}.first) {
            constraint.constant = totalHeight
        }
    }
    
    func setGridDataSourceAndDelegate(viewController: HeroDetailViewController) {
        gridView.setGridDataSourceAndDelegate(viewController: viewController)
    }
    
    func addPlaceholderView() {
        let categoryName = categoryLabel.text ?? ""
        let text = "No " + categoryName + " for this hero :("
        self.placeholderLabel = getNewLabel(textLabel: text)
        guard let placeholderLabel = self.placeholderLabel else { return }
        addTopConstraint(currentLabel: placeholderLabel,
                         topLabel: categoryLabel,
                         paddingValue: Constants.mediumPadding)
        addSideConstraintsToLabel(label: placeholderLabel)
    }
    
    func updateLayoutAfterRotation() {
        self.layoutIfNeeded()
        self.setViewIntrinsicHeight()
    }
    
    private func getNewLabel(textLabel: String,
                             alignment: NSTextAlignment = .left) -> UILabel {
        let label = UILabel()
        label.text = textLabel
        label.textAlignment = alignment
        label.textColor = .white
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        addSubview(label)
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    private func addSideConstraintsToLabel(label: UILabel) {
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func addTopConstraint(currentLabel: UILabel, topLabel: UILabel,
                                  paddingValue: CGFloat) {
        currentLabel.topAnchor.constraint(equalTo: topLabel.bottomAnchor,
                                          constant: paddingValue).isActive = true
    }
    
    private func setupConstraints() {
        gridView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            gridView.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: Constants.mediumPadding),
            gridView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            gridView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            categoryLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            categoryLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            categoryLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            spinner.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: Constants.mediumPadding),
            spinner.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            spinner.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            self.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
