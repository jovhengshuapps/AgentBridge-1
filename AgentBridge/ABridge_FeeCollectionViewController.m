//
//  ABridge_FeeCollectionViewController.m
//  AgentBridge
//
//  Created by host24_iOS Dev on 12/17/13.
//  Copyright (c) 2013 host24_iOS Dev. All rights reserved.
//

#import "ABridge_FeeCollectionViewController.h"
#import "State.h"
#import "Country.h"

@interface ABridge_FeeCollectionViewController ()
@property (weak, nonatomic) IBOutlet UIButton *buttonContinueComission;
@property (weak, nonatomic) IBOutlet UIButton *buttonCancel;
@property (weak, nonatomic) IBOutlet UIButton *buttonBack;
@property (weak, nonatomic) IBOutlet UILabel *labelGrossComission;
@property (weak, nonatomic) IBOutlet UITextField *textFieldGrossComission;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *labelPersonalInfo;
@property (weak, nonatomic) IBOutlet UITextField *textFieldFirstname;
@property (weak, nonatomic) IBOutlet UITextField *textFieldLastname;
@property (weak, nonatomic) IBOutlet UITextField *textFieldEmail;
@property (weak, nonatomic) IBOutlet UITextField *textFieldPhoneNumber;
@property (weak, nonatomic) IBOutlet UIButton *buttonContinuePersonalInfo;
@property (weak, nonatomic) IBOutlet UILabel *labelBrokerInfo;
@property (weak, nonatomic) IBOutlet UITextField *textFieldAgentLicense;
@property (weak, nonatomic) IBOutlet UITextField *textFieldBrokerLicense;
@property (weak, nonatomic) IBOutlet UITextField *textFieldTaxId;
@property (weak, nonatomic) IBOutlet UIButton *buttonContinueBroker;
@property (weak, nonatomic) IBOutlet UILabel *labelBillingAddress;
@property (weak, nonatomic) IBOutlet UIButton *buttonCountry;
@property (weak, nonatomic) IBOutlet UITextField *textFieldAddress1;
@property (weak, nonatomic) IBOutlet UITextField *textFieldAddress2;
@property (weak, nonatomic) IBOutlet UITextField *textFieldZipcode;
@property (weak, nonatomic) IBOutlet UITextField *textFieldCity;
@property (weak, nonatomic) IBOutlet UIButton *buttonState;
@property (weak, nonatomic) IBOutlet UIButton *buttonContinueBilling;
@property (weak, nonatomic) IBOutlet UILabel *labelTotalFree;
@property (weak, nonatomic) IBOutlet UILabel *labelTotalValue;
@property (weak, nonatomic) IBOutlet UITextField *textFieldCreditCard;
@property (weak, nonatomic) IBOutlet UITextField *textFieldSecurityCode;
@property (weak, nonatomic) IBOutlet UIButton *buttonExpiry;
@property (weak, nonatomic) IBOutlet UISwitch *switchAgree;
@property (weak, nonatomic) IBOutlet UILabel *labelAgree;
@property (weak, nonatomic) IBOutlet UIButton *buttonSubmit;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerExpiry;
@property (weak, nonatomic) IBOutlet UIView *viewPickerExpiry;
@property (weak, nonatomic) IBOutlet UIView *viewPickerCountry;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerCountry;
@property (weak, nonatomic) IBOutlet UIView *viewPickerState;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerState;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbarKeyboard;



@property (strong, nonatomic) NSArray *arrayOfMonth;
@property (strong, nonatomic) NSMutableArray *arrayOfYear;
@property (strong, nonatomic) NSMutableArray *arrayOfCountry;
@property (strong, nonatomic) NSMutableArray *arrayOfState;
@property (strong, nonatomic) NSMutableArray *arrayOfCountry_ID;
@property (strong, nonatomic) NSString *cardExpiry;


- (IBAction)continuePressed:(id)sender;
- (IBAction)cancelPressed:(id)sender;
- (IBAction)backPressed:(id)sender;
- (IBAction)countryPressed:(id)sender;
- (IBAction)statePressed:(id)sender;
- (IBAction)saveExpiryDate:(id)sender;
- (IBAction)expiryPressed:(id)sender;
- (IBAction)submitTransaction:(id)sender;
- (IBAction)resignKeyboards:(id)sender;

@end

@implementation ABridge_FeeCollectionViewController
@synthesize arrayOfMonth;
@synthesize arrayOfYear;
@synthesize arrayOfCountry;
@synthesize arrayOfState;
@synthesize arrayOfCountry_ID;
@synthesize referral_id;
@synthesize cardExpiry;

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
	// Do any additional setup after loading the view.
    self.slidingViewController.underLeftViewController = nil;
    self.slidingViewController.underRightViewController = nil;
    
    
    self.labelGrossComission.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
    self.textFieldGrossComission.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
    self.buttonCancel.titleLabel.font = FONT_OPENSANS_BOLD(FONT_SIZE_SMALL);
    self.buttonContinueComission.titleLabel.font = FONT_OPENSANS_BOLD(FONT_SIZE_SMALL);
    self.buttonBack.titleLabel.font = FONT_OPENSANS_BOLD(FONT_SIZE_SMALL);
    
    self.labelPersonalInfo.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
    self.textFieldFirstname.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
    self.textFieldLastname.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
    self.textFieldEmail.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
    self.textFieldPhoneNumber.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
    self.buttonContinuePersonalInfo.titleLabel.font = FONT_OPENSANS_BOLD(FONT_SIZE_SMALL);
    
    self.labelBrokerInfo.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
    self.textFieldAgentLicense.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
    self.textFieldBrokerLicense.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
    self.textFieldTaxId.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
    self.buttonContinueBroker.titleLabel.font = FONT_OPENSANS_BOLD(FONT_SIZE_SMALL);
    
    self.labelBillingAddress.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
    self.textFieldAddress1.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
    self.textFieldAddress2.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
    self.textFieldZipcode.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
    self.textFieldCity.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
    self.buttonCountry.titleLabel.font = FONT_OPENSANS_BOLD(FONT_SIZE_SMALL);
    self.buttonState.titleLabel.font = FONT_OPENSANS_BOLD(FONT_SIZE_SMALL);
    self.buttonContinueBilling.titleLabel.font = FONT_OPENSANS_BOLD(FONT_SIZE_SMALL);
    
    self.textFieldCreditCard.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
    self.textFieldSecurityCode.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
    self.buttonSubmit.titleLabel.font = FONT_OPENSANS_BOLD(FONT_SIZE_SMALL);
    
    [self addPaddingAndBorder:self.textFieldGrossComission color:[UIColor colorWithRed:178.0f/255.0f green:178.0f/255.0f blue:178.0f/255.0f alpha:1.0f]];
     [self addPaddingAndBorder:self.textFieldFirstname color:[UIColor colorWithRed:178.0f/255.0f green:178.0f/255.0f blue:178.0f/255.0f alpha:1.0f]];
     [self addPaddingAndBorder:self.textFieldLastname color:[UIColor colorWithRed:178.0f/255.0f green:178.0f/255.0f blue:178.0f/255.0f alpha:1.0f]];
     [self addPaddingAndBorder:self.textFieldEmail color:[UIColor colorWithRed:178.0f/255.0f green:178.0f/255.0f blue:178.0f/255.0f alpha:1.0f]];
     [self addPaddingAndBorder:self.textFieldPhoneNumber color:[UIColor colorWithRed:178.0f/255.0f green:178.0f/255.0f blue:178.0f/255.0f alpha:1.0f]];
    [self addPaddingAndBorder:self.textFieldAgentLicense color:[UIColor colorWithRed:178.0f/255.0f green:178.0f/255.0f blue:178.0f/255.0f alpha:1.0f]];
    [self addPaddingAndBorder:self.textFieldBrokerLicense color:[UIColor colorWithRed:178.0f/255.0f green:178.0f/255.0f blue:178.0f/255.0f alpha:1.0f]];
    [self addPaddingAndBorder:self.textFieldTaxId color:[UIColor colorWithRed:178.0f/255.0f green:178.0f/255.0f blue:178.0f/255.0f alpha:1.0f]];
    [self addPaddingAndBorder:self.textFieldAddress1 color:[UIColor colorWithRed:178.0f/255.0f green:178.0f/255.0f blue:178.0f/255.0f alpha:1.0f]];
    [self addPaddingAndBorder:self.textFieldAddress2 color:[UIColor colorWithRed:178.0f/255.0f green:178.0f/255.0f blue:178.0f/255.0f alpha:1.0f]];
    [self addPaddingAndBorder:self.textFieldZipcode color:[UIColor colorWithRed:178.0f/255.0f green:178.0f/255.0f blue:178.0f/255.0f alpha:1.0f]];
    [self addPaddingAndBorder:self.textFieldCity color:[UIColor colorWithRed:178.0f/255.0f green:178.0f/255.0f blue:178.0f/255.0f alpha:1.0f]];
    [self addPaddingAndBorder:self.textFieldCreditCard color:[UIColor colorWithRed:178.0f/255.0f green:178.0f/255.0f blue:178.0f/255.0f alpha:1.0f]];
    [self addPaddingAndBorder:self.textFieldSecurityCode color:[UIColor colorWithRed:178.0f/255.0f green:178.0f/255.0f blue:178.0f/255.0f alpha:1.0f]];
    
    self.arrayOfMonth = [NSArray arrayWithObjects:@"Jan", @"Mar", @"Feb", @"Apr", @"May", @"Jun", @"Jul", @"Aug", @"Sep", @"Oct", @"Nov", @"Dec", nil];
    self.arrayOfYear = [NSMutableArray array];
    for (int year = 2013; year < 2031; year++) {
        [self.arrayOfYear addObject:[NSString stringWithFormat:@"%li",(long)year]];
    }
    
    UITapGestureRecognizer *tapClose = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideViewForPickerExpiry)];
    tapClose.numberOfTapsRequired = 1;
    tapClose.numberOfTouchesRequired = 1;
    [self.viewPickerExpiry addGestureRecognizer:tapClose];
    
    
    UITapGestureRecognizer *tapClose1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideViewForPickerExpiry)];
    tapClose1.numberOfTapsRequired = 1;
    tapClose1.numberOfTouchesRequired = 1;
    [self.viewPickerCountry addGestureRecognizer:tapClose1];
    
    
    UITapGestureRecognizer *tapClose2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideViewForPickerExpiry)];
    tapClose2.numberOfTapsRequired = 1;
    tapClose2.numberOfTouchesRequired = 1;
    [self.viewPickerState addGestureRecognizer:tapClose2];
    
    //get Countries
    self.buttonCountry.enabled = NO;
    self.buttonCountry.backgroundColor = [UIColor lightGrayColor];
    
    NSString *urlString = @"http://keydiscoveryinc.com/agent_bridge/webservice/getdb_country.php";
    
    __block NSError *errorData = nil;
    __block ASIHTTPRequest *requestCountry = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlString]];
    [requestCountry setCompletionBlock:^{
        // Use when fetching text data
        //                        NSString *responseString = [request responseString];
        // Use when fetching binary data
        NSData *responseData = [requestCountry responseData];
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&errorData];
        
        if (self.arrayOfCountry == nil) {
            self.arrayOfCountry = [[NSMutableArray alloc] init];
        }
        
        for (NSDictionary *entry in [json objectForKey:@"data"]) {
            [self.self.arrayOfCountry addObject:[entry objectForKey:@"countries_name"]];
        }
        
        
        if (self.arrayOfCountry_ID == nil) {
            self.arrayOfCountry_ID = [[NSMutableArray alloc] init];
        }
        
        for (NSDictionary *entry in [json objectForKey:@"data"]) {
            [self.self.arrayOfCountry_ID addObject:[entry objectForKey:@"countries_id"]];
        }
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.buttonCountry.enabled = YES;
            self.buttonCountry.backgroundColor = [UIColor whiteColor];
            
            
            [self.pickerCountry reloadAllComponents];
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
            
        });
        
    }];
    [requestCountry setFailedBlock:^{
        NSError *error = [requestCountry error];
        NSLog(@"error:%@",error);
        
    }];
    [requestCountry startAsynchronous];
    
    //get States
    self.buttonState.enabled = NO;
    self.buttonState.backgroundColor = [UIColor lightGrayColor];
    
    urlString = @"http://keydiscoveryinc.com/agent_bridge/webservice/getdb_state.php";
    
    __block ASIHTTPRequest *requestState = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlString]];
    [requestState setCompletionBlock:^{
        // Use when fetching text data
        //                        NSString *responseString = [request responseString];
        // Use when fetching binary data
        NSData *responseData = [requestState responseData];
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&errorData];
        
        if (self.arrayOfState == nil) {
            self.arrayOfState = [[NSMutableArray alloc] init];
        }
        
        for (NSDictionary *entry in [json objectForKey:@"data"]) {
            [self.self.arrayOfState addObject:[entry objectForKey:@"zone_name"]];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.buttonState.enabled = YES;
            self.buttonState.backgroundColor = [UIColor whiteColor];
            
            
            [self.pickerState reloadAllComponents];
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
        });
        
    }];
    [requestState setFailedBlock:^{
        NSError *error = [requestState error];
        NSLog(@"error:%@",error);
        
    }];
    [requestState startAsynchronous];
    
    [self.textFieldGrossComission setInputAccessoryView:self.toolbarKeyboard];
    [self.textFieldFirstname setInputAccessoryView:self.toolbarKeyboard];
    [self.textFieldLastname setInputAccessoryView:self.toolbarKeyboard];
    [self.textFieldEmail setInputAccessoryView:self.toolbarKeyboard];
    [self.textFieldZipcode setInputAccessoryView:self.toolbarKeyboard];
    [self.textFieldPhoneNumber setInputAccessoryView:self.toolbarKeyboard];
    [self.textFieldAddress1 setInputAccessoryView:self.toolbarKeyboard];
    [self.textFieldAddress2 setInputAccessoryView:self.toolbarKeyboard];
    [self.textFieldCity setInputAccessoryView:self.toolbarKeyboard];
    [self.textFieldAgentLicense setInputAccessoryView:self.toolbarKeyboard];
    [self.textFieldBrokerLicense setInputAccessoryView:self.toolbarKeyboard];
    [self.textFieldTaxId setInputAccessoryView:self.toolbarKeyboard];
    [self.textFieldCreditCard setInputAccessoryView:self.toolbarKeyboard];
    [self.textFieldSecurityCode setInputAccessoryView:self.toolbarKeyboard];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)continuePressed:(id)sender {
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x + 320.0f, 0.0f) animated:YES];
    
    [self.textFieldGrossComission resignFirstResponder];
    [self.textFieldFirstname resignFirstResponder];
    [self.textFieldLastname resignFirstResponder];
    [self.textFieldEmail resignFirstResponder];
    [self.textFieldPhoneNumber resignFirstResponder];
    [self.textFieldAgentLicense resignFirstResponder];
    [self.textFieldBrokerLicense resignFirstResponder];
    [self.textFieldTaxId resignFirstResponder];
    [self.textFieldAddress1 resignFirstResponder];
    [self.textFieldAddress2 resignFirstResponder];
    [self.textFieldCity resignFirstResponder];
    [self.textFieldZipcode resignFirstResponder];
    [self.textFieldCreditCard resignFirstResponder];
    [self.textFieldSecurityCode resignFirstResponder];
}

- (IBAction)cancelPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (IBAction)backPressed:(id)sender {
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x - 320.0f, 0.0f) animated:YES];
    
    [self.textFieldGrossComission resignFirstResponder];
    [self.textFieldFirstname resignFirstResponder];
    [self.textFieldLastname resignFirstResponder];
    [self.textFieldEmail resignFirstResponder];
    [self.textFieldPhoneNumber resignFirstResponder];
    [self.textFieldAgentLicense resignFirstResponder];
    [self.textFieldBrokerLicense resignFirstResponder];
    [self.textFieldTaxId resignFirstResponder];
    [self.textFieldAddress1 resignFirstResponder];
    [self.textFieldAddress2 resignFirstResponder];
    [self.textFieldCity resignFirstResponder];
    [self.textFieldZipcode resignFirstResponder];
    [self.textFieldCreditCard resignFirstResponder];
    [self.textFieldSecurityCode resignFirstResponder];
}

- (IBAction)countryPressed:(id)sender {
    [self.textFieldAddress1 resignFirstResponder];
    [self.textFieldAddress2 resignFirstResponder];
    [self.textFieldCity resignFirstResponder];
    [self.textFieldZipcode resignFirstResponder];
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x, 30.0f) animated:YES];
    self.viewPickerCountry.hidden = NO;
    [self.pickerCountry reloadAllComponents];
}

- (IBAction)statePressed:(id)sender {
    [self.textFieldAddress1 resignFirstResponder];
    [self.textFieldAddress2 resignFirstResponder];
    [self.textFieldCity resignFirstResponder];
    [self.textFieldZipcode resignFirstResponder];
    
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x, 150.0f) animated:YES];
    self.viewPickerState.hidden = NO;
    [self.pickerState reloadAllComponents];
}

- (IBAction)saveExpiryDate:(id)sender {
    [self hideViewForPickerExpiry];
}

- (IBAction)expiryPressed:(id)sender {
    
    [self.textFieldCreditCard resignFirstResponder];
    [self.textFieldSecurityCode resignFirstResponder];
    
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x, 95.0f) animated:YES];
    self.viewPickerExpiry.hidden = NO;
    [self.pickerExpiry reloadAllComponents];
    
}

- (IBAction)submitTransaction:(id)sender {
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL: [[NSURL alloc] initWithString:@"http://keydiscoveryinc.com/agent_bridge/components/com_propertylisting/controller.php"]];
    [request setResponseEncoding:NSISOLatin1StringEncoding];
    [request setPostFormat:ASIMultipartFormDataPostFormat];
    [request setPostValue:self.textFieldGrossComission.text forKey:@"amount"];
    [request setPostValue:[NSString stringWithFormat:@"%li",(long)referral_id] forKey:@"ref_id"];
    [request setPostValue:self.textFieldEmail.text forKey:@"email"];
    [request setPostValue:[NSString stringWithFormat:@"%@,%@",self.textFieldAddress1.text,self.textFieldAddress2.text] forKey:@"address"];
    [request setPostValue:@"223" forKey:@"city"];
    [request setPostValue:@"12" forKey:@"state"];
    [request setPostValue:self.textFieldZipcode.text forKey:@"zip"];
    [request setPostValue:self.textFieldFirstname.text forKey:@"firstname"];
    [request setPostValue:self.textFieldLastname.text forKey:@"lastname"];
    [request setPostValue:self.textFieldPhoneNumber.text forKey:@"phone"];
    [request setPostValue:@"BL29231" forKey:@"bslno"];
    [request setPostValue:@"AB9301838" forKey:@"alslno"];
    [request setPostValue:self.textFieldTaxId.text forKey:@"btino"];
    [request setPostValue:self.cardExpiry forKey:@"card_expiry"];
    [request setPostValue:self.textFieldCreditCard.text forKey:@"card_number"];
    [request setPostValue:self.textFieldSecurityCode.text forKey:@"security_no"];
    [request setPostValue:[NSString stringWithFormat:@"%i",self.switchAgree.isOn] forKey:@"agree_terms"];
    [request setPostValue:@"0" forKey:@"save_trans"];
    [request setPostValue:@"Submit" forKey:@"send"];
    
    [request setCompletionBlock:^{
        // Use when fetching text data
        NSString *responseString = [request responseString];
        // Use when fetching binary data
        NSError *errorData = nil;
        NSData *responseData = [request responseData];
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&errorData];
        
//        NSLog(@"%@\njson,%@",responseString,json);
        
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
        
    }];
    [request setFailedBlock:^{
        NSError *error = [request error];
        NSLog(@"error:%@",error);
        
    }];
    [request startAsynchronous];
}

- (IBAction)resignKeyboards:(id)sender {
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x, 0.0f) animated:YES];
    [self.textFieldGrossComission resignFirstResponder];
    [self.textFieldFirstname resignFirstResponder];
    [self.textFieldLastname resignFirstResponder];
    [self.textFieldEmail resignFirstResponder];
    [self.textFieldPhoneNumber resignFirstResponder];
    [self.textFieldAgentLicense resignFirstResponder];
    [self.textFieldBrokerLicense resignFirstResponder];
    [self.textFieldTaxId resignFirstResponder];
    [self.textFieldAddress1 resignFirstResponder];
    [self.textFieldAddress2 resignFirstResponder];
    [self.textFieldCity resignFirstResponder];
    [self.textFieldZipcode resignFirstResponder];
    [self.textFieldCreditCard resignFirstResponder];
    [self.textFieldSecurityCode resignFirstResponder];
}


- (void) addPaddingAndBorder:(UITextField*)textField color:(UIColor*)color {
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 20)];
    textField.leftView = paddingView;
    textField.leftViewMode = UITextFieldViewModeAlways;
    
    textField.layer.borderColor = color.CGColor;
    textField.layer.borderWidth = 1.0f;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.scrollView.contentOffset.x >= 320.0f) {
        self.buttonBack.hidden = NO;
    }
    else {
        self.buttonBack.hidden = YES;
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == self.textFieldFirstname || textField == self.textFieldAgentLicense || textField == self.textFieldBrokerLicense || textField == self.textFieldTaxId) {
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x, 25.0f) animated:YES];
    }
    else if (textField == self.textFieldLastname) {
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x, 50.0f) animated:YES];
    }
    else if (textField == self.textFieldAddress1) {
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x, 65.0f) animated:YES];
    }
    else if (textField == self.textFieldCreditCard) {
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x, 65.0f) animated:YES];
    }
    else if (textField == self.textFieldEmail || textField == self.textFieldPhoneNumber) {
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x, 80.0f) animated:YES];
    }
    else if (textField == self.textFieldAddress2) {
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x, 100.0f) animated:YES];
    }
    else if (textField == self.textFieldZipcode || textField == self.textFieldCity || textField == self.textFieldSecurityCode) {
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x, 130.0f) animated:YES];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
//    if (textField == self.textFieldGrossComission) {
//        if ([string length] > 0) {
//            NSNumberFormatter * formatter = [[NSNumberFormatter alloc] init];
//            formatter.numberStyle = NSNumberFormatterCurrencyStyle;
//            [formatter setMaximumFractionDigits:0];
//            formatter.currencyCode = @"USD";
//            textField.text = [formatter stringFromNumber:[NSNumber numberWithDouble:[[NSString stringWithFormat:@"%@%@",textField.text,string] doubleValue]]];
//        }
//        
//    }
    
    return YES;
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if(pickerView == self.pickerExpiry){
        return 2;
    }
        
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (pickerView == self.pickerExpiry) {
        if (component == 0) {
            return [self.arrayOfMonth count];
        }
        else {
            return [self.arrayOfYear count];
        }
    }
    else if (pickerView == self.pickerCountry) {
        return [self.arrayOfCountry count];
    }
    else if (pickerView == self.pickerState) {
        return [self.arrayOfState count];
    }
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (pickerView == self.pickerExpiry) {
        if (component == 0) {
            return [self.arrayOfMonth objectAtIndex:row];
        }
        else {
            return [self.arrayOfYear objectAtIndex:row];
        }
    }
    else if (pickerView == self.pickerCountry) {
        return [self.arrayOfCountry objectAtIndex:row];
    }
    else if (pickerView == self.pickerState) {
        return [self.arrayOfState objectAtIndex:row];
    }
    return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (pickerView == self.pickerExpiry) {
        NSMutableString *expiry = [NSMutableString stringWithString:@""];
//        if (component == 0) {
            if(row < 10){
                [expiry appendFormat:@"0%li",(long)row+1];
            }
            else {
                [expiry appendFormat:@"%li",(long)row+1];
            }
                
//        }
//        else {
            [expiry appendFormat:@"-%@",[[self.arrayOfYear objectAtIndex:row] substringFromIndex:2]];
//        }
        self.cardExpiry = expiry;
        [self.buttonExpiry setTitle:[NSString stringWithFormat:@"Expiry date: %@",expiry] forState:UIControlStateNormal];
    }
    else if (pickerView == self.pickerCountry) {
        [self.buttonCountry setTitle:[self.arrayOfCountry objectAtIndex:row] forState:UIControlStateNormal];
//        [self reloadStateValues:[self.arrayOfCountry_ID objectAtIndex:row]];
    }
    else if (pickerView == self.pickerState) {
        [self.buttonState setTitle:[self.arrayOfState objectAtIndex:row] forState:UIControlStateNormal];
    }
}

- (void)reloadStateValues:(NSString*)country_id {
    
    
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"zone_country_id == %@", country_id];
    NSArray *result = [self fetchObjectsWithEntityName:@"State" andPredicate:predicate];
    
    [self.arrayOfState removeAllObjects];
    
    for (State *state in result) {
        [self.arrayOfState addObject:state.zone_name];
    }
    
    [self.buttonState setTitle:[self.arrayOfState firstObject] forState:UIControlStateNormal];
    
    if ([self.arrayOfState count] == 0) {
        self.buttonState.enabled = NO;
        self.buttonState.backgroundColor = [UIColor lightGrayColor];
    }
    else {
        self.buttonState.enabled = YES;
        self.buttonState.backgroundColor = [UIColor whiteColor];
    }
    
    [self.pickerState reloadAllComponents];
    
}

- (void) hideViewForPickerExpiry {
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x, 0.0f) animated:YES];
    self.viewPickerExpiry.hidden = YES;
    self.viewPickerCountry.hidden = YES;
    self.viewPickerState.hidden = YES;
}

@end
