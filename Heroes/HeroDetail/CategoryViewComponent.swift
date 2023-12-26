//
//  CategoryView.swift
//  Heroes
//
//  Created by Bernardo Vala Lourenço on 27/10/2023.
//

import UIKit

class CategoryViewComponent: UIView {
    
    private enum Constants {
        static let titleSize: CGFloat = 20
        static let textSize: CGFloat = 24
        static let gridCellHeight: CGFloat = 190
        static let viewWithSpinnerHeight: CGFloat = 60
    }
    
    private lazy var categoryLabel: UILabel = {
        let label = getNewLabel(textLabel: "")
        label.font = UIFont.boldSystemFont(ofSize: GlobalConstants.categoryTitleFontSize)
        return label
    }()
    
    private let gridView = GridView(scrollDirection: .horizontal)
    
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
        var totalHeight: CGFloat = Constants.titleSize + GlobalConstants.mediumPadding
        
        if hasElements {
            gridView.heightAnchor.constraint(equalToConstant: Constants.gridCellHeight).isActive = true
            totalHeight += Constants.gridCellHeight
        } else {
            totalHeight += Constants.textSize + GlobalConstants.mediumPadding
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
                         paddingValue: GlobalConstants.mediumPadding)
        addSideConstraintsToLabel(label: placeholderLabel)
    }
    
    func updateLayoutAfterRotation() {
        self.layoutIfNeeded()
        self.setViewIntrinsicHeight()
    }
    
    func reload() {
        gridView.update()
    }
    
    func getGridView() -> GridView {
        return gridView
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
            gridView.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: GlobalConstants.mediumPadding),
            gridView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            gridView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            categoryLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            categoryLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            categoryLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            spinner.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: GlobalConstants.mediumPadding),
            spinner.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor),
            spinner.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor),
            self.heightAnchor.constraint(equalToConstant: Constants.viewWithSpinnerHeight)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
