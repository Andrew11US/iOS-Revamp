//
//  OpenCVWrapper.m
//  Revamp
//
//  Created by Andrew on 4/23/20.
//  Copyright © 2020 Andrii Halabuda. All rights reserved.
//

#import <opencv2/opencv.hpp>
#import <opencv2/imgcodecs/ios.h>
#import "OpenCVWrapper.h"

// MARK: - Objective-C++ implementation file
@implementation OpenCVWrapper
using namespace cv;

+ (NSString *)openCVVersion {
    return [NSString stringWithFormat:@"Open CV Version: %s", CV_VERSION];
}

+ (UIImage *)makeGray:(UIImage *)image {
    Mat src;
    UIImageToMat(image, src);
    
    if (src.channels() == 1) return image;
    Mat dst;
    cvtColor(src, dst, COLOR_BGR2GRAY);
    return MatToUIImage(dst);
}

+ (UIImage *)stretchHistogram:(UIImage *) image {
    Mat src, dst;
    /// Load image
    UIImageToMat(image, src);
    /// Convert to grayscale
    cvtColor( src, src, COLOR_BGR2GRAY );
    /// Apply Histogram Equalization
    equalizeHist( src, dst );
    return MatToUIImage(dst);
}

@end
