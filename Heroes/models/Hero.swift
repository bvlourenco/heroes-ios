//
//  hero.swift
//  Heroes
//
//  Created by Bernardo Vala Lourenço on 24/10/2023.
//

import Foundation

typealias Hero = HeroResponse.ResponseData.Hero
typealias HeroCategory = HeroResponse.ResponseData.Hero.Category
typealias HeroThumbnail = HeroResponse.ResponseData.Hero.Thumbnail

struct HeroResponse: Decodable {
    let data: ResponseData
    
    struct ResponseData: Decodable {
        let heroes: [Hero]
        
        private enum CodingKeys : String, CodingKey {
            case heroes = "results"
        }
        
        struct Hero: Decodable {
            let name: String?
            let description: String?
            let thumbnail: Thumbnail?
            var stories: Category?
            var comics: Category?
            var events: Category?
            var series: Category?
            
            var imageData: Data?
            var descriptionsLoaded: Bool = false
            
            private enum CodingKeys : String, CodingKey {
                case name, description, thumbnail, stories, comics,
                     events, series
            }
            
            mutating func setHeroImage(image: Data) {
                self.imageData = image
            }
            
            struct Thumbnail: Decodable {
                let path: String
                let `extension`: String
                
                var imageURL: URL {
                    URL(string: "\(path).\(`extension`)")!
                }
            }
            
            struct Category: Decodable {
                var items: [Item]
                
                struct Item: Decodable {
                    let resourceURI: String
                    let name: String
                    var description: String?
                    
                    mutating func setDescription(_ description: String?) {
                        self.description = description
                    }
                }
            }
        }
    }
}

struct DescriptionResponse: Decodable {
    let data: ResponseData
    
    struct ResponseData: Decodable {
        let results: [HeroDetail]
        
        struct HeroDetail: Decodable {
            let description: String?
        }
    }
}
