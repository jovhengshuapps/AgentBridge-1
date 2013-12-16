//
//  ABridge_TabBarViewController.m
//  AgentBridge
//
//  Created by host24_iOS Dev on 12/16/13.
//  Copyright (c) 2013 host24_iOS Dev. All rights reserved.
//

#import "ABridge_TabBarViewController.h"

@interface ABridge_TabBarViewController ()

@end

@implementation ABridge_TabBarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [((UITabBarItem*)[self.tabBar.items objectAtIndex:0]) setFinishedSelectedImage:[UIImage imageNamed:@"activity_icon"] withFinishedUnselectedImage:[UIImage imageNamed:@"activity_icon"]];
    
    [((UITabBarItem*)[self.tabBar.items objectAtIndex:1]) setFinishedSelectedImage:[UIImage imageNamed:@"pops_icon"] withFinishedUnselectedImage:[UIImage imageNamed:@"pops_icon"]];
    
    [((UITabBarItem*)[self.tabBar.items objectAtIndex:2]) setFinishedSelectedImage:[UIImage imageNamed:@"buyers_icon"] withFinishedUnselectedImage:[UIImage imageNamed:@"buyers_icon"]];
    
    [((UITabBarItem*)[self.tabBar.items objectAtIndex:3]) setFinishedSelectedImage:[UIImage imageNamed:@"referral_icon"] withFinishedUnselectedImage:[UIImage imageNamed:@"referral_icon"]];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
