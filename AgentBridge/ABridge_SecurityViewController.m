//
//  ABridge_SecurityViewController.m
//  AgentBridge
//
//  Created by host24_iOS Dev on 11/28/13.
//  Copyright (c) 2013 host24_iOS Dev. All rights reserved.
//

#import "ABridge_SecurityViewController.h"
#import "ASIHTTPRequest.h"
#import "LoginDetails.h"

@interface ABridge_SecurityViewController ()
@property (weak, nonatomic) IBOutlet UILabel *securityTitle;
@property (weak, nonatomic) IBOutlet UILabel *labelNewPassword;
@property (weak, nonatomic) IBOutlet UILabel *confirmPasswordHeader;
@property (weak, nonatomic) IBOutlet UITextField *textFieldNewPassword;
@property (weak, nonatomic) IBOutlet UITextField *textFieldOldPassword;
@property (weak, nonatomic) IBOutlet UITextField *textFieldConfirmPassword;
@property (weak, nonatomic) IBOutlet UIView *viewContent;
@property (weak, nonatomic) IBOutlet UIButton *buttonSave;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *barButtonPrev;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *barButtonNext;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbarAccessory;
@property (strong, nonatomic) UITextField *currentTextField;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
- (IBAction)savePassword:(id)sender;
- (IBAction)dismissKeyboard:(id)sender;
- (IBAction)prevItem:(id)sender;
- (IBAction)nextItem:(id)sender;

@end

@implementation ABridge_SecurityViewController
@synthesize securityTitle;
@synthesize labelNewPassword;
@synthesize confirmPasswordHeader;
@synthesize textFieldConfirmPassword;
@synthesize textFieldNewPassword;
@synthesize buttonSave;
@synthesize currentTextField;
@synthesize textFieldOldPassword;
@synthesize barButtonNext;
@synthesize barButtonPrev;
@synthesize toolbarAccessory;
@synthesize viewContent;

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
    self.textFieldNewPassword.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
    self.textFieldConfirmPassword.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
    self.textFieldOldPassword.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
    self.buttonSave.titleLabel.font = FONT_OPENSANS_BOLD(FONT_SIZE_SMALL);
    
    [self addPaddingAndBorder:self.textFieldNewPassword color:[UIColor colorWithRed:178.0f/255.0f green:178.0f/255.0f blue:178.0f/255.0f alpha:1.0f]];
    
    [self addPaddingAndBorder:self.textFieldConfirmPassword color:[UIColor colorWithRed:178.0f/255.0f green:178.0f/255.0f blue:178.0f/255.0f alpha:1.0f]];
    
    [self addPaddingAndBorder:self.textFieldOldPassword color:[UIColor colorWithRed:178.0f/255.0f green:178.0f/255.0f blue:178.0f/255.0f alpha:1.0f]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)savePassword:(id)sender {
    
    if ([self.textFieldOldPassword.text isEqualToString:@""] || self.textFieldOldPassword.text == nil) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please input your current password" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [av show];
    }
    else if ([self.textFieldNewPassword.text isEqualToString:@""] || self.textFieldNewPassword.text == nil) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please input your New password" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [av show];
    }
    else if ([self.textFieldConfirmPassword.text isEqualToString:@""] || self.textFieldConfirmPassword.text == nil) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please Confirm your New password" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [av show];
    }
    else if ([self.textFieldNewPassword.text isEqualToString:self.textFieldConfirmPassword.text]) {
        self.buttonSave.enabled=NO;
        self.activityIndicator.hidden = NO;
        NSManagedObjectContext *context = ((ABridge_AppDelegate *)[[UIApplication sharedApplication] delegate]).managedObjectContext;
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"LoginDetails"
                                                  inManagedObjectContext:context];
        [fetchRequest setEntity:entity];
        NSError *error = nil;
        NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
        
        LoginDetails *loginDetail = (LoginDetails*)[fetchedObjects firstObject];
        
        NSString *parameters = [NSString stringWithFormat:@"?user_id=%@&email=%@&password=%@",loginDetail.user_id,loginDetail.email,self.textFieldOldPassword.text];
        
        NSMutableString *urlString = [NSMutableString stringWithString:@"http://keydiscoveryinc.com/agent_bridge/webservice/check_password.php"];
        [urlString appendString:parameters];
        __block NSError *errorData = nil;
        __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlString]];
        //            [self.activityIndicator startAnimating];
        //            self.activityIndicator.hidden = NO;
        [request setCompletionBlock:
         ^{
             NSData *responseData = [request responseData];
             NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&errorData];
             
             NSLog(@"json:%@",json);
             if ([[json objectForKey:@"data"] count]) {
                 NSString *parameters = [NSString stringWithFormat:@"?user_id=%@&email=%@&password=%@",loginDetail.user_id,loginDetail.email,self.textFieldNewPassword.text];
                 
                 NSMutableString *urlString = [NSMutableString stringWithString:@"http://keydiscoveryinc.com/agent_bridge/webservice/change_password.php"];
                 [urlString appendString:parameters];
                 
                 __block NSError *errorDataPassword = nil;
                 __block ASIHTTPRequest *requestPassword = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlString]];
                 //            [self.activityIndicator startAnimating];
                 //            self.activityIndicator.hidden = NO;
                 [requestPassword setCompletionBlock:
                  ^{
                      NSData *responseData = [requestPassword responseData];
                      NSDictionary *jsonPassword = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&errorDataPassword];
                      
                      if ([[json objectForKey:@"status"] integerValue] == YES) {
                          
                          UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Successfully Changed your Password" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                          [av show];
                          
                          self.textFieldOldPassword.text = @"";
                          self.textFieldNewPassword.text = @"";
                          self.textFieldConfirmPassword.text = @"";
                      }
                      else {
                          
                          UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed in Changing your Password" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                          [av show];
                      }
                      
                  }];
                 [requestPassword setFailedBlock:^{
                     NSError *error = [requestPassword error];
                     NSLog(@" error:%@",error);
                 }];
                 
                 [requestPassword startAsynchronous];
             }
             else {
                 
                 NSLog(@"error");
                 UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your Old Password is incorrect." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                 [av show];
             }
             
             self.buttonSave.enabled=YES;
             self.activityIndicator.hidden = YES;
         }];
        [request setFailedBlock:^{
            NSError *error = [request error];
            NSLog(@" error:%@",error);
        }];
        
        [request startAsynchronous];
        
        
    }
    else {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error" message:@"New Password and Confirm Password does not match." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [av show];
    }
}

- (IBAction)dismissKeyboard:(id)sender {
    [UIView animateWithDuration:0.2f animations:^{
        CGRect frame = self.viewContent.frame;
            frame.origin.y = 107.0f;
        
        self.viewContent.frame = frame;
    }];
    
    [self.currentTextField resignFirstResponder];
}

- (IBAction)prevItem:(id)sender {
    if (self.currentTextField == self.textFieldNewPassword) {
        [self.textFieldOldPassword becomeFirstResponder];
    }
    else if (self.currentTextField == self.textFieldConfirmPassword) {
        [self.textFieldNewPassword becomeFirstResponder];
    }
}

- (IBAction)nextItem:(id)sender {
    if (self.currentTextField == self.textFieldOldPassword) {
        [self.textFieldNewPassword becomeFirstResponder];
    }
    else if (self.currentTextField == self.textFieldNewPassword) {
        [self.textFieldConfirmPassword becomeFirstResponder];
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    textField.inputAccessoryView = self.toolbarAccessory;
    self.currentTextField = textField;
    [UIView animateWithDuration:0.2f animations:^{
        CGRect frame = self.viewContent.frame;
        if (textField == self.textFieldOldPassword) {
            frame.origin.y = 107.0f;
            self.barButtonPrev.enabled = NO;
            self.barButtonNext.enabled = YES;
        }
        else if (textField == self.textFieldNewPassword) {
            frame.origin.y = -35.0f;
            self.barButtonPrev.enabled = YES;
            self.barButtonNext.enabled = YES;
        }
        else if (textField == self.textFieldConfirmPassword) {
            frame.origin.y = -47.0f;
            self.barButtonPrev.enabled = YES;
            self.barButtonNext.enabled = NO;
        }
        
        self.viewContent.frame = frame;
    }];
}


- (void) addPaddingAndBorder:(UITextField*)textField color:(UIColor*)color {
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 20)];
    textField.leftView = paddingView;
    textField.leftViewMode = UITextFieldViewModeAlways;
    
    textField.layer.borderColor = color.CGColor;
    textField.layer.borderWidth = 1.0f;
}
@end
