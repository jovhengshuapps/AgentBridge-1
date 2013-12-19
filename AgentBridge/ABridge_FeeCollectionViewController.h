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
//#import "AuthNet.h"

@interface ABridge_FeeCollectionViewController : ABridge_ParentViewController <UITextFieldDelegate, UIScrollViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate/*, AuthNetDelegate*/>

@property (assign, nonatomic) NSInteger referral_id;

@end
