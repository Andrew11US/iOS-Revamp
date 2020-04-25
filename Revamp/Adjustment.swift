//
//  Adjustment.swift
//  Revamp
//
//  Created by Andrew on 4/25/20.
//  Copyright © 2020 Andrii Halabuda. All rights reserved.
//

import Foundation

public struct Adjustment {
    var name: String
    var action: (UIImage)->(UIImage)
    
    init(name: String, action: @escaping (UIImage)->(UIImage) ) {
        self.name = name
        self.action = action
    }
}
