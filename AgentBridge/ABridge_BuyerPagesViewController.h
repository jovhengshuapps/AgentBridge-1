//
//  ABridge_BuyerPagesViewController.h
//  AgentBridge
//
//  Created by host24_iOS Dev on 12/3/13.
//  Copyright (c) 2013 host24_iOS Dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Buyer.h"


@interface ABridge_BuyerPagesViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIView *viewTop;
@property (strong, nonatomic) IBOutlet UILabel *labelBuyerName;
@property (strong, nonatomic) IBOutlet UILabel *labelBuyerType;
@property (strong, nonatomic) IBOutlet UILabel *labelBuyerZip;
@property (strong, nonatomic) IBOutlet UILabel *labelPrice;
@property (strong, nonatomic) IBOutlet UILabel *labelExpiry;
@property (strong, nonatomic) IBOutlet UILabel *labelMatching;
@property (strong, nonatomic) IBOutlet UITextView *textViewDescription;
@property (strong, nonatomic) IBOutlet UIImageView *imageProperty;
@property (strong, nonatomic) IBOutlet UIButton *buttonSaved;
@property (strong, nonatomic) IBOutlet UIButton *buttonNew;


@property (strong, nonatomic) Buyer *buyerDetail;
@property (assign, nonatomic) NSUInteger index;
@end
