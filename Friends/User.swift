//
//  User.swift
//  Friends
//
//  Created by alexander on 23.11.2019.
//  Copyright © 2019 alexander. All rights reserved.
//

import Foundation

struct User: Codable, Identifiable {
    var id: UUID
    var isActive: Bool
    var name: String
    var age: Int
    var company: String
    var email: String
    var address: String
    var about: String
    var registered: String
    var tags: [String]
    var friends: [Friend]
}
