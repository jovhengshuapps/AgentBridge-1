//
//  ABridge_AgentNetworkPagesViewController.h
//  AgentBridge
//
//  Created by host24_iOS Dev on 11/19/13.
//  Copyright (c) 2013 host24_iOS Dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "AgentProfile.h"

@interface ABridge_AgentNetworkPagesViewController : UIViewController <UITableViewDataSource, MFMailComposeViewControllerDelegate>
    
    @property (assign, nonatomic) NSInteger index;
    @property (strong, nonatomic) AgentProfile *profileData;
@end
