//
//  ABridge_PropertyPagesViewController.h
//  AgentBridge
//
//  Created by host24_iOS Dev on 11/14/13.
//  Copyright (c) 2013 host24_iOS Dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Property.h"

@interface ABridge_PropertyPagesViewController : UIViewController <UIScrollViewDelegate>

@property (assign, nonatomic) NSInteger index;
@property (strong, nonatomic) Property *propertyDetails;
@end
