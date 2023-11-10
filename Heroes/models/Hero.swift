//
//  hero.swift
//  Heroes
//
//  Created by Bernardo Vala Lourenço on 24/10/2023.
//

import Foundation

typealias HeroThumbnail = Hero.Thumbnail
typealias Stories = Category
typealias Comics = Category
typealias Events = Category
typealias Series = Category

struct Hero: Decodable {
    let name: String?
    let description: String?
    let thumbnail: Thumbnail?
    var stories: Stories?
    var comics: Comics?
    var events: Events?
    var series: Series?
    
    private enum CodingKeys : String, CodingKey {
        case name, description, thumbnail, stories, comics,
             events, series
    }
    
    struct Thumbnail: Decodable {
        let path: String
        let `extension`: String
        
        var imageURL: URL {
            URL(string: "\(path).\(`extension`)")!
        }
    }
}
