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
                int output = computeContrast(src.at<Vec3b>(y,x)[c], r1, r2, s1, s2);
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
    Mat src, gray, thresh, opening, item_bg, dist_transform, item_fg, unknown, markers, dst;
    Mat kernel;
    
    UIImageToMat(image, src);
    cvtColor(src, gray, COLOR_BGR2GRAY);
    threshold(gray, thresh, 0, 255, THRESH_BINARY_INV + THRESH_OTSU);
    
    kernel = getStructuringElement(MORPH_ELLIPSE, cv::Size(3,3), cv::Point(-1,-1));
    morphologyEx(thresh, opening, MORPH_OPEN, kernel, cv::Point(-1,-1), 1);
    dilate(opening, item_bg, kernel);
    
    distanceTransform(opening, dist_transform, DIST_L2, 5);
    threshold(dist_transform, item_fg, 1, 255, THRESH_BINARY);
    morphologyEx(item_fg, item_fg, MORPH_ERODE, kernel, cv::Point(-1,-1), 12);
    item_fg.convertTo(item_fg, CV_8U);
    subtract(item_bg, item_fg, unknown);
    connectedComponents(item_fg, markers);
    
    
    
    markers.convertTo(markers, CV_8UC1);
    
//    img_gray = cv2.cvtColor(image,cv2.COLOR_BGR2GRAY)
//    ret2,thresh = cv2.threshold(img_gray,0,255,cv2.THRESH_BINARY_INV+cv2.THRESH_OTSU)
//    kernel = np.ones((3,3),np.uint8)
//    opening = cv2.morphologyEx(thresh,cv2.MORPH_OPEN,kernel, iterations = 1)
//    sure_bg = cv2.dilate(opening,kernel,iterations=1)
//    dist_transform = cv2.distanceTransform(opening,cv2.DIST_L2,5)
    //    ret, sure_fg = cv2.threshold(dist_transform,0.5*dist_transform.max(),255,0)
    //    sure_fg = np.uint8(sure_fg)
    //    unknown = cv2.subtract(sure_bg,sure_fg)
    //    ret, markers = cv2.connectedComponents(sure_fg)
    
//    markers = markers+1
//    markers[unknown==255] = 0
//    markers2 = cv2.watershed(image, markers)
//    img gray[markers2 == -1] = 255
    
    

//    for (int i = 0; i < markers.rows; i++) {
//        for (int j = 0; j < markers.cols; j++) {
//            markers.intPtr(i, j)[0] = markers.ucharPtr(i, j)[0] + 1;
//            if (unknown.ucharPtr(i, j)[0] == 255) {
//                markers.intPtr(i, j)[0] = 0;
//            }
//        }
//    }
//    cv.cvtColor(src, src, cv.COLOR_RGBA2RGB, 0);
//    cv.watershed(src, markers);
//    // draw barriers
//    for (let i = 0; i < markers.rows; i++) {
//        for (let j = 0; j < markers.cols; j++) {
//            if (markers.intPtr(i, j)[0] == -1) {
//                src.ucharPtr(i, j)[0] = 255; // R
//                src.ucharPtr(i, j)[1] = 0; // G
//                src.ucharPtr(i, j)[2] = 0; // B
//            }
//        }
//    }
//    cv.imshow('canvasOutput', src);
    
    return MatToUIImage(markers);
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

    /// Convert image to GRAY
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

    /// Convert image to GRAY
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

    /// Convert image to GRAY
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

+ (UIImage *)thinning:(UIImage *) image {
    Mat src, dst, gray;
    UIImageToMat(image, src);
    cvtColor(src, gray, COLOR_BGR2GRAY);
    thinning(gray);
    cvtColor(gray, dst, COLOR_GRAY2RGB);
    return MatToUIImage(dst);
}

+ (NSMutableArray *)metrics:(UIImage *) image {
    Mat src, thresh, gray, canny_output;
    std::vector<std::vector<cv::Point> > contours;
    std::vector<Vec4i> hierarchy;
    
    UIImageToMat(image, src);
    /// Number of channels
    int channels = src.channels();
    /// Central points
    int cX = 0, cY = 0;
    /// Image dimensions
    int totalPixels = 0, width = 0, height = 0;
    double area = 0, perimeter = 0;
    
    cvtColor(src, gray, COLOR_BGR2GRAY);
    threshold(gray, thresh, 127, 255, THRESH_BINARY);
    /// Getting moments
    Moments m = moments(thresh, true);
    
    blur(gray, gray, cv::Size(3,3));
    Canny(gray, canny_output, 50, 100, 3);
    /// Calling findContours from canny threshold
    findContours(canny_output, contours, hierarchy, RETR_TREE, CHAIN_APPROX_SIMPLE, cv::Point(0, 0));
    
    /// Getting contour from std::vector
    std::vector<cv::Point> cnt = contours[0];
    /// Contour area and perimeter
    area = contourArea(cnt);
    perimeter = arcLength(cnt, true);
    
    /// Calculation of aspect ratio
    cv::Rect rect = boundingRect(cnt);
    double aspectRatio = (double)(rect.width) / rect.height;
    
    /// Calculation of extent
    int rect_area = rect.width*rect.height;
    double extent = double(area)/rect_area;
    
    /// Calculation of solidity
    std::vector<cv::Point> hull;
    convexHull(cnt, hull);
    double hull_area = contourArea(hull);
    double solidity = double(area) / hull_area;
    
    /// Calculation of equivalent diameter
    double eq_diameter = sqrt(4 * area/M_PI);
    
    // Calculating dimensions
    for (int i = 0; i < gray.rows; ++i) {
        width = 0;
        for (int j = 0; j < gray.cols; ++j) {
            width++;
            totalPixels++;
        }
        height++;
    }
    
    // Calculating central point
    if (int(m.m00) != 0) {
        cX = int(m.m10 / m.m00);
        cY = int(m.m01 / m.m00);
    }
    
    // Adding data to metrics NSArray
    NSMutableArray *arr = [NSMutableArray arrayWithObjects:@(m.m00),@(m.m01),@(m.m10),@(m.m11),@(m.mu20),@(m.mu11),@(m.mu02),@(m.mu30), nil];
    [arr addObject:@(cX)];
    [arr addObject:@(cY)];
    [arr addObject:@(width)];
    [arr addObject:@(height)];
    [arr addObject:@(totalPixels)];
    [arr addObject:@(channels)];
    [arr addObject:@(area)];
    [arr addObject:@(perimeter)];
    [arr addObject:@(aspectRatio)];
    [arr addObject:@(extent)];
    [arr addObject:@(solidity)];
    [arr addObject:@(eq_diameter)];
    return arr;
}

+ (NSString *)shapeDetector:(UIImage *) image {
    Mat src, thresh, gray;
    std::vector<std::vector<cv::Point>> contours;
    NSString *shape;
    
    /// Getting Mat from UIImage
    UIImageToMat(image, src);
    
    /// Converting to Gray
    cvtColor(src, gray, COLOR_BGR2GRAY);
    threshold(gray, thresh, 128, 255, THRESH_BINARY);
    /// Calling findContours from threshold
    findContours(thresh, contours, RETR_LIST, CHAIN_APPROX_SIMPLE, cv::Point(0,0));
    
    /// Getting contour from std::vector
    std::vector<cv::Point> cnt = contours[0];
    
    std::vector<cv::Point> approx;
    approxPolyDP(cnt, approx, 3, true);
    cv::Rect rect = boundingRect(cnt);
    double aspectRatio = (double)(rect.width) / rect.height;

    /// Detecting shape using approximation of polygon
    if (approx.size() == 3) {
        shape = @"Triangle";
    } else if (approx.size() == 4) {
        if (aspectRatio >= 0.95 && aspectRatio <= 1.05) {
            shape = @"Square";
        } else {
            shape = @"Rectangle";
        }
    } else if (approx.size() == 5) {
        shape = @"Pentagon";
    } else {
        shape = @"Circle";
    }
    
    return shape;
}



// MARK: - helping functions
private void thinning(Mat& src) {
    src /= 255;
    
    cv::Mat prev = cv::Mat::zeros(src.size(), CV_8UC1);
    cv::Mat diff;
    
    do {
        thinningIteration(src, 0);
        thinningIteration(src, 1);
        cv::absdiff(src, prev, diff);
        src.copyTo(prev);
    } while (cv::countNonZero(diff) > 0);
    
    src *= 255;
}

private void thinningIteration(Mat& src, int iteration) {
    cv::Mat marker = cv::Mat::zeros(src.size(), CV_8UC1);
    
    for (int i = 1; i < src.rows; i++) {
        for (int j = 1; j < src.cols; j++) {
            uchar p2 = src.at<uchar>(i-1, j);
            uchar p3 = src.at<uchar>(i-1, j+1);
            uchar p4 = src.at<uchar>(i, j+1);
            uchar p5 = src.at<uchar>(i+1, j+1);
            uchar p6 = src.at<uchar>(i+1, j);
            uchar p7 = src.at<uchar>(i+1, j-1);
            uchar p8 = src.at<uchar>(i, j-1);
            uchar p9 = src.at<uchar>(i-1, j-1);
            
            int C  = ((!p2) & (p3 | p4)) + ((!p4) & (p5 | p6)) +
            ((!p6) & (p7 | p8)) + ((!p8) & (p9 | p2));
            int N1 = (p9 | p2) + (p3 | p4) + (p5 | p6) + (p7 | p8);
            int N2 = (p2 | p3) + (p4 | p5) + (p6 | p7) + (p8 | p9);
            int N  = N1 < N2 ? N1 : N2;
            int m  = iteration == 0 ? ((p6 | p7 | !p9) & p8) : ((p2 | p3 | !p5) & p4);
            
            if (C == 1 && (N >= 2 && N <= 3) & (m == 0))
                marker.at<uchar>(i,j) = 1;
        }
    }
    
    src &= ~marker;
}

private int computeContrast(int x, int r1, int r2, int s1, int s2)
{
    float result = 0.0;
    if (0 <= x && x <= r1) {
        result = s1/r1 * x;
    } else if (r1 < x && x <= r2) {
        result = ((s2 - s1)/(r2 - r1)) * (x - r1) + s1;
    } else if (r2 < x && x <= 255) {
        result = ((255 - s2)/(255 - r2)) * (x - r2) + s2;
    }
    return (int)result;
}

@end
