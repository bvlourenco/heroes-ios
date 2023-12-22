//
//  CategoryDetailViewController.swift
//  Heroes
//
//  Created by Bernardo Vala Lourenço on 22/12/2023.
//

import UIKit

class CategoryDetailViewController: UIViewController {
    private let categoryView: CategoryDetailView
    private var category: Category.Item?
    private let loader: ImageLoader
    
    init(category: Category.Item?, loader: ImageLoader) {
        self.categoryView = CategoryDetailView()
        self.category = category
        self.loader = loader
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = categoryView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryView.setupView(name: category?.name,
                               description: category?.description,
                               imageURL: category?.thumbnail?.imageURL)
    }
    
    private func createTitleLabel() -> UILabel {
        // The frame arguments allows to have a very long name being shown completely
        let label = UILabel(frame: CGRect(x: CGFloat(0), y: CGFloat(0),
                                          width: UIScreen.main.bounds.width,
                                          height: CGFloat(Constants.navigationTitleFrameSize)))
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: label.font.pointSize)
        label.text = category?.name
        return label
    }
}
