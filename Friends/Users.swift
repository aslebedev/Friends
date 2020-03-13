//
//  Users.swift
//  Friends
//
//  Created by alexander on 23.11.2019.
//  Copyright © 2019 alexander. All rights reserved.
//

import Foundation

class Users: ObservableObject, Codable {
    @Published var items = [User]()
    
    enum CodingKeys: CodingKey {
        case items
    }
    
    init() { }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        items = try container.decode([User].self, forKey: .items)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(items, forKey: .items)
    }
}
