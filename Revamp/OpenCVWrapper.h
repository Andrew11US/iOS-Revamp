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

// Shows OpenCV version
+ (NSString *)openCVVersion;
// Makes image grayscale
+ (UIImage *)makeGray:(UIImage *) image;

@end

NS_ASSUME_NONNULL_END
