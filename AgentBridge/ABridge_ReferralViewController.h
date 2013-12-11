//
//  ABridge_ReferralViewController.h
//  AgentBridge
//
//  Created by host24_iOS Dev on 11/14/13.
//  Copyright (c) 2013 host24_iOS Dev. All rights reserved.
//

#import "ABridge_ParentViewController.h"

@interface ABridge_ReferralViewController : ABridge_ParentViewController <UIPageViewControllerDataSource, NSURLConnectionDelegate>

@property (strong, nonatomic) UIPageViewController *pageController;

-(void) scrollToReferralIn:(NSString*)client_id;
-(void) scrollToReferralOut:(NSString*)client_id;

@end
