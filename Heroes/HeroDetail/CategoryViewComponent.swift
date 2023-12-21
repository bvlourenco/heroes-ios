//
//  CategoryView.swift
//  Heroes
//
//  Created by Bernardo Vala Lourenço on 27/10/2023.
//

import UIKit

class CategoryViewComponent: UIView {
    private lazy var categoryLabel: UILabel = {
        let categoryLabel = getNewLabel(textLabel: "")
        categoryLabel.font = UIFont.boldSystemFont(ofSize: Constants.categoryTitleFontSize)
        return categoryLabel
    }()
    
    private var nameLabels: [UILabel] = []
    private var descriptionLabels: [UILabel] = []
    private var placeholderLabel: UILabel? = nil
    
    init(categoryName: String) {
        super.init(frame: CGRectZero)
        backgroundColor = .black
        categoryLabel.text = categoryName
        addSideConstraintsToLabel(label: categoryLabel)
        
        self.heightAnchor.constraint(equalToConstant: categoryLabel.frame.size.height).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addCategoryNameAndDescription(name: String, description: String) {
        let nameLabel = getNewLabel(textLabel: "Name: " + name)
        let descriptionLabel = getNewLabel(textLabel: "Description: " + description)
        setupLabelConstraints(nameLabel: nameLabel,
                              descriptionLabel: descriptionLabel)
        
        // Forcing the name/description view to update layout to recompute
        // view height
        nameLabel.layoutIfNeeded()
        descriptionLabel.layoutIfNeeded()
        
        self.nameLabels.append(nameLabel)
        self.descriptionLabels.append(descriptionLabel)
    }
    
    func setViewIntrinsicHeight() {
        var totalHeight: CGFloat = categoryLabel.frame.size.height
        + Constants.mediumPadding
        
        if let placeholderLabel = placeholderLabel {
            totalHeight += placeholderLabel.frame.size.height + Constants.mediumPadding
        } else {
            for nameLabel in nameLabels {
                totalHeight += nameLabel.frame.size.height + Constants.mediumPadding
            }
            for descriptionLabel in descriptionLabels {
                totalHeight += descriptionLabel.frame.size.height + Constants.smallPadding
            }
        }
        
        // Adding a special "bottom padding" in each view to add some space
        // between two CategoryViewComponent.
        totalHeight += Constants.mediumPadding
        
        
        // Updating height constraint
        if let constraint = (self.constraints.filter{$0.firstAttribute == .height}.first) {
            constraint.constant = totalHeight
        }
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
    
    func updateDescription(at index: Int, description: String) {
        self.descriptionLabels[index].text = "Description: " + description
        self.descriptionLabels[index].layoutIfNeeded()
        self.setViewIntrinsicHeight()
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
    
    private func setupLabelConstraints(nameLabel: UILabel,
                                       descriptionLabel: UILabel) {
        addTopConstraint(currentLabel: nameLabel,
                         topLabel: descriptionLabels.count > 0 ? descriptionLabels[descriptionLabels.count - 1]
                                                                 : categoryLabel,
                         paddingValue: Constants.mediumPadding)
        
        addTopConstraint(currentLabel: descriptionLabel,
                         topLabel: nameLabel,
                         paddingValue: Constants.smallPadding)
        
        addSideConstraintsToLabel(label: nameLabel)
        addSideConstraintsToLabel(label: descriptionLabel)
    }
}
