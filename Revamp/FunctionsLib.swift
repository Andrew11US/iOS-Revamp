//
//  FunctionsLib.swift
//  Revamp
//
//  Created by Andrew on 5/3/20.
//  Copyright © 2020 Andrii Halabuda. All rights reserved.
//

import Foundation

struct FunctionsLib {
    // MARK: - Shows metrics of an image
    static func showMetrics(img: UIImage, anchor: UIView) {
        guard let metrics = OpenCVWrapper.metrics(img) as? [Double] else { return }
        let alert = UIAlertController(style: .actionSheet)
        
        let text: [AttributedTextBlock] = [
            .header1("Image Metrics"),
            .header2("Image Dimensions"),
            .list("Width: \(Int(metrics[10]))"),
            .list("Height: \(Int(metrics[11]))"),
            .list("Total pixels: \(Int(metrics[12]))"),
            .list("Megapixels: \( Double(round((metrics[12] / 1_000_000)*100)/100) ) MPs"),
            .list("Channels: \(Int(metrics[13]))"),
            .normal(""),
            .header2("Moments"),
            .list("Moment m(0,0): \(Int(metrics[0]))"),
            .list("Moment m(0,1): \(Int(metrics[1]))"),
            .list("Moment m(1,0): \(Int(metrics[2]))"),
            .list("Moment m(1,1): \(Int(metrics[3]))"),
            .normal(""),
            .header2("Central Moments"),
            .list("Central Moment mu(20): \(Int(metrics[4]))"),
            .list("Central Moment mu(11): \(Int(metrics[5]))"),
            .list("Central Moment mu(02): \(Int(metrics[6]))"),
            .list("Central Moment mu(30): \(Int(metrics[7]))"),
            .normal(""),
            .header2("Center of mass"),
            .list("Central Point: (\(Int(metrics[8])), \(Int(metrics[9])))"),
            .header2("Object Properties"),
            .list("Area: \(Int(metrics[14]))"),
            .list("Perimeter: \(Int(metrics[15]))"),
            .header2("Contour Properties"),
            .list("Aspect Ratio: 1 : \(String(format: "%.2f", metrics[16]))"),
            .list("Extent: \(metrics[17])"),
            .list("Solidity: \(metrics[18])"),
            .list("Equivalent Diameter: \(metrics[19])"),
            ]
        alert.addTextViewer(text: .attributedText(text))
        alert.addAction(title: "OK", style: .cancel)
        
        // If device is iPad anchor rect for alert is needed
        if UIDevice.current.userInterfaceIdiom == .pad {
            alert.popoverPresentationController?.sourceView = anchor
            alert.popoverPresentationController?.sourceRect = anchor.bounds
            alert.popoverPresentationController?.permittedArrowDirections = [.down, .up]
        }
        
        alert.show()
    }
    
    // MARK: - Show shape detection prompt
    static func detectShape(img: UIImage, anchor: UIView) {
        let shape = OpenCVWrapper.shapeDetector(img)
        let alert = UIAlertController(style: .actionSheet)
        
        let text: [AttributedTextBlock] = [
            .header1("Shape Detector"),
            .header2("Using OpenCV contour markers"),
            .normal("Detected shape is \(shape)")
            ]
        alert.addTextViewer(text: .attributedText(text))
        alert.addAction(title: "OK", style: .cancel)
        
        // If device is iPad anchor rect for alert is needed
        if UIDevice.current.userInterfaceIdiom == .pad {
            alert.popoverPresentationController?.sourceView = anchor
            alert.popoverPresentationController?.sourceRect = anchor.bounds
            alert.popoverPresentationController?.permittedArrowDirections = [.down, .up]
        }
        
        alert.show()
    }
    
    // MARK: - Show About the App info
    static func aboutApp(anchor: UIView) {
        let alert = UIAlertController(style: .actionSheet)
        
        let text: [AttributedTextBlock] = [
            .header1("Revamp"),
            .header2("WIT University Project"),
            .normal(""),
            .header2("Title: Image Processing app for iOS Devices"),
            .normal("Author: Andrii Halabuda"),
            .normal("Group: ID06IO2"),
            .normal("Student ID: 17460"),
            .normal("Subject: Algorytmy Przetwarzania Obrazów 2020 WIT"),
            .normal("Prowadzący: mgr inż. Łukasz Roszkowiak"),
            .normal(""),
            .normal("Warsaw School of Information Technologies"),
            .normal("Warsaw 2020")
            ]
        alert.addTextViewer(text: .attributedText(text))
        alert.addAction(title: "OK", style: .cancel)
        
        // If device is iPad anchor rect for alert is needed
        if UIDevice.current.userInterfaceIdiom == .pad {
            alert.popoverPresentationController?.sourceView = anchor
            alert.popoverPresentationController?.sourceRect = anchor.bounds
            alert.popoverPresentationController?.permittedArrowDirections = [.down, .up]
        }
        
        alert.show()
    }
}
