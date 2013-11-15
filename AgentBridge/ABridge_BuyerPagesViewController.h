//
//  ABridge_BuyerPagesViewController.h
//  AgentBridge
//
//  Created by host24_iOS Dev on 11/14/13.
//  Copyright (c) 2013 host24_iOS Dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Buyer.h"

@interface ABridge_BuyerPagesViewController : UIViewController

@property (assign, nonatomic) NSInteger index;
@property (strong, nonatomic) Buyer *buyerDetails;
@end
