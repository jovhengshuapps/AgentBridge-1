//
//  ABridge_BrokerageViewController.m
//  AgentBridge
//
//  Created by host24_iOS Dev on 11/28/13.
//  Copyright (c) 2013 host24_iOS Dev. All rights reserved.
//

#import "ABridge_BrokerageViewController.h"
#import "AgentProfile.h"

@interface ABridge_BrokerageViewController ()
@property (weak, nonatomic) IBOutlet UILabel *aboutMeTitle;
@property (weak, nonatomic) IBOutlet UILabel *brokerageHeader;
@property (weak, nonatomic) IBOutlet UILabel *designationHeader;
@property (weak, nonatomic) IBOutlet UITextField *textFieldBrokerage;
@property (weak, nonatomic) IBOutlet UIButton *buttonSave;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewDesignations;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorMain;
@property (weak, nonatomic) IBOutlet UILabel *labelNoneSpecified;
@property (strong, nonatomic) NSURLConnection *urlConnectionDesignation;
@property (strong, nonatomic) NSMutableData *dataReceived;
@property (strong, nonatomic) NSMutableArray *arrayOfDesignation;
- (IBAction)saveBrokerage:(id)sender;
- (IBAction)backButton:(id)sender;

@end

@implementation ABridge_BrokerageViewController
@synthesize urlConnectionDesignation;
@synthesize dataReceived;
@synthesize arrayOfDesignation;

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
    self.brokerageHeader.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
    self.designationHeader.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
    self.labelNoneSpecified.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
    self.textFieldBrokerage.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
    self.buttonSave.titleLabel.font = FONT_OPENSANS_BOLD(FONT_SIZE_SMALL);
    
    self.activityIndicator.hidden = YES;
    self.activityIndicatorMain.hidden = YES;
    
    [self addPaddingAndBorder:self.textFieldBrokerage color:[UIColor colorWithRed:178.0f/255.0f green:178.0f/255.0f blue:178.0f/255.0f alpha:1.0f]];
    
    NSManagedObjectContext *context = ((ABridge_AppDelegate *)[[UIApplication sharedApplication] delegate]).managedObjectContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"LoginDetails"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error = nil;
    LoginDetails *loginDetails = (LoginDetails*)[[context executeFetchRequest:fetchRequest error:&error] firstObject];
    
    NSFetchRequest *fetchRequestProfile = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityProfile = [NSEntityDescription entityForName:@"AgentProfile"
                                                     inManagedObjectContext:context];
    [fetchRequestProfile setEntity:entityProfile];
    
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"user_id == %@", loginDetails.user_id];
    [fetchRequestProfile setPredicate:predicate];
    
    NSError *errorProfile = nil;
    AgentProfile *profile = (AgentProfile*)[[context executeFetchRequest:fetchRequestProfile error:&errorProfile] firstObject];
    
    
    
    self.textFieldBrokerage.text = @"";
    self.textFieldBrokerage.text = profile.broker_name;
    
    NSString *urlString = @"http://keydiscoveryinc.com/agent_bridge/webservice/getuser_designations.php";
    
    urlString = [NSString stringWithFormat:@"%@?user_id=%@",urlString, loginDetails.user_id];
    
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    
    self.urlConnectionDesignation = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self startImmediately:YES];
    
    if (self.urlConnectionDesignation) {
        self.activityIndicator.hidden = NO;
        [self.activityIndicator startAnimating];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveBrokerage:(id)sender {
}

- (IBAction)backButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) addPaddingAndBorder:(UITextField*)textField color:(UIColor*)color {
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 20)];
    textField.leftView = paddingView;
    textField.leftViewMode = UITextFieldViewModeAlways;
    
    textField.layer.borderColor = color.CGColor;
    textField.layer.borderWidth = 1.0f;
}

- (void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse *)response
{
    self.arrayOfDesignation = nil;
    self.dataReceived = nil;
    self.dataReceived = [[NSMutableData alloc] init];
    
}
- (void)connection:(NSURLConnection*)connection didReceiveData:(NSData*)data
{
    //NSLog(@"Did Receive Data %@", data);
    [self.dataReceived appendData:data];
}
- (void)connection:(NSURLConnection*)connection didFailWithError:(NSError*)error
{
    //    NSLog(@"Did Fail");
    
    [self.activityIndicator stopAnimating];
    self.activityIndicator.hidden = YES;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Internet Connection" message:@"You have no Internet Connection available." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    NSError *error = nil;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:self.dataReceived options:NSJSONReadingAllowFragments error:&error];
    
    NSLog(@"Did Finish:%@", json);
    self.labelNoneSpecified.hidden = YES;
    
    if ([[json objectForKey:@"data"] count]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
//            NSManagedObjectContext *context = ((ABridge_AppDelegate *)[[UIApplication sharedApplication] delegate]).managedObjectContext;
//            for (NSDictionary *entry in [json objectForKey:@"data"]) {
//                State *state = nil;
//                
//                NSPredicate * predicate = [NSPredicate predicateWithFormat:@"zone_id == %@", [entry objectForKey:@"zone_id"]];
//                NSArray *result = [self fetchObjectsWithEntityName:@"State" andPredicate:predicate];
//                if ([result count]) {
//                    state = (State*)[result firstObject];
//                }
//                else {
//                    state = [NSEntityDescription insertNewObjectForEntityForName: @"State" inManagedObjectContext: context];
//                }
//                
//                [state setValuesForKeysWithDictionary:entry];
//                
//                NSError *error = nil;
//                if (![context save:&error]) {
//                    NSLog(@"Error on saving Property:%@",[error localizedDescription]);
//                }
//                else {
//                    if (self.arrayOfState == nil) {
//                        self.arrayOfState = [[NSMutableArray alloc] init];
//                    }
//                    
//                    [self.arrayOfState addObject:state.zone_name];
//                }
//            }
            
            if (self.arrayOfDesignation == nil) {
                self.arrayOfDesignation = [[NSMutableArray alloc] init];
            }

            for (NSDictionary *entry in [json objectForKey:@"data"]) {
                [self.arrayOfDesignation addObject:[entry objectForKey:@"designation_name"]];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                CGFloat yOffset = 0.0f;
                if ([self.arrayOfDesignation count] > 2) {
                    CGRect frame = self.scrollViewDesignations.frame;
                    frame.size.height += 30.0f;
                    self.scrollViewDesignations.frame = frame;
                    
                    frame = self.buttonSave.frame;
                    frame.origin.y += 30.0f;
                    self.buttonSave.frame = frame;
                }
                for (NSString *designation in self.arrayOfDesignation) {
                    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0.0f, yOffset, 280.0f, 30.0f)];
                    textField.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
                    [self addPaddingAndBorder:textField color:[UIColor colorWithRed:178.0f/255.0f green:178.0f/255.0f blue:178.0f/255.0f alpha:1.0f]];
                    textField.borderStyle = UITextBorderStyleNone;
                    textField.placeholder = [NSString stringWithFormat:@"Designation %i",[self.arrayOfDesignation indexOfObject:designation]];
                    textField.adjustsFontSizeToFitWidth = YES;
                    textField.minimumFontSize = 11.0f;
                    textField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                    textField.text = designation;
                    
                    [self.scrollViewDesignations addSubview:textField];
                    yOffset += textField.frame.size.height + 10.0f;
                    
                    self.scrollViewDesignations.contentSize = CGSizeMake(0.0f, yOffset);
                }
                
                if ([self.arrayOfDesignation count] == 0) {
                    self.labelNoneSpecified.hidden = NO;
                    [self.activityIndicator stopAnimating];
                    self.activityIndicator.hidden = YES;
                }
                else {
                    self.labelNoneSpecified.hidden = YES;
                }
                
                UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0.0f, yOffset, 280.0f, 30.0f)];
                textField.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
                [self addPaddingAndBorder:textField color:[UIColor colorWithRed:178.0f/255.0f green:178.0f/255.0f blue:178.0f/255.0f alpha:1.0f]];
                textField.borderStyle = UITextBorderStyleNone;
                textField.placeholder = [NSString stringWithFormat:@"Designation %i",[self.arrayOfDesignation count]+1];
                textField.adjustsFontSizeToFitWidth = YES;
                textField.minimumFontSize = 11.0f;
                textField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                
                [self.scrollViewDesignations addSubview:textField];
                
                self.scrollViewDesignations.contentSize = CGSizeMake(self.scrollViewDesignations.contentSize.width, self.scrollViewDesignations.contentSize.height + 35.0f);
                
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
            });
            
        });
    }
    else {
        self.labelNoneSpecified.hidden = NO;
    }
    
    [self.activityIndicator stopAnimating];
    self.activityIndicator.hidden = YES;
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
}
@end
