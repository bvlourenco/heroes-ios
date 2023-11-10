//
//  ResponseModel.swift
//  Heroes
//
//  Created by Bernardo Vala Lourenço on 10/11/2023.
//

import Foundation

struct HeroResponse: Decodable {
    let data: ResponseData
    
    struct ResponseData: Decodable {
        let heroes: [Hero]
        
        private enum CodingKeys : String, CodingKey {
            case heroes = "results"
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
