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

+ (UIImage *)toGrayscale:(UIImage *)image {
    Mat src, dst;
    UIImageToMat(image, src);           // iOS UIImage -> Mat
    cvtColor(src, dst, COLOR_BGR2GRAY);
    cvtColor(dst, dst, COLOR_GRAY2RGB); // Converting back to RBG
    cv::flip(dst, dst, 0); // Flip x issue fix
    cv::flip(dst, dst, 1); // Flip y issue fix
    return MatToUIImage(dst);
}

+ (UIImage *)histogramEqualization:(UIImage *) image {
    Mat src, dst;
    UIImageToMat(image, src);
    cvtColor(src, src, COLOR_BGR2GRAY);
    equalizeHist(src, dst);
    cvtColor(dst, dst, COLOR_GRAY2RGB);
    return MatToUIImage(dst);
}

+ (UIImage *)threshold:(UIImage *)image level:(double)level {
    Mat src, dst;
    UIImageToMat(image, src);
    cv::threshold(src, dst, level, 255, THRESH_BINARY);
    return MatToUIImage(dst);
}

+ (UIImage *)grayscaleThreshold:(UIImage *) image level:(double) level {
    Mat src, dst;
    UIImageToMat(image, src);
    cv::threshold(src, dst, level, 255, THRESH_TOZERO);
    return MatToUIImage(dst);
}

+ (UIImage *)adaptiveThreshold:(UIImage *) image level:(double) blockSize {
    Mat src, dst;
    UIImageToMat(image, src);
    dst = src;
    cvtColor(src, src, COLOR_BGR2GRAY);
    cv::adaptiveThreshold(src, dst, 255, ADAPTIVE_THRESH_MEAN_C, THRESH_BINARY, blockSize, 0);
    return MatToUIImage(dst);
}

+ (UIImage *)contrastEnhancement:(UIImage *) image {
    Mat src, dst;
    UIImageToMat(image, src);
    dst = src.clone();
    for( int y = 0; y < src.rows; y++ ) {
        for( int x = 0; x < src.cols; x++ ) {
            for( int c = 0; c < 3; c++ ) {
                dst.at<Vec3b>(y,x)[c] = saturate_cast<uchar>( 3 *( src.at<Vec3b>(y,x)[c] ) + 50 );
            }
        }
    }
    
    return MatToUIImage(dst);
}

+ (UIImage *)invert:(UIImage *) image {
    Mat mat;
    UIImageToMat(image, mat);

    cv::Mat rgb;
    cv::cvtColor(mat, rgb, COLOR_RGBA2RGB);
    cv::Mat tmp(rgb.size(), rgb.type(), cv::Scalar(255,255,255));
    cv::Mat rgb_invert = tmp ^ rgb;

//    cv::Mat gray;
//    cv::cvtColor(rgb, gray, COLOR_RGB2GRAY);
//    cv::Mat gray_invert = 255 ^ gray;
    UIImage* binImg = MatToUIImage(rgb_invert);
    return binImg;
}

@end
