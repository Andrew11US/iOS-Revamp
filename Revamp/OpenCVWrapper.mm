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

+ (UIImage *)blur:(UIImage *) image level:(int) level {
    Mat src, dst;
    UIImageToMat(image, src);
    cv::blur(src, dst, cv::Size(level, level));
    return MatToUIImage(dst);
}

+ (UIImage *)gaussianBlur:(UIImage *) image level:(int) level {
    Mat src, dst;
    UIImageToMat(image, src);
    cv::GaussianBlur(src, dst, cv::Size(level, level), 0);
    return MatToUIImage(dst);
}

+ (UIImage *)medianFilter:(UIImage *) image level:(int) level {
    Mat src, dst;
    UIImageToMat(image, src);
    dst = src.clone();
    cv::medianBlur(src, dst, level);
    return MatToUIImage(dst);
}

+ (UIImage *)otsuThreshold:(UIImage *) image level:(double) level {
    Mat src, dst, tmp;
    UIImageToMat(image, src);
    cvtColor(src, tmp, COLOR_BGR2GRAY);
    cv::threshold(tmp, dst, level, 255, THRESH_BINARY | THRESH_OTSU);
    cvtColor(dst, dst, COLOR_GRAY2RGB);
    return MatToUIImage(dst);
}

+ (UIImage *)posterize:(UIImage *) image level:(int) level {
    Mat src;
    UIImageToMat(image, src);
    cv::Mat dst(src.size(), src.type(), cv::Scalar(255,255,255));
    
    for(int i = 0; i < src.rows; i++) {
        for(int j = 0; j < src.cols; j++) {
            for(int c = 0; c < 3; c++) {
                int num_colors = level;
                int divisor = 256 / num_colors;
                int max_quantized_value = 255 / divisor;
                int new_value = ((src.at<Vec3b>(i,j)[c] / divisor) * 255) / max_quantized_value;
                dst.at<Vec3b>(i,j)[c] = new_value;
            }
        }
    }
    return MatToUIImage(dst);
}

+ (UIImage *)watershed:(UIImage *) image {
//    Mat src, tmp;
//    UIImageToMat(image, src);
//    cvtColor(src, tmp, COLOR_BGRA2BGR);
////    tmp.convertTo(tmp, CV_32F);
//    cv::Mat dst(tmp.size(), tmp.type(), cv::Scalar(255));
////    cvtColor(src, tmp, COLOR_BGR2GRAY);
//    cv::watershed(tmp, dst);
////    cvtColor(dst, dst, COLOR_GRAY2RGB);
//    return MatToUIImage(dst);
    
    Mat src;
    UIImageToMat(image, src);
    Mat dst = cv::Mat();
    Mat gray =  Mat();
    Mat opening = Mat();
    Mat coinsBg = Mat();
    Mat coinsFg = Mat();
    Mat distTrans = Mat();
    Mat unknown = Mat();
    Mat markers = cv::Mat();
    // gray and threshold image
    cvtColor(src, gray, COLOR_RGBA2GRAY, 0);
    threshold(gray, gray, 0, 255, THRESH_BINARY_INV + THRESH_OTSU);
    // get background
    Mat M = Mat::ones(3, 3, CV_8U);
    erode(gray, gray, M);
    dilate(gray, opening, M);
    dilate(opening, coinsBg, M, cv::Point(-1, -1), 3);
    // distance transform
    cv::distanceTransform(opening, distTrans, DIST_L2, 5);
    cv::normalize(distTrans, distTrans, 1, 0, NORM_INF);
    // get foreground
    cv::threshold(distTrans, coinsFg, 0.7 * 1, 255, cv::THRESH_BINARY);
    coinsFg.convertTo(coinsFg, CV_8U, 1, 0);
    cv::subtract(coinsBg, coinsFg, unknown);
    // get connected components markers
    cv::connectedComponents(coinsFg, markers);
    markers += 1;
    
    for (int i = 0; i < markers.rows; i++) {
        for (int j = 0; j < markers.cols; j++) {
//            markers.ptr(i, j)[0] = markers.ptr(i, j)[0] + 1;
            markers.at<Vec3b>(i,j)[0] = markers.at<Vec3b>(i,j)[0] + 1;
            if (unknown.at<Vec3b>(i, j)[0] == 255) {
                markers.at<Vec3b>(i, j)[0] = 0;
            }
        }
    }
    cv::cvtColor(src, src, COLOR_RGBA2RGB, 0);
    cv::watershed(src, markers);
    // draw barriers
    for (int i = 0; i < markers.rows; i++) {
        for (int j = 0; j < markers.cols; j++) {
            if (markers.at<Vec3b>(i, j)[0] == -1) {
                src.at<Vec3b>(i, j)[0] = 255; // R
                src.at<Vec3b>(i, j)[1] = 0; // G
                src.at<Vec3b>(i, j)[2] = 0; // B
            }
        }
    }
    UIImage* output = MatToUIImage(src);
    src.deallocate();
    return output;
//    src.delete(); dst.delete(); gray.delete(); opening.delete(); coinsBg.delete();
//    coinsFg.delete(); distTrans.delete(); unknown.delete(); markers.delete(); M.delete();
    
//    Mat src, dst;
//    UIImageToMat(image, src);
//    cvtColor(src, dst, COLOR_BGR2GRAY);
////    src.convertTo(src, CV_8UC3);
////    dst.convertTo(dst, CV_32SC1);
////    cvtColor(src, tmp, COLOR_BGR2GRAY);
//    cv::watershed(dst, dst);
////    cvtColor(dst, dst, COLOR_GRAY2RGB);
//    return MatToUIImage(dst);
}

+ (UIImage *)sobel:(UIImage *) image type:(int) type border:(int) border {
    Mat src, gray, dst;
    Mat grad;
    Mat grad_x, grad_y;
    Mat abs_grad_x, abs_grad_y;
    
    int scale = 1;
    int delta = 0;
    int ddepth = CV_16S;

    UIImageToMat(image, src);
    GaussianBlur( src, src, cv::Size(3,3), 0, 0, BORDER_DEFAULT );

    /// Convert it to GRAY
    cvtColor( src, gray, COLOR_BGR2GRAY );

    if (type == 0) {
        /// Gradient X
        Sobel( gray, grad_x, ddepth, 1, 0, 3, scale, delta, BORDER_DEFAULT );
        convertScaleAbs( grad_x, abs_grad_x ); // Convert back to CV_8U
        cvtColor(abs_grad_x, grad, COLOR_GRAY2BGR);
        return MatToUIImage(grad);
    } else {
        /// Gradient Y
        Sobel( gray, grad_y, ddepth, 0, 1, 3, scale, delta, BORDER_DEFAULT );
        convertScaleAbs( grad_y, abs_grad_y );
        cvtColor(abs_grad_y, grad, COLOR_GRAY2BGR);
        return MatToUIImage(grad);
    }
}

+ (UIImage *)laplacian:(UIImage *) image {
    Mat src, gray, dst;
    Mat abs_dst;

    UIImageToMat(image, src);
    GaussianBlur( src, src, cv::Size(3,3), 0, 0, BORDER_DEFAULT );

    /// Convert it to GRAY
    cvtColor( src, gray, COLOR_BGR2GRAY );
    Laplacian(gray, dst, CV_16S);
    convertScaleAbs( dst, abs_dst ); // Convert back to CV_8U
    cvtColor(abs_dst, abs_dst, COLOR_GRAY2BGR);
    return MatToUIImage(abs_dst);
}

+ (UIImage *)canny:(UIImage *) image lower:(int) lower upper:(int) upper {
    Mat src, gray, dst;
    Mat abs_dst;

    UIImageToMat(image, src);
    GaussianBlur( src, src, cv::Size(3,3), 0, 0, BORDER_DEFAULT );

    /// Convert it to GRAY
    cvtColor( src, gray, COLOR_BGR2GRAY );
    Canny(gray, dst, lower, upper);
    convertScaleAbs( dst, abs_dst ); // Convert back to CV_8U
    cvtColor(abs_dst, abs_dst, COLOR_GRAY2BGR);
    return MatToUIImage(abs_dst);
}

+ (UIImage *)mask3x3:(UIImage *) image mask:(NSArray *) mask divisor:(int) divisor {
    Mat src, gray, dst;
    
    float kernelData[9];
    NSInteger count = [mask count];
    
    for (int k = 0; k < count; ++k) {
        kernelData[k] = [[mask objectAtIndex:(NSUInteger)k] floatValue];
//        NSLog(@"%f", kernelData[k]);
    }

    for (int i = 0; i < 9; ++i) {
        kernelData[i] = (kernelData[i] / divisor);
    }
    Mat kernel(3,3, CV_32F, kernelData);

    UIImageToMat(image, src);
    filter2D(src, dst, CV_8U, kernel, cv::Point(-1,-1), 0, BORDER_DEFAULT );
    return MatToUIImage(dst);
}

+ (UIImage *)sharpen:(UIImage *) image type:(int) type border:(int) border {
    Mat src, kernel, dst;
    
    float kernelData1[9] = {0,-1,0,-1,5,-1,0,-1,0};
    float kernelData2[9] = {-1,-1,-1,-1,9,-1,-1,-1,-1};
    float kernelData3[9] = {1,-2,1,-2,5,-2,1,-2,1};
    
    if (type == 0) {
        Mat temp(3,3, CV_32F, kernelData1);
        kernel = temp.clone();
    } else if (type == 1) {
        Mat temp(3,3, CV_32F, kernelData2);
        kernel = temp.clone();
    } else {
        Mat temp(3,3, CV_32F, kernelData3);
        kernel = temp.clone();
    }

    UIImageToMat(image, src);
    filter2D(src, dst, CV_8U, kernel, cv::Point(-1,-1), 0, border);
    return MatToUIImage(dst);
}

+ (UIImage *)prewitt:(UIImage *) image type:(int) type border:(int) border {
    Mat src, kernel, dst;
    
    float kernelData1[9] = {1,1,1,0,1,0,-1,-1,-1};
    float kernelData2[9] = {1,0,-1, 1,1,-1, 1,0,-1};
    
    if (type == 0) {
        Mat temp(3,3, CV_32F, kernelData1);
        kernel = temp.clone();
    } else {
        Mat temp(3,3, CV_32F, kernelData2);
        kernel = temp.clone();
    }

    UIImageToMat(image, src);
    filter2D(src, dst, CV_8U, kernel, cv::Point(-1,-1), 0, border);
    return MatToUIImage(dst);
}

+ (UIImage *)edgeDetection:(UIImage *) image type:(int) type border:(int) border {
    Mat src, kernel, dst;
    
    float kernelData0[9] = { 1, 1, 0, 1, 1, -1, 0, -1, -1 };
    float kernelData1[9] = { 1, 1, 1, 0, 1, 0, -1, -1, -1 };
    float kernelData2[9] = { 0, 1, 1 , -1, 1, 1 , -1, -1, 0 };
    float kernelData3[9] = { 1, 0, -1 , 1, 1, -1 , 1, 0, -1 };
    float kernelData4[9] = { -1, 0, 1 ,- 1, 1, 1 , -1, 0, 1 };
    float kernelData5[9] = { 0, -1, -1 , 1, 1, -1 , 1, 1, 0 };
    float kernelData6[9] = { -1, -1, -1 , 0, 1, 0 , 1, 1, 1 };
    float kernelData7[9] = { -1, -1, 0 , -1, 1, 1 , 0, 1, 1 };
    
    if (type == 0) {
        Mat temp(3,3, CV_32F, kernelData0);
        kernel = temp.clone();
    } else if (type == 1) {
        Mat temp(3,3, CV_32F, kernelData1);
        kernel = temp.clone();
    } else if (type == 2) {
        Mat temp(3,3, CV_32F, kernelData2);
        kernel = temp.clone();
    } else if (type == 3) {
        Mat temp(3,3, CV_32F, kernelData3);
        kernel = temp.clone();
    } else if (type == 4) {
        Mat temp(3,3, CV_32F, kernelData4);
        kernel = temp.clone();
    } else if (type == 5) {
        Mat temp(3,3, CV_32F, kernelData5);
        kernel = temp.clone();
    } else if (type == 6) {
        Mat temp(3,3, CV_32F, kernelData6);
        kernel = temp.clone();
    } else {
        Mat temp(3,3, CV_32F, kernelData7);
        kernel = temp.clone();
    }

    UIImageToMat(image, src);
    filter2D(src, dst, CV_8U, kernel, cv::Point(-1,-1), 0, border);
    return MatToUIImage(dst);
}

+ (UIImage *)morphology:(UIImage *) image operation:(int) op element:(int) element n:(int) n border:(int) border {
    Mat src, kernel, dst;
    UIImageToMat(image, src);
    
    kernel = getStructuringElement(element, cv::Size(3,3), cv::Point(-1,-1));
    morphologyEx(src, dst, op, kernel, cv::Point(-1,-1), n, border);
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
