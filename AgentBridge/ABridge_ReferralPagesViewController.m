//
//  ABridge_ReferralPagesViewController.m
//  AgentBridge
//
//  Created by host24_iOS Dev on 11/14/13.
//  Copyright (c) 2013 host24_iOS Dev. All rights reserved.
//

#import "ABridge_ReferralPagesViewController.h"
#import "Constants.h"

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
@property (weak, nonatomic) IBOutlet UIView *viewForName;
@property (weak, nonatomic) IBOutlet UILabel *labelInfo;
@property (weak, nonatomic) IBOutlet UILabel *labelIntention;

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
    // Add a bottomBorder.
    CALayer *bottomBorder = [CALayer layer];
    
    bottomBorder.frame = CGRectMake(0.0f, self.viewForName.frame.size.height-1.0f, self.viewForName.frame.size.width, 1.0f);
    
    bottomBorder.backgroundColor = [UIColor colorWithRed:191.0f/255.0f green:191.0f/255.0f blue:191.0f/255.0f alpha:1.0f].CGColor;
    
    [self.viewForName.layer addSublayer:bottomBorder];
    
    
    self.labelPage.text = [NSString stringWithFormat:@"%li",(long)self.index+1];
    
    
    self.labelAgentName.text = self.referralDetails.agent_name;
    self.labelAddress.text = self.referralDetails.city;
    self.labelStateCountry.text = [NSString stringWithFormat:@"%@, %@",self.referralDetails.state_code,self.referralDetails.countries_iso_code_3];
    
    self.labelAgentName.font = FONT_OPENSANS_REGULAR(12.0f);
    self.labelAddress.font = FONT_OPENSANS_REGULAR(12.0f);
    self.labelStateCountry.font = FONT_OPENSANS_REGULAR(12.0f);
    
    self.labelBuyerName.text = self.referralDetails.client_name;
    NSNumberFormatter * formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterCurrencyStyle;
    formatter.currencyCode = @"USD";
    
    NSMutableString *priceText = [NSMutableString stringWithString:@""];
    [priceText appendString:[formatter stringFromNumber: [NSNumber numberWithDouble:[self.referralDetails.price_1 doubleValue]]]];
    if ([self.referralDetails.price_2 class] != Nil) {
        [priceText appendFormat:@" - %@",[formatter stringFromNumber: [NSNumber numberWithDouble:[self.referralDetails.price_2 doubleValue]]]];
    }
    self.labelPrice.text = priceText;
    self.labelIntention.text = CLIENT_INTENTION([self.referralDetails.client_intention integerValue]);
    
    self.labelReferralFee.text = [NSString stringWithFormat:@"Referral Agreement (%@)",self.referralDetails.referral_fee];
    
    
    self.labelBuyerName.font = FONT_OPENSANS_REGULAR(12.0f);
    self.labelPrice.font = FONT_OPENSANS_REGULAR(12.0f);
    self.labelReferralFee.font = FONT_OPENSANS_REGULAR(12.0f);
    self.labelInfo.font = FONT_OPENSANS_REGULAR(12.0f);
    self.labelIntention.font = FONT_OPENSANS_REGULAR(12.0f);
    
    if (self.referralDetails.image_data == nil) {
        self.referralDetails.image_data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.referralDetails.image]];
    }
    
    self.imagePicture.image = [UIImage imageWithData:self.referralDetails.image_data];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveBuyerVCard:(id)sender {
    NSLog(@"name:%@",self.referralDetails.client_name);
    CFErrorRef error = NULL;
     ABAddressBookRef iPhoneAddressBook = ABAddressBookCreate();
    CFRetain(iPhoneAddressBook);
    
     ABRecordRef newPerson = ABPersonCreate();
    CFRetain(newPerson);
    
    ABRecordSetValue(newPerson, kABPersonFirstNameProperty, (__bridge CFTypeRef)(self.referralDetails.client_name), &error);
    ABRecordSetValue(newPerson, kABPersonLastNameProperty, (__bridge CFTypeRef)(self.referralDetails.client_name), &error);
    ABRecordSetValue(newPerson, kABPersonOrganizationProperty, @"Agent Bridge", &error);
    ABRecordSetValue(newPerson, kABPersonJobTitleProperty, CLIENT_INTENTION([self.referralDetails.client_intention integerValue]), &error);
    
    //Client Number
    ABMutableMultiValueRef multiPhone = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    ABMultiValueAddValueAndLabel(multiPhone, (__bridge CFTypeRef)(self.referralDetails.client_number), kABPersonPhoneMobileLabel, NULL);
    ABRecordSetValue(newPerson, kABPersonPhoneProperty, multiPhone,nil);
    CFRelease(multiPhone);
    
    //Client Email
    ABMutableMultiValueRef multiEmail = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    ABMultiValueAddValueAndLabel(multiEmail, (__bridge CFTypeRef)(self.referralDetails.client_email), kABWorkLabel, NULL);
    ABRecordSetValue(newPerson, kABPersonEmailProperty, multiEmail, &error);
    CFRelease(multiEmail);
    
    //Client Address
    ABMutableMultiValueRef multiAddress = ABMultiValueCreateMutable(kABMultiDictionaryPropertyType);
    NSMutableDictionary *addressDictionary = [[NSMutableDictionary alloc] init];
    [addressDictionary setObject:self.referralDetails.client_address_1 forKey:(NSString *) kABPersonAddressStreetKey];
    [addressDictionary setObject:self.referralDetails.client_city forKey:(NSString *)kABPersonAddressCityKey];
    [addressDictionary setObject:self.referralDetails.client_state_name forKey:(NSString *)kABPersonAddressStateKey];
    [addressDictionary setObject:self.referralDetails.client_zip forKey:(NSString *)kABPersonAddressZIPKey];
    [addressDictionary setObject:self.referralDetails.client_country_name forKey:(NSString *)kABPersonAddressCountryKey];
    ABMultiValueAddValueAndLabel(multiAddress, (__bridge CFTypeRef)(addressDictionary), kABWorkLabel, NULL);
    ABRecordSetValue(newPerson, kABPersonAddressProperty, multiAddress,&error);
    CFRelease(multiAddress);
    
    ABAddressBookAddRecord(iPhoneAddressBook, newPerson, &error);
    
    
    CFRelease(newPerson);
    CFRelease(iPhoneAddressBook);
    
    if (ABAddressBookSave(iPhoneAddressBook, &error))
    {
        NSLog(@"Save!");
    }
    else {
        NSLog(@"error!!");
    }
}
@end
