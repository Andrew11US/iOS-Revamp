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
    UIImage* img = MatToUIImage(dst);
    return img;
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

+ (UIImage *)contrastEnhancement:(UIImage *) image r1:(int) r1 r2:(int) r2 s1:(int) s1 s2:(int) s2 {
    Mat src, dst;
    UIImageToMat(image, src);
    dst = src.clone();
    
    for(int y = 0; y < src.rows; ++y) {
        for(int x = 0; x < src.cols; ++x) {
            for(int c = 0; c < 3; ++c) {
                int output = computeOutput(src.at<Vec3b>(y,x)[c], r1, r2, s1, s2);
                dst.at<Vec3b>(y,x)[c] = saturate_cast<uchar>(output);
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
    UIImage* img = MatToUIImage(rgb_invert);
    return img;
}

+ (UIImage *)blur:(UIImage *) image {
    Mat src, dst;
    UIImageToMat(image, src);
    cv::blur(src, dst, cv::Size(15,15));
    return MatToUIImage(dst);
}

+ (UIImage *)gaussianBlur:(UIImage *) image {
    Mat src, dst;
    UIImageToMat(image, src);
    cv::GaussianBlur(src, dst, cv::Size(155,155), 0);
    return MatToUIImage(dst);
}

+ (UIImage *)medianFilter:(UIImage *) image {
    Mat src, dst;
    UIImageToMat(image, src);
    dst = src.clone();
    cv::medianBlur(src, dst, 221);
    return MatToUIImage(dst);
}

private int computeOutput(int x, int r1, int r2, int s1, int s2)
{
    float result;
    if(0 <= x && x <= r1){
        result = s1/r1 * x;
    }else if(r1 < x && x <= r2){
        result = ((s2 - s1)/(r2 - r1)) * (x - r1) + s1;
    }else if(r2 < x && x <= 255){
        result = ((255 - s2)/(255 - r2)) * (x - r2) + s2;
    }
    return (int)result;
}

@end
