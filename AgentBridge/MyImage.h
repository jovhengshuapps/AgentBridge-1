//
//  MyImage.h
//  AgentBridge
//
//  Created by host24_iOS Dev on 2/8/14.
//  Copyright (c) 2014 host24_iOS Dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface MyImage : NSObject

+ (UIImage*)imageWithImage:(UIImage *)image convertToWidth:(float)width covertToHeight:(float)height;
+ (UIImage*)imageWithImage:(UIImage *)image convertToHeight:(float)height;
+ (UIImage*)imageWithImage:(UIImage *)image convertToWidth:(float)width;
+ (UIImage*)imageWithImage:(UIImage *)image fitInsideWidth:(float)width fitInsideHeight:(float)height;
+ (UIImage*)imageWithImage:(UIImage *)image fitOutsideWidth:(float)width fitOutsideHeight:(float)height;
+ (UIImage*)imageWithImage:(UIImage *)image cropToWidth:(float)width cropToHeight:(float)height;
+ (UIImage*)imageWithImage:(UIImage *)image resizeToFitWidth:(float)width;
@end
