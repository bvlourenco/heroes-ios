//
//  Category.swift
//  Heroes
//
//  Created by Bernardo Vala Lourenço on 10/11/2023.
//

import Foundation

struct Category: Codable {
    var items: [Item]
    
    struct Item: Codable {
        let resourceURI: String
        let name: String
        var description: String?
        
        mutating func setDescription(_ description: String?) {
            self.description = description
        }
        
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(resourceURI, forKey: .resourceURI)
            try container.encode(name, forKey: .name)
            try container.encode(description, forKey: .description)
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(items, forKey: .items)
    }
}
