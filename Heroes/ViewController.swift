//
//  ViewController.swift
//  Heroes
//
//  Created by Bernardo Vala Lourenço on 24/10/2023.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // FIXME: Only for testing purposes
        Task {
            await getAllHeroes()
        }
    }
    
    // FIXME: Only for testing purposes
    func getAllHeroes() async {
        do {
            let heroService = HeroService()
            var heroes = try await heroService.getHeroes()
            try await heroService.getHeroDetails(&heroes[0])
            print(heroes[0].heroComics as AnyObject)
            print(heroes[0].heroSeries as AnyObject)
            print(heroes[0].heroStories as AnyObject)
            print(heroes[0].heroEvents as AnyObject)
        } catch {
            print(error)
        }
    }


}

