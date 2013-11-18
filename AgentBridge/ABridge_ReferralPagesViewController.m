//
//  ABridge_ReferralPagesViewController.m
//  AgentBridge
//
//  Created by host24_iOS Dev on 11/14/13.
//  Copyright (c) 2013 host24_iOS Dev. All rights reserved.
//

#import "ABridge_ReferralPagesViewController.h"

@interface ABridge_ReferralPagesViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imagePicture;
@property (weak, nonatomic) IBOutlet UILabel *labelAgentName;
@property (weak, nonatomic) IBOutlet UILabel *labelAddress;
@property (weak, nonatomic) IBOutlet UILabel *labelStateCountry;
@property (weak, nonatomic) IBOutlet UIImageView *imagePendingAccepted;
@property (weak, nonatomic) IBOutlet UILabel *labelReferralFee;
@property (weak, nonatomic) IBOutlet UILabel *labelBuyerName;
@property (weak, nonatomic) IBOutlet UILabel *labelPrice;
@property (weak, nonatomic) IBOutlet UILabel *labelPage;

- (IBAction)saveBuyerVCard:(id)sender;
@end

@implementation ABridge_ReferralPagesViewController
@synthesize index;
@synthesize referralDetails;

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
    // Do any additional setup after loading the view from its nib.
    self.labelPage.text = [NSString stringWithFormat:@"%li",(long)self.index+1];
    
    self.labelAgentName.text = self.referralDetails.agent_name;
    self.labelAddress.text = self.referralDetails.city;
    self.labelStateCountry.text = [NSString stringWithFormat:@"%@, %@",self.referralDetails.state,self.referralDetails.countries_iso_code_3];
    
    self.labelBuyerName.text = self.referralDetails.client_name;
    self.labelPrice.text = [NSString stringWithFormat:@"$%@ - $%@",self.referralDetails.price_1, self.referralDetails.price_2];
    
    self.labelReferralFee.text = [NSString stringWithFormat:@"Referral Agreement (%@)",self.referralDetails.referral_fee];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveBuyerVCard:(id)sender {
}
@end
