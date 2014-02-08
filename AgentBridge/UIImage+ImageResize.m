//
//  UIImage+ImageResize.m
//  AgentBridge
//
//  Created by host24_iOS Dev on 2/8/14.
//  Copyright (c) 2014 host24_iOS Dev. All rights reserved.
//

#import "UIImage+ImageResize.h"

@implementation UIImage (ImageResize)

- (UIImage*) resizeImageToFitWidth:(CGFloat)width fromData:(NSData*)data{
    
    float widthScale = 0;
    float heightScale = 0;
    widthScale = width/self.size.width;
    heightScale = width/self.size.height;
    float scale = MIN(widthScale, heightScale);
    CGSize newSize = CGSizeMake((int)(self.size.width * scale), (int)(self.size.height * scale));
    
    
    if (newSize.width < newSize.height) {
        float dif = newSize.height - newSize.width;
        newSize = CGSizeMake(newSize.width + dif, newSize.height + dif);
    }

    float finalScale = MIN(width/newSize.width, width/newSize.height);
    
    return [UIImage imageWithData:data scale:finalScale+1.0f];
    
}

@end
