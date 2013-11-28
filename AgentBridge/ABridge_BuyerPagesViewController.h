//
//  ABridge_BuyerPagesViewController.h
//  AgentBridge
//
//  Created by host24_iOS Dev on 11/14/13.
//  Copyright (c) 2013 host24_iOS Dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Buyer.h"

@protocol ABridge_BuyerPagesViewControllerDelegate <NSObject>

-(void)viewSavedPopsWithBuyerId:(NSInteger)buyer_id;
-(void)viewNewPopsWithBuyerId:(NSInteger)buyer_id;

@end
@interface ABridge_BuyerPagesViewController : UIViewController

@property (assign, nonatomic) NSInteger index;
@property (strong, nonatomic) Buyer *buyerDetails;
@property (assign, nonatomic) id<ABridge_BuyerPagesViewControllerDelegate> delegate;
@end
