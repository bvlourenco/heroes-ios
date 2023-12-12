//
//  LoadingGridViewCell.swift
//  Heroes
//
//  Created by Bernardo Vala Lourenço on 30/11/2023.
//

import UIKit

class LoadingGridViewCell: UICollectionViewCell {
    private let loadingCell = LoadingCell()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadingCell.setView(view: contentView)
    }
    
    func animateSpinner() {
        loadingCell.animateSpinner()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
