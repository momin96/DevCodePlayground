//
//  Item.swift
//  Find It Fast
//
//  Created by Nasir Ahmed Momin on 11/09/24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}