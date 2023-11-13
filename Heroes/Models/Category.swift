//
//  Category.swift
//  Heroes
//
//  Created by Bernardo Vala Lourenço on 10/11/2023.
//

import Foundation

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
