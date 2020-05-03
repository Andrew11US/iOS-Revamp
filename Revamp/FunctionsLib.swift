//
//  FunctionsLib.swift
//  Revamp
//
//  Created by Andrew on 5/3/20.
//  Copyright © 2020 Andrii Halabuda. All rights reserved.
//

import Foundation

struct FunctionsLib {
    static func showMetrics(img: UIImage) {
        guard let moments = OpenCVWrapper.metrics(img) as? [Double] else { return }
        let alert = UIAlertController(style: .actionSheet)
        
        let text: [AttributedTextBlock] = [
            .header1("Image Metrics"),
            .header2("Image Dimensions"),
            .list("Width: \(Int(moments[10]))"),
            .list("Height: \(Int(moments[11]))"),
            .list("Total pixels: \(Int(moments[12]))"),
            .list("Megapixels: \( Double(round((moments[12] / 1_000_000)*100)/100) ) MPs"),
            .list("Channels: \(Int(moments[13]))"),
            .normal(""),
            .header2("Moments"),
            .list("Moment m(0,0): \(Int(moments[0]))"),
            .list("Moment m(0,1): \(Int(moments[1]))"),
            .list("Moment m(1,0): \(Int(moments[2]))"),
            .list("Moment m(1,1): \(Int(moments[3]))"),
            .normal(""),
            .header2("Central Moments"),
            .list("Central Moment mu(20): \(Int(moments[4]))"),
            .list("Central Moment mu(11): \(Int(moments[5]))"),
            .list("Central Moment mu(02): \(Int(moments[6]))"),
            .list("Central Moment mu(30): \(Int(moments[7]))"),
            .normal(""),
            .header2("Center of mass"),
            .list("Central Point: (\(Int(moments[8])), \(Int(moments[9])))"),
            .header2("Object Properties"),
            .list("Area: \(Int(moments[14]))"),
            .list("Perimeter: \(Int(moments[15]))"),
            .header2("Contour Properties"),
            .list("Aspect Ratio: \(moments[16])"),
            .list("Extent: \(moments[17])"),
            .list("Solidity: \(moments[18])"),
            .list("Equivalent Diameter: \(moments[19])"),
            ]
        alert.addTextViewer(text: .attributedText(text))
        alert.addAction(title: "OK", style: .cancel)
        alert.show()
    }
    
    static func detectShape(img: UIImage) {
        let shape = OpenCVWrapper.shapeDetector(img)
        let alert = UIAlertController(style: .actionSheet)
        
        let text: [AttributedTextBlock] = [
            .header1("Shape Detector"),
            .header2("Using OpenCV contour markers"),
            .normal("Detected shape is \(shape)")
            ]
        alert.addTextViewer(text: .attributedText(text))
        alert.addAction(title: "OK", style: .cancel)
        alert.show()
    }
}
