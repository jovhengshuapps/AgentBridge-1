//
//  ABridge_ActivityAgentPOPsViewController.h
//  AgentBridge
//
//  Created by host24_iOS Dev on 12/13/13.
//  Copyright (c) 2013 host24_iOS Dev. All rights reserved.
//

#import "ABridge_ParentViewController.h"
#import "ABridge_PropertyPagesViewController.h"
#import "ASIHTTPRequest.h"

@interface ABridge_ActivityAgentPOPsViewController : ABridge_ParentViewController<UIPageViewControllerDataSource, NSURLConnectionDelegate, ABridge_PropertyPagesViewControllerDelegate, UIScrollViewDelegate>

@property (strong, nonatomic) UIPageViewController *pageController;

@property (strong, nonatomic) NSString *user_id;
@property (strong, nonatomic) NSString *user_name;

@end
