//
//  ABridge_ActivityPagesViewController.h
//  AgentBridge
//
//  Created by host24_iOS Dev on 11/14/13.
//  Copyright (c) 2013 host24_iOS Dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Activity.h"
#import "ASIHTTPRequest.h"

@interface ABridge_ActivityPagesViewController : UIViewController <UIWebViewDelegate, NSURLConnectionDelegate>

@property (assign, nonatomic) NSInteger index;
@property (strong, nonatomic) Activity *activityDetail;
@end
