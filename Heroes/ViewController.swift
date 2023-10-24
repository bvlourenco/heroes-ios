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
            let heroes = try await HeroService().getHeroes()
            print(heroes.count)
            print(heroes[0])
        } catch {
            print(error)
        }
    }


}

