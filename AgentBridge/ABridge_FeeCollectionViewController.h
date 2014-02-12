//
//  ABridge_FeeCollectionViewController.h
//  AgentBridge
//
//  Created by host24_iOS Dev on 12/17/13.
//  Copyright (c) 2013 host24_iOS Dev. All rights reserved.
//

#import "ABridge_ParentViewController.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import <MessageUI/MFMailComposeViewController.h>

@protocol ABridge_FeeCollectionViewControllerDelegate <NSObject>

-(void) transactionCompletedSuccessfully;

@end

@interface ABridge_FeeCollectionViewController : ABridge_ParentViewController <UITextFieldDelegate, UIScrollViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UIAlertViewDelegate, UIWebViewDelegate, MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) NSString *referral_id;
@property (strong, nonatomic) NSString *referral_name; //client_name
@property (assign, nonatomic) CGFloat referral_fee;
@property (strong, nonatomic) NSString *referral_agentname;

@property (strong, nonatomic) NSString *client_number;
@property (strong, nonatomic) NSString *client_email;
@property (strong, nonatomic) NSString *client_address;
@property (strong, nonatomic) NSString *client_type;

@property (strong, nonatomic) NSNumber *user_id;

@property (assign, nonatomic) id<ABridge_FeeCollectionViewControllerDelegate> delegate;

@property (strong, nonatomic) NSString *grossCommissionValue;

@end
