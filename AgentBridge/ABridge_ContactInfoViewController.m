//
//  ABridge_ContactInfoViewController.m
//  AgentBridge
//
//  Created by host24_iOS Dev on 11/28/13.
//  Copyright (c) 2013 host24_iOS Dev. All rights reserved.
//

#import "ABridge_ContactInfoViewController.h"
#import "AgentProfile.h"
#import "ASIHTTPRequest.h"
#import "ContactInfoNumber.h"

@interface ABridge_ContactInfoViewController ()
@property (weak, nonatomic) IBOutlet UILabel *aboutMeTitle;
@property (weak, nonatomic) IBOutlet UILabel *mobileHeader;
@property (weak, nonatomic) IBOutlet UILabel *workHeader;
@property (weak, nonatomic) IBOutlet UILabel *faxHeader;
@property (weak, nonatomic) IBOutlet UITextField *textFieldMobileNumber;
@property (weak, nonatomic) IBOutlet UIView *viewContent;
@property (weak, nonatomic) IBOutlet UITextField *textFieldWorkNumber;
@property (weak, nonatomic) IBOutlet UITextField *textFieldFaxNumber;
@property (weak, nonatomic) IBOutlet UIButton *buttonSave;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbarAccessory;
@property (strong, nonatomic) NSMutableArray *arrayOfMobileNumber;
@property (strong, nonatomic) NSMutableArray *arrayOfFaxNumber;
@property (strong, nonatomic) NSMutableArray *arrayOfWorkNumber;
@property (strong, nonatomic) LoginDetails *loginDetails;
- (IBAction)saveContacts:(id)sender;
- (IBAction)backButton:(id)sender;
- (IBAction)dismissKeyboard:(id)sender;
- (IBAction)insertComma:(id)sender;

@end

@implementation ABridge_ContactInfoViewController
@synthesize arrayOfMobileNumber;
@synthesize arrayOfFaxNumber;
@synthesize arrayOfWorkNumber;
@synthesize loginDetails;

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
    self.slidingViewController.underRightViewController = nil;
    
    self.aboutMeTitle.font = FONT_OPENSANS_REGULAR(FONT_SIZE_TITLE);
    self.mobileHeader.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
    self.workHeader.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
    self.faxHeader.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
    self.textFieldMobileNumber.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
    self.textFieldWorkNumber.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
    self.textFieldFaxNumber.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
    self.buttonSave.titleLabel.font = FONT_OPENSANS_BOLD(FONT_SIZE_SMALL);
    
    self.activityIndicator.hidden = YES;
    
    [self addPaddingAndBorder:self.textFieldMobileNumber color:[UIColor colorWithRed:178.0f/255.0f green:178.0f/255.0f blue:178.0f/255.0f alpha:1.0f]];
    
    [self addPaddingAndBorder:self.textFieldFaxNumber color:[UIColor colorWithRed:178.0f/255.0f green:178.0f/255.0f blue:178.0f/255.0f alpha:1.0f]];
    
    [self addPaddingAndBorder:self.textFieldWorkNumber color:[UIColor colorWithRed:178.0f/255.0f green:178.0f/255.0f blue:178.0f/255.0f alpha:1.0f]];
    
    NSManagedObjectContext *context = ((ABridge_AppDelegate *)[[UIApplication sharedApplication] delegate]).managedObjectContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"LoginDetails"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error = nil;
    self.loginDetails = (LoginDetails*)[[context executeFetchRequest:fetchRequest error:&error] firstObject];
//
//    NSFetchRequest *fetchRequestProfile = [[NSFetchRequest alloc] init];
//    NSEntityDescription *entityProfile = [NSEntityDescription entityForName:@"AgentProfile"
//                                                     inManagedObjectContext:context];
//    [fetchRequestProfile setEntity:entityProfile];
//    
//    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"user_id == %@", loginDetails.user_id];
//    [fetchRequestProfile setPredicate:predicate];
//    
//    NSError *errorProfile = nil;
//    AgentProfile *profile = (AgentProfile*)[[context executeFetchRequest:fetchRequestProfile error:&errorProfile] firstObject];
//    
    self.textFieldMobileNumber.text = @"";
//    self.textFieldMobileNumber.text = profile.mobile_number;
    
    self.textFieldFaxNumber.text = @"";
    self.textFieldWorkNumber.text = @"";
    
    NSString *parameters = [NSString stringWithFormat:@"?user_id=%@",self.loginDetails.user_id];
    
    NSMutableString *urlString = [NSMutableString stringWithString:@"http://keydiscoveryinc.com/agent_bridge/webservice/get_mobilenumber.php"];
    [urlString appendString:parameters];
    
    self.activityIndicator.hidden = NO;
    __block NSError *errorData = nil;
    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    [request setCompletionBlock:
     ^{
         NSData *responseData = [request responseData];
         NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&errorData];
         
         if ([[json objectForKey:@"data"] count]) {
             NSMutableString *numbers = [NSMutableString stringWithString:@""];
             NSManagedObjectContext *context = ((ABridge_AppDelegate *)[[UIApplication sharedApplication] delegate]).managedObjectContext;
             for (NSDictionary *entry in [json objectForKey:@"data"]) {
                 ContactInfoNumber *contactInfo = nil;
                 
                 NSPredicate * predicate = [NSPredicate predicateWithFormat:@"pk_id == %@", [entry objectForKey:@"pk_id"]];
                 NSArray *result = [self fetchObjectsWithEntityName:@"ContactInfoNumber" andPredicate:predicate];
                 if ([result count]) {
                     contactInfo = (ContactInfoNumber*)[result firstObject];
                 }
                 else {
                     contactInfo = [NSEntityDescription insertNewObjectForEntityForName: @"ContactInfoNumber" inManagedObjectContext: context];
                 }
                 
                 [contactInfo setValuesForKeysWithDictionary:entry];
                 
                 //                NSLog(@"agent:%@",[agent valueForKey:@"firstname"]);
                 
                 NSError *error = nil;
                 if (![context save:&error]) {
                     NSLog(@"Error on saving Buyer:%@",[error localizedDescription]);
                 }
                 else {
                     if (self.arrayOfMobileNumber == nil) {
                         self.arrayOfMobileNumber = [[NSMutableArray alloc] init];
                     }
                     
                     [self.arrayOfMobileNumber addObject:contactInfo];
                 }
                 
                 [numbers appendString:[entry valueForKey:@"value"]];
                 if (![entry isEqualToDictionary:[[json objectForKey:@"data"] lastObject]]) {
                     [numbers appendString:@","];
                 }
             }
             
             self.textFieldMobileNumber.text = numbers;
         }
         else {
             
         }
         self.activityIndicator.hidden = YES;
         
     }];
    [request setFailedBlock:^{
        NSError *error = [request error];
        NSLog(@" error:%@",error);
    }];
    
    [request startAsynchronous];
    
    parameters = [NSString stringWithFormat:@"?user_id=%@",self.loginDetails.user_id];
    
    urlString = [NSMutableString stringWithString:@"http://keydiscoveryinc.com/agent_bridge/webservice/get_faxnumber.php"];
    [urlString appendString:parameters];
    
    self.activityIndicator.hidden = NO;
    errorData = nil;
    request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    [request setCompletionBlock:
     ^{
         NSData *responseData = [request responseData];
         NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&errorData];
         
         if ([[json objectForKey:@"data"] count]) {
             NSMutableString *numbers = [NSMutableString stringWithString:@""];
             NSManagedObjectContext *context = ((ABridge_AppDelegate *)[[UIApplication sharedApplication] delegate]).managedObjectContext;
             for (NSDictionary *entry in [json objectForKey:@"data"]) {
                 ContactInfoNumber *contactInfo = nil;
                 
                 NSPredicate * predicate = [NSPredicate predicateWithFormat:@"pk_id == %@", [entry objectForKey:@"pk_id"]];
                 NSArray *result = [self fetchObjectsWithEntityName:@"ContactInfoNumber" andPredicate:predicate];
                 if ([result count]) {
                     contactInfo = (ContactInfoNumber*)[result firstObject];
                 }
                 else {
                     contactInfo = [NSEntityDescription insertNewObjectForEntityForName: @"ContactInfoNumber" inManagedObjectContext: context];
                 }
                 
                 [contactInfo setValuesForKeysWithDictionary:entry];
                 
                 //                NSLog(@"agent:%@",[agent valueForKey:@"firstname"]);
                 
                 NSError *error = nil;
                 if (![context save:&error]) {
                     NSLog(@"Error on saving Buyer:%@",[error localizedDescription]);
                 }
                 else {
                     if (self.arrayOfFaxNumber == nil) {
                         self.arrayOfFaxNumber = [[NSMutableArray alloc] init];
                     }
                     
                     [self.arrayOfFaxNumber addObject:contactInfo];
                 }
                 
                 [numbers appendString:[entry valueForKey:@"value"]];
                 if (![entry isEqualToDictionary:[[json objectForKey:@"data"] lastObject]]) {
                     [numbers appendString:@","];
                 }
             }
             
             self.textFieldFaxNumber.text = numbers;
         }
         else {
             
         }
         self.activityIndicator.hidden = YES;
         
     }];
    [request setFailedBlock:^{
        NSError *error = [request error];
        NSLog(@" error:%@",error);
    }];
    
    [request startAsynchronous];
    
    parameters = [NSString stringWithFormat:@"?user_id=%@",self.loginDetails.user_id];
    
    urlString = [NSMutableString stringWithString:@"http://keydiscoveryinc.com/agent_bridge/webservice/get_worknumber.php"];
    [urlString appendString:parameters];
    
    self.activityIndicator.hidden = NO;
    errorData = nil;
    request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    [request setCompletionBlock:
     ^{
         NSData *responseData = [request responseData];
         NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&errorData];
         
         if ([[json objectForKey:@"data"] count]) {
             NSMutableString *numbers = [NSMutableString stringWithString:@""];
             NSManagedObjectContext *context = ((ABridge_AppDelegate *)[[UIApplication sharedApplication] delegate]).managedObjectContext;
             for (NSDictionary *entry in [json objectForKey:@"data"]) {
                 ContactInfoNumber *contactInfo = nil;
                 
                 NSPredicate * predicate = [NSPredicate predicateWithFormat:@"pk_id == %@", [entry objectForKey:@"pk_id"]];
                 NSArray *result = [self fetchObjectsWithEntityName:@"ContactInfoNumber" andPredicate:predicate];
                 if ([result count]) {
                     contactInfo = (ContactInfoNumber*)[result firstObject];
                 }
                 else {
                     contactInfo = [NSEntityDescription insertNewObjectForEntityForName: @"ContactInfoNumber" inManagedObjectContext: context];
                 }
                 
                 [contactInfo setValuesForKeysWithDictionary:entry];
                 
                 //                NSLog(@"agent:%@",[agent valueForKey:@"firstname"]);
                 
                 NSError *error = nil;
                 if (![context save:&error]) {
                     NSLog(@"Error on saving Buyer:%@",[error localizedDescription]);
                 }
                 else {
                     if (self.arrayOfWorkNumber == nil) {
                         self.arrayOfWorkNumber = [[NSMutableArray alloc] init];
                     }
                     
                     [self.arrayOfWorkNumber addObject:contactInfo];
                 }
                 
                 [numbers appendString:[entry valueForKey:@"value"]];
                 if (![entry isEqualToDictionary:[[json objectForKey:@"data"] lastObject]]) {
                     [numbers appendString:@","];
                 }
             }
             
             self.textFieldWorkNumber.text = numbers;
         }
         else {
             
         }
         self.activityIndicator.hidden = YES;
         
     }];
    [request setFailedBlock:^{
        NSError *error = [request error];
        NSLog(@" error:%@",error);
    }];
    
    [request startAsynchronous];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveContacts:(id)sender {
//    if([self.textFieldMobileNumber.text isEqualToString:@""]) {
//        
//    }
//    else {
//        for (NSString *number in [self.textFieldMobileNumber.text componentsSeparatedByString:@","]) {
//            if(![number isEqualToString:@""]) {
//                
//                NSPredicate * predicate = [NSPredicate predicateWithFormat:@"value == %@", number];
//                NSString *number_id = ((ContactInfoNumber*)[[self fetchObjectsWithEntityName:@"ContactInfoNumber" andPredicate:predicate] firstObject]).pk_id;
//                
//                NSString *parameters = [NSString stringWithFormat:@"?id=%@&user_id=%@value_number=%@",number_id,self.loginDetails.user_id,number];
//                
//                NSMutableString *urlString = [NSMutableString stringWithString:@"http://keydiscoveryinc.com/agent_bridge/webservice/change_mobilenumber.php"];
//                [urlString appendString:parameters];
//                
//                self.activityIndicator.hidden = NO;
//                __block NSError *errorData = nil;
//                __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlString]];
//                
//                [request setCompletionBlock:
//                 ^{
//                     NSData *responseData = [request responseData];
//                     NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&errorData];
//                     
//                     if ([[json objectForKey:@"status"] count]) {
//                         NSLog(@"successfully saved");
//                     }
//                     else {
//                         NSLog(@"failed to saved");
//                     }
//                     
//                 }];
//                [request setFailedBlock:^{
//                    NSError *error = [request error];
//                    NSLog(@" error:%@",error);
//                }];
//                
//                [request startAsynchronous];
//            }
//        }
//    }
    
}

- (IBAction)backButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)dismissKeyboard:(id)sender {
    [UIView animateWithDuration:0.2 animations:^{
        CGRect frame = self.viewContent.frame;
        frame.origin.y = 52.0f;
        self.viewContent.frame = frame;
    } completion:^(BOOL finished) {
        
    }];
    
    [self.textFieldMobileNumber resignFirstResponder];
    [self.textFieldFaxNumber resignFirstResponder];
    [self.textFieldWorkNumber resignFirstResponder];
}

- (IBAction)insertComma:(id)sender {
    if ([self.textFieldMobileNumber isFirstResponder]) {
        self.textFieldMobileNumber.text = [NSString stringWithFormat:@"%@,",self.textFieldMobileNumber.text];
    }
    else if ([self.textFieldFaxNumber isFirstResponder]) {
        self.textFieldFaxNumber.text = [NSString stringWithFormat:@"%@,",self.textFieldFaxNumber.text];
    }
    else if ([self.textFieldWorkNumber isFirstResponder]) {
        self.textFieldWorkNumber.text = [NSString stringWithFormat:@"%@,",self.textFieldWorkNumber.text];
    }
}

- (void) addPaddingAndBorder:(UITextField*)textField color:(UIColor*)color {
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 20)];
    textField.leftView = paddingView;
    textField.leftViewMode = UITextFieldViewModeAlways;
    
    textField.layer.borderColor = color.CGColor;
    textField.layer.borderWidth = 1.0f;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [textField setInputAccessoryView:self.toolbarAccessory];
    
    NSMutableString *mobileNumber = [NSMutableString stringWithString:textField.text];
    [mobileNumber replaceOccurrencesOfString:@"-" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [mobileNumber length])];
    [mobileNumber replaceOccurrencesOfString:@"(" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [mobileNumber length])];
    [mobileNumber replaceOccurrencesOfString:@")" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [mobileNumber length])];
    [mobileNumber replaceOccurrencesOfString:@" " withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [mobileNumber length])];
    textField.text = mobileNumber;
    
    [UIView animateWithDuration:0.2 animations:^{
        CGRect frame = self.viewContent.frame;
        if (textField == self.textFieldMobileNumber) {
            frame.origin.y = 52.0f;
        }
        else if (textField == self.textFieldWorkNumber) {
            frame.origin.y = -12.0f;
        }
        else if (textField == self.textFieldFaxNumber) {
            frame.origin.y = -82.0f;
        }
        self.viewContent.frame = frame;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSMutableString *string = [NSMutableString stringWithString:textField.text];
    [string replaceOccurrencesOfString:@";" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [string length])];
    [string replaceOccurrencesOfString:@"+" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [string length])];
    [string replaceOccurrencesOfString:@"#" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [string length])];
    [string replaceOccurrencesOfString:@"*" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [string length])];
    NSMutableString *mobileNumbers = [NSMutableString stringWithString:@""];
    for (NSString *number in [string componentsSeparatedByString:@","]) {
        if (![number isEqualToString:@""]) {
            if([number length] == 7) {
                [mobileNumbers appendString: [NSString stringWithFormat:@"%@-%@",[number substringToIndex:3],[number substringFromIndex:4]]];
            }
            else if([number length] > 7 && [number length] < 11) {
                [mobileNumbers appendString: [NSString stringWithFormat:@"(%@)%@-%@",[number substringWithRange:NSMakeRange(0, [number length]-7)],[number substringWithRange:NSMakeRange([number length]-7, 3)],[number substringWithRange:NSMakeRange([number length]-4, 4)]]];
            }
            
            if (![number isEqualToString:[[string componentsSeparatedByString:@","] lastObject]]) {
                [mobileNumbers appendString:@","];
            }
            
        }
    }
    
    textField.text = mobileNumbers;
}


@end
