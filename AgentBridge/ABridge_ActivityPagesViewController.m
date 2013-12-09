//
//  ABridge_ActivityPagesViewController.m
//  AgentBridge
//
//  Created by host24_iOS Dev on 11/14/13.
//  Copyright (c) 2013 host24_iOS Dev. All rights reserved.
//

#import "ABridge_ActivityPagesViewController.h"
#import "ABridge_BuyerViewController.h"
#import "ABridge_PropertyViewController.h"
#import "Constants.h"
#import "LoginDetails.h"
#import "RequestAccess.h"
#import "RequestNetwork.h"

@interface ABridge_ActivityPagesViewController ()
@property (weak, nonatomic) IBOutlet UIView *viewTop;
@property (weak, nonatomic) IBOutlet UILabel *labelActivityName;
@property (weak, nonatomic) IBOutlet UILabel *labelDateTime;
@property (weak, nonatomic) IBOutlet UITextView *textViewMessage;
@property (weak, nonatomic) IBOutlet UIImageView *imagePicture;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (strong, nonatomic) NSMutableData *dataReceived;
@property (strong, nonatomic) NSURLConnection * urlConnectionRequestNetwork;
@property (strong, nonatomic) NSURLConnection * urlConnectionRequestAccess;
@property (weak, nonatomic) IBOutlet UIView *viewForDescription;
@property (weak, nonatomic) IBOutlet UILabel *labelDescription;
@property (weak, nonatomic) IBOutlet UIButton *buttonDescription;
@property (strong, nonatomic) LoginDetails * loginDetail;
@end

@implementation ABridge_ActivityPagesViewController
@synthesize index;
@synthesize activityDetail;
@synthesize dataReceived;
@synthesize urlConnectionRequestAccess;
@synthesize urlConnectionRequestNetwork;
@synthesize loginDetail;

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
    
    self.labelActivityName.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
    self.labelDateTime.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
    
    self.buttonDescription.titleLabel.font = FONT_OPENSANS_REGULAR(FONT_SIZE_SMALL);
    self.labelDescription.font = FONT_OPENSANS_REGULAR(FONT_SIZE_SMALL);
    
//    self.textViewMessage.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
    self.webView.backgroundColor = [UIColor whiteColor];
    for (UIView* subView in [self.webView subviews])
    {
        if ([subView isKindOfClass:[UIScrollView class]]) {
            ((UIScrollView*)subView).scrollEnabled = NO;
            for (UIView* shadowView in [subView subviews])
            {
                if ([shadowView isKindOfClass:[UIImageView class]]) {
                    [shadowView setHidden:YES];
                }
            }
        }
    }
    
    // Add a bottomBorder.
    CALayer *bottomBorder = [CALayer layer];
    
    bottomBorder.frame = CGRectMake(0.0f, self.viewTop.frame.size.height - 1.0f, self.viewTop.frame.size.width, 1.0f);
    
    bottomBorder.backgroundColor = [UIColor colorWithRed:191.0f/255.0f green:191.0f/255.0f blue:191.0f/255.0f alpha:1.0f].CGColor;
    
    [self.viewTop.layer addSublayer:bottomBorder];
    
    NSManagedObjectContext *context = ((ABridge_AppDelegate *)[[UIApplication sharedApplication] delegate]).managedObjectContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"LoginDetails"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error = nil;
    NSArray *fetchedObjects = [context
                               executeFetchRequest:fetchRequest error:&error];
    
    self.loginDetail = (LoginDetails*)[fetchedObjects firstObject];
    if ([self.activityDetail.activity_type integerValue] == 25) {
        if ([self.loginDetail.user_id integerValue] != [self.activityDetail.pops_user_id integerValue]) {
            NSString *parameters = [NSString stringWithFormat:@"?user_id=%@&other_user_id=%@",self.activityDetail.pops_user_id,self.loginDetail.user_id];
            
            NSMutableString *urlString_ = [NSMutableString stringWithString:@"http://keydiscoveryinc.com/agent_bridge/webservice/get_request_network.php"];
            [urlString_ appendString:parameters];
            //        NSLog(@"url:%@",urlString_);
            NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlString_]];
            
            self.urlConnectionRequestNetwork = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self startImmediately:YES];
            
            if (self.urlConnectionRequestNetwork) {
                [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
                [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
            }
        }
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *message = @"";
        if ([self.activityDetail.activity_type integerValue] == 25) {
//            NSLog(@"listing:%@",self.activityDetail.listing_id);
            NSString *buyer_name = [NSString stringWithFormat:@"<a href='http://buyer/%@'>%@</a>",self.activityDetail.buyer_id, self.activityDetail.buyer_name];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.labelActivityName.text = @"Buyer Match";
                self.labelDateTime.text = self.activityDetail.date;
                self.viewForDescription.hidden = NO;
                self.labelDescription.text = @"";
                [self.buttonDescription setTitle:@"Save" forState:UIControlStateNormal];
            });
            
            if ([self.activityDetail.other_user_id integerValue] == [self.activityDetail.user_id integerValue]) {
                
                NSString *pops_link = [NSString stringWithFormat:@"<a href='http://pops/%@'>%@</a>",self.activityDetail.listing_id, self.activityDetail.property_name];
                
                NSLog(@"pops:%@",self.activityDetail.listing_id);
                
                message = [NSString stringWithFormat:@"Your POPs™, %@, is a match to your buyer, %@", pops_link, buyer_name];
            }
            else {
                message = [NSString stringWithFormat:@"%@ POPs™, %@, is a match to your buyer, %@",self.activityDetail.other_user_name, self.activityDetail.property_name, buyer_name];
            }
            
        }
        else if ([self.activityDetail.activity_type integerValue] == 11) {
            
            NSString *buyer_name = [NSString stringWithFormat:@"<a href='http://%@'>%@</a>",self.activityDetail.client_id, self.activityDetail.referral_buyer_name];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.labelActivityName.text = [NSString stringWithFormat:@"Referral %@ Update",self.activityDetail.referral_buyer_name];
                self.labelDateTime.text = self.activityDetail.referral_date;
            });
            
            switch ([self.activityDetail.referral_status integerValue]) {
                case 1:
                    message = [NSString stringWithFormat:@"%@ is now under contract.",buyer_name];
                    break;
                case 4:
                    message = [NSString stringWithFormat:@"%@ has now closed your referral %@. AgentBridge will now be collecting a service fee. ", self.activityDetail.user_name,buyer_name];
                    break;
                case 5:
                    message = [NSString stringWithFormat:@"%@ has declined the referral. ", self.activityDetail.user_name];
                    break;
                case 6:
                    message = [NSString stringWithFormat:@"%@ needs your help on referral %@ ", self.activityDetail.user_name, buyer_name];
                    break;
                case 7:
                    message = [NSString stringWithFormat:@"You have sent a referral to %@ with a %@ referral fee. ", self.activityDetail.user_name, self.activityDetail.referral_fee];
                    break;
                case 8:
                    message = [NSString stringWithFormat:@"%@ has now accepted your referral of %@ fee for client %@.\n\nSign the referral contract. ", self.activityDetail.user_name, self.activityDetail.referral_fee, buyer_name];
                    break;
                case 9:
                    message = [NSString stringWithFormat:@"Congratulations. Referral %@ is now complete. ", self.activityDetail.user_name];
                    break;
                    
                    
                default:
                    message = @"";
                    break;
            }
        }
        
        NSString *htmlString = [NSString stringWithFormat:@"<html><head><style>body{font-family:'OpenSans'} a{text-decoration: none; color:#2C99CE;}</style></head><body>%@</body></html>", message];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.webView loadHTMLString:htmlString baseURL:nil];
        });
        
//        if ([self.activityDetail.activity_type integerValue] == 25) {
            if (self.activityDetail.image_data == nil) {
                self.activityDetail.image_data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.activityDetail.image]];
            }
//        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
//            if ([self.activityDetail.activity_type integerValue] == 25) {
                if (self.activityDetail.image_data != nil) {
                    self.imagePicture.image = [UIImage imageWithData:self.activityDetail.image_data];
                }
//            }
        });
    });
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString* url = [[request URL] absoluteString];
    if (UIWebViewNavigationTypeLinkClicked == navigationType)
    {
        NSString *newURL = [url substringToIndex:[url length]-1];
        NSString *type = [newURL substringFromIndex:7];
        if ([type rangeOfString:@"buyer"].location != NSNotFound) {
            [self.tabBarController setSelectedIndex:2];
            ABridge_BuyerViewController *viewController = ((ABridge_BuyerViewController*)((UINavigationController*)self.tabBarController.selectedViewController).viewControllers[0]);
            [viewController scrollToBuyer:[newURL substringFromIndex:13]];
        }
        else if ([type rangeOfString:@"pops"].location != NSNotFound) {
            
            [self.tabBarController setSelectedIndex:1];
            ABridge_PropertyViewController *viewController = ((ABridge_PropertyViewController*)self.tabBarController.selectedViewController);
            NSLog(@"newURL:%@",newURL);
            [viewController scrollToPOPs:[newURL substringFromIndex:12]];
        }
    }
    return YES;
}


- (void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse *)response
{
    [self.buttonDescription setTitle:@"" forState:UIControlStateNormal];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    self.dataReceived = nil;
    self.dataReceived = [[NSMutableData alloc]init];
}
- (void)connection:(NSURLConnection*)connection didReceiveData:(NSData*)data
{
    //NSLog(@"Did Receive Data %@", data);
    [self.dataReceived appendData:data];
}
- (void)connection:(NSURLConnection*)connection didFailWithError:(NSError*)error
{
     NSLog(@"Did Fail");
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Internet Connection" message:@"You have no Internet Connection available." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSError *error = nil;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:self.dataReceived options:NSJSONReadingAllowFragments error:&error];
    
    //    NSLog(@"Did Finish:%@", json);
    if (connection == self.urlConnectionRequestNetwork) {
//        NSLog(@"Did Finish:%@", json);
        if ([[json objectForKey:@"data"] count]) {
            NSManagedObjectContext *context = ((ABridge_AppDelegate *)[[UIApplication sharedApplication] delegate]).managedObjectContext;
            
            NSDictionary *entry = [[json objectForKey:@"data"] firstObject];
            if ([[json objectForKey:@"data"] count]) {
                RequestNetwork *network = nil;
                
                NSPredicate * predicate = [NSPredicate predicateWithFormat:@"network_id == %@", [entry objectForKey:@"network_id"]];
                
                NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
                [fetchRequest setPredicate:predicate];
                [fetchRequest setEntity:[NSEntityDescription entityForName:@"RequestNetwork" inManagedObjectContext:context]];
                NSError * error = nil;
                NSArray * result = [context executeFetchRequest:fetchRequest error:&error];
                if ([result count]) {
                    network = (RequestNetwork*)[result firstObject];
                }
                else {
                    network = [NSEntityDescription insertNewObjectForEntityForName: @"RequestNetwork" inManagedObjectContext: context];
                }
                
                [network setValuesForKeysWithDictionary:entry];
                
                NSError *errorSave = nil;
                if (![context save:&errorSave]) {
                    NSLog(@"Error on saving RequestNetwork:%@",[errorSave localizedDescription]);
                }
                
                if ([network.status integerValue] == 1) {
//                    NSLog(@"setting:%@",self.activityDetail.setting);
                    if ([self.activityDetail.setting integerValue] == 1) {
//                        [self checkSettingGetPrice];
                    }
                    else if ([self.activityDetail.setting integerValue] == 2) {
                        
                        NSString *parameters = [NSString stringWithFormat:@"?user_id=%@&other_user_id=%@&property_id=%@",self.activityDetail.pops_user_id,self.loginDetail.user_id, self.activityDetail.listing_id];
                        
                        NSMutableString *urlString_ = [NSMutableString stringWithString:@"http://keydiscoveryinc.com/agent_bridge/webservice/get_request_access.php"];
                        [urlString_ appendString:parameters];
//                        NSLog(@"url:%@",urlString_);
                        NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlString_]];
                        
                        self.urlConnectionRequestAccess = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self startImmediately:YES];
                        
                        if (self.urlConnectionRequestAccess) {
                            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
                            [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
                        }
                    }
                    
                }
                else if ([network.status integerValue] == 0){
                    self.viewForDescription.hidden = NO;
                    self.labelDescription.text = [NSString stringWithFormat:@"This POPs™ is restricted to %@'s Network members only",self.activityDetail.pops_user_name];
                    [self.buttonDescription setTitle:@"Pending" forState:UIControlStateNormal];
                }
                else {
                    self.viewForDescription.hidden = NO;
                    self.labelDescription.text = @"";
                    [self.buttonDescription setTitle:@"Save" forState:UIControlStateNormal];
                }
            }
            else {
                self.viewForDescription.hidden = NO;
                self.labelDescription.text = [NSString stringWithFormat:@"This POPs™ is restricted to %@'s Network members only",self.activityDetail.pops_user_name];
                [self.buttonDescription setTitle:@"Request To View" forState:UIControlStateNormal];
            }
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
            
        }
        else {
            self.viewForDescription.hidden = NO;
            self.labelDescription.text = [NSString stringWithFormat:@"This POPs™ is restricted to %@'s Network members only",self.activityDetail.pops_user_name];
            [self.buttonDescription setTitle:@"Request To View" forState:UIControlStateNormal];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
        }
        
    }
    else if (connection == self.urlConnectionRequestAccess) {
//        NSLog(@"Access Did Finish:%@", json);
        if ([[json objectForKey:@"data"] count]) {
            NSManagedObjectContext *context = ((ABridge_AppDelegate *)[[UIApplication sharedApplication] delegate]).managedObjectContext;
            NSDictionary *entry = [[json objectForKey:@"data"] firstObject];
            
            if ([[json objectForKey:@"data"] count]) {
                RequestAccess *access = nil;
                
                NSPredicate * predicate = [NSPredicate predicateWithFormat:@"access_id == %@", [entry objectForKey:@"access_id"]];
                
                NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
                [fetchRequest setPredicate:predicate];
                [fetchRequest setEntity:[NSEntityDescription entityForName:@"RequestAccess" inManagedObjectContext:context]];
                NSError * error = nil;
                NSArray * result = [context executeFetchRequest:fetchRequest error:&error];
                
                if ([result count]) {
                    access = (RequestAccess*)[result firstObject];
                }
                else {
                    access = [NSEntityDescription insertNewObjectForEntityForName: @"RequestAccess" inManagedObjectContext: context];
                }
                
                [access setValuesForKeysWithDictionary:entry];
                
                NSError *errorSave = nil;
                if (![context save:&errorSave]) {
                    NSLog(@"Error on saving RequestAccess:%@",[errorSave localizedDescription]);
                }
                
                if ([access.permission boolValue] == YES) {
//                    [self getPriceText];
                    
                        self.viewForDescription.hidden = NO;
                        self.labelDescription.text = @"";
                        [self.buttonDescription setTitle:@"Save" forState:UIControlStateNormal];
                }
                else if ([access.permission boolValue] == NO){
                    self.viewForDescription.hidden = NO;
                    self.labelDescription.text = @"This POPs™ is restricted to private";
                    [self.buttonDescription setTitle:@"Pending" forState:UIControlStateNormal];
                }
                
            }
            else {
                self.viewForDescription.hidden = NO;
                self.labelDescription.text = [NSString stringWithFormat:@"This POPs™ is restricted to %@'s Network members only",self.activityDetail.pops_user_name];
                [self.buttonDescription setTitle:@"Request To View" forState:UIControlStateNormal];
            }
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
        }
        else {
            self.viewForDescription.hidden = NO;
            self.labelDescription.text = [NSString stringWithFormat:@"This POPs™ is restricted to %@'s Network members only",self.activityDetail.pops_user_name];
            [self.buttonDescription setTitle:@"Request To View" forState:UIControlStateNormal];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
        }
    }
    // Do something with responseData
}

@end
