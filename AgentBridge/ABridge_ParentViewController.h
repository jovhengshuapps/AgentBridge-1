//
//  ABridge_ParentViewController.h
//  AgentBridge
//
//  Created by host24_iOS Dev on 11/13/13.
//  Copyright (c) 2013 host24_iOS Dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "ECSlidingViewController.h"

@interface ABridge_ParentViewController : UIViewController

@property (strong, nonatomic) NSMutableArray *arrayOfURLConnection;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewTopBar;

- (IBAction)revealMenu:(id)sender;
- (IBAction)revealSearch:(id)sender;

- (NSURLConnection*)urlConnectionWithURLString:(NSString*)urlString andParameters:(NSString*)parameters;
- (void)addURLConnection:(NSURLConnection*)urlConnection;

@end
