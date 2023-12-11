//
//  HeroViewControllerDelegate.swift
//  Heroes
//
//  Created by Bernardo Vala Lourenço on 13/11/2023.
//

import Foundation

protocol HeroViewControllerDelegate: AnyObject {
    func updateHeroInView(heroIndex: Int, hero: Hero)
    func updateView(isFavourite: Bool, hero: Hero)
}
