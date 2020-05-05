//
//  UIImage+Extension.swift
//  Revamp
//
//  Created by Andrew on 4/24/20.
//  Copyright © 2020 Andrii Halabuda. All rights reserved.
//

import UIKit
import Accelerate

extension UIImage {
    
    // MARK: - Histogram using vImage
    func histogram() -> (alpha: [UInt], red: [UInt], green: [UInt], blue: [UInt])? {
        guard let imageRef = self.cgImage else { return nil }
        guard let imageProvider = imageRef.dataProvider else { return nil }
        let bitmapData = imageProvider.data
        
        var imageBuffer = vImage_Buffer(data: UnsafeMutablePointer(mutating: CFDataGetBytePtr(bitmapData)), height: UInt(imageRef.height), width: UInt(imageRef.width), rowBytes: imageRef.bytesPerRow)
        
        let alpha = [UInt](repeating: 0, count: 256)
        let red = [UInt](repeating: 0, count: 256)
        let green = [UInt](repeating: 0, count: 256)
        let blue = [UInt](repeating: 0, count: 256)
        
        let alphaPtr = UnsafeMutablePointer<vImagePixelCount>(mutating: alpha)
        let redPtr = UnsafeMutablePointer<vImagePixelCount>(mutating: red)
        let greenPtr = UnsafeMutablePointer<vImagePixelCount>(mutating: green)
        let bluePtr = UnsafeMutablePointer<vImagePixelCount>(mutating: blue)
        
        // ARBG vImage function takes channel order RBG+A
        let RGBA: [UnsafeMutablePointer<vImagePixelCount>?] = [redPtr, greenPtr, bluePtr, alphaPtr]
        let histogram = UnsafeMutablePointer<UnsafeMutablePointer<vImagePixelCount>?>(mutating: RGBA)
        
        vImageHistogramCalculation_ARGB8888(&imageBuffer, histogram, UInt32(kvImageNoFlags))
        
        return (alpha, red, green, blue)
    }
}
