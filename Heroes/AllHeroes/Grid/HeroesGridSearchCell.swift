//
//  HeroesSearchCell.swift
//  Heroes
//
//  Created by Bernardo Vala Lourenço on 06/12/2023.
//

import UIKit

class HeroesGridSearchCell: UICollectionViewCell {
    
    private enum CellConstants {
        static let imageHeight: CGFloat = 250
        static let spacing: CGFloat = 10
    }
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = CellConstants.spacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let heroName = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    let heroImage = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    var onReuse: () -> Void = {}
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(heroImage)
        stackView.addArrangedSubview(heroName)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        heroImage.image = nil
        heroImage.cancelImageLoad()
    }
    
    private func loadImage(imageURL: URL?) {
        if let imageURL = imageURL {
            if imageURL.absoluteString.hasSuffix(Constants.notAvailableImageName) == false {
                heroImage.loadImage(at: imageURL)
            } else {
                heroImage.image = UIImage(named: "placeholder")
            }
        } else {
            heroImage.image = UIImage(named: "placeholder")
        }
    }
    
    func configure(imageURL: URL?, name: String?) {
        heroName.text = name
        loadImage(imageURL: imageURL)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
        heroImage.contentMode = .scaleAspectFit
    }
}
