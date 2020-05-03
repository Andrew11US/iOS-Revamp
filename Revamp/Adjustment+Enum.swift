//
//  Adjustment+Enum.swift
//  Revamp
//
//  Created by Andrew on 5/2/20.
//  Copyright © 2020 Andrii Halabuda. All rights reserved.
//

import Foundation

enum Adjustment: String, CaseIterable {
    case grayscale = "Grayscale"
    case equalize = "Equalize Histogram"
    case thresholdBinarized = "Threshold Binarized"
    case thresholGray = "Threshold Grayscale"
    case thresholAdaptive = "Adaptive Threshold"
    case thresholdOtsu = "Otsu Threshold"
    case contrast = "Enhance Contrast"
    case invert = "Invert"
    case blur = "Blur"
    case gaussian = "Gaussian Blur"
    case median = "Median Filter"
    case posterize = "Posterize"
    case watershed = "Watershed"
    case sobel = "Sobel"
    case laplacian = "Laplacian"
    case canny = "Canny Filter"
    case mask = "Mask 3x3"
    case sharpen = "Sharpen"
    case prewitt = "Prewitt"
    case edge = "Edge Detection"
    case morphology = "Morphology"
    case thinning = "Thinning"
    case shapeDetector = "Shape Detector"
    case metrics = "Metrics"
}

