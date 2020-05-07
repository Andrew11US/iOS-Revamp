//
//  Adjustment+Enum.swift
//  Revamp
//
//  Created by Andrew on 5/2/20.
//  Copyright © 2020 Andrii Halabuda. All rights reserved.
//

import Foundation

// MARK: - Adjustment types enum
enum Adjustment: String, CaseIterable {
    case grayscale = "Grayscale"
    case invert = "Invert"
    case equalize = "Equalize Histogram"
    case thresholdBinarized = "Threshold Binarized"
    case thresholGray = "Threshold Grayscale"
    case thresholAdaptive = "Adaptive Threshold"
    case thresholdOtsu = "Otsu Threshold"
    case contrast = "Enhance Contrast"
    case blur = "Blur Filter"
    case gaussian = "Gaussian Blur"
    case median = "Median Filter"
    case mask = "Mask 3x3"
    case sharpen = "Sharpen Filter"
    case posterize = "Posterize"
    case watershed = "Watershed"
    case sobel = "Sobel Operator"
    case laplacian = "Laplacian"
    case canny = "Canny Edge Detector"
    case prewitt = "Prewitt Operator"
    case edge = "Edge Direction"
    case morphology = "Morphology Operations"
    case thinning = "Thinning"
    case shapeDetector = "Detect Shape"
    case metrics = "Image Metrics"
}

