//
//  ABridge_ActivityAgentProfileViewController.h
//  AgentBridge
//
//  Created by host24_iOS Dev on 12/13/13.
//  Copyright (c) 2013 host24_iOS Dev. All rights reserved.
//

#import "ABridge_ParentViewController.h"
#import <MessageUI/MFMailComposeViewController.h>
#import "ASIHTTPRequest.h"

@interface ABridge_ActivityAgentProfileViewController : ABridge_ParentViewController <UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) NSString *user_id;

@end
