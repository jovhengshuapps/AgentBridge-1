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
#import "ABridge_SendTransaction.h"
#import "AgentProfile.h"

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
@property (weak, nonatomic) IBOutlet UILabel *labelServiceFee;
@property (weak, nonatomic) IBOutlet UITextView *textViewTop;

@property (weak, nonatomic) IBOutlet UIView *viewInfo;
@property (weak, nonatomic) IBOutlet UILabel *labelContactInfoHeader; //order summary
@property (weak, nonatomic) IBOutlet UILabel *labelCreditCardInfo;
@property (weak, nonatomic) IBOutlet UIView *viewForTerms;
@property (weak, nonatomic) IBOutlet UITextView *textViewForTerms;
@property (weak, nonatomic) IBOutlet UIView *viewForScrollView;

@property (weak, nonatomic) IBOutlet UIView *topNavBar;

@property (strong, nonatomic) NSArray *arrayOfMonth;
@property (strong, nonatomic) NSMutableArray *arrayOfYear;
@property (strong, nonatomic) NSMutableArray *arrayOfCountry;
@property (strong, nonatomic) NSMutableArray *arrayOfState;
@property (strong, nonatomic) NSMutableArray *arrayOfCountry_ID;
@property (strong, nonatomic) NSMutableArray *arrayOfState_ID;
@property (strong, nonatomic) NSString *cardExpiry;

@property (strong, nonatomic) NSString *selectedCountryID;
@property (strong, nonatomic) NSString *selectedStateID;

@property (strong, nonatomic) NSMutableString *grossCommission;
@property (strong, nonatomic) NSString *serviceFee;

@property (strong, nonatomic) NSString *sessionToken;

@property (strong, nonatomic) UIWebView *webViewInvoice;
@property (strong, nonatomic) UIWebView *webViewPayment;

@property (assign, nonatomic) NSInteger webViewHeight;
@property (assign, nonatomic) NSInteger imageName;

@property (strong, nonatomic) LoginDetails *loginDetails;
@property (strong, nonatomic) AgentProfile *profile;

@property (strong, nonatomic) NSString *invoice_number;
@property (strong, nonatomic) NSString *payment_id;

- (IBAction)continuePressed:(id)sender;
- (IBAction)cancelPressed:(id)sender;
- (IBAction)backPressed:(id)sender;
- (IBAction)countryPressed:(id)sender;
- (IBAction)statePressed:(id)sender;
- (IBAction)saveExpiryDate:(id)sender;
- (IBAction)expiryPressed:(id)sender;
- (IBAction)submitTransaction:(id)sender;
- (IBAction)resignKeyboards:(id)sender;
- (IBAction)hideTermsView:(id)sender;

@end

@implementation ABridge_FeeCollectionViewController
@synthesize arrayOfMonth;
@synthesize arrayOfYear;
@synthesize arrayOfCountry;
@synthesize arrayOfState;
@synthesize arrayOfCountry_ID;
@synthesize arrayOfState_ID;
@synthesize referral_id;
@synthesize cardExpiry;
@synthesize sessionToken;
@synthesize user_id;
@synthesize selectedCountryID;
@synthesize selectedStateID;
@synthesize delegate;
@synthesize grossCommission;
@synthesize serviceFee;
@synthesize referral_name;
@synthesize grossCommissionValue;
@synthesize referral_fee;
@synthesize webViewInvoice;
@synthesize webViewPayment;
@synthesize webViewHeight;
@synthesize imageName;

@synthesize loginDetails;
@synthesize profile;
@synthesize invoice_number;
@synthesize payment_id;
@synthesize referral_agentname;
@synthesize client_address;
@synthesize client_email;
@synthesize client_number;
@synthesize client_type;

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
//    self.slidingViewController.underLeftViewController = nil;
//    self.slidingViewController.underRightViewController = nil;
    
    
    self.labelGrossComission.font = FONT_OPENSANS_BOLD(FONT_SIZE_REGULAR);
    self.textFieldGrossComission.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
    self.buttonCancel.titleLabel.font = FONT_OPENSANS_BOLD(FONT_SIZE_SMALL);
    self.buttonContinueComission.titleLabel.font = FONT_OPENSANS_BOLD(FONT_SIZE_SMALL);
    self.buttonBack.titleLabel.font = FONT_OPENSANS_BOLD(FONT_SIZE_SMALL);
    
    self.labelPersonalInfo.font = FONT_OPENSANS_BOLD(FONT_SIZE_REGULAR);
    self.textFieldFirstname.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
    self.textFieldLastname.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
    self.textFieldEmail.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
    self.textFieldPhoneNumber.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
    self.buttonContinuePersonalInfo.titleLabel.font = FONT_OPENSANS_BOLD(FONT_SIZE_SMALL);
    
    self.labelBrokerInfo.font = FONT_OPENSANS_BOLD(FONT_SIZE_REGULAR);
    self.textFieldAgentLicense.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
    self.textFieldBrokerLicense.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
    self.textFieldTaxId.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
    self.buttonContinueBroker.titleLabel.font = FONT_OPENSANS_BOLD(FONT_SIZE_SMALL);
    
    self.labelBillingAddress.font = FONT_OPENSANS_BOLD(FONT_SIZE_REGULAR);
    self.textFieldAddress1.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
    self.textFieldAddress2.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
    self.textFieldZipcode.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
    self.textFieldCity.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
    self.buttonCountry.titleLabel.font = FONT_OPENSANS_BOLD(FONT_SIZE_SMALL);
    self.buttonState.titleLabel.font = FONT_OPENSANS_BOLD(FONT_SIZE_SMALL);
    self.buttonContinueBilling.titleLabel.font = FONT_OPENSANS_BOLD(FONT_SIZE_SMALL);
    
    self.labelContactInfoHeader.font = FONT_OPENSANS_BOLD(FONT_SIZE_REGULAR);
    self.labelCreditCardInfo.font = FONT_OPENSANS_BOLD(FONT_SIZE_REGULAR);
    self.textFieldCreditCard.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
    self.textFieldSecurityCode.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
    self.buttonSubmit.titleLabel.font = FONT_OPENSANS_BOLD(FONT_SIZE_SMALL);
    
    self.textViewTop.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
    
    self.buttonCountry.layer.borderColor = [UIColor colorWithRed:178.0f/255.0f green:178.0f/255.0f blue:178.0f/255.0f alpha:1.0f].CGColor;
    self.buttonCountry.layer.borderWidth = 1.0f;
    
    self.buttonState.layer.borderColor = [UIColor colorWithRed:178.0f/255.0f green:178.0f/255.0f blue:178.0f/255.0f alpha:1.0f].CGColor;
    self.buttonState.layer.borderWidth = 1.0f;
    
    self.buttonExpiry.layer.borderColor = [UIColor colorWithRed:178.0f/255.0f green:178.0f/255.0f blue:178.0f/255.0f alpha:1.0f].CGColor;
    self.buttonExpiry.layer.borderWidth = 1.0f;
    
    [self addPaddingAndBorder:self.textFieldGrossComission color:[UIColor colorWithRed:178.0f/255.0f green:178.0f/255.0f blue:178.0f/255.0f alpha:1.0f]];
    
//    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(self.textFieldGrossComission.frame.size.width - 15.0f, 0, 15, 20)];
//    self.textFieldGrossComission.rightView = paddingView;
//    self.textFieldGrossComission.rightViewMode = UITextFieldViewModeAlways;
    
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
    
    self.arrayOfMonth = [NSArray arrayWithObjects:@"Jan", @"Feb", @"Mar",  @"Apr", @"May", @"Jun", @"Jul", @"Aug", @"Sep", @"Oct", @"Nov", @"Dec", nil];
    self.arrayOfYear = [NSMutableArray array];
    
    NSDate *today = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *weekdayComponents = [gregorian components:(NSDayCalendarUnit | NSWeekdayCalendarUnit | NSYearCalendarUnit) fromDate:today];
    NSInteger year = [weekdayComponents year];
    NSInteger yearPlus30 = year + 30;
    while(year <= yearPlus30) {
        [self.arrayOfYear addObject:[NSString stringWithFormat:@"%li",(long)year]];
        year++;
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
    __weak ASIHTTPRequest *requestCountry = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlString]];
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
            [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
            
        });
        
    }];
    [requestCountry setFailedBlock:^{
        NSError *error = [requestCountry error];
        NSLog(@" error:%@",error);
        
    }];
    [requestCountry startAsynchronous];
    
    //get States
    self.buttonState.enabled = NO;
    self.buttonState.backgroundColor = [UIColor lightGrayColor];
    
    urlString = @"http://keydiscoveryinc.com/agent_bridge/webservice/getdb_state.php";
    
    __weak ASIHTTPRequest *requestState = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlString]];
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
        
        
        if (self.arrayOfState_ID == nil) {
            self.arrayOfState_ID = [[NSMutableArray alloc] init];
        }
        
        for (NSDictionary *entry in [json objectForKey:@"data"]) {
            [self.self.arrayOfState_ID addObject:[entry objectForKey:@"zone_id"]];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.buttonState.enabled = YES;
            self.buttonState.backgroundColor = [UIColor whiteColor];
            
            
            [self.pickerState reloadAllComponents];
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
        });
        
    }];
    [requestState setFailedBlock:^{
        NSError *error = [requestState error];
        NSLog(@" error:%@",error);
        
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
    
    
    NSManagedObjectContext *context = ((ABridge_AppDelegate *)[[UIApplication sharedApplication] delegate]).managedObjectContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"LoginDetails"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error = nil;
    self.loginDetails = (LoginDetails*)[[context executeFetchRequest:fetchRequest error:&error] firstObject];
    
    NSFetchRequest *fetchRequestProfile = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityProfile = [NSEntityDescription entityForName:@"AgentProfile"
                                                     inManagedObjectContext:context];
    [fetchRequestProfile setEntity:entityProfile];
    
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"user_id == %@", self.loginDetails.user_id];
    [fetchRequestProfile setPredicate:predicate];
    
    NSError *errorProfile = nil;
    self.profile = (AgentProfile*)[[context executeFetchRequest:fetchRequestProfile error:&errorProfile] firstObject];
    
    
    NSString *parameter = [NSString stringWithFormat:@"?text=%@",[[self.profile.licence stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"]  stringByReplacingOccurrencesOfString:@"=" withString:@"%3D"]];
    NSMutableString *urlStringDecrypt = [NSMutableString stringWithString:@"http://keydiscoveryinc.com/agent_bridge/webservice/decrypt_license.php"];
    
    [urlStringDecrypt appendString:parameter];
    
    __block NSError *errorDataDecrypt = nil;
    __weak ASIHTTPRequest *requestDecrypt = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStringDecrypt]];

    [requestDecrypt setCompletionBlock:^{
        // Use when fetching text data
        //                        NSString *responseString = [request responseString];
        // Use when fetching binary data
        
        NSData *responseData = [requestDecrypt responseData];
        
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&errorDataDecrypt];
        //NSLog(@"json:%@",json);
        
        if ([[json valueForKey:@"data"] isKindOfClass:[NSNull class]]) {
            self.textFieldAgentLicense.text = @"";
        }
        else {
            self.textFieldAgentLicense.text = [json valueForKey:@"data"];
        }
        
        
    }];
    [requestDecrypt setFailedBlock:^{
        NSError *error = [requestDecrypt error];
        NSLog(@" error:%@",error);
        
    }];
    [requestDecrypt startAsynchronous];
    
    parameter = [NSString stringWithFormat:@"?text=%@",[[self.profile.brokerage_license stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"]  stringByReplacingOccurrencesOfString:@"=" withString:@"%3D"]];
    [urlStringDecrypt setString:@"http://keydiscoveryinc.com/agent_bridge/webservice/decrypt_license.php"];
    
    [urlStringDecrypt appendString:parameter];
    
    errorDataDecrypt = nil;
    requestDecrypt = nil;
    requestDecrypt = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStringDecrypt]];
    [requestDecrypt setCompletionBlock:^{
        // Use when fetching text data
        //                        NSString *responseString = [request responseString];
        // Use when fetching binary data
        NSData *responseData = [requestDecrypt responseData];
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&errorDataDecrypt];
        //NSLog(@"Bjson:%@",json);
        
        
        if ([[json valueForKey:@"data"] isKindOfClass:[NSNull class]]) {
            self.textFieldBrokerLicense.text = @"";
        }
        else {
            self.textFieldBrokerLicense.text = [json valueForKey:@"data"];
        }
        
        
    }];
    [requestDecrypt setFailedBlock:^{
        NSError *error = [requestDecrypt error];
        NSLog(@" error:%@",error);
        
    }];
    [requestDecrypt startAsynchronous];
    
    
    parameter = [NSString stringWithFormat:@"?text=%@",[[self.profile.tax_id_num stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"]  stringByReplacingOccurrencesOfString:@"=" withString:@"%3D"]];
    [urlStringDecrypt setString:@"http://keydiscoveryinc.com/agent_bridge/webservice/decrypt_license.php"];
    
    [urlStringDecrypt appendString:parameter];
    
    errorDataDecrypt = nil;
    requestDecrypt = nil;
    requestDecrypt = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStringDecrypt]];
    [requestDecrypt setCompletionBlock:^{
        // Use when fetching text data
        //                        NSString *responseString = [request responseString];
        // Use when fetching binary data
        NSData *responseData = [requestDecrypt responseData];
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&errorDataDecrypt];
        //NSLog(@"Tjson:%@",json);
        
        
        if ([[json valueForKey:@"data"] isKindOfClass:[NSNull class]]) {
            self.textFieldTaxId.text = @"";
        }
        else {
            self.textFieldTaxId.text = [json valueForKey:@"data"];
        }
        
        
    }];
    [requestDecrypt setFailedBlock:^{
        NSError *error = [requestDecrypt error];
        NSLog(@" error:%@",error);
        
    }];
    [requestDecrypt startAsynchronous];
    
//    UITapGestureRecognizer *tapViewInfo = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resizeViewInfo)];
//    tapViewInfo.numberOfTapsRequired = 1;
//    tapViewInfo.numberOfTouchesRequired = 1;
//    [self.viewInfo addGestureRecognizer:tapViewInfo];
//    
//    UITapGestureRecognizer *tapTextView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resizeTextViewTop)];
//    tapTextView.numberOfTapsRequired = 1;
//    tapTextView.numberOfTouchesRequired = 1;
//    [self.view addGestureRecognizer:tapTextView];
    
    if (self.grossCommissionValue != nil && [self.grossCommissionValue isEqualToString:@""] == NO) {
        UIButton *sender = [[UIButton alloc] init];
        sender.tag = 1;
        if (self.grossCommission == nil) {
            self.grossCommission = [[NSMutableString alloc] init];
        }
        [self.grossCommission setString:self.grossCommissionValue];

        
        [self continuePressed:sender];
        
    }
    
    self.textViewTop.showsVerticalScrollIndicator = YES;
    
    UITapGestureRecognizer *tapTerms = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showTermsView)];
    tapTerms.numberOfTapsRequired = 1;
    tapTerms.numberOfTouchesRequired = 1;
    [self.labelAgree addGestureRecognizer:tapTerms];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) resizeViewInfo {
//    //NSLog(@"resizeView");
    
    [UIView animateWithDuration:0.5f animations:^{
        self.textViewTop.font = FONT_OPENSANS_REGULAR(10.0f);
        
        CGSize constraint = CGSizeMake(self.textViewTop.frame.size.width - 10.0f, 20000.0f);
        
        CGSize size = [self.textViewTop.text sizeWithFont:FONT_OPENSANS_REGULAR(10.0f) constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
        
        CGFloat height = MAX(size.height, 10.0f);
        
        CGRect frame = self.textViewTop.frame;
        frame.size.height = height + 25.0f;
        self.textViewTop.frame = frame;
        
        frame = self.viewInfo.frame;
        frame.origin.y = self.textViewTop.frame.size.height + self.textViewTop.frame.origin.y;
        self.viewInfo.frame = frame;
    }];
}

- (void) resizeTextViewTop {
    
//    //NSLog(@"resizeText");
    [UIView animateWithDuration:0.5f animations:^{
        self.textViewTop.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
        
        CGSize constraint = CGSizeMake(self.textViewTop.frame.size.width - 10.0f, 20000.0f);
        
        CGSize size = [self.textViewTop.text sizeWithFont:FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR) constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
        
        CGFloat height = MAX(size.height, FONT_SIZE_REGULAR);
        
        CGRect frame = self.textViewTop.frame;
        frame.size.height = height + 20.0f;
        self.textViewTop.frame = frame;
        
        frame = self.viewInfo.frame;
        frame.origin.y = self.textViewTop.frame.size.height + self.textViewTop.frame.origin.y;
        self.viewInfo.frame = frame;
    }];
}

- (IBAction)continuePressed:(id)sender {
    BOOL continueToNextView = NO;
    
    switch ([sender tag]) {
        case 1: {
            //NSLog(@"commission:%@",self.grossCommissionValue);
            if ([self textIsNull:self.grossCommission] == YES) {
                
                continueToNextView = NO;
                UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Required Information" message:@"Please enter the Gross Commission." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                av.tag = 1;
                [av show];
            }
            else {
                continueToNextView = YES;
//                NSNumberFormatter * formatter = [[NSNumberFormatter alloc] init];
//                formatter.numberStyle = NSNumberFormatterCurrencyStyle;
//                [formatter setMaximumFractionDigits:0];
//                formatter.currencyCode = @"USD";
//                
//                self.labelTotalValue.text = [formatter stringFromNumber: [NSNumber numberWithDouble:[self.grossCommission doubleValue]]];
                
                
                NSString *parameter = [NSString stringWithFormat:@"?fee=%@",self.grossCommission];
                NSMutableString *urlStringDecrypt = [NSMutableString stringWithString:@"http://keydiscoveryinc.com/agent_bridge/webservice/get_referral_fee.php"];
                
                [urlStringDecrypt appendString:parameter];
                
                __block NSError *errorData = nil;
                __weak ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStringDecrypt]];
                
                [request setCompletionBlock:^{
                    // Use when fetching text data
                    //                        NSString *responseString = [request responseString];
                    // Use when fetching binary data
                    
                    NSData *responseData = [request responseData];
                    
                    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&errorData];
//                    //NSLog(@"json:%@",json);
                    
                    if ([[json objectForKey:@"data"] count]) {
                        
                        if (self.grossCommissionValue != nil && [self.grossCommissionValue isEqualToString:@""] == NO) {
                            self.serviceFee = [[[json objectForKey:@"data"] firstObject]objectForKey:@"r1_fee"];
                        }
                        else {
                            self.serviceFee = [[[json objectForKey:@"data"] firstObject]objectForKey:@"r2_fee"];
                        }
                        NSNumberFormatter * formatter = [[NSNumberFormatter alloc] init];
                        formatter.numberStyle = NSNumberFormatterCurrencyStyle;
                        [formatter setMaximumFractionDigits:0];
                        formatter.currencyCode = @"USD";
                        
                        self.labelServiceFee.text = [NSString stringWithFormat:@"Service Fee: %@",[formatter stringFromNumber: [NSNumber numberWithDouble:[self.serviceFee doubleValue]]]];
                        
                        CGFloat total = [self.grossCommission doubleValue] + [self.serviceFee doubleValue];
                        
                        self.labelTotalValue.text = [formatter stringFromNumber: [NSNumber numberWithDouble:total]];
                        
                        NSString * commissionString = (self.grossCommissionValue != nil && [self.grossCommissionValue isEqualToString:@""] == NO)?[NSString stringWithFormat:@"Your Gross Commission: %@",[formatter stringFromNumber: [NSNumber numberWithDouble:[self.grossCommission doubleValue]]] ]: [NSString stringWithFormat:@"Gross Commission of %@: %@", self.referral_agentname, [formatter stringFromNumber: [NSNumber numberWithDouble:[self.grossCommission doubleValue]]]];
                        
                        self.textViewTop.text = [NSString stringWithFormat:@"The %@ referral fee of %@ is ready to to be disbursed. AgentBridge will now be collecting the service fee of %@.\n\n%@", self.referral_name, [formatter stringFromNumber: [NSNumber numberWithDouble:([self.grossCommission doubleValue] * self.referral_fee)]], [formatter stringFromNumber: [NSNumber numberWithDouble:[self.serviceFee doubleValue]]], commissionString ];
                        
//                        CGSize constraint = CGSizeMake(self.textViewTop.frame.size.width - 10.0f, 20000.0f);
//                        
//                        CGSize size = [self.textViewTop.text sizeWithFont:FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR) constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
//                        
//                        CGFloat height = MAX(size.height, FONT_SIZE_REGULAR);
//                        
//                        CGRect frame = self.textViewTop.frame;
//                        frame.size.height = height + 20.0f;
//                        self.textViewTop.frame = frame;
//                        
//                        frame = self.viewInfo.frame;
//                        frame.origin.y = self.textViewTop.frame.size.height + self.textViewTop.frame.origin.y;
//                        self.viewInfo.frame = frame;
                        
                    }
                    else {
                        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your Gross Commission exceeds the limit." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        [av show];
                    }
                    
                    
                }];
                [request setFailedBlock:^{
                    NSError *error = [request error];
                    NSLog(@" error:%@",error);
                    
                }];
                [request startAsynchronous];
                
                
            }
            break;
        }
        case 2: {
            if ([self textIsNull:self.textFieldFirstname.text] == NO && [self textIsNull:self.textFieldLastname.text] == NO && [self textIsNull:self.textFieldEmail.text] == NO && [self textIsNull:self.textFieldPhoneNumber.text] == NO) {
                
                if ([self NSStringIsValidEmail:self.textFieldEmail.text] == YES) {
                    continueToNextView = YES;
                }
                else {
                    continueToNextView = NO;
                    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Invalid Information" message:@"Please enter a valid Email." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    av.tag = 20;
                    [av show];
                }
            }
            else if ([self textIsNull:self.textFieldFirstname.text] == YES){
                
                continueToNextView = NO;
                UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Required Information" message:@"Please enter your First Name." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                av.tag = 21;
                [av show];
            }
            else if ([self textIsNull:self.textFieldLastname.text] == YES){
                
                continueToNextView = NO;
                UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Required Information" message:@"Please enter your Last Name." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                av.tag = 22;
                [av show];
            }
            else if ([self textIsNull:self.textFieldEmail.text] == YES){
                
                continueToNextView = NO;
                UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Required Information" message:@"Please enter your Email." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                av.tag = 23;
                [av show];
            }
            else if ([self textIsNull:self.textFieldPhoneNumber.text] == YES){
                
                continueToNextView = NO;
                UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Required Information" message:@"Please enter your Phone Number." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                av.tag = 24;
                [av show];
            }
            break;
        }
        case 3:
            continueToNextView = YES;
            break;
        case 4: {
            if ([self textIsNull:self.textFieldZipcode.text] == NO && [self textIsNull:self.textFieldCity.text] == NO && self.selectedCountryID != nil && self.selectedStateID != nil) {
                
                continueToNextView = YES;
            }
            else if ([self textIsNull:self.textFieldZipcode.text] == YES){
                
                continueToNextView = NO;
                UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Required Information" message:@"Please enter Zip code." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                av.tag = 41;
                [av show];
            }
            else if ([self textIsNull:self.textFieldCity.text] == YES){
                
                continueToNextView = NO;
                UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Required Information" message:@"Please enter City." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                av.tag = 42;
                [av show];
            }
            else if (self.selectedCountryID == nil){
                
                continueToNextView = NO;
                UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Required Information" message:@"Please select your Country." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                av.tag = 43;
                [av show];
            }
            else if (self.selectedStateID == nil){
                
                continueToNextView = NO;
                UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Required Information" message:@"Please select your State." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                av.tag = 44;
                [av show];
            }
            break;
        }
        default:
            break;
    }
    
    if (continueToNextView) {
        
        [UIView animateWithDuration:0.2 animations:^{
            [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x + 320.0f, 0.0f)];
        }];
        
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
}

- (IBAction)cancelPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (IBAction)backPressed:(id)sender {
    [UIView animateWithDuration:0.2 animations:^{
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x - 320.0f, 0.0f)];
    }];
    
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
//    [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x, 30.0f) animated:YES];
    self.viewPickerCountry.hidden = NO;
    [self.pickerCountry reloadAllComponents];
    
    [self.pickerCountry selectRow:[self.arrayOfCountry indexOfObject:@"United States"] inComponent:0 animated:YES];
}

- (IBAction)statePressed:(id)sender {
    [self.textFieldAddress1 resignFirstResponder];
    [self.textFieldAddress2 resignFirstResponder];
    [self.textFieldCity resignFirstResponder];
    [self.textFieldZipcode resignFirstResponder];
    
    [UIView animateWithDuration:0.2 animations:^{
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x, 130.0f)];
    }];
    self.viewPickerState.hidden = NO;
    [self.pickerState reloadAllComponents];
    [self.pickerState selectRow:0 inComponent:0 animated:YES];
}

- (IBAction)saveExpiryDate:(id)sender {
    [self hideViewForPickerExpiry];
}

- (IBAction)expiryPressed:(id)sender {
    
    [self.textFieldCreditCard resignFirstResponder];
    [self.textFieldSecurityCode resignFirstResponder];
    
    [UIView animateWithDuration:0.2 animations:^{
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x, 65.0f)];
    }];
    self.viewPickerExpiry.hidden = NO;
    [self.pickerExpiry reloadAllComponents];
    
}

- (IBAction)submitTransaction:(id)sender {
    
    if ([self.switchAgree isOn] && [self textIsNull:self.textFieldCreditCard.text] == NO && self.cardExpiry != nil) {
        
//        CGFloat total = [self.grossCommission doubleValue] + [self.serviceFee doubleValue];
        
        NSString *parameters = [[NSString stringWithFormat:@"?amount=%f&service_fee=%f&card_num=%@&card_exp=%@&user_id=%@&firstname=%@&lastname=%@&address=%@&city=%@&state=%@&zip=%@&country=%@&phone=%@&email=%@&referral_id=%@",[self.grossCommission doubleValue], [self.serviceFee doubleValue], self.textFieldCreditCard.text, [self.cardExpiry stringByReplacingOccurrencesOfString:@"/" withString:@"%2F"], self.user_id, self.textFieldFirstname.text, self.textFieldLastname.text, [NSString stringWithFormat:@"%@,%@",self.textFieldAddress1.text,self.textFieldAddress2.text], self.textFieldCity.text, self.selectedStateID, self.textFieldZipcode.text, self.selectedCountryID, [self.textFieldPhoneNumber.text stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding], self.textFieldEmail.text, self.referral_id] stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        
        NSMutableString *urlString = [NSMutableString stringWithString:@"http://keydiscoveryinc.com/agent_bridge/webservice/send_transaction.php"];
        [urlString appendString:parameters];
        
//        NSLog(@"url:%@",urlString);
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
        self.buttonSubmit.enabled = NO;
        //    self.activityIndicator.hidden = NO;
        __block NSError *errorData = nil;
        __weak ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlString]];
        [request setCompletionBlock:
         ^{
             NSData *responseData = [request responseData];
             NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&errorData];
             NSLog(@"json:%@",json);
             if ([[json objectForKey:@"status"] integerValue] == YES) {
                 self.invoice_number = [[json objectForKey:@"data"] objectForKey:@"invoice_number"];
                 [self createInvoicePDF];
             }
             else if ([json objectForKey:@"error"] != nil) {
                 UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Transaction Failed" message:[[json objectForKey:@"error"] substringFromIndex:[[json objectForKey:@"error"] rangeOfString:@"Response Reason Text:"].location+21] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                 [av show];
                 [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                 [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
                 self.buttonSubmit.enabled = YES;
             }
             else {
                 UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Transaction Failed" message:@"Something went wrong in your Transaction." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                 [av show];
                 [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                 [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
                 self.buttonSubmit.enabled = YES;
             }
             
         }];
        [request setFailedBlock:^{
            NSError *error = [request error];
            NSLog(@" error:%@",error);
            
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Transaction Failed" message:@"Received an Error in connection." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [av show];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
            self.buttonSubmit.enabled = YES;
        }];
        
        [request startAsynchronous];
    }
    else if ([self.switchAgree isOn] == NO){
        
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Transaction Failed" message:@"You need to agree with the Terms and Conditions." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [av show];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
        self.buttonSubmit.enabled = YES;
    }
    else if ([self textIsNull:self.textFieldCreditCard.text] == YES){
        
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Required Information" message:@"Please input your credit card number." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [av show];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
        self.buttonSubmit.enabled = YES;
    }
    else if (self.cardExpiry == nil){
        
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Required Information" message:@"Please select your credit card expiry date." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [av show];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
        self.buttonSubmit.enabled = YES;
    }
    else {
        
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Transaction Failed" message:@"Something went wrong in your Transaction." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [av show];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
        self.buttonSubmit.enabled = YES;
    }
    
}

- (IBAction)resignKeyboards:(id)sender {
    [UIView animateWithDuration:0.2 animations:^{
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x, 0.0f)];
    }];
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

- (IBAction)hideTermsView:(id)sender {
    [UIView animateWithDuration:0.2 animations:^{
        CGRect frame = self.viewForScrollView.frame;
        frame.origin.x = 0.0f;
        self.viewForScrollView.frame = frame;
//
//        frame = self.scrollView.frame;
//        frame.origin.x = 0.0f;
//        self.scrollView.frame = frame;
        
        frame = self.viewForTerms.frame;
        frame.origin.x = 320.0f;
        self.viewForTerms.frame = frame;
    } completion:^(BOOL finished) {
        
    }];
}

- (void) showTermsView {
    [UIView animateWithDuration:0.2 animations:^{
        CGRect frame = self.viewForScrollView.frame;
        frame.origin.x = -320.0f;
        self.viewForScrollView.frame = frame;
//
//        frame = self.scrollView.frame;
//        frame.origin.x = -320.0f;
//        self.scrollView.frame = frame;
        
        frame = self.viewForTerms.frame;
        frame.origin.x = 0.0f;
        self.viewForTerms.frame = frame;
    } completion:^(BOOL finished) {
        
    }];
}

- (BOOL) textIsNull:(NSString*)text {
    return ([text isEqualToString:@""] == YES || text == nil);
}

-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = YES; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

- (void) addPaddingAndBorder:(UITextField*)textField color:(UIColor*)color {
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 20)];
    textField.leftView = paddingView;
    textField.leftViewMode = UITextFieldViewModeAlways;
    
    textField.layer.borderColor = color.CGColor;
    textField.layer.borderWidth = 1.0f;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat marker = (self.grossCommissionValue != nil && [self.grossCommissionValue isEqualToString:@""] == NO)?640.0f:320.0f;
    if (self.scrollView.contentOffset.x >= marker) {
        self.buttonBack.hidden = NO;
    }
    else {
        self.buttonBack.hidden = YES;
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == self.textFieldFirstname || textField == self.textFieldLastname) {
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x, 25.0f + self.textViewTop.frame.size.height) animated:YES];
    }
    else if (textField == self.textFieldEmail || textField == self.textFieldPhoneNumber) {
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x, 50.0f + self.textViewTop.frame.size.height) animated:YES];
    }
    else if (textField == self.textFieldAgentLicense || textField == self.textFieldBrokerLicense || textField == self.textFieldTaxId) {
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x, 25.0f) animated:YES];
    }
    else if (textField == self.textFieldAddress1) {
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x, 65.0f) animated:YES];
    }
    else if (textField == self.textFieldCreditCard) {
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x, 65.0f) animated:YES];
    }
//    else if (textField == self.textFieldEmail || textField == self.textFieldPhoneNumber) {
//        [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x, 80.0f) animated:YES];
//    }
    else if (textField == self.textFieldAddress2) {
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x, 100.0f) animated:YES];
    }
    else if (textField == self.textFieldZipcode || textField == self.textFieldCity || textField == self.textFieldSecurityCode) {
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x, 130.0f) animated:YES];
    }
    else if (textField == self.textFieldGrossComission) {
        self.grossCommission = nil;
        textField.text = @"";
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == self.textFieldGrossComission) {
        if (self.grossCommission == nil) {
            self.grossCommission = [[NSMutableString alloc] init];
        }
        [self.grossCommission appendString:string];
        
        NSNumberFormatter * formatter = [[NSNumberFormatter alloc] init];
        formatter.numberStyle = NSNumberFormatterCurrencyStyle;
        [formatter setMaximumFractionDigits:0];
        formatter.currencyCode = @"USD";
        
        textField.text = [formatter stringFromNumber: [NSNumber numberWithDouble:[self.grossCommission doubleValue]]];
        
        return NO;
    }
//
    return YES;
}


- (BOOL)textFieldShouldClear:(UITextField *)textField {
    self.grossCommission = nil;
    return YES;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    if (textField == self.textFieldPhoneNumber) {
        
        NSMutableString *mobileNumber = [NSMutableString stringWithString:textField.text];
        [mobileNumber replaceOccurrencesOfString:@"-" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [mobileNumber length])];
        [mobileNumber replaceOccurrencesOfString:@"(" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [mobileNumber length])];
        [mobileNumber replaceOccurrencesOfString:@")" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [mobileNumber length])];
        [mobileNumber replaceOccurrencesOfString:@" " withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [mobileNumber length])];
        textField.text = mobileNumber;
    }
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if (textField == self.textFieldPhoneNumber) {
        
        NSMutableString *string = [NSMutableString stringWithString:textField.text];
        [string replaceOccurrencesOfString:@";" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [string length])];
        [string replaceOccurrencesOfString:@"+" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [string length])];
        [string replaceOccurrencesOfString:@"#" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [string length])];
        [string replaceOccurrencesOfString:@"*" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [string length])];
        NSMutableString *mobileNumbers = [NSMutableString stringWithString:@""];
        for (NSString *number in [string componentsSeparatedByString:@","]) {
            if (![number isEqualToString:@""]) {
                if([number length] == 7) {
                    [mobileNumbers appendString: [NSString stringWithFormat:@"%@-%@",[number substringToIndex:3],[number substringFromIndex:3]]];
                }
                else if([number length] > 7 && [number length] < 11) {
                    [mobileNumbers appendString: [NSString stringWithFormat:@"(%@) %@-%@",[number substringWithRange:NSMakeRange(0, [number length]-7)],[number substringWithRange:NSMakeRange([number length]-7, 3)],[number substringWithRange:NSMakeRange([number length]-4, 4)]]];
                }
                
                if (![number isEqualToString:[[string componentsSeparatedByString:@","] lastObject]]) {
                    [mobileNumbers appendString:@","];
                }
                
            }
        }
        
        textField.text = mobileNumbers;
    }
    
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
        if (component == 0) {
            if(row < 9){
                [expiry appendFormat:@"0%li",(long)row+1];
            }
            else {
                [expiry appendFormat:@"%li",(long)row+1];
            }
            
            NSInteger yearRow = [pickerView selectedRowInComponent:1];
            [expiry appendFormat:@"/%@",[[self.arrayOfYear objectAtIndex:yearRow] substringFromIndex:2]];
        }
        else {
            NSInteger monthRow = [pickerView selectedRowInComponent:0];
            if(monthRow < 9){
                [expiry appendFormat:@"0%li",(long)monthRow+1];
            }
            else {
                [expiry appendFormat:@"%li",(long)monthRow+1];
            }
            
            [expiry appendFormat:@"/%@",[[self.arrayOfYear objectAtIndex:row] substringFromIndex:2]];
        }
        self.cardExpiry = expiry;
        [self.buttonExpiry setTitle:[NSString stringWithFormat:@"Expiry date: %@",expiry] forState:UIControlStateNormal];
    }
    else if (pickerView == self.pickerCountry) {
        [self.buttonCountry setTitle:[self.arrayOfCountry objectAtIndex:row] forState:UIControlStateNormal];
        self.selectedCountryID = [self.arrayOfCountry_ID objectAtIndex:row];
//        [self reloadStateValues:[self.arrayOfCountry_ID objectAtIndex:row]];
    }
    else if (pickerView == self.pickerState) {
        [self.buttonState setTitle:[self.arrayOfState objectAtIndex:row] forState:UIControlStateNormal];
        self.selectedStateID = [self.arrayOfState_ID objectAtIndex:row];
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
    [UIView animateWithDuration:0.2 animations:^{
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x, 0.0f)];
    }];
    
//    //NSLog(@"country:%i, state:%i, date:%i - %i",[self.pickerCountry selectedRowInComponent:0], [self.pickerState selectedRowInComponent:0], [self.pickerExpiry selectedRowInComponent:0], [self.pickerExpiry selectedRowInComponent:1]);
    
    NSInteger rowCountry = [self.pickerCountry selectedRowInComponent:0];
    NSInteger rowState = [self.pickerState selectedRowInComponent:0];
    NSInteger rowMonth = [self.pickerExpiry selectedRowInComponent:0];
    NSInteger rowYear = [self.pickerExpiry selectedRowInComponent:1];
    
    [self.buttonCountry setTitle:[self.arrayOfCountry objectAtIndex:rowCountry] forState:UIControlStateNormal];
    self.selectedCountryID = [self.arrayOfCountry_ID objectAtIndex:rowCountry];
    
    [self.buttonState setTitle:[self.arrayOfState objectAtIndex:rowState] forState:UIControlStateNormal];
    self.selectedStateID = [self.arrayOfState_ID objectAtIndex:rowState];
    
    NSMutableString *expiry = [NSMutableString stringWithString:@""];
    if(rowMonth < 9){
        [expiry appendFormat:@"0%li",(long)rowMonth+1];
    }
    else {
        [expiry appendFormat:@"%li",(long)rowMonth+1];
    }
    
    [expiry appendFormat:@"/%@",[[self.arrayOfYear objectAtIndex:rowYear] substringFromIndex:2]];
    
    self.cardExpiry = expiry;
    [self.buttonExpiry setTitle:[NSString stringWithFormat:@"Expiry date: %@",expiry] forState:UIControlStateNormal];
    
    self.viewPickerExpiry.hidden = YES;
    self.viewPickerCountry.hidden = YES;
    self.viewPickerState.hidden = YES;
}

- (NSString*) monthName:(NSInteger)monthNumber {
    switch (monthNumber) {
        case 1:
            return @"January";
            break;
            
        case 2:
            return @"February";
            break;
            
        case 3:
            return @"March";
            break;
            
        case 4:
            return @"April";
            break;
            
        case 5:
            return @"May";
            break;
            
        case 6:
            return @"June";
            break;
            
        case 7:
            return @"July";
            break;
            
        case 8:
            return @"August";
            break;
            
        case 9:
            return @"September";
            break;
            
        case 10:
            return @"October";
            break;
            
        case 11:
            return @"November";
            break;
            
        case 12:
            return @"December";
            break;
            
        default:
            return @"January";
            break;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch ([alertView tag]) {
        case 1:
            [self.textFieldGrossComission becomeFirstResponder];
            break;
        case 21:
            [self.textFieldFirstname becomeFirstResponder];
            break;
        case 22:
            [self.textFieldLastname becomeFirstResponder];
            break;
        case 23: case 20:
            [self.textFieldEmail becomeFirstResponder];
            break;
        case 24:
            [self.textFieldPhoneNumber becomeFirstResponder];
            break;
        case 41:
            [self.textFieldZipcode becomeFirstResponder];
            break;
        case 42:
            [self.textFieldCity becomeFirstResponder];
            break;
        case 43:
            [self countryPressed:nil];
            break;
        case 44:
            [self statePressed:nil];
            break;
        case 99:{
            NSString *parameters = [NSString stringWithFormat:@"?referral_id=%@&price_paid=%@", self.referral_id, self.grossCommission];
            
            NSString *urlString = @"";
            if (self.grossCommissionValue != nil && [self.grossCommissionValue isEqualToString:@""] == NO) {
                //r1
                urlString = [NSString stringWithFormat:@"http://keydiscoveryinc.com/agent_bridge/webservice/save_closed_referral_r1.php%@", parameters];
            }
            else {
                //r2
                urlString = [NSString stringWithFormat:@"http://keydiscoveryinc.com/agent_bridge/webservice/save_closed_referral_r2.php%@", parameters];
            }
            
//            NSString *parameters = [NSString stringWithFormat:@"?referral_id=%@&price_paid=%@", self.referral_id, self.grossCommission];
//            
//            NSString *urlString = [NSString stringWithFormat:@"http://keydiscoveryinc.com/agent_bridge/webservice/save_closed_referral.php%@", parameters];
            
            
            __block NSError *errorData = nil;
            __weak ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlString]];
            [request setCompletionBlock:^{
                // Use when fetching text data
                //                        NSString *responseString = [request responseString];
                // Use when fetching binary data
                NSData *responseData = [request responseData];
                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&errorData];
                
                //NSLog(@"json:%@",json);
                if([[json objectForKey:@"status"] integerValue] == 1){
                    
                    [self dismissViewControllerAnimated:YES completion:^{
                        [self.delegate transactionCompletedSuccessfully];
                    }];
                }
                
            }];
            [request setFailedBlock:^{
                NSError *error = [request error];
                NSLog(@" error:%@",error);
                
            }];
            [request startAsynchronous];
            
            
            break;
        }
        default:
            break;
    }
}

- (void) createInvoicePDF {
    
    NSString *agent_name = [NSString stringWithFormat:@"%@ %@",self.textFieldFirstname.text, self.textFieldLastname.text];
    NSString *address = @"";
    if ([self textIsNull:self.textFieldAddress1.text] == NO && [self textIsNull:self.textFieldAddress2.text] == YES) {
        address = self.textFieldAddress1.text;
    }
    else if ([self textIsNull:self.textFieldAddress1.text] == YES && [self textIsNull:self.textFieldAddress2.text] == NO) {
        address = self.textFieldAddress2.text;
    }
    else if ([self textIsNull:self.textFieldAddress1.text] == NO && [self textIsNull:self.textFieldAddress2.text] == NO) {
        address = [NSString stringWithFormat:@"%@, %@",self.textFieldAddress1.text, self.textFieldAddress2.text];
    }
    NSString *cityStateZip = [NSString stringWithFormat:@"%@, %@ %@",self.textFieldCity.text, [self.arrayOfState objectAtIndex:[self.pickerState selectedRowInComponent:0]], self.textFieldZipcode.text];
    
    NSString *country = [self.arrayOfCountry objectAtIndex:[self.pickerCountry selectedRowInComponent:0]];
    
    NSDate *today = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *weekdayComponents = [gregorian components:(NSDayCalendarUnit | NSWeekdayCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit) fromDate:today];
    NSInteger day = [weekdayComponents day];
    NSInteger month = [weekdayComponents month];
    NSInteger year = [weekdayComponents year];
    
    NSString *invoice_date = [NSString stringWithFormat:@"%li-%li-%li",(long)month,(long)day,(long)year];
    NSString *referrence = [NSString stringWithFormat:@"%@, %@",self.referral_id, self.referral_name];
    
    NSNumberFormatter * formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterCurrencyStyle;
    [formatter setMaximumFractionDigits:0];
    formatter.currencyCode = @"USD";
    
    NSString *service_fee = [formatter stringFromNumber: [NSNumber numberWithDouble:[self.serviceFee doubleValue]]];
    
    NSString *htmlStringForPDF = [NSString stringWithFormat:HTMLSTRING_INVOICE,self.profile.broker_name, agent_name, address, cityStateZip, country, self.profile.broker_name, agent_name, address, cityStateZip, country, invoice_date, self.invoice_number, invoice_date, self.referral_id, invoice_date, invoice_date, referrence, service_fee, service_fee, service_fee, service_fee, self.profile.broker_name, agent_name, address, cityStateZip, country, self.user_id, agent_name, self.invoice_number, invoice_date, service_fee];
    
        self.webViewInvoice = [[UIWebView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 1024.0f, 768.0f)];
        self.webViewInvoice.delegate = self;
    [self.webViewInvoice loadHTMLString:htmlStringForPDF baseURL:nil];
    
}

- (void) createPaymentPDF {
    
    NSString *agent_name = [NSString stringWithFormat:@"%@ %@",self.textFieldFirstname.text, self.textFieldLastname.text];
    NSDate *today = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *weekdayComponents = [gregorian components:(NSDayCalendarUnit | NSWeekdayCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit) fromDate:today];
    NSInteger day = [weekdayComponents day];
    NSInteger month = [weekdayComponents month];
    NSInteger year = [weekdayComponents year];
    
    NSString *date_today = [NSString stringWithFormat:@"%li-%li-%li",(long)month,(long)day,(long)year];
    
    NSString *payment_date = [NSString stringWithFormat:@"%@ %li, %li",[self monthName:month],(long)day,(long)year];
    
    NSNumberFormatter * formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterCurrencyStyle;
    [formatter setMaximumFractionDigits:0];
    formatter.currencyCode = @"USD";
    
    NSString *referralFeeDetail = [formatter stringFromNumber: [NSNumber numberWithDouble:(self.referral_fee * 100.0f)]];
    
    NSString *grossCommissionSale = [formatter stringFromNumber: [NSNumber numberWithDouble:[self.grossCommission doubleValue]]];
    
    NSString *htmlStringForPDF = [NSString stringWithFormat:HTMLSTRING_PAYMENT, payment_date, self.referral_name, self.loginDetails.user_id, self.profile.broker_name, self.referral_name, self.profile.broker_name,self.textFieldBrokerLicense.text, agent_name, self.textFieldAgentLicense.text, self.textFieldPhoneNumber.text, self.textFieldEmail.text, self.textFieldTaxId.text, self.referral_name, self.client_number, self.client_email, self.client_address, self.client_type, [NSString stringWithFormat:@"%f%%",(self.referral_fee * 100.0f) ], payment_date, grossCommissionSale, [NSString stringWithFormat:@"%f%%",(self.referral_fee * 100.0f) ], referralFeeDetail];
    
    self.payment_id = [NSString stringWithFormat:@"Payment_%@_%@_%@",self.user_id,self.user_id,[date_today stringByReplacingOccurrencesOfString:@"-" withString:@"_"]];
    
        self.webViewPayment = [[UIWebView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 1024.0f, 768.0f)];
        self.webViewPayment.delegate = self;
    [self.webViewPayment loadHTMLString:htmlStringForPDF baseURL:nil];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    //NSLog(@"start");
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    //NSLog(@"error");
}

- (void)webViewDidFinishLoad:(UIWebView *)theWebView {
    if (theWebView == self.webViewInvoice) {
        
        NSUInteger contentHeight = [[theWebView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.body.scrollHeight;"]] intValue];
        //    NSUInteger contentWidth = [[theWebView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.body.scrollWidth;"]] intValue];
        [theWebView setFrame:CGRectMake(0, 0, 1024, contentHeight)];
        //    //NSLog(@"width:%i height:%i",contentWidth, contentHeight);
        
        //    self.webViewHeight = [[self.webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight;"] integerValue];
        
        CGRect screenRect = self.webViewInvoice.frame;
        UIGraphicsBeginImageContext(screenRect.size);
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        [[UIColor blackColor] set];
        CGContextFillRect(ctx, screenRect);
        
        [self.webViewInvoice.layer renderInContext:ctx];
        
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *pngPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",self.invoice_number]];
        
        CGRect lastImageRect = CGRectMake(0, 0, self.webViewInvoice.frame.size.width, self.webViewInvoice.frame.size.height);
        CGImageRef imageRef = CGImageCreateWithImageInRect([newImage CGImage], lastImageRect);
        
        newImage = [UIImage imageWithCGImage:imageRef];
        CGImageRelease(imageRef);
        [UIImagePNGRepresentation(newImage) writeToFile:pngPath atomically:YES];
        
        CGSize pageSize = CGSizeMake(self.webViewInvoice.frame.size.width, self.webViewInvoice.frame.size.height);
        
        if([self drawPdf:self.invoice_number pageSize:pageSize]) {
            NSLog(@"Successfully created invoice");
            [self createPaymentPDF];
        }
    }
    else if (theWebView == self.webViewPayment) {
        
        NSUInteger contentHeight = [[theWebView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.body.scrollHeight;"]] intValue];
        //    NSUInteger contentWidth = [[theWebView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.body.scrollWidth;"]] intValue];
        [theWebView setFrame:CGRectMake(0, 0, 1024, contentHeight)];
        //    //NSLog(@"width:%i height:%i",contentWidth, contentHeight);
        
        //    self.webViewHeight = [[self.webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight;"] integerValue];
        
        CGRect screenRect = self.webViewPayment.frame;
        UIGraphicsBeginImageContext(screenRect.size);
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        [[UIColor blackColor] set];
        CGContextFillRect(ctx, screenRect);
        
        [self.webViewPayment.layer renderInContext:ctx];
        
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *pngPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",self.payment_id]];
        
        CGRect lastImageRect = CGRectMake(0, 0, self.webViewPayment.frame.size.width, self.webViewPayment.frame.size.height);
        CGImageRef imageRef = CGImageCreateWithImageInRect([newImage CGImage], lastImageRect);
        
        newImage = [UIImage imageWithCGImage:imageRef];
        CGImageRelease(imageRef);
        [UIImagePNGRepresentation(newImage) writeToFile:pngPath atomically:YES];
        
        CGSize pageSize = CGSizeMake(self.webViewPayment.frame.size.width, self.webViewPayment.frame.size.height);
        
        if([self drawPdf:self.payment_id pageSize:pageSize]) {
            NSLog(@"Successfully created Payment");
            //if done
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Transaction Successful" message:@"Your Transaction has completed Successfully!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            av.tag = 99;
            [av show];
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
            self.buttonSubmit.enabled = YES;
        }
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    return YES;
}

- (BOOL) drawPdf:(NSString*)filename pageSize:(CGSize)pageSize
{
    NSString *fileName = [NSString stringWithFormat:@"%@.pdf",filename];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *pdfFileName = [documentsDirectory stringByAppendingPathComponent:fileName];
    
    UIGraphicsBeginPDFContextToFile(pdfFileName, CGRectZero, nil);
    
    // Mark the beginning of a new page.
    UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, pageSize.width, pageSize.height), nil);
    
//    double currentHeight = 0.0;
        NSString *pngPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", filename]];
        UIImage *pngImage = [UIImage imageWithContentsOfFile:pngPath];
        
        [pngImage drawInRect:CGRectMake(0, /*currentHeight*/0, pageSize.width, pngImage.size.height)];
//        currentHeight += pngImage.size.height;
    
    UIGraphicsEndPDFContext();
    
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSError *error;
    BOOL success =[fileManager removeItemAtPath:pngPath error:&error];
    
    return success;
}

@end
