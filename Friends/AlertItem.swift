//
//  AlertItem.swift
//  Friends
//
//  Created by alexander on 13.04.2020.
//  Copyright © 2020 alexander. All rights reserved.
//

import Foundation
import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    let title: Text
    var message: Text?
    var dismissButton: Alert.Button? = nil
}
