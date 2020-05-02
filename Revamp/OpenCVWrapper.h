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
// Otsu thresholding
+ (UIImage *)otsuThreshold:(UIImage *) image level:(double) level;
// Contrast enhancement
+ (UIImage *)contrastEnhancement:(UIImage *) image r1:(int) r1 r2:(int) r2 s1:(int) s1 s2:(int) s2;
// Invert
+ (UIImage *)invert:(UIImage *) image;
// Blur
+ (UIImage *)blur:(UIImage *) image level:(int) level;
// Gaussian blur
+ (UIImage *)gaussianBlur:(UIImage *) image level:(int) level;
// Median filter
+ (UIImage *)medianFilter:(UIImage *) image level:(int) level;
// Posterize
+ (UIImage *)posterize:(UIImage *) image level:(int) level;
// Watershed segmentation
+ (UIImage *)watershed:(UIImage *) image; // <<< FIX
// Sobel filter
+ (UIImage *)sobel:(UIImage *) image type:(int) type border:(int) border;
// Laplacian
+ (UIImage *)laplacian:(UIImage *) image;
// Canny
+ (UIImage *)canny:(UIImage *) image lower:(int) lower upper:(int) upper;
// Mask 3x3
+ (UIImage *)mask3x3:(UIImage *) image mask:(NSArray *) mask divisor:(int) divisor;
// Sharpen mask
+ (UIImage *)sharpen:(UIImage *) image type:(int) type border:(int) border;
// Prewitt operator
+ (UIImage *)prewitt:(UIImage *) image type:(int) type border:(int) border;
// Edge detection
+ (UIImage *)edgeDetection:(UIImage *) image type:(int) type border:(int) border;
// Morphology functions
+ (UIImage *)morphology:(UIImage *) image operation:(int) op element:(int) element n:(int) n border:(int) border;


@end

NS_ASSUME_NONNULL_END
