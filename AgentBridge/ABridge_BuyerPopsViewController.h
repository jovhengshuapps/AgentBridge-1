//
//  ABridge_BuyerPopsViewController.h
//  AgentBridge
//
//  Created by host24_iOS Dev on 11/27/13.
//  Copyright (c) 2013 host24_iOS Dev. All rights reserved.
//

#import "ABridge_ParentViewController.h"
#import "ABridge_PropertyPagesViewController.h"

@interface ABridge_BuyerPopsViewController : ABridge_ParentViewController <UIPageViewControllerDataSource, NSURLConnectionDelegate, ABridge_PropertyPagesViewControllerDelegate, UIScrollViewDelegate>

@property (strong, nonatomic) UIPageViewController *pageController;
@property (assign, nonatomic) BOOL is_saved;
@property (assign, nonatomic) NSInteger buyer_id;
@property (strong, nonatomic) NSString *buyer_name;

@end
