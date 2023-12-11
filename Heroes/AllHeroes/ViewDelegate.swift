//
//  ViewDelegate.swift
//  Heroes
//
//  Created by Bernardo Vala Lourenço on 11/12/2023.
//

import UIKit

protocol ViewDelegate: AnyObject {
    func addHeroesToView()
    func reloadView()
    func getTopBarIconImage() -> UIImage?
    func getViewControllers() -> [UIViewController]
    func hideSpinner()
}
