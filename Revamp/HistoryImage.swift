//
//  HistoryImage.swift
//  Revamp
//
//  Created by Andrew on 4/25/20.
//  Copyright © 2020 Andrii Halabuda. All rights reserved.
//

import Foundation

// MARK: - History Image struct
struct HistoryImage {
    var name: String
    var image: UIImage
    
    init(name: String, image: UIImage) {
        self.image = image
        self.name = name
    }
}
