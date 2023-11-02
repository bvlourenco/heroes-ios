//
//  CategoryView.swift
//  Heroes
//
//  Created by Bernardo Vala Lourenço on 27/10/2023.
//

import UIKit

class CategoryViewComponent: UIView {
    lazy var categoryLabel: UILabel = getNewLabel(textLabel: "")
    
    // TODO: Refactor name and description labels
    var nameLabels: [UILabel] = []
    var descriptionLabels: [UILabel] = []
    
    init(frame: CGRect, categoryName: String) {
        super.init(frame: frame)
        setupCategoryLabel(categoryName: categoryName)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCategoryLabel(categoryName: String) {
        categoryLabel.text = categoryName
        categoryLabel.sizeToFit()
        addSubview(categoryLabel)
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func addCategoryNameAndDescription(name: String, description: String) {
        let nameLabel = getNewLabel(textLabel: name)
        let descriptionLabel = getNewLabel(textLabel: description)
        addSubview(nameLabel)
        addSubview(descriptionLabel)
        setupLabelConstraints(nameLabel, descriptionLabel)
        self.nameLabels.append(nameLabel)
        self.descriptionLabels.append(descriptionLabel)
    }
    
    func getNewLabel(textLabel: String) -> UILabel {
        let label = UILabel()
        label.text = textLabel
        label.textAlignment = .left
        label.textColor = .black
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.sizeToFit()
        return label
    }
    
    func setupLabelConstraints(_ nameLabel: UILabel,
                               _ descriptionLabel: UILabel) {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
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
        
        nameLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        descriptionLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
    }
    
    func setViewIntrinsicHeight() {
        var totalHeight: CGFloat = categoryLabel.frame.size.height + 16
        for nameLabel in nameLabels {
            totalHeight += nameLabel.frame.size.height + 16
        }
        for descriptionLabel in descriptionLabels {
            totalHeight += descriptionLabel.frame.size.height + 8
        }
        self.heightAnchor.constraint(equalToConstant: totalHeight).isActive = true
    }
}
