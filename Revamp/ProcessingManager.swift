//
//  ProcessingManager.swift
//  Revamp
//
//  Created by Andrew on 4/25/20.
//  Copyright © 2020 Andrii Halabuda. All rights reserved.
//

import Foundation

public struct ProcessingManager {
//    public static let shared = ProcessingManager()
    public static let adjustments: [Adjustment] = [Adjustment(name: "gray", action: makeGrayscale(image:))]
    
    public static func makeGrayscale(image: UIImage) -> UIImage {
        return OpenCVWrapper.makeGray(image)
    }
}
