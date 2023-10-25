//
//  hero.swift
//  Heroes
//
//  Created by Bernardo Vala Lourenço on 24/10/2023.
//

import Foundation

// TODO: HeroCategoryDetails is a bad name
struct HeroCategoryDetails: Decodable {
    // TODO: Decide whether resourceURL is a String or URL
    let resourceURL: String
    let name: String
    var description: String?
    
    mutating func setDescription(_ description: String?) {
        self.description = description
    }
}

struct Hero: Decodable {
    let name: String
    let description: String
    let imageURL: String
    var heroComics: [HeroCategoryDetails]
    var heroEvents: [HeroCategoryDetails]
    var heroStories: [HeroCategoryDetails]
    var heroSeries: [HeroCategoryDetails]
}
