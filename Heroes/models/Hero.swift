//
//  hero.swift
//  Heroes
//
//  Created by Bernardo Vala Lourenço on 24/10/2023.
//

import Foundation

// TODO: HeroCategoryDetails is a bad name
struct HeroCategoryDetails: Decodable {
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
    var heroComics: [String: HeroCategoryDetails]
    var heroEvents: [String: HeroCategoryDetails]
    var heroStories: [String: HeroCategoryDetails]
    var heroSeries: [String: HeroCategoryDetails]
}
