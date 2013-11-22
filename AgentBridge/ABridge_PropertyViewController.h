//
//  ABridge_PropertyViewController.h
//  AgentBridge
//
//  Created by host24_iOS Dev on 11/13/13.
//  Copyright (c) 2013 host24_iOS Dev. All rights reserved.
//

#import "ABridge_ParentViewController.h"
#import "ABridge_PropertyPagesViewController.h"

@interface ABridge_PropertyViewController : ABridge_ParentViewController <UIPageViewControllerDataSource, NSURLConnectionDelegate, ABridge_PropertyPagesViewControllerDelegate, UIScrollViewDelegate>

@property (strong, nonatomic) UIPageViewController *pageController;

@end
