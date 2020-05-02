//
//  lut.cpp
//  Revamp
//
//  Created by Andrew on 5/2/20.
//  Copyright © 2020 Andrii Halabuda. All rights reserved.
//

#include <stdio.h>
#include <opencv2/imgproc/imgproc_c.h>

// MARK: - C++ lut usage
/*
cv::Mat mInput_8UC1 = cv::Mat(512,512,CV_8UC1, cv::Scalar(0));

for(int j=0; j<mInput_8UC1.rows; ++j)
    for(int i=0; i<mInput_8UC1.cols; ++i)
    {
        mInput_8UC1.at<unsigned char>(j,i) = i/2;
    }


// unfortunately, we have to convert to grayscale, because OpenCV doesnt allow LUT from single channel to 3 channel directly. (LUT must have same number of channels as mInput_8UC1)
cv::Mat mInput_8UC3;
cv::cvtColor(mInput_8UC1, mInput_8UC3, CV_GRAY2BGR);

// create replacement look-up-table:
// 1. basic => gray values of given intensity
cv::Mat mlookUpTable_8UC1(1, 256, CV_8UC1);
cv::Mat mlookUpTable_8UC3(1, 256, CV_8UC3);

for( int i = 0; i < 256; ++i)
{
    mlookUpTable_8UC1.at<uchar>(0,i) = uchar(255-i);//Just an Inverse
    mlookUpTable_8UC3.at<cv::Vec3b>(0,i) = cv::Vec3b(255-i,255-i,0);
}

// LUT will fail if used this way: cv::LUT(mInput_8UC1, mlookUpTable_8UC3, m3CLUTOutput_8UC3); - with assertion failed: (lutcn == cn || lutcn == 1) because LUT has 3 channels but mInput_8UC1 only has 1 channel.

cv::Mat m1CLUTOutput_8UC3,m3CLUTOutput_8UC3,mOutput_8UC1;

cv::LUT(mInput_8UC1, mlookUpTable_8UC1, mOutput_8UC1);//Simple 1D LUT
cv::LUT(mInput_8UC3, mlookUpTable_8UC1, m1CLUTOutput_8UC3);//In this case same LUT is used for all the 3 Channels
cv::LUT(mInput_8UC3, mlookUpTable_8UC3, m3CLUTOutput_8UC3);//Individual Channel LUT is Substituited

*/
