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
    let description: String?
}

struct Hero: Decodable {
    let name: String
    let description: String
    let imageURL: String
    let heroComics: [HeroCategoryDetails]
    let heroEvents: [HeroCategoryDetails]
    let heroStories: [HeroCategoryDetails]
    let heroSeries: [HeroCategoryDetails]
}
