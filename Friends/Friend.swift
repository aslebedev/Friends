//
//  Friend.swift
//  Friends
//
//  Created by alexander on 23.11.2019.
//  Copyright © 2019 alexander. All rights reserved.
//

import Foundation

struct Friend: Codable, Identifiable {
    var id: UUID
    var name: String
}
