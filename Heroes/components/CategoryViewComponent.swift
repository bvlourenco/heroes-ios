//
//  CategoryView.swift
//  Heroes
//
//  Created by Bernardo Vala Lourenço on 27/10/2023.
//

import UIKit

class CategoryViewComponent: UIView {
    private lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: Constants.categoryTitleFontSize)
        addSubview(label)
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width)
            .isActive = true
        return label
    }()
    
    private var nameLabels: [UILabel] = []
    private var descriptionLabels: [UILabel] = []
    private var placeholderLabel: UILabel? = nil
    
    init(frame: CGRect, categoryName: String) {
        super.init(frame: frame)
        addBackgroundAndBordersToComponent()
        categoryLabel.text = categoryName
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addCategoryNameAndDescription(name: String, description: String) {
        let nameLabel = getNewLabel(textLabel: "Name: " + name)
        let descriptionLabel = getNewLabel(textLabel: "Description: " + description)
        setupLabelConstraints(nameLabel: nameLabel,
                              descriptionLabel: descriptionLabel)
        
        // Forcing the views to update layout to avoid case where current view
        // is smaller than its elements together
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
        
        self.heightAnchor.constraint(equalToConstant: totalHeight)
            .isActive = true
    }
    
    func addPlaceholderView() {
        let categoryName = categoryLabel.text ?? ""
        let text = "No " + categoryName + " for this hero :("
        self.placeholderLabel = getNewLabel(textLabel: text)
        if let placeholderLabel = placeholderLabel {
            addTopConstraint(currentLabel: placeholderLabel,
                             topLabel: categoryLabel,
                             paddingValue: Constants.mediumPadding)
            addSideConstraintsToLabel(label: placeholderLabel)
        }
    }
    
    private func addBackgroundAndBordersToComponent() {
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.systemGray2.cgColor
        self.backgroundColor = UIColor.systemGray6
    }
    
    private func getNewLabel(textLabel: String) -> UILabel {
        let label = UILabel()
        label.text = textLabel
        label.textAlignment = .left
        label.textColor = .black
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        addSubview(label)
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    private func addSideConstraintsToLabel(label: UILabel) {
        label.leadingAnchor.constraint(equalTo: self.leadingAnchor,
                                       constant: Constants.smallPadding)
        .isActive = true
        
        label.trailingAnchor.constraint(equalTo: self.trailingAnchor,
                                        constant: -Constants.smallPadding)
        .isActive = true
    }
    
    private func addTopConstraint(currentLabel: UILabel, topLabel: UILabel,
                                  paddingValue: CGFloat) {
        currentLabel.topAnchor.constraint(equalTo: topLabel.bottomAnchor,
                                          constant: paddingValue).isActive = true
    }
    
    private func setupLabelConstraints(nameLabel: UILabel,
                                       descriptionLabel: UILabel) {
        if descriptionLabels.count > 0 {
            let lastIndex = descriptionLabels.count - 1
            addTopConstraint(currentLabel: nameLabel,
                             topLabel: descriptionLabels[lastIndex],
                             paddingValue: Constants.mediumPadding)
        } else {
            addTopConstraint(currentLabel: nameLabel,
                             topLabel: categoryLabel,
                             paddingValue: Constants.mediumPadding)
        }
        
        addTopConstraint(currentLabel: descriptionLabel,
                         topLabel: nameLabel,
                         paddingValue: Constants.smallPadding)
        
        addSideConstraintsToLabel(label: nameLabel)
        addSideConstraintsToLabel(label: descriptionLabel)
    }
}
