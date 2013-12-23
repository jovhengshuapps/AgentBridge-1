//
//  ABridge_AgentInvitesViewController.m
//  AgentBridge
//
//  Created by host24_iOS Dev on 12/10/13.
//  Copyright (c) 2013 host24_iOS Dev. All rights reserved.
//

#import "ABridge_AgentInvitesViewController.h"
#import "AgentProfile.h"

@interface ABridge_AgentInvitesViewController ()
@property (weak, nonatomic) IBOutlet UILabel *labelInviteTitle;
@property (weak, nonatomic) IBOutlet UITextField *textFieldFirstname;
@property (weak, nonatomic) IBOutlet UITextField *textFieldLastname;
@property (weak, nonatomic) IBOutlet UITextField *textFieldEmail;
@property (weak, nonatomic) IBOutlet UITextField *textFieldZipcode;
@property (weak, nonatomic) IBOutlet UIButton *buttonSend;
@property (weak, nonatomic) IBOutlet UIView *viewContent;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
- (IBAction)sendInvite:(id)sender;

@property (assign, nonatomic) NSInteger numberOfInvites;
@property (strong, nonatomic) AgentProfile *profileData;

@end

@implementation ABridge_AgentInvitesViewController
@synthesize numberOfInvites;
@synthesize profileData;

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
    
    self.labelInviteTitle.font = FONT_OPENSANS_REGULAR(FONT_SIZE_TITLE);
    self.textFieldFirstname.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
    self.textFieldLastname.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
    self.textFieldEmail.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
    self.textFieldZipcode.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
    self.buttonSend.titleLabel.font = FONT_OPENSANS_BOLD(FONT_SIZE_REGULAR);
    
    [self addPaddingAndBorder:self.textFieldEmail color:[UIColor colorWithRed:178.0f/255.0f green:178.0f/255.0f blue:178.0f/255.0f alpha:1.0f]];
    
    [self addPaddingAndBorder:self.textFieldFirstname color:[UIColor colorWithRed:178.0f/255.0f green:178.0f/255.0f blue:178.0f/255.0f alpha:1.0f]];
    
    [self addPaddingAndBorder:self.textFieldLastname color:[UIColor colorWithRed:178.0f/255.0f green:178.0f/255.0f blue:178.0f/255.0f alpha:1.0f]];
    
    [self addPaddingAndBorder:self.textFieldZipcode color:[UIColor colorWithRed:178.0f/255.0f green:178.0f/255.0f blue:178.0f/255.0f alpha:1.0f]];
    
    NSManagedObjectContext *context = ((ABridge_AppDelegate *)[[UIApplication sharedApplication] delegate]).managedObjectContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"LoginDetails" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error = nil;
    NSArray *fetchedObjects = [context
                               executeFetchRequest:fetchRequest error:&error];
    
    fetchRequest = [[NSFetchRequest alloc] init];
    entity = [NSEntityDescription entityForName:@"AgentProfile"
                         inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    error = nil;
    fetchedObjects = nil;
    fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    for (AgentProfile *profile in fetchedObjects) {
        if ([profile.user_id integerValue] == [[[fetchedObjects firstObject] valueForKey:@"user_id"] integerValue]) {
            self.profileData = profile;
            break;
        }
    }
    
    [self checkInvites];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) checkInvites {
    NSString *parameters = [NSString stringWithFormat:@"?profile_id=%@", self.profileData.profile_id];
    
    NSString *urlString = [NSString stringWithFormat:@"http://keydiscoveryinc.com/agent_bridge/webservice/getinvites.php%@",parameters];
    
    __block NSError *errorData = nil;
    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setCompletionBlock:^{
        NSData *responseData = [request responseData];
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&errorData];
        
        self.numberOfInvites = 10 - [[json objectForKey:@"data"] count];
        
        if (self.numberOfInvites < 1) {
            self.labelInviteTitle.text = [NSString stringWithFormat:@"You have used up all your invite credits.",self.numberOfInvites];
            [self.labelInviteTitle sizeToFit];
            
            self.textFieldEmail.hidden = YES;
            self.textFieldFirstname.hidden = YES;
            self.textFieldLastname.hidden = YES;
            self.textFieldZipcode.hidden = YES;
            self.buttonSend.hidden = YES;
        }
        else {
            
            self.labelInviteTitle.text = [NSString stringWithFormat:@"You may sponsor %i agents for membership.",self.numberOfInvites];
            [self.labelInviteTitle sizeToFit];
            
            self.textFieldEmail.text = @"";
            self.textFieldFirstname.text = @"";
            self.textFieldLastname.text = @"";
            self.textFieldZipcode.text = @"";
            self.buttonSend.enabled = YES;
        }
        
    }];
    [request setFailedBlock:^{
        NSError *error = [request error];
        NSLog(@"25 error:%@",error);
        
    }];
    [request startAsynchronous];
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

- (IBAction)sendInvite:(id)sender {
    [self.textFieldFirstname resignFirstResponder];
    [self.textFieldLastname resignFirstResponder];
    [self.textFieldEmail resignFirstResponder];
    [self.textFieldZipcode resignFirstResponder];
    
    self.buttonSend.enabled = NO;
    self.activityIndicator.hidden = NO;
    if ([self NSStringIsValidEmail:self.textFieldEmail.text]) {
        NSString *parameters = [NSString stringWithFormat:@"?email=%@", self.textFieldEmail.text];
        
        NSString *urlString = [NSString stringWithFormat:@"http://keydiscoveryinc.com/agent_bridge/webservice/validate_invite.php%@",parameters];
        
        __block NSError *errorData = nil;
        __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlString]];
        [request setCompletionBlock:^{
            NSData *responseData = [request responseData];
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&errorData];
            
            if ([[json objectForKey:@"status"] integerValue] > 0) {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invite Error" message:[json objectForKey:@"message"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                self.buttonSend.enabled = YES;
                self.activityIndicator.hidden = YES;
            }
            else {
                //Submit invite
                
                self.buttonSend.enabled = NO;
                self.activityIndicator.hidden = NO;
                
                [self submit];
            }
            
        }];
        [request setFailedBlock:^{
            NSError *error = [request error];
            NSLog(@"25 error:%@",error);
            
        }];
        [request startAsynchronous];
    }
    else {
        
        self.buttonSend.enabled = YES;
        self.activityIndicator.hidden = YES;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invite Error" message:@"Please Input a valid Email Address" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

- (void) submit {
    NSString *parametersSend = [NSString stringWithFormat:@"?firstname=%@&lastname=%@&email=%@&zip=%@&user_id=%@&profile_id=%@", self.textFieldFirstname.text, self.textFieldLastname.text, self.textFieldEmail.text, self.textFieldZipcode.text, self.profileData.user_id, self.profileData.profile_id];
    
    NSString *urlStringSend = [NSString stringWithFormat:@"http://keydiscoveryinc.com/agent_bridge/webservice/send_invite.php%@",parametersSend];
//    NSLog(@"url:%@",urlStringSend);
    __block NSError *errorDataSend = nil;
    __block ASIHTTPRequest *requestSend = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStringSend]];
    [requestSend setCompletionBlock:^{
        NSData *responseDataSend = [requestSend responseData];
        NSDictionary *jsonSend = [NSJSONSerialization JSONObjectWithData:responseDataSend options:NSJSONReadingAllowFragments error:&errorDataSend];
//        NSLog(@"%@json:%@",[requestSend responseString],jsonSend);
        if ([[jsonSend objectForKey:@"status"] integerValue] == 1) {
            
            NSLog(@"Successful");
        
                                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message" message:@"Invitation Sent." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                  [alert show];
            [self checkInvites];
        }
        else {
            NSLog(@"Failed");
        }
        self.buttonSend.enabled = YES;
        self.activityIndicator.hidden = YES;
        
    }];
    [requestSend setFailedBlock:^{
        NSError *error = [requestSend error];
        NSLog(@"25 error:%@",error);
        
    }];
    [requestSend startAsynchronous];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return NO;
}

- (void) addPaddingAndBorder:(UITextField*)textField color:(UIColor*)color {
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 20)];
    textField.leftView = paddingView;
    textField.leftViewMode = UITextFieldViewModeAlways;
    
    textField.layer.borderColor = color.CGColor;
    textField.layer.borderWidth = 1.0f;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [UIView animateWithDuration:0.2 animations:^{
        CGRect frame = self.viewContent.frame;
            frame.origin.y = -17.0f;
        self.viewContent.frame = frame;
    }];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [UIView animateWithDuration:0.2 animations:^{
        CGRect frame = self.viewContent.frame;
        frame.origin.y = 52.0f;
        self.viewContent.frame = frame;
    }];
}



@end
