//
//  ABridge_ReferralPagesViewController.m
//  AgentBridge
//
//  Created by host24_iOS Dev on 11/14/13.
//  Copyright (c) 2013 host24_iOS Dev. All rights reserved.
//

#import "ABridge_ReferralPagesViewController.h"
#import "Constants.h"
#import "ABridge_AppDelegate.h"
#import "LoginDetails.h"

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
@property (weak, nonatomic) IBOutlet UIButton *buttonVCard;
@property (weak, nonatomic) IBOutlet UIButton *buttonChangeStatus;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerStatus;
@property (weak, nonatomic) IBOutlet UIView *viewChangeStatus;
@property (weak, nonatomic) IBOutlet UITextView *textViewNote;
@property (weak, nonatomic) IBOutlet UILabel *labelNote;
@property (weak, nonatomic) IBOutlet UIButton *buttonSubmit;
@property (weak, nonatomic) IBOutlet UIButton *buttonCancel;
@property (weak, nonatomic) IBOutlet UIView *viewForButtons;
@property (strong, nonatomic) LoginDetails *loginDetail;
@property (strong, nonatomic) NSArray *arrayOfStatus;
@property (strong, nonatomic) NSString *urlStringStatusChange;
@property (assign, nonatomic) NSInteger statusPicked;
@property (assign, nonatomic) NSInteger statusPicked_test;
@property (assign, nonatomic) BOOL pickerChanged;

- (IBAction)changeStatus:(id)sender;
- (IBAction)submitChange:(id)sender;
- (IBAction)cancelChange:(id)sender;

- (IBAction)saveBuyerVCard:(id)sender;
@end

@implementation ABridge_ReferralPagesViewController
@synthesize index;
@synthesize referralDetails;
@synthesize loginDetail;
@synthesize arrayOfStatus;
@synthesize urlStringStatusChange;
@synthesize statusPicked;
@synthesize statusPicked_test;
@synthesize pickerChanged;

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
    
    self.labelAgentName.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
    self.labelAddress.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
    self.labelStateCountry.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
    self.labelBuyerName.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
    self.labelPrice.font = FONT_OPENSANS_BOLD(FONT_SIZE_REGULAR);
    self.labelReferralFee.font = FONT_OPENSANS_REGULAR(FONT_SIZE_SMALL);
    self.labelInfo.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
    self.labelIntention.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
    
    self.labelNote.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
    self.textViewNote.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
    
    self.textViewNote.layer.borderColor = [UIColor colorWithRed:191.0f/255.0f green:191.0f/255.0f blue:191.0f/255.0f alpha:1.0f].CGColor;
    self.textViewNote.layer.borderWidth = 1.0f;
    
    self.buttonSubmit.titleLabel.font = FONT_OPENSANS_BOLD(FONT_SIZE_SMALL);
    self.buttonCancel.titleLabel.font = FONT_OPENSANS_BOLD(FONT_SIZE_SMALL);
    
    // Add a bottomBorder.
    CALayer *bottomBorder = [CALayer layer];
    
    bottomBorder.frame = CGRectMake(0.0f, self.viewForName.frame.size.height-1.0f, self.viewForName.frame.size.width, 1.0f);
    
    bottomBorder.backgroundColor = [UIColor colorWithRed:191.0f/255.0f green:191.0f/255.0f blue:191.0f/255.0f alpha:1.0f].CGColor;
    
    [self.viewForName.layer addSublayer:bottomBorder];
    
    
    self.labelPage.text = [NSString stringWithFormat:@"%li",(long)self.index+1];
    
    self.labelAgentName.text = self.referralDetails.agent_name;
//    self.labelAddress.text = [self isNull:self.referralDetails.city]?@"":self.referralDetails.city;
//    self.labelStateCountry.text = [NSString stringWithFormat:@"%@, %@",self.referralDetails.state_code,self.referralDetails.countries_iso_code_3];
    
    NSMutableString *address = [[NSMutableString alloc] initWithString:@""];
    
    if (![self isNull:self.referralDetails.city]) {
        [address appendFormat:@"%@\n",self.referralDetails.city];
        
    }
    
    if (![self isNull:self.referralDetails.state_code]) {
        [address appendFormat:@"%@, ",self.referralDetails.state_code];
    }
    
    if (![self isNull:self.referralDetails.countries_iso_code_3]) {
        [address appendFormat:@"%@",self.referralDetails.countries_iso_code_3];
    }
    
    self.labelAddress.text = address;
    
    [self.labelAddress sizeToFit];
    
    NSManagedObjectContext *context = ((ABridge_AppDelegate *)[[UIApplication sharedApplication] delegate]).managedObjectContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"LoginDetails"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error = nil;
    NSArray *fetchedObjects = [context
                               executeFetchRequest:fetchRequest error:&error];
    
    self.loginDetail = (LoginDetails*)[fetchedObjects firstObject];
    
    NSString *parameters = [NSString stringWithFormat:@"?user_id=%@&update_id=%@", self.loginDetail.user_id, self.referralDetails.referral_id];
    
    NSString *urlString = [NSString stringWithFormat:@"http://keydiscoveryinc.com/agent_bridge/webservice/check_if_signed.php%@", parameters];
    
    __block NSString *client_name = self.referralDetails.client_name;
    
    __block NSError *errorData = nil;
    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setCompletionBlock:^{
        // Use when fetching text data
        //                        NSString *responseString = [request responseString];
        // Use when fetching binary data
        NSData *responseData = [request responseData];
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&errorData];
        
        
        if ([[json objectForKey:@"data"] count] == 0 && [self.referralDetails.agent_b integerValue] == [self.loginDetail.user_id integerValue]) {
            NSMutableString *encryptBuyerName = [[NSMutableString alloc] initWithString:@""];
            if ([client_name length] > 4) {
                
                [encryptBuyerName appendString:[client_name substringToIndex:2]];
                
                for (int i = 0; i < [[client_name substringWithRange:NSMakeRange(2, [client_name length] - 2)] length]; i++) {
                    [encryptBuyerName appendString:@"x"];
                }
                
                [encryptBuyerName appendString:[client_name substringFromIndex:[client_name length]-2]];
                
            }
            self.labelBuyerName.text = encryptBuyerName;
            self.buttonVCard.hidden = YES;
        }
        else {
            self.labelBuyerName.text = client_name;
            self.buttonVCard.hidden = NO;
        }
        
        
    }];
    [request setFailedBlock:^{
        NSError *error = [request error];
        NSLog(@"error:%@",error);
        
    }];
    [request startAsynchronous];
    
    if ([self.referralDetails.agent_b integerValue] == [self.loginDetail.user_id integerValue]) {
        self.buttonChangeStatus.hidden = NO;
    }
    else {
        self.buttonChangeStatus.hidden = YES;
    }
    
//    self.labelBuyerName.text = self.referralDetails.client_name;
    NSNumberFormatter * formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterCurrencyStyle;
    [formatter setMaximumFractionDigits:0];
    formatter.currencyCode = @"USD";
    
    NSMutableString *priceText = [NSMutableString stringWithString:@""];
    [priceText appendString:[formatter stringFromNumber: [NSNumber numberWithDouble:[self.referralDetails.price_1 doubleValue]]]];
    if ([self.referralDetails.price_2 class] != Nil) {
        [priceText appendFormat:@" - %@",[formatter stringFromNumber: [NSNumber numberWithDouble:[self.referralDetails.price_2 doubleValue]]]];
    }
    self.labelPrice.text = priceText;
    self.labelIntention.text = CLIENT_INTENTION([self.referralDetails.client_intention integerValue]);
    
    self.labelReferralFee.text = [NSString stringWithFormat:@"Referral Agreement (%@)",self.referralDetails.referral_fee];
    
    self.imagePendingAccepted.image = [self imageForReferralStatus:[self.referralDetails.status integerValue]];
    
    self.statusPicked_test = [self.referralDetails.status integerValue];
    
    if (self.referralDetails.image == nil || [self.referralDetails.image isEqualToString:@""]) {
        self.imagePicture.image = [UIImage imageNamed:@"blank-image"];
    }
    else {
        if (self.referralDetails.image_data == nil) {
            self.referralDetails.image_data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.referralDetails.image]];
        }
        
        self.imagePicture.image = [UIImage imageWithData:self.referralDetails.image_data];
        
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
//    [UIView animateWithDuration:1 animations:^{
//        [self.textViewNote resignFirstResponder];
//        CGRect frame = self.viewChangeStatus.frame;
//        frame.origin.y = 0.0f;
//        self.viewChangeStatus.frame = frame;
//    } completion:^(BOOL finished) {
//        self.viewChangeStatus.hidden = YES;
//    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIImage*) imageForReferralStatus:(NSInteger)referral_status {
    UIImage *image = nil;
    switch (referral_status) {
        case REFERRAL_STATUS_UNDERCONTRACT:
            image = [UIImage imageNamed:@"under_contract"];
            break;
        case REFERRAL_STATUS_CLOSED:
            image = [UIImage imageNamed:@"closed"];
            break;
        case REFERRAL_STATUS_NOGO:
            image = [UIImage imageNamed:@"no_go"];
            break;
        case REFERRAL_STATUS_NEEDHELP:
            image = [UIImage imageNamed:@"need_help"];
            break;
        case REFERRAL_STATUS_PENDING:
            image = [UIImage imageNamed:@"pending"];
            break;
        case REFERRAL_STATUS_ACCEPTED:
            image = [UIImage imageNamed:@"accepted"];
            break;
        case REFERRAL_STATUS_COMMISSIONRECEIVED:
            image = [UIImage imageNamed:@"commission"];
            break;
        default:
            break;
    }
    return image;
}

- (IBAction)changeStatus:(id)sender {
    
    switch (self.statusPicked_test) {
        case REFERRAL_STATUS_UNDERCONTRACT:
            self.arrayOfStatus = [NSArray arrayWithObjects: @"Active", @"Need Help", @"Closed", nil];
            break;
        case REFERRAL_STATUS_CLOSED:
            self.arrayOfStatus = [NSArray arrayWithObjects: @"Completed", nil];
            break;
        case REFERRAL_STATUS_NOGO:
            self.arrayOfStatus = [NSArray arrayWithObjects:nil];
            break;
        case REFERRAL_STATUS_NEEDHELP:
            self.arrayOfStatus = [NSArray arrayWithObjects:@"Active", @"Under Contract", @"No Go",nil];
            break;
        case REFERRAL_STATUS_PENDING:
            self.arrayOfStatus = [NSArray arrayWithObjects:@"Active", @"No Go", @"Need Help", nil];
            break;
        case REFERRAL_STATUS_ACCEPTED:
            self.arrayOfStatus = [NSArray arrayWithObjects: @"Under Contract", @"No Go", @"Need Help", nil];
            break;
        case REFERRAL_STATUS_COMMISSIONRECEIVED:
            self.arrayOfStatus = [NSArray arrayWithObjects:nil];
            break;
        default:
            break;
    }
    
    if ([self.arrayOfStatus count]) {
        [self.pickerStatus reloadAllComponents];
        [self.pickerStatus selectRow:0 inComponent:0 animated:YES];
        self.pickerChanged = NO;
        self.viewChangeStatus.hidden = NO;
    }
}

- (IBAction)submitChange:(id)sender {
    
    if (self.pickerChanged == NO) {
        [self generateURLString:0];
    }
    
    
//     NSLog(@"url:%@",self.urlStringStatusChange);
    
    __block NSError *errorData = nil;
    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:self.urlStringStatusChange]];
    [request setCompletionBlock:^{
        // Use when fetching text data
        //                        NSString *responseString = [request responseString];
        // Use when fetching binary data
        NSData *responseData = [request responseData];
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&errorData];
        
//        NSLog(@"json:%@",json);
        if([[json objectForKey:@"status"] integerValue] == 1){
            self.statusPicked_test = self.statusPicked;
            self.imagePendingAccepted.image = [self imageForReferralStatus:self.statusPicked_test];
        }
        
        
    }];
    [request setFailedBlock:^{
        NSError *error = [request error];
        NSLog(@"error:%@",error);
        
    }];
    [request startAsynchronous];


    
    self.viewChangeStatus.hidden = YES;
}

- (IBAction)cancelChange:(id)sender {
    self.viewChangeStatus.hidden = YES;
}

- (IBAction)saveBuyerVCard:(id)sender {
//    NSLog(@"name:%@",self.referralDetails.client_name);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        __block CFErrorRef error = NULL;
        ABAddressBookRef iPhoneAddressBook = ABAddressBookCreate();
        
        __block BOOL accessGranted = NO;
        
        if (ABAddressBookRequestAccessWithCompletion != NULL) { // we're on iOS 6
            dispatch_semaphore_t sema = dispatch_semaphore_create(0);
            
            ABAddressBookRequestAccessWithCompletion(iPhoneAddressBook, ^(bool granted, CFErrorRef error) {
                accessGranted = granted;
                dispatch_semaphore_signal(sema);
            });
            
            dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        }
        else { // we're on iOS 5 or older
            accessGranted = YES;
        }
        
        
        if (accessGranted) {
            
            //        NSArray *thePeople = (__bridge_transfer NSArray*)ABAddressBookCopyArrayOfAllPeople(iPhoneAddressBook);
            // Do whatever you need with thePeople...
            
            
            ABRecordRef newPerson = ABPersonCreate();
            
            NSString *firstName = @"";
            NSString *lastName = @"";
            if ([self.referralDetails.client_name rangeOfString:@" "].location == NSNotFound) {
                firstName = self.referralDetails.client_name;
            }
            else {
                firstName = [[self.referralDetails.client_name componentsSeparatedByString:@" "] objectAtIndex:0];
                lastName = [[self.referralDetails.client_name componentsSeparatedByString:@" "] objectAtIndex:1];
            }
            
            ABRecordSetValue(newPerson, kABPersonFirstNameProperty, (__bridge CFTypeRef)([self stringTestNull:firstName]), &error);
            ABRecordSetValue(newPerson, kABPersonLastNameProperty, (__bridge CFTypeRef)([self stringTestNull:lastName]), &error);
            
            ABPersonSetImageData (newPerson,(__bridge CFDataRef)([NSData dataWithContentsOfFile:@"blank-image.png"]),&error);
            
            ABRecordSetValue(newPerson, kABPersonOrganizationProperty, @"Agent Bridge", &error);
            ABRecordSetValue(newPerson, kABPersonJobTitleProperty, CLIENT_INTENTION([[self stringTestNull:self.referralDetails.client_intention] integerValue]), &error);
            
            //Client Number
            ABMutableMultiValueRef multiPhone = ABMultiValueCreateMutable(kABMultiStringPropertyType);
            ABMultiValueAddValueAndLabel(multiPhone, (__bridge CFTypeRef)([self stringTestNull:self.referralDetails.client_number]), kABPersonPhoneMobileLabel, NULL);
            ABRecordSetValue(newPerson, kABPersonPhoneProperty, multiPhone,nil);
            CFRelease(multiPhone);
            
            //Client Email
            ABMutableMultiValueRef multiEmail = ABMultiValueCreateMutable(kABMultiStringPropertyType);
            ABMultiValueAddValueAndLabel(multiEmail, (__bridge CFTypeRef)([self stringTestNull:self.referralDetails.client_email]), kABWorkLabel, NULL);
            ABRecordSetValue(newPerson, kABPersonEmailProperty, multiEmail, &error);
            CFRelease(multiEmail);
            
            //Client Address
            ABMutableMultiValueRef multiAddress = ABMultiValueCreateMutable(kABMultiDictionaryPropertyType);
            NSMutableDictionary *addressDictionary = [[NSMutableDictionary alloc] init];
            [addressDictionary setObject:[self stringTestNull:self.referralDetails.client_address_1] forKey:(NSString *) kABPersonAddressStreetKey];
            [addressDictionary setObject:[self stringTestNull:self.referralDetails.client_city] forKey:(NSString *)kABPersonAddressCityKey];
            [addressDictionary setObject:[self stringTestNull:self.referralDetails.client_state_name] forKey:(NSString *)kABPersonAddressStateKey];
            [addressDictionary setObject:[self stringTestNull:self.referralDetails.client_zip] forKey:(NSString *)kABPersonAddressZIPKey];
            [addressDictionary setObject:[self stringTestNull:self.referralDetails.client_country_name] forKey:(NSString *)kABPersonAddressCountryKey];
            ABMultiValueAddValueAndLabel(multiAddress, (__bridge CFTypeRef)(addressDictionary), kABWorkLabel, NULL);
            ABRecordSetValue(newPerson, kABPersonAddressProperty, multiAddress,&error);
            CFRelease(multiAddress);
            
            ABAddressBookAddRecord(iPhoneAddressBook, newPerson, &error);
            CFRelease(newPerson);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (ABAddressBookSave(iPhoneAddressBook, &error))
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Saving Contacts" message:@"Successfully saved Buyer into Contacts." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                }
                else {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Saving Contacts" message:@"Failed in saving Buyer into Contacts." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                }
            });
            
        }
        else {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Saving Contacts" message:@"Please allow the AgentBridge to Access your Contacts." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            });
        }
    });
}

-(NSString*)stringTestNull:(NSString*)string {
    if ([self isNull:string]) {
        return @"";
    }
    return string;
}


-(BOOL)isNull:(id)value {
    return ((NSNull*)value == nil || [value isEqualToString:@""]);
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (pickerView == self.pickerStatus) {
        return [self.arrayOfStatus count];
    }
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (pickerView == self.pickerStatus) {
        return [self.arrayOfStatus objectAtIndex:row];
    }
    return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (pickerView == self.pickerStatus) {
        self.pickerChanged = YES;
        [self generateURLString:row];
    }
}

- (void) generateURLString:(NSInteger)row {
    NSString *status_type = @"";
    NSString *note_text = @"";
    if ([[self.arrayOfStatus objectAtIndex:row] isEqualToString:@"Need Help"]) {
        
        [UIView animateWithDuration:1 animations:^{
            CGRect frame = self.viewForButtons.frame;
            frame.origin.y = 269.0f;
            self.viewForButtons.frame = frame;
            
            frame = self.viewChangeStatus.frame;
            frame.size.height = 331.0f;
            self.viewChangeStatus.frame = frame;
        } completion:^(BOOL finished) {
            self.labelNote.alpha = 1.0f;
            self.textViewNote.alpha = 1.0f;
            self.textViewNote.userInteractionEnabled = YES;
        }];
        
        status_type = @"6";
        note_text = self.textViewNote.text;
    }
    else {
        [UIView animateWithDuration:1 animations:^{
            CGRect frame = self.viewForButtons.frame;
            frame.origin.y = 162.0f;
            self.viewForButtons.frame = frame;
            
            frame = self.viewChangeStatus.frame;
            frame.size.height = 217.0f;
            self.viewChangeStatus.frame = frame;
        } completion:^(BOOL finished) {
            self.labelNote.alpha = 0.3f;
            self.textViewNote.alpha = 0.3f;
            self.textViewNote.userInteractionEnabled = NO;
        }];
        
        note_text = @"";
        
        if ([[self.arrayOfStatus objectAtIndex:row] isEqualToString:@"Active"]) {
            status_type = @"8";
        }
        else if ([[self.arrayOfStatus objectAtIndex:row] isEqualToString:@"Under Contract"]) {
            status_type = @"1";
        }
        else if ([[self.arrayOfStatus objectAtIndex:row] isEqualToString:@"No Go"]) {
            status_type = @"5";
        }
        else if ([[self.arrayOfStatus objectAtIndex:row] isEqualToString:@"Closed"]) {
            status_type = @"4";
        }
        else if ([[self.arrayOfStatus objectAtIndex:row] isEqualToString:@"Completed"]) {
            status_type = @"9";
        }
    }
    
    self.statusPicked = [status_type integerValue];
    
    NSString *parameters = [NSString stringWithFormat:@"?user_id=%@&referral_id=%@&value_id=%@&agent_a=%@&status=%@&activity_type=%@note=%@", self.loginDetail.user_id, self.referralDetails.referral_id, self.referralDetails.referral_id,self.referralDetails.agent_a,status_type,@"17",note_text];
    
    self.urlStringStatusChange = [NSString stringWithFormat:@"http://keydiscoveryinc.com/agent_bridge/webservice/change_status.php%@", parameters];
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    [UIView animateWithDuration:0.2 animations:^{
        CGRect frame = self.viewChangeStatus.frame;
        frame.origin.y = -165.0f;
        self.viewChangeStatus.frame = frame;
    } completion:^(BOOL finished) {
    }];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [UIView animateWithDuration:1 animations:^{
            [textView resignFirstResponder];
            CGRect frame = self.viewChangeStatus.frame;
            frame.origin.y = 0.0f;
            self.viewChangeStatus.frame = frame;
        } completion:^(BOOL finished) {
            
        }];
        return NO;
    }
    return YES;
}

@end
