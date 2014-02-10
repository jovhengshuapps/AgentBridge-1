//
//  UIImage+ImageResize.h
//  AgentBridge
//
//  Created by host24_iOS Dev on 2/8/14.
//  Copyright (c) 2014 host24_iOS Dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ImageResize)
- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize;
@end
