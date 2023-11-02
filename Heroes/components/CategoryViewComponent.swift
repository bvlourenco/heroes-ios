//
//  CategoryView.swift
//  Heroes
//
//  Created by Bernardo Vala Lourenço on 27/10/2023.
//

import UIKit

class CategoryViewComponent: UIView {
    lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 20)
        addSubview(label)
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        return label
    }()
    
    // TODO: Refactor name and description labels
    var nameLabels: [UILabel] = []
    var descriptionLabels: [UILabel] = []
    
    var placeholderLabel: UILabel? = nil
    
    init(frame: CGRect, categoryName: String) {
        super.init(frame: frame)
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.systemGray2.cgColor
        self.backgroundColor = UIColor.systemGray6
        categoryLabel.text = categoryName
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addCategoryNameAndDescription(name: String, description: String) {
        let nameLabel = getNewLabel(textLabel: "Name: " + name)
        let descriptionLabel = getNewLabel(textLabel: "Description: " + description)
        setupLabelConstraints(nameLabel, descriptionLabel)
        self.nameLabels.append(nameLabel)
        self.descriptionLabels.append(descriptionLabel)
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
    
    private func setupLabelConstraints(_ nameLabel: UILabel,
                                       _ descriptionLabel: UILabel) {
        if descriptionLabels.count > 0 {
            let lastIndex = descriptionLabels.count - 1
            nameLabel.topAnchor.constraint(equalTo: descriptionLabels[lastIndex]
                                                    .bottomAnchor,
                                           constant: 16).isActive = true
        } else {
            nameLabel.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor,
                                           constant: 16).isActive = true
        }
        descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor,
                                              constant: 8).isActive = true

        nameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8).isActive = true
        
        nameLabel.layoutIfNeeded()
        descriptionLabel.layoutIfNeeded()
    }
    
    func setViewIntrinsicHeight() {
        var totalHeight: CGFloat = categoryLabel.frame.size.height + 16
        for nameLabel in nameLabels {
            totalHeight += nameLabel.frame.size.height + 16
        }
        for descriptionLabel in descriptionLabels {
            totalHeight += descriptionLabel.frame.size.height + 8
        }
        
        if let placeholderLabel = placeholderLabel {
            totalHeight += placeholderLabel.frame.size.height + 16
        }

        // Adding a special "bottom padding" in each view to add some space
        // between two CategoryViewComponent.
        totalHeight += 16
        
        self.heightAnchor.constraint(equalToConstant: totalHeight).isActive = true
    }
    
    func addPlaceholderView() {
        let categoryName = categoryLabel.text ?? ""
        self.placeholderLabel = getNewLabel(textLabel: "No " + categoryName + " for this hero :(")
        if let placeholderLabel = placeholderLabel {
            placeholderLabel.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor,
                                                  constant: 16).isActive = true
            placeholderLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
            placeholderLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8).isActive = true
            placeholderLabel.layoutIfNeeded()
        }
    }
}
