//
//  ABridge_LoginViewController.m
//  AgentBridge
//
//  Created by host24_iOS Dev on 11/13/13.
//  Copyright (c) 2013 host24_iOS Dev. All rights reserved.
//

#import "ABridge_LoginViewController.h"
#import "Constants.h"
#import "LoginDetails.h"
#import "ABridge_AppDelegate.h"
#import "AgentProfile.h"

@interface ABridge_LoginViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageViewBackground;
@property (weak, nonatomic) IBOutlet UIView *viewBox;
@property (weak, nonatomic) IBOutlet UITextField *textEmail;
@property (weak, nonatomic) IBOutlet UITextField *textPassword;
@property (weak, nonatomic) IBOutlet UIButton *buttonSignIn;
@property (weak, nonatomic) IBOutlet UIButton *buttonForgot;
@property (weak, nonatomic) IBOutlet UIView *viewOverlay;
@property (weak, nonatomic) IBOutlet UILabel *labelLoading;
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@property (strong, nonatomic) NSURLConnection *urlConnectionLogin;
@property (strong, nonatomic) NSMutableData *dataReceived;
@property (strong, nonatomic) NSTimer* timer;
@property (assign, nonatomic) NSInteger count;
@property (strong, nonatomic) LoginDetails *item;
    
@property (strong, nonatomic) NSURLConnection *urlConnectionProfile;
    
    @property (strong, nonatomic) AgentProfile *profileData;
    
-(IBAction)signIn:(id)sender;
-(IBAction)forgotPassword:(id)sender;
@end

@implementation ABridge_LoginViewController

@synthesize urlConnectionLogin;
@synthesize dataReceived;
@synthesize timer;
@synthesize count;
    @synthesize urlConnectionProfile;
    @synthesize profileData;
@synthesize item;

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
    
    self.viewBox.center = self.view.center;
    self.viewOverlay.center = self.view.center;
    
//    self.viewBox.layer.cornerRadius = 5;
//    self.viewBox.layer.masksToBounds = YES;
    
    self.textEmail.font = FONT_OPENSANS_REGULAR(15.0f);
    self.textPassword.font = FONT_OPENSANS_REGULAR(15.0f);
    self.buttonSignIn.titleLabel.font = FONT_OPENSANS_BOLD(17.0f);
    self.buttonForgot.titleLabel.font = FONT_OPENSANS_REGULAR(15.0f);
//    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 20)];
//    self.textEmail.leftView = paddingView;
//    self.textEmail.leftViewMode = UITextFieldViewModeAlways;
//    UIView *paddingView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 20)];
//    self.textPassword.leftView = paddingView2;
//    self.textPassword.leftViewMode = UITextFieldViewModeAlways;
    
//    self.textEmail.layer.borderColor = [UIColor colorWithRed:178.0f/255.0f green:178.0f/255.0f blue:178.0f/255.0f alpha:1.0f].CGColor;
//    self.textEmail.layer.borderWidth = 1.0f;
//    self.textPassword.layer.borderColor = [UIColor colorWithRed:178.0f/255.0f green:178.0f/255.0f blue:178.0f/255.0f alpha:1.0f].CGColor;
//    self.textPassword.layer.borderWidth = 1.0f;
    
//    UIBezierPath *emailMaskPathWithRadiusTop = [UIBezierPath bezierPathWithRoundedRect:self.textEmail.bounds
//                                                                        byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight)
//                                                                              cornerRadii:CGSizeMake(8.0, 8.0)];
//    
//    UIBezierPath *passwordMaskPathWithRadiusBottom = [UIBezierPath bezierPathWithRoundedRect:self.textPassword.bounds
//                                                                           byRoundingCorners:(UIRectCornerBottomLeft | UIRectCornerBottomRight)
//                                                                                 cornerRadii:CGSizeMake(8.0, 8.0)];
//    
//    CAShapeLayer *emailMaskLayer = [[CAShapeLayer alloc] init];
//    emailMaskLayer.frame = self.textEmail.bounds;
//    emailMaskLayer.path = emailMaskPathWithRadiusTop.CGPath;
//    
//    CAShapeLayer *passwordMaskLayer = [[CAShapeLayer alloc] init];
//    passwordMaskLayer.frame = self.textPassword.bounds;
//    passwordMaskLayer.path = passwordMaskPathWithRadiusBottom.CGPath;
//
//    self.textEmail.layer.mask = emailMaskLayer;
//    self.textPassword.layer.mask = passwordMaskLayer;
    
    self.textEmail.backgroundColor = [UIColor clearColor];
    self.textPassword.backgroundColor = [UIColor clearColor];
    
    self.tableView.layer.borderColor = [UIColor colorWithRed:25.0f/255.0f green:25.0f/255.0f blue:25.0f/255.0f alpha:1.0f].CGColor;
    self.tableView.layer.borderWidth = 1.0f;
    self.tableView.layer.cornerRadius = 4.0f;
    self.tableView.layer.masksToBounds = YES;
//    self.tableView.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.9f];
    
    self.tableView.separatorColor = [UIColor colorWithRed:25.0f/255.0f green:25.0f/255.0f blue:25.0f/255.0f alpha:1.0f];
    
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    
    self.labelLoading.font = FONT_OPENSANS_REGULAR(15.0f);
    
    timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(updateImage) userInfo:nil repeats:YES];
    count = 2;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

-(void)updateImage{
    
    self.imageViewBackground.image = [UIImage imageNamed:[NSString stringWithFormat:@"slide_%li.png",(long)count]];
    
    CATransition *transition = [CATransition animation];
    transition.duration = 1.0f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    
    [self.imageViewBackground.layer addAnimation:transition forKey:nil];
    
    if (count==4) {
        count = 0;
    }
    
    count++;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

-(IBAction)signIn:(id)sender {
    
    [self.textEmail resignFirstResponder];
    [self.textPassword resignFirstResponder];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.3f];
    [UIView setAnimationDelay:0.2f];
    
    self.viewBox.center = self.view.center;
    
    
    [UIView commitAnimations];
    
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:1.0f];
    
    self.viewOverlay.alpha = 1.0f;
    
    [UIView commitAnimations];
    
    [self login];
}

-(IBAction)forgotPassword:(id)sender {
    
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

- (void)login {
    
    if (self.textEmail.text != nil && self.textPassword.text != nil) {
        if ([self NSStringIsValidEmail:self.textEmail.text]) {
            NSMutableString *urlString = [NSMutableString stringWithString:@"http://keydiscoveryinc.com/agent_bridge/webservice/login.php"];
            NSString *parameters = [NSString stringWithFormat:@"?email=%@&password=%@",self.textEmail.text,self.textPassword.text];
            [urlString appendString:parameters];
//            //NSLog(@"url:%@",urlString);
            NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
            
            self.urlConnectionLogin = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self startImmediately:YES];
            
            
//            if (urlConnectionLogin) {
//                //NSLog(@"Connection Successful");
//            }
//            else {
//                //NSLog(@"Connection Failed");
//            }
            
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please Input a valid Email Address" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please Input your Email and Password" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.3f];
    [UIView setAnimationDelay:0.2f];
    
    CGRect frame = self.viewBox.frame;
    frame.origin.y = (isiPhone5)?110.0f:70.0f;
    self.viewBox.frame = frame;
    
    [UIView commitAnimations];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self signIn:nil];
    return NO;
}

- (void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse *)response
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    self.dataReceived = nil;
    self.dataReceived = [[NSMutableData alloc]init];
}
- (void)connection:(NSURLConnection*)connection didReceiveData:(NSData*)data
{
    ////NSLog(@"Did Receive Data %@", data);
    [self.dataReceived appendData:data];
}
- (void)connection:(NSURLConnection*)connection didFailWithError:(NSError*)error
{
//    //NSLog(@"Did Fail");
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Internet Connection" message:@"You have no Internet Connection available." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSError *error = nil;
    
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:self.dataReceived options:NSJSONReadingAllowFragments error:&error];
    
//    //NSLog(@"Did Finish:%@", json);
    
    if (connection == self.urlConnectionLogin) {
        
        if ([[json objectForKey:@"data"] count]) {
            self.labelLoading.text = @"Saving Login details.";
            NSDictionary *dataJson = [[json objectForKey:@"data"] firstObject];
            
            NSManagedObjectContext *context = ((ABridge_AppDelegate *)[[UIApplication sharedApplication] delegate]).managedObjectContext;
            
            self.item = [NSEntityDescription
                                  insertNewObjectForEntityForName:@"LoginDetails"
                                  inManagedObjectContext:context];
            self.item.user_id = [NSNumber numberWithInt:[[dataJson objectForKey:@"id"] integerValue]];
            self.item.name = [dataJson objectForKey:@"name"];
            self.item.username = [dataJson objectForKey:@"username"];
            self.item.email = [dataJson objectForKey:@"email"];
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            NSError *errorSave = nil;
            if (![context save:&errorSave]) {
                //NSLog(@"Error occurred in saving Login Details:%@",[errorSave localizedDescription]);
            }
            else {
                
                NSString *parameters = [NSString stringWithFormat:@"?email=%@",self.item.email];
                
                NSMutableString *urlString = [NSMutableString stringWithString:@"http://keydiscoveryinc.com/agent_bridge/webservice/getuser_info.php"];
                [urlString appendString:parameters];
                //            //NSLog(@"url:%@",urlString);
                NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
                
                self.urlConnectionProfile = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self startImmediately:YES];
                
                
                if (self.urlConnectionProfile) {
                    self.labelLoading.text = @"Retrieving Profile.";
                    //                //NSLog(@"Connection Successful");
                }
                else {
                    //                //NSLog(@"Connection Failed");
                }
                
            }
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login Error" message:@"Email and password does not match a member profile. Please try again or apply for membership." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }
    else if(connection == self.urlConnectionProfile) {
        
        if ([[json objectForKey:@"data"] count]) {
            
            self.labelLoading.text = @"Saving Profile.";
            NSManagedObjectContext *context = ((ABridge_AppDelegate *)[[UIApplication sharedApplication] delegate]).managedObjectContext;
            for (NSDictionary *entry in [json objectForKey:@"data"]) {
                self.profileData = nil;
                
                NSPredicate * predicate = [NSPredicate predicateWithFormat:@"user_id == %@", [entry objectForKey:@"user_id"]];
                NSArray *result = [self fetchObjectsWithEntityName:@"AgentProfile" andPredicate:predicate];
                if ([result count]) {
                    self.profileData = (AgentProfile*)[result firstObject];
                }
                else {
                    self.profileData = [NSEntityDescription insertNewObjectForEntityForName: @"AgentProfile" inManagedObjectContext: context];
                }
                
                [self.profileData setValuesForKeysWithDictionary:entry];
                
                NSError *error = nil;
                if (![context save:&error]) {
                    //NSLog(@"Error on saving Buyer:%@",[error localizedDescription]);
                }
                else {
//                    NSFetchRequest *fetchRequestProfile = [[NSFetchRequest alloc] init];
//                    NSEntityDescription *entityProfile = [NSEntityDescription entityForName:@"AgentProfile"
//                                                                     inManagedObjectContext:context];
//                    [fetchRequestProfile setEntity:entityProfile];
//                    
//                    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"user_id == %@", self.item.user_id];
//                    [fetchRequestProfile setPredicate:predicate];
//                    
//                    NSError *error = nil;
//                    NSArray *fetchedProfile = [context executeFetchRequest:fetchRequestProfile error:&error];
//                    
//                    //NSLog(@"%@\nprofile:%@",self.item.user_id,fetchedProfile);
//                    if ([fetchedProfile count] == 0) {
//                        if (![context save:&error]) {
//                            //NSLog(@"Error on saving Buyer:%@",[error localizedDescription]);
//                        }
//                        else {
                            [self performSelector:@selector(proceedToMainApp) withObject:nil afterDelay:1];
//                        }
//                    }
//                    else {
//                    }
                }
            }
            
            
            
        }
    }
    
    
    
    // Do something with responseData
}

- (void)proceedToMainApp {
    
    if (self.profileData.image_data == nil) {
        self.profileData.image_data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.profileData.image]];
    }
    
    self.labelLoading.text = @"Done!";
    [self dismissViewControllerAnimated:YES completion:^{
        [self.timer invalidate];
        //                //NSLog(@"Successfully saved Login Details");
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.5f];
    
    self.viewOverlay.alpha = 0.0f;
    
    [UIView commitAnimations];
}
    
    
- (NSArray *)fetchObjectsWithEntityName:(NSString *)entity andPredicate:(NSPredicate *)predicate {
    NSManagedObjectContext *context = ((ABridge_AppDelegate *)[[UIApplication sharedApplication] delegate]).managedObjectContext;
    NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setEntity:[NSEntityDescription entityForName:entity inManagedObjectContext:context]];
    NSError * error = nil;
    NSArray * results = [context executeFetchRequest:fetchRequest error:&error];
    return results;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = @"CellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
    
    
    
    if ([indexPath row] == 0) {
        CGRect frame = self.textEmail.frame;
        frame.origin.x = 15.0f;
        frame.origin.y = 2.0f;
        frame.size.width = cell.frame.size.width - 20.0f;
        frame.size.height = cell.frame.size.height - 4.0f;
        self.textEmail.frame = frame;
        
        [cell.contentView addSubview:self.textEmail];
    }
    else if ([indexPath row] == 1) {
        CGRect frame = self.textPassword.frame;
        frame.origin.x = 15.0f;
        frame.origin.y = 2.0f;
        frame.size.width = cell.frame.size.width - 20.0f;
        frame.size.height = cell.frame.size.height - 4.0f;
        self.textPassword.frame = frame;
        
        [cell.contentView addSubview:self.textPassword];
    }
    
    UIView *viewCell = [[UIView alloc] initWithFrame:cell.bounds];
    viewCell.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.9f];
    
    
//    if ([indexPath row] == 0) {
//    UIBezierPath *emailMaskPathWithRadiusTop = [UIBezierPath bezierPathWithRoundedRect:self.textEmail.bounds
//                                                                     byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight)
//                                                                           cornerRadii:CGSizeMake(4.0, 4.0)];
//        CAShapeLayer *emailMaskLayer = [[CAShapeLayer alloc] init];
//        emailMaskLayer.frame = viewCell.bounds;
//        emailMaskLayer.path = emailMaskPathWithRadiusTop.CGPath;
//        
//        viewCell.layer.mask = emailMaskLayer;
//    }
//    else if ([indexPath row] == 1) {
//        UIBezierPath *passwordMaskPathWithRadiusBottom = [UIBezierPath bezierPathWithRoundedRect:self.textPassword.bounds
//                                                                               byRoundingCorners:(UIRectCornerBottomLeft | UIRectCornerBottomRight)
//                                                                                     cornerRadii:CGSizeMake(4.0, 4.0)];
//        CAShapeLayer *passwordMaskLayer = [[CAShapeLayer alloc] init];
//        passwordMaskLayer.frame = viewCell.bounds;
//        passwordMaskLayer.path = passwordMaskPathWithRadiusBottom.CGPath;
//        
//        viewCell.layer.mask = passwordMaskLayer;
//    }
    
    cell.backgroundView = viewCell;
    
    return cell;
}

@end
