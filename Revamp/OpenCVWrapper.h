//
//  OpenCVWrapper.h
//  Revamp
//
//  Created by Andrew on 4/23/20.
//  Copyright © 2020 Andrii Halabuda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

// MARK: - Objective-C Wrapper for OpenCV library to operate with Swift
// Header file is used for declarations
@interface OpenCVWrapper : NSObject

// Show OpenCV version
+ (NSString *)openCVVersion;
// Convert to Grayscale
+ (UIImage *)toGrayscale:(UIImage *) image;
// Histogram equalization
+ (UIImage *)histogramEqualization:(UIImage *) image;
// Thresholding
+ (UIImage *)threshold:(UIImage *) image level:(double) level;
// Thresholding with grayscale
+ (UIImage *)grayscaleThreshold:(UIImage *) image level:(double) level;
// Adaptive thresholding
+ (UIImage *)adaptiveThreshold:(UIImage *) image level:(double) blockSize;
// Contrast enhancement
+ (UIImage *)contrastEnhancement:(UIImage *) image;
// Invert
+ (UIImage *)invert:(UIImage *) image;

@end

NS_ASSUME_NONNULL_END
