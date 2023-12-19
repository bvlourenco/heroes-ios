//
//  ViewControllerDelegate.swift
//  Heroes
//
//  Created by Bernardo Vala Lourenço on 11/12/2023.
//

import UIKit

protocol ViewControllerDelegate: AnyObject {
    func addHeroesToView()
    func reloadView()
    func spinnerHidden(to value: Bool)
}
