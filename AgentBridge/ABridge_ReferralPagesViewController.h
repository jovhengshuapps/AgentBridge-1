//
//  ABridge_ReferralPagesViewController.h
//  AgentBridge
//
//  Created by host24_iOS Dev on 11/14/13.
//  Copyright (c) 2013 host24_iOS Dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import "Referral.h"
#import "ASIHTTPRequest.h"

@interface ABridge_ReferralPagesViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>

@property (assign, nonatomic) NSInteger index;
@property (strong, nonatomic) Referral *referralDetails;
@end
