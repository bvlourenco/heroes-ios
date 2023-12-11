//
//  LoadingTableViewCell.swift
//  Heroes
//
//  Created by Bernardo Vala Lourenço on 30/11/2023.
//

import UIKit

class LoadingTableViewCell: UITableViewCell {
    private let loadingCell = LoadingCell()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        loadingCell.setView(view: contentView)
    }
    
    func animateSpinner() {
        loadingCell.animateSpinner()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
