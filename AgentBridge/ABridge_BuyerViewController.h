//
//  ABridge_BuyerViewController.h
//  AgentBridge
//
//  Created by host24_iOS Dev on 11/14/13.
//  Copyright (c) 2013 host24_iOS Dev. All rights reserved.
//

#import "ABridge_ParentViewController.h"
#import "ABridge_BuyerPagesViewController.m"

@interface ABridge_BuyerViewController : ABridge_ParentViewController <UIPageViewControllerDataSource, NSURLConnectionDelegate, ABridge_BuyerPagesViewControllerDelegate>

@property (strong, nonatomic) UIPageViewController *pageController;

@end
