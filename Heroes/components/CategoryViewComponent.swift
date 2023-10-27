//
//  CategoryView.swift
//  Heroes
//
//  Created by Bernardo Vala Lourenço on 27/10/2023.
//

import UIKit

class CategoryViewComponent: UIView {
    let categoryName: String
    
    // TODO: Refactor name and description labels
    var nameLabels: [UILabel] = []
    var descriptionLabels: [UILabel] = []
    
    init(frame: CGRect, categoryName: String) {
        self.categoryName = categoryName
        super.init(frame: frame)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        label.textAlignment = .center
        label.textColor = .black
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }
    
    func setupConstraints() {
        self.translatesAutoresizingMaskIntoConstraints = false
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
        }
        descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor,
                                              constant: 8).isActive = true
    }
}
