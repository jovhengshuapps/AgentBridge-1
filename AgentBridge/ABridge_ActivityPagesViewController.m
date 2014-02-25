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
#import "ABridge_ReferralViewController.h"
#import "ABridge_ActivityAgentProfileViewController.h"
#import "ABridge_ActivityAgentPOPsViewController.h"
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

@property (strong, nonatomic) NSString *pricePaid;
@property (strong, nonatomic) NSString *clrf_id;

- (IBAction)buttonActionPressed:(id)sender;
@end

@implementation ABridge_ActivityPagesViewController
@synthesize index;
@synthesize activityDetail;
@synthesize dataReceived;
@synthesize urlConnectionRequestAccess;
@synthesize urlConnectionRequestNetwork;
@synthesize loginDetail;
@synthesize pricePaid;
@synthesize clrf_id;

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
    
    self.buttonDescription.titleLabel.font = FONT_OPENSANS_BOLD(FONT_SIZE_SMALL);
    self.labelDescription.font = FONT_OPENSANS_BOLD(FONT_SIZE_SMALL);
    
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
//    if ([self.activityDetail.activity_type integerValue] == 25) {
//    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *message = @"";
        if ([self.activityDetail.activity_type integerValue] == 25) {
//            //NSLog(@"listing:%@",self.activityDetail.listing_id);
            NSString *buyer_name = [NSString stringWithFormat:@"<a href='http://buyer/%@'>%@</a>",self.activityDetail.buyer_id, self.activityDetail.buyer_name];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.labelActivityName.text = @"Buyer Match";
                self.labelDateTime.text = self.activityDetail.date;
//                self.viewForDescription.hidden = NO;
                self.labelDescription.hidden = YES;
                self.buttonDescription.hidden = YES;
                
                NSString *parameters = [NSString stringWithFormat:@"?user_id=%@&listing_id=%@&buyer_id=%@",self.loginDetail.user_id,self.activityDetail.listing_id, self.activityDetail.buyer_id];
                
                NSMutableString *urlString = [NSMutableString stringWithString:@"http://agentbridge.com/webservice/check_new_if_saved.php"];
                [urlString appendString:parameters];
//                //NSLog(@"url:%@",urlString);
                
                
                __block NSError *errorData = nil;
                __weak ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlString]];
                //            [self.activityIndicator startAnimating];
                //            self.activityIndicator.hidden = NO;
                [request setCompletionBlock:
                 ^{
                     NSData *responseData = [request responseData];
                     NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&errorData];
                     
//                     //NSLog(@"json:%@",json);
                     if ([[json objectForKey:@"data"] count]) {
                         
//                         self.viewForDescription.hidden = NO;
                         self.buttonDescription.hidden = YES;
                         self.labelDescription.text = [NSString stringWithFormat:@"Saved to %@",self.activityDetail.buyer_name];
                         self.labelDescription.hidden = NO;
                     }
                     else {
//                         self.viewForDescription.hidden = NO;
                         self.buttonDescription.hidden = NO;
                         self.labelDescription.hidden = YES;
                         self.labelDescription.text = @"";
                         [self.buttonDescription setTitle:@"Save" forState:UIControlStateNormal];
                         self.buttonDescription.tag = 2501;
                     }
                     
                     
                 }];
                [request setFailedBlock:^{
                    NSError *error = [request error];
                    NSLog(@" error:%@",error);
                }];
                
                [request startAsynchronous];
                
            });
            
            
            if ([self.loginDetail.user_id integerValue] != [self.activityDetail.pops_user_id integerValue]) {
                NSString *parameters = [NSString stringWithFormat:@"?user_id=%@&other_user_id=%@",self.activityDetail.pops_user_id,self.loginDetail.user_id];
                
                NSMutableString *urlString_ = [NSMutableString stringWithString:@"http://agentbridge.com/webservice/get_request_network.php"];
                [urlString_ appendString:parameters];
                //        //NSLog(@"url:%@",urlString_);
//                NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlString_]];
//                
//                self.urlConnectionRequestNetwork = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self startImmediately:YES];
//                
//                if (self.urlConnectionRequestNetwork) {
//                    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
//                    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
//                }
                
                __block NSError *errorData = nil;
                __weak ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlString_]];
                //            [self.activityIndicator startAnimating];
                //            self.activityIndicator.hidden = NO;
                [request setCompletionBlock:
                 ^{
                     NSData *responseData = [request responseData];
                     NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&errorData];
                     
                     //                     //NSLog(@"json:%@",json);
                     
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
                                 //NSLog(@"Error on saving RequestNetwork:%@",[errorSave localizedDescription]);
                             }
                             
                             if ([network.status integerValue] == 1) {
                                 //                    //NSLog(@"setting:%@",self.activityDetail.setting);
                                 if ([self.activityDetail.setting integerValue] == 1) {
                                     //                        [self checkSettingGetPrice];
                                 }
                                 else if ([self.activityDetail.setting integerValue] == 2) {
                                     
                                     NSString *parameters = [NSString stringWithFormat:@"?user_id=%@&other_user_id=%@&property_id=%@",self.activityDetail.pops_user_id,self.loginDetail.user_id, self.activityDetail.listing_id];
                                     
                                     NSMutableString *urlString_ = [NSMutableString stringWithString:@"http://agentbridge.com/webservice/get_request_access.php"];
                                     [urlString_ appendString:parameters];
                                     //                        //NSLog(@"url:%@",urlString_);
//                                     NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlString_]];
                                     
//                                     self.urlConnectionRequestAccess = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self startImmediately:YES];
//                                     
//                                     if (self.urlConnectionRequestAccess) {
//                                         [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
//                                         [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
//                                     }
                                     
                                     __block NSError *errorDataA = nil;
                                     __weak ASIHTTPRequest *requestA = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlString_]];
                                     //            [self.activityIndicator startAnimating];
                                     //            self.activityIndicator.hidden = NO;
                                     [requestA setCompletionBlock:
                                      ^{
                                          NSData *responseData = [requestA responseData];
                                          NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&errorDataA];
                                          
                                          //                     //NSLog(@"json:%@",json);
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
                                                      //NSLog(@"Error on saving RequestAccess:%@",[errorSave localizedDescription]);
                                                  }
                                                  
                                                  if ([access.permission boolValue] == YES) {
                                                      //                    [self getPriceText];
                                                      
                                                      //                        self.viewForDescription.hidden = NO;
                                                      self.labelDescription.text = @"";
                                                      self.labelDescription.hidden = YES;
                                                      self.buttonDescription.hidden = NO;
                                                      [self.buttonDescription setTitle:@"Save" forState:UIControlStateNormal];
                                                      self.buttonDescription.tag = 0;
                                                  }
                                                  else if ([access.permission boolValue] == NO){
                                                      //                    self.viewForDescription.hidden = NO;
                                                      
                                                      self.labelDescription.hidden = NO;
                                                      self.buttonDescription.hidden = NO;
                                                      self.labelDescription.text = @"This POPs™ is restricted to private";
                                                      [self.buttonDescription setTitle:@"Pending" forState:UIControlStateNormal];
                                                      self.buttonDescription.tag = 0;
                                                  }
                                                  
                                              }
                                              else {
                                                  //                self.viewForDescription.hidden = NO;
                                                  self.labelDescription.text = [NSString stringWithFormat:@"This POPs™ is restricted to %@'s Network members only",self.activityDetail.pops_user_name];
                                                  self.labelDescription.hidden = NO;
                                                  self.buttonDescription.hidden = NO;
                                                  [self.buttonDescription setTitle:@"Request To View" forState:UIControlStateNormal];
                                                  self.buttonDescription.tag = 2510;
                                              }
                                              
                                              [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                              [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
                                          }
                                          else {
                                              //            self.viewForDescription.hidden = NO;
                                              self.labelDescription.text = [NSString stringWithFormat:@"This POPs™ is restricted to %@'s Network members only",self.activityDetail.pops_user_name];
                                              self.labelDescription.hidden = NO;
                                              self.buttonDescription.hidden = NO;
                                              [self.buttonDescription setTitle:@"Request To View" forState:UIControlStateNormal];
                                              self.buttonDescription.tag = 2510;
                                              
                                              [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                              [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
                                          }
                                          
                                          
                                      }];
                                     [requestA setFailedBlock:^{
                                         NSError *error = [requestA error];
                                         NSLog(@" error:%@",error);
                                     }];
                                     
                                     [requestA startAsynchronous];
                                 }
                                 
                             }
                             else if ([network.status integerValue] == 1){
                                 //                    self.viewForDescription.hidden = NO;
                                 self.labelDescription.text = @"";
                                 self.labelDescription.hidden = YES;
                                 self.buttonDescription.hidden = NO;
                                 [self.buttonDescription setTitle:@"Save" forState:UIControlStateNormal];
                                 self.buttonDescription.tag = 0;
                             }
                             else {
                                 //                    self.viewForDescription.hidden = NO;
                                 self.labelDescription.text = [NSString stringWithFormat:@"This POPs™ is restricted to %@'s Network members only",self.activityDetail.pops_user_name];
                                 self.labelDescription.hidden = NO;
                                 self.buttonDescription.hidden = NO;
                                 [self.buttonDescription setTitle:@"Pending" forState:UIControlStateNormal];
                                 self.buttonDescription.tag = 0;
                             }
                         }
                         else {
                             //                self.viewForDescription.hidden = NO;
                             self.labelDescription.text = [NSString stringWithFormat:@"This POPs™ is restricted to %@'s Network members only",self.activityDetail.pops_user_name];
                             self.labelDescription.hidden = NO;
                             self.buttonDescription.hidden = NO;
                             [self.buttonDescription setTitle:@"Request To View" forState:UIControlStateNormal];
                             self.buttonDescription.tag = 2502;
                         }
                         
                         [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                         [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
                         
                     }
                     else {
                         //            self.viewForDescription.hidden = NO;
                         self.labelDescription.text = [NSString stringWithFormat:@"This POPs™ is restricted to %@'s Network members only",self.activityDetail.pops_user_name];
                         self.labelDescription.hidden = NO;
                         self.buttonDescription.hidden = NO;
                         [self.buttonDescription setTitle:@"Request To View" forState:UIControlStateNormal];
                         self.buttonDescription.tag = 2502;
                         
                         [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                         [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
                     }
                     
                     
                 }];
                [request setFailedBlock:^{
                    NSError *error = [request error];
                    NSLog(@" error:%@",error);
                }];
                
                [request startAsynchronous];
            }
            
            if ([self.activityDetail.other_user_id integerValue] == [self.activityDetail.user_id integerValue]) {
                
                NSString *pops_link = [NSString stringWithFormat:@"<a href='http://pops/%@'>%@</a>",self.activityDetail.listing_id, self.activityDetail.property_name];
                
                message = [NSString stringWithFormat:@"Your POPs™, %@, is a match to your buyer, %@", pops_link, buyer_name];
            }
            else {
                
                NSString *user_name = [NSString stringWithFormat:@"<a href='http://profile/%@'>%@</a>",self.activityDetail.other_user_id, self.activityDetail.other_user_name];
                
                message = [NSString stringWithFormat:@"%@ POPs™, %@, is a match to your buyer, %@",user_name, self.activityDetail.property_name, buyer_name];
            }
            
        }
        else if ([self.activityDetail.activity_type integerValue] == 11) {
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
//                NSString *activityName = [NSString stringWithFormat:@"Referral %@ Update",self.activityDetail.referral_buyer_name];
//            
//                NSMutableString *spaces = [[NSMutableString alloc] initWithString:@" "];
//                
//                while(index < [activityName length]) {
//                    [spaces appendString:@"  "];
//                    index++;
//                }
//                
                self.labelActivityName.text = @"";//[NSString stringWithFormat:@"Referral %@ Update",self.activityDetail.referral_buyer_name];
                self.labelDateTime.text = self.activityDetail.referral_date;
                
                self.labelDescription.text = @"";
//                self.viewForDescription.hidden = YES;
                
                self.labelDescription.hidden = YES;
                self.buttonDescription.hidden = YES;
                [self.buttonDescription setTitle:@"" forState:UIControlStateNormal];
            });
            
//            //NSLog(@"user:%@/%@ --- %@",self.activityDetail.user_id,self.activityDetail.other_user_id,self.loginDetail.user_id);
            
            if ([self.activityDetail.user_id integerValue] == [self.loginDetail.user_id integerValue]) {
                
                NSString *user_name = [NSString stringWithFormat:@"<a href='http://profile/%@'>%@</a>",self.activityDetail.other_user_id, self.activityDetail.user_name];
                NSString *buyer_name = [NSString stringWithFormat:@"<a href='http://client/in/%@'>%@</a>",self.activityDetail.client_id, self.activityDetail.referral_buyer_name];
                
                if ([self.activityDetail.referral_status integerValue] == 7) {
                    dispatch_async(dispatch_get_main_queue(), ^{
//                        self.labelActivityName.text = @"";
                    });
                }
                
                switch ([self.activityDetail.referral_status integerValue]) {
                    case 1:{
                        message = [NSString stringWithFormat:@"%@ is now under contract.",buyer_name];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            self.labelActivityName.text = [NSString stringWithFormat:@"Referral %@ Update",self.activityDetail.referral_buyer_name];
                        });
                        break;
                    }
                    case 4:{
                        message = [NSString stringWithFormat:@"Congratulations for closing your referral %@.",buyer_name];
                        dispatch_async(dispatch_get_main_queue(), ^{
//                            self.viewForDescription.hidden = NO;
                            
                            self.labelDescription.hidden = NO;
                            self.labelDescription.text = @"AgentBridge has successfully collected the referral service fee.";
                            self.buttonDescription.hidden = YES;
                            
                            self.labelActivityName.text = [NSString stringWithFormat:@"Referral %@ Update",self.activityDetail.referral_buyer_name];
                        });}
                        break;
                    case 5:{
                        user_name = [NSString stringWithFormat:@"<a href='http://profile/%@'>%@</a>",self.activityDetail.other_user_id, self.activityDetail.user_name];
                        message = [NSString stringWithFormat:@"You have declined the referral from %@.", user_name];
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            self.labelActivityName.text = [NSString stringWithFormat:@"Referral %@ Update",self.activityDetail.referral_buyer_name];
                        });
                        break;
                    }
                    case 6:{
                        message = [NSString stringWithFormat:@"%@ needs your help on referral %@ ", user_name, buyer_name];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            self.labelActivityName.text = [NSString stringWithFormat:@"Referral %@ Update",self.activityDetail.referral_buyer_name];
                        });
                        break;
                    }
                    case 7:{
                        
                        NSString *parameters = [NSString stringWithFormat:@"?user_id=%@&update_id=%@", self.loginDetail.user_id, self.activityDetail.referral_update_id];
                        
                        NSString *urlString = [NSString stringWithFormat:@"http://agentbridge.com/webservice/check_if_signed.php%@", parameters];
                        
                        __block NSString *buyer_block = buyer_name;
                        
                        __block NSError *errorData = nil;
                        __weak ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlString]];
                        [request setCompletionBlock:^{
                            // Use when fetching text data
                            //                        NSString *responseString = [request responseString];
                            // Use when fetching binary data
                            NSData *responseData = [request responseData];
                            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&errorData];
                            NSString *message_block = @"";
                            if ([[json objectForKey:@"data"] count] == 0) {
                                if ([self.activityDetail.referral_buyer_name length] > 4) {
                                    NSMutableString *encryptBuyerName = [[NSMutableString alloc] initWithString:@""];
                                    
                                    [encryptBuyerName appendString:[self.activityDetail.referral_buyer_name substringToIndex:2]];
                                    
                                    for (int i = 0; i < [[self.activityDetail.referral_buyer_name substringWithRange:NSMakeRange(2, [self.activityDetail.referral_buyer_name length] - 2)] length]; i++) {
                                        [encryptBuyerName appendString:@"x"];
                                    }
                                    
                                    [encryptBuyerName appendString:[self.activityDetail.referral_buyer_name substringFromIndex:[self.activityDetail.referral_buyer_name length]-2]];
                                    
                                    buyer_block = [NSString stringWithFormat:@"<a href='http://client/in/%@'>%@</a>",self.activityDetail.client_id, encryptBuyerName];
                                    
                                    self.labelActivityName.text = [NSString stringWithFormat:@"Referral %@ Update",encryptBuyerName];
                                }
                            }
                            else {
                                self.labelActivityName.text = [NSString stringWithFormat:@"Referral %@ Update",self.activityDetail.referral_buyer_name];
                            }
                            
                            if ([self.activityDetail.referral_response integerValue]) {
                                message_block = [NSString stringWithFormat:@"You have accepted %@'s %@ referral on %@. %@'s contact will be released once you have signed the Referral Agreement.", user_name, self.activityDetail.referral_fee, buyer_block,buyer_block];
                                dispatch_async(dispatch_get_main_queue(), ^{
//                                    self.viewForDescription.hidden = NO;
                                    
                                    self.labelDescription.hidden = YES;
                                    self.buttonDescription.hidden = YES;
//                                    [self.buttonDescription setTitle:@"Sign" forState:UIControlStateNormal];
//                                    self.buttonDescription.tag = 0;
                                });
                            }
                            else {
                                message_block = [NSString stringWithFormat:@"%@ has sent you referral %@ with a %@ referral fee.", user_name, buyer_block, self.activityDetail.referral_fee];
                                dispatch_async(dispatch_get_main_queue(), ^{
//                                    self.viewForDescription.hidden = NO;
                                    
                                    self.labelDescription.hidden = YES;
                                    self.buttonDescription.hidden = YES;
//                                    [self.buttonDescription setTitle:@"Accept" forState:UIControlStateNormal];
//                                    self.buttonDescription.tag = 0;
                                });
                            }
                            
                            
                            NSString *htmlString = [NSString stringWithFormat:@"<html><head><style>body{font-family:'OpenSans'} a{text-decoration: none; color:#2C99CE;}</style></head><body>%@</body></html>", message_block];
                            
//                            dispatch_async(dispatch_get_main_queue(), ^{
                                CGSize constraint = CGSizeMake(200.0f - 0.0f, 20000.0f);
                                
                                CGSize size = [self.labelActivityName.text sizeWithFont:FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR) constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
                                
                                CGFloat height = MAX(size.height, FONT_SIZE_REGULAR);
                                
                                CGRect frame = self.labelActivityName.frame;
                                frame.size.height = height;
                                self.labelActivityName.frame = frame;
//                            NSLog(@"height:%f",height);
                                frame = self.labelDateTime.frame;
                                frame.origin.y = self.labelActivityName.frame.origin.y + self.labelActivityName.frame.size.height + 5.0f;
                                self.labelDateTime.frame = frame;
//                            });
//                            
//                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self.webView loadHTMLString:htmlString baseURL:nil];
//                            });
                            
                        }];
                        [request setFailedBlock:^{
                            NSError *error = [request error];
                            NSLog(@" error:%@",error);
                            
                        }];
                        [request startAsynchronous];
                        
                        break;
                    }
                    case 8:{
                        message = [NSString stringWithFormat:@"You are actively working on referral, %@. ", buyer_name];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            self.labelActivityName.text = [NSString stringWithFormat:@"Referral %@ Update",self.activityDetail.referral_buyer_name];
                        });
                        break;
                    }
                    case 9:{
                        message = @"This referral is now complete and parties have been fully paid.";
                        dispatch_async(dispatch_get_main_queue(), ^{
                            self.labelActivityName.text = [NSString stringWithFormat:@"Referral %@ Update",self.activityDetail.referral_buyer_name];
                        });
                        break;
                    }
                        
                    default:
                        message = @"";
                        break;
                }
            }
            else {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.labelActivityName.text = [NSString stringWithFormat:@"Referral %@ Update",self.activityDetail.referral_buyer_name];
                });
                
                NSString *user_name = [NSString stringWithFormat:@"<a href='http://profile/%@'>%@</a>",self.activityDetail.user_id, self.activityDetail.user_name];
                NSString *buyer_name = [NSString stringWithFormat:@"<a href='http://client/out/%@'>%@</a>",self.activityDetail.client_id, self.activityDetail.referral_buyer_name];
                
                switch ([self.activityDetail.referral_status integerValue]) {
                    case 1:
                        message = [NSString stringWithFormat:@"%@ is now under contract.",buyer_name];
                        break;
                    case 4:{
                        message = [NSString stringWithFormat:@"%@ has now closed your referral %@. AgentBridge will now be collecting a service fee.", user_name,buyer_name];
                        dispatch_async(dispatch_get_main_queue(), ^{
//                            self.viewForDescription.hidden = NO;
                            NSString *parameters = [NSString stringWithFormat:@"?referral_id=%@", self.activityDetail.referral_id];
                            
                            NSString *urlString = [NSString stringWithFormat:@"http://agentbridge.com/webservice/get_closed_referral.php%@", parameters];
                            
                            
                            //            //NSLog(@"urlString:%@",urlString);
                            __block NSError *errorData = nil;
                            __weak ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlString]];
                            [request setCompletionBlock:^{
                                // Use when fetching text data
                                //                        NSString *responseString = [request responseString];
                                // Use when fetching binary data
                                NSData *responseData = [request responseData];
                                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&errorData];
                                
                                //                //NSLog(@"json:%@",json);
                                if([[json objectForKey:@"data"] count]){
                                    
                                    self.clrf_id = [[[json objectForKey:@"data"] firstObject] valueForKey:@"clrf_id"];
                                    
                                    if ([[[[json objectForKey:@"data"] firstObject] valueForKey:@"r1_paid"] boolValue] == YES) {
                                        
                                        self.labelDescription.hidden = NO;
                                        self.buttonDescription.hidden = YES;
                                        
                                        self.labelDescription.text = @"Thank you for the payment. You may now change the status of the Referral to Completed.";
                                    }
                                    else {
                                        self.pricePaid = [[[json objectForKey:@"data"] firstObject] valueForKey:@"price_paid"];
                                        
                                        self.labelDescription.hidden = YES;
                                        self.buttonDescription.hidden = NO;
                                        [self.buttonDescription setTitle:@"Pay" forState:UIControlStateNormal];
                                        self.buttonDescription.tag = 1901;
                                    }
                                    
                                }
                                
                            }];
                            [request setFailedBlock:^{
                                NSError *error = [request error];
                                NSLog(@" error:%@",error);
                                
                            }];
                            [request startAsynchronous];
                            
                            
                        });}
                        break;
                    case 5:
                        message = [NSString stringWithFormat:@"%@ has declined the referral. ", user_name];
                        break;
                    case 6:
                        message = [NSString stringWithFormat:@"%@ needs your help on referral %@ ", user_name, buyer_name];
                        break;
                    case 7:
                        if ([self.activityDetail.referral_response integerValue]) {
                            
                            NSString *parameters = [NSString stringWithFormat:@"?user_id=%@&update_id=%@", self.loginDetail.user_id, self.activityDetail.referral_update_id];
                            
                            NSString *urlString = [NSString stringWithFormat:@"http://agentbridge.com/webservice/check_if_signed.php%@", parameters];
                            
                            __block NSString *buyer_block = buyer_name;
                            
                            __block NSError *errorData = nil;
                            __weak ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlString]];
                            [request setCompletionBlock:^{
                                // Use when fetching text data
                                //                        NSString *responseString = [request responseString];
                                // Use when fetching binary data
                                NSData *responseData = [request responseData];
                                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&errorData];
                                NSString *message_block = @"";
                                if ([[json objectForKey:@"data"] count] == 0) {
                                    
                                    message_block = [NSString stringWithFormat:/*@"You have accepted %@'s %@ referral on %@.*/ @"%@ have accepted your %@ referral on %@. You have signed the Referral Agreement.", user_name, self.activityDetail.referral_fee, buyer_block];
                                }
                                else {
                                    
                                    message_block = [NSString stringWithFormat:/*@"You have accepted %@'s %@ referral on %@.*/ @"%@ have accepted your %@ referral on %@. You have not signed the Referral Agreement.", user_name, self.activityDetail.referral_fee, buyer_block];
                                    
                                    dispatch_async(dispatch_get_main_queue(), ^{
//                                        self.viewForDescription.hidden = NO;
                                        
                                        self.labelDescription.hidden = YES;
                                        self.buttonDescription.hidden = NO;
                                        [self.buttonDescription setTitle:@"Sign" forState:UIControlStateNormal];
                                        self.buttonDescription.tag = 0;
                                    });
                                }
                                
//                                    dispatch_async(dispatch_get_main_queue(), ^{
//                                        self.viewForDescription.hidden = NO;
//                                        [self.buttonDescription setTitle:@"Sign" forState:UIControlStateNormal];
//                                    });
                                
                                
                                NSString *htmlString = [NSString stringWithFormat:@"<html><head><style>body{font-family:'OpenSans'} a{text-decoration: none; color:#2C99CE;}</style></head><body>%@</body></html>", message_block];
                                
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [self.webView loadHTMLString:htmlString baseURL:nil];
                                });
                                
                            }];
                            [request setFailedBlock:^{
                                NSError *error = [request error];
                                NSLog(@" error:%@",error);
                                
                            }];
                            [request startAsynchronous];
                            
//                            message = [NSString stringWithFormat:@"%@ has now accepted your referral of %@ fee for client %@.<br/><br/>Sign the referral contract. ", self.activityDetail.user_name, self.activityDetail.referral_fee, buyer_name];
//                            dispatch_async(dispatch_get_main_queue(), ^{
//                                self.viewForDescription.hidden = NO;
//                                [self.buttonDescription setTitle:@"Sign" forState:UIControlStateNormal];
//                            });
                        }
                        else {
                            message = [NSString stringWithFormat:@"You have sent a referral to %@ with a %@ referral fee. ", user_name, self.activityDetail.referral_fee];
                        }
                        break;
                    case 8:{
                        message = [NSString stringWithFormat:@"%@ is actively working on your referral, %@. ", user_name, buyer_name];
                        break;
                    }
                    case 9:
                        message = [NSString stringWithFormat:@"Congratulations. Referral %@ is now complete. ", user_name];
                        break;
                        
                        
                    default:
                        message = @"";
                        break;
                }
            }
            
            
        }
        else if ([self.activityDetail.activity_type integerValue] == 6) {
            //            //NSLog(@"listing:%@",self.activityDetail.listing_id);
            
//            //NSLog(@"user:%@, other:%@",self.activityDetail.user_id, self.activityDetail.other_user_id);
            dispatch_async(dispatch_get_main_queue(), ^{
                self.labelActivityName.text = @"Request to View Private POPs™";
                self.labelDateTime.text = self.activityDetail.date;
                
//                //NSLog(@"permission:%@",self.activityDetail.permission);
                if ([self.activityDetail.permission integerValue] == 0) {
                    if ([self.activityDetail.user_id integerValue] == [self.loginDetail.user_id integerValue]) {
                        
                        self.labelDescription.text = @"";
                        self.labelDescription.hidden = YES;
                        self.buttonDescription.hidden = NO;
                        [self.buttonDescription setTitle:@"Accept" forState:UIControlStateNormal];
                        self.buttonDescription.tag = 601;
                    }
                    else {
                        
                        self.labelDescription.text = @"";
                        self.labelDescription.hidden = YES;
                        self.buttonDescription.hidden = YES;
                    }
                }
                else {
                    if ([self.activityDetail.user_id integerValue] == [self.loginDetail.user_id integerValue]) {
                        self.labelDescription.text = @"You have accepted this request.";
                    }
                    else {
                        self.labelDescription.text = [NSString stringWithFormat:@"%@ have accepted your request.",self.activityDetail.user_name];
                    }
                    self.buttonDescription.hidden = YES;
                    self.labelDescription.hidden = NO;
                }
//                self.viewForDescription.hidden = NO;
            });
            
            if ([self.activityDetail.user_id integerValue] == [self.loginDetail.user_id integerValue]) {
                NSString *user_name = [NSString stringWithFormat:@"<a href='http://profile/%@'>%@</a>",self.activityDetail.other_user_id, self.activityDetail.user_name];
                
                NSString *pops_link = [NSString stringWithFormat:@"<a href='http://pops/%@'>%@</a>",self.activityDetail.listing_id, self.activityDetail.property_name];
                
                message = [NSString stringWithFormat:@"%@ is requesting to view your private POPs™, %@.",user_name, pops_link];
            }
            else {
                NSString *user_name = [NSString stringWithFormat:@"<a href='http://profile/%@'>%@</a>",self.activityDetail.user_id, self.activityDetail.user_name];
                
                NSString *pops_link = [NSString stringWithFormat:@"<a href='http://agent_pops/%@'>%@</a>",self.activityDetail.user_id, self.activityDetail.property_name];
                
                message = [NSString stringWithFormat:@"You are requesting to view %@ private POPs™, %@.",user_name, pops_link];
            }
            
        }
        else if ([self.activityDetail.activity_type integerValue] == 8) {
            
//            //NSLog(@"[8]%@ user:%@ - %@ --- %@",self.loginDetail.user_id,self.activityDetail.user_id, self.activityDetail.other_user_id, self.activityDetail.user_name);
            
//            //NSLog(@"8 user:%@, other:%@",self.activityDetail.user_id, self.activityDetail.other_user_id);
            if ([self.activityDetail.user_id integerValue] == [self.loginDetail.user_id integerValue]) {
                
                NSString *user_name = [NSString stringWithFormat:@"<a href='http://profile/%@'>%@</a>",self.activityDetail.other_user_id, self.activityDetail.user_name];
                
                message = [NSString stringWithFormat:@"%@ is requesting to view your public POPs™.",user_name];
            }
            else {
                
                NSString *user_name = [NSString stringWithFormat:@"<a href='http://profile/%@'>%@</a>",self.activityDetail.user_id, self.activityDetail.user_name];
                message = [NSString stringWithFormat:@"You have requested to view  %@'s  public POPs™.",user_name];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.labelActivityName.text = @"Request Network Access";
                self.labelDateTime.text = self.activityDetail.date;
                
                if ([self.activityDetail.user_id integerValue] == [self.loginDetail.user_id integerValue]) {
//                    self.viewForDescription.hidden = NO;
                    self.labelDescription.text = @"";
                    self.labelDescription.hidden = YES;
                    self.buttonDescription.hidden = NO;
                    [self.buttonDescription setTitle:@"Accept" forState:UIControlStateNormal];
                    self.buttonDescription.tag = 801;
                    
                    
                    if ([self.activityDetail.network_status integerValue] == 1) {
//                        self.viewForDescription.hidden = NO;
                        self.labelDescription.text = [NSString stringWithFormat:@"You have accepted this request. %@ is now part of your Network.",self.activityDetail.user_name];
                        self.labelDescription.hidden = NO;
                        self.buttonDescription.hidden = YES;
                    }
                    else if ([self.activityDetail.network_status integerValue] == 2) {
//                        self.viewForDescription.hidden = NO;
                        self.labelDescription.text = @"You have declined this request. ";
                        self.buttonDescription.hidden = YES;
                        self.labelDescription.hidden = NO;
                    }
                }
                else {
//                    self.viewForDescription.hidden = YES;
                    
                    
                    if ([self.activityDetail.network_status integerValue] == 1) {
//                        self.viewForDescription.hidden = NO;
                        self.labelDescription.text = [NSString stringWithFormat:@"%@ has accepted this request. You are now able to view %@'s POPs™.",self.activityDetail.user_name,self.activityDetail.user_name];
                        self.buttonDescription.hidden = YES;
                        self.labelDescription.hidden = NO;
                    }
                    else if ([self.activityDetail.network_status integerValue] == 2) {
//                        self.viewForDescription.hidden = NO;
                        self.labelDescription.text = [NSString stringWithFormat:@"%@ has declined this request.",self.activityDetail.user_name];
                        self.buttonDescription.hidden = NO;
                        self.labelDescription.hidden = NO;
                        [self.buttonDescription setTitle:@"Request to View" forState:UIControlStateNormal];
                        self.buttonDescription.tag = 802;
                    }
                    else if ([self.activityDetail.network_status integerValue] == 0) {
//                        self.viewForDescription.hidden = NO;
                        self.labelDescription.hidden = NO;
                        self.labelDescription.text = @"Pending Approval";
                        self.buttonDescription.hidden = YES;
                    }
                }
                
            });
            
            
            
        }
        else if ([self.activityDetail.activity_type integerValue] == 28) {
            
//            //NSLog(@"[28]%@ user:%@ - %@ --- %@",self.loginDetail.user_id,self.activityDetail.user_id, self.activityDetail.other_user_id, self.activityDetail.user_name);
            
//            //NSLog(@"28 user:%@, other:%@",self.activityDetail.user_id, self.activityDetail.other_user_id);
            if ([self.activityDetail.other_user_id integerValue] == [self.loginDetail.user_id integerValue]) {
                
                NSString *user_name = [NSString stringWithFormat:@"<a href='http://profile/%@'>%@</a>",self.activityDetail.user_id, self.activityDetail.user_name];
                
                message = [NSString stringWithFormat:@"You have been invited to join %@'s Network. If you accept this request, you will be able to view %@'s public POPs™.",user_name,user_name];
                
            }
            else {
                
                NSString *user_name = [NSString stringWithFormat:@"<a href='http://profile/%@'>%@</a>",self.activityDetail.other_user_id, self.activityDetail.user_name];
                message = [NSString stringWithFormat:@"You requested to join %@'s Network.",user_name];
//                message = [NSString stringWithFormat:@"%@ is now added to your Network and will be able to view your public POPs™.",self.activityDetail.user_name];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.labelActivityName.text = @"Request Network Access";
                self.labelDateTime.text = self.activityDetail.date;
                
                if ([self.activityDetail.other_user_id integerValue] == [self.loginDetail.user_id integerValue]) {
//                    self.viewForDescription.hidden = NO;
                    self.labelDescription.text = @"";
                    self.labelDescription.hidden = NO;
                    self.buttonDescription.hidden = NO;
                    [self.buttonDescription setTitle:@"Accept" forState:UIControlStateNormal];
                    self.buttonDescription.tag = 2801;
                    
//                    NSString *user_name = [NSString stringWithFormat:@"<a href='http://profile/%@'>%@</a>",self.activityDetail.user_id, self.activityDetail.other_user_name];
                    
                    if ([self.activityDetail.network_status integerValue] == 1) {
//                        self.viewForDescription.hidden = NO;
                        self.labelDescription.text = [NSString stringWithFormat:@"You have accepted this request. You are now part of %@'s Network.",self.activityDetail.user_name];
                        self.labelDescription.hidden = NO;
                        self.buttonDescription.hidden = YES;
                    }
                    else if ([self.activityDetail.network_status integerValue] == 2) {
//                        self.viewForDescription.hidden = NO;
                        self.labelDescription.hidden = NO;
                        self.labelDescription.text = @"You have declined this request.";
                        self.buttonDescription.hidden = YES;
                    }
                }
                else {
//                    self.viewForDescription.hidden = YES;
                    
//                    NSString *user_name = [NSString stringWithFormat:@"<a href='http://profile/%@'>%@</a>",self.activityDetail.other_user_id, self.activityDetail.user_name];
                    
                    if ([self.activityDetail.network_status integerValue] == 1) {
//                        self.viewForDescription.hidden = NO;
                        self.labelDescription.text = [NSString stringWithFormat:@"%@ has accepted this request and is now part of your Network.",self.activityDetail.user_name];
                        self.labelDescription.hidden = NO;
                        self.buttonDescription.hidden = YES;
                    }
                    else if ([self.activityDetail.network_status integerValue] == 2) {
//                        self.viewForDescription.hidden = NO;
                        self.labelDescription.text = [NSString stringWithFormat:@"%@ has declined this request.",self.activityDetail.user_name];
                        self.buttonDescription.hidden = NO;
                        self.labelDescription.hidden = NO;
                        [self.buttonDescription setTitle:@"Request to View" forState:UIControlStateNormal];
                        self.buttonDescription.tag = 2802;
                    }
                    else if ([self.activityDetail.network_status integerValue] == 0) {
//                        self.viewForDescription.hidden = NO;
                        self.labelDescription.text = @"Pending Approval";
                        self.buttonDescription.hidden = YES;
                        self.labelDescription.hidden = NO;
                    }
                }
                
                
            });
            
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            CGSize constraint = CGSizeMake(200.0f - 0.0f, 20000.0f);
            
            CGSize size = [self.labelActivityName.text sizeWithFont:FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR) constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
            
            CGFloat height = MAX(size.height, FONT_SIZE_REGULAR);
            
            CGRect frame = self.labelActivityName.frame;
            frame.size.height = height;
            self.labelActivityName.frame = frame;
            
            frame = self.labelDateTime.frame;
            frame.origin.y = self.labelActivityName.frame.origin.y + self.labelActivityName.frame.size.height + 5.0f;
            self.labelDateTime.frame = frame;
        });
        
        if (!([self.activityDetail.activity_type integerValue] == 11 && [self.activityDetail.user_id integerValue] == [self.loginDetail.user_id integerValue] && [self.activityDetail.referral_status integerValue] == 7)) {
            NSString *htmlString = [NSString stringWithFormat:@"<html><head><style>body{font-family:'OpenSans'} a{text-decoration: none; color:#2C99CE;}</style></head><body>%@</body></html>", message];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.webView loadHTMLString:htmlString baseURL:nil];
            });
        }
        
        
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
//    //NSLog(@"url:%@",url);
    if (UIWebViewNavigationTypeLinkClicked == navigationType)
    {
        NSString *type = [url substringFromIndex:7];
        if ([type rangeOfString:@"buyer"].location != NSNotFound) {
            [self.tabBarController setSelectedIndex:2];
            ABridge_BuyerViewController *viewController = ((ABridge_BuyerViewController*)((UINavigationController*)self.tabBarController.selectedViewController).viewControllers[0]);
            [viewController scrollToBuyer:[url substringFromIndex:13]];
        }
        else if ([type rangeOfString:@"pops"].location != NSNotFound) {
            
            [self.tabBarController setSelectedIndex:1];
            ABridge_PropertyViewController *viewController = ((ABridge_PropertyViewController*)self.tabBarController.selectedViewController);
            [viewController scrollToPOPs:[url substringFromIndex:12]];
        }
        else if ([type rangeOfString:@"client"].location != NSNotFound) {
            
            
            [self.tabBarController setSelectedIndex:3];
            ABridge_ReferralViewController *viewController = ((ABridge_ReferralViewController*)self.tabBarController.selectedViewController);
            
            if ([[url substringToIndex:17] rangeOfString:@"in"].location != NSNotFound) {
                [viewController scrollToReferralIn:[url substringFromIndex:17]];
            }
            else {
                [viewController scrollToReferralOut:[url substringFromIndex:18]];
            }
            
        }
        else if ([type rangeOfString:@"profile"].location != NSNotFound) {
            ABridge_ActivityAgentProfileViewController *profileViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ActivityAgentProfile"];
            profileViewController.user_id = [url substringFromIndex:15];
            [self.navigationController pushViewController:profileViewController animated:YES];
        }
        else if ([type rangeOfString:@"agent_pops"].location != NSNotFound) {
            ABridge_ActivityAgentPOPsViewController *popsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ActivityAgentPOPs"];
            popsViewController.user_id = [url substringFromIndex:18];
            [self.navigationController pushViewController:popsViewController animated:YES];
        }
    }
    return YES;
}


- (void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse *)response
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
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
     //NSLog(@"Did Fail");
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Internet Connection" message:@"You have no Internet Connection available." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
//    NSError *error = nil;
//    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:self.dataReceived options:NSJSONReadingAllowFragments error:&error];
    
    //    //NSLog(@"Did Finish:%@", json);
    if (connection == self.urlConnectionRequestNetwork) {
////        //NSLog(@"Did Finish:%@", json);
//        if ([[json objectForKey:@"data"] count]) {
//            NSManagedObjectContext *context = ((ABridge_AppDelegate *)[[UIApplication sharedApplication] delegate]).managedObjectContext;
//            
//            NSDictionary *entry = [[json objectForKey:@"data"] firstObject];
//            if ([[json objectForKey:@"data"] count]) {
//                RequestNetwork *network = nil;
//                
//                NSPredicate * predicate = [NSPredicate predicateWithFormat:@"network_id == %@", [entry objectForKey:@"network_id"]];
//                
//                NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
//                [fetchRequest setPredicate:predicate];
//                [fetchRequest setEntity:[NSEntityDescription entityForName:@"RequestNetwork" inManagedObjectContext:context]];
//                NSError * error = nil;
//                NSArray * result = [context executeFetchRequest:fetchRequest error:&error];
//                if ([result count]) {
//                    network = (RequestNetwork*)[result firstObject];
//                }
//                else {
//                    network = [NSEntityDescription insertNewObjectForEntityForName: @"RequestNetwork" inManagedObjectContext: context];
//                }
//                
//                [network setValuesForKeysWithDictionary:entry];
//                
//                NSError *errorSave = nil;
//                if (![context save:&errorSave]) {
//                    //NSLog(@"Error on saving RequestNetwork:%@",[errorSave localizedDescription]);
//                }
//                
//                if ([network.status integerValue] == 1) {
////                    //NSLog(@"setting:%@",self.activityDetail.setting);
//                    if ([self.activityDetail.setting integerValue] == 1) {
////                        [self checkSettingGetPrice];
//                    }
//                    else if ([self.activityDetail.setting integerValue] == 2) {
//                        
//                        NSString *parameters = [NSString stringWithFormat:@"?user_id=%@&other_user_id=%@&property_id=%@",self.activityDetail.pops_user_id,self.loginDetail.user_id, self.activityDetail.listing_id];
//                        
//                        NSMutableString *urlString_ = [NSMutableString stringWithString:@"http://agentbridge.com/webservice/get_request_access.php"];
//                        [urlString_ appendString:parameters];
////                        //NSLog(@"url:%@",urlString_);
//                        NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlString_]];
//                        
//                        self.urlConnectionRequestAccess = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self startImmediately:YES];
//                        
//                        if (self.urlConnectionRequestAccess) {
//                            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
//                            [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
//                        }
//                    }
//                    
//                }
//                else if ([network.status integerValue] == 1){
//                    //                    self.viewForDescription.hidden = NO;
//                    self.labelDescription.text = @"";
//                    self.labelDescription.hidden = YES;
//                    self.buttonDescription.hidden = NO;
//                    [self.buttonDescription setTitle:@"Save" forState:UIControlStateNormal];
//                    self.buttonDescription.tag = 0;
//                }
//                else {
//                    //                    self.viewForDescription.hidden = NO;
//                    self.labelDescription.text = [NSString stringWithFormat:@"This POPs™ is restricted to %@'s Network members only",self.activityDetail.pops_user_name];
//                    self.labelDescription.hidden = NO;
//                    self.buttonDescription.hidden = NO;
//                    [self.buttonDescription setTitle:@"Pending" forState:UIControlStateNormal];
//                    self.buttonDescription.tag = 0;
//                }
//            }
//            else {
////                self.viewForDescription.hidden = NO;
//                self.labelDescription.text = [NSString stringWithFormat:@"This POPs™ is restricted to %@'s Network members only",self.activityDetail.pops_user_name];
//                self.labelDescription.hidden = NO;
//                self.buttonDescription.hidden = NO;
//                [self.buttonDescription setTitle:@"Request To View" forState:UIControlStateNormal];
//                self.buttonDescription.tag = 2502;
//            }
//            
//            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//            [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
//            
//        }
//        else {
////            self.viewForDescription.hidden = NO;
//            self.labelDescription.text = [NSString stringWithFormat:@"This POPs™ is restricted to %@'s Network members only",self.activityDetail.pops_user_name];
//            self.labelDescription.hidden = NO;
//            self.buttonDescription.hidden = NO;
//            [self.buttonDescription setTitle:@"Request To View" forState:UIControlStateNormal];
//            self.buttonDescription.tag = 2502;
//            
//            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//            [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
//        }
        
    }
    else if (connection == self.urlConnectionRequestAccess) {
//        //NSLog(@"Access Did Finish:%@", json);
//        if ([[json objectForKey:@"data"] count]) {
//            NSManagedObjectContext *context = ((ABridge_AppDelegate *)[[UIApplication sharedApplication] delegate]).managedObjectContext;
//            NSDictionary *entry = [[json objectForKey:@"data"] firstObject];
//            
//            if ([[json objectForKey:@"data"] count]) {
//                RequestAccess *access = nil;
//                
//                NSPredicate * predicate = [NSPredicate predicateWithFormat:@"access_id == %@", [entry objectForKey:@"access_id"]];
//                
//                NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
//                [fetchRequest setPredicate:predicate];
//                [fetchRequest setEntity:[NSEntityDescription entityForName:@"RequestAccess" inManagedObjectContext:context]];
//                NSError * error = nil;
//                NSArray * result = [context executeFetchRequest:fetchRequest error:&error];
//                
//                if ([result count]) {
//                    access = (RequestAccess*)[result firstObject];
//                }
//                else {
//                    access = [NSEntityDescription insertNewObjectForEntityForName: @"RequestAccess" inManagedObjectContext: context];
//                }
//                
//                [access setValuesForKeysWithDictionary:entry];
//                
//                NSError *errorSave = nil;
//                if (![context save:&errorSave]) {
//                    //NSLog(@"Error on saving RequestAccess:%@",[errorSave localizedDescription]);
//                }
//                
//                if ([access.permission boolValue] == YES) {
////                    [self getPriceText];
//                    
////                        self.viewForDescription.hidden = NO;
//                    self.labelDescription.text = @"";
//                    self.labelDescription.hidden = YES;
//                    self.buttonDescription.hidden = NO;
//                    [self.buttonDescription setTitle:@"Save" forState:UIControlStateNormal];
//                    self.buttonDescription.tag = 0;
//                }
//                else if ([access.permission boolValue] == NO){
////                    self.viewForDescription.hidden = NO;
//                    
//                    self.labelDescription.hidden = NO;
//                    self.buttonDescription.hidden = NO;
//                    self.labelDescription.text = @"This POPs™ is restricted to private";
//                    [self.buttonDescription setTitle:@"Pending" forState:UIControlStateNormal];
//                    self.buttonDescription.tag = 0;
//                }
//                
//            }
//            else {
////                self.viewForDescription.hidden = NO;
//                self.labelDescription.text = [NSString stringWithFormat:@"This POPs™ is restricted to %@'s Network members only",self.activityDetail.pops_user_name];
//                self.labelDescription.hidden = NO;
//                self.buttonDescription.hidden = NO;
//                [self.buttonDescription setTitle:@"Request To View" forState:UIControlStateNormal];
//                self.buttonDescription.tag = 2510;
//            }
//            
//            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//            [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
//        }
//        else {
////            self.viewForDescription.hidden = NO;
//            self.labelDescription.text = [NSString stringWithFormat:@"This POPs™ is restricted to %@'s Network members only",self.activityDetail.pops_user_name];
//            self.labelDescription.hidden = NO;
//            self.buttonDescription.hidden = NO;
//            [self.buttonDescription setTitle:@"Request To View" forState:UIControlStateNormal];
//            self.buttonDescription.tag = 2510;
//            
//            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//            [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
//        }
    }
//    else {
//        
//        [self.buttonDescription setTitle:@"Save" forState:UIControlStateNormal];
//    }
    // Do something with responseData
}

- (IBAction)buttonActionPressed:(id)sender {
// NSLog(@"pressed:%i",[((UIButton*)sender) tag]);
    switch ([((UIButton*)sender) tag]) {
        case 2501:{
            
            NSString *parameters = [NSString stringWithFormat:@"?user_id=%@&listing_id=%@&buyer_id=%@",self.loginDetail.user_id,self.activityDetail.listing_id, self.activityDetail.buyer_id];
            
            NSMutableString *urlString = [NSMutableString stringWithString:@"http://agentbridge.com/webservice/save_buyer.php"];
            [urlString appendString:parameters];
//             //NSLog(@"url:%@",urlString);
            
            __block NSError *errorData = nil;
            __weak ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlString]];
            //            [self.activityIndicator startAnimating];
            //            self.activityIndicator.hidden = NO;
            [request setCompletionBlock:
             ^{
                 NSData *responseData = [request responseData];
                 NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&errorData];
                 
                 //         //NSLog(@"json:%@",json);
                 if ([json objectForKey:@"status"]) {
//                     //NSLog(@"Success");
//                     self.viewForDescription.hidden = NO;
                     self.buttonDescription.hidden = YES;
                     self.labelDescription.text = [NSString stringWithFormat:@"Saved to %@",self.activityDetail.buyer_name];
                     self.labelDescription.hidden = NO;
                 }
                 else {
//                     //NSLog(@"Failed");
                 }
                 
                 
             }];
            [request setFailedBlock:^{
                NSError *error = [request error];
                NSLog(@" error:%@",error);
            }];
            
            [request startAsynchronous];
        break;
        }
        case 601:{
            
            NSString *parameters = [NSString stringWithFormat:@"?access_id=%@&user_id=%@&other_user_id=%@",self.activityDetail.access_id, self.loginDetail.user_id, self.activityDetail.other_user_id];
            
            NSMutableString *urlString = [NSMutableString stringWithString:@"http://agentbridge.com/webservice/accept_access.php"];
            [urlString appendString:parameters];
//             //NSLog(@"url:%@",urlString);
            
            __block NSError *errorData = nil;
            __weak ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlString]];
            //            [self.activityIndicator startAnimating];
            //            self.activityIndicator.hidden = NO;
            [request setCompletionBlock:
             ^{
                 NSData *responseData = [request responseData];
                 NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&errorData];
                 
//                 //NSLog(@"json:%@",json);
                 if ([json objectForKey:@"status"]) {
//                     //NSLog(@"Success");
                     
//                     if ([self.activityDetail.user_id integerValue] == [self.loginDetail.user_id integerValue]) {
                         self.labelDescription.text = @"You have accepted this request.";
//                     }
//                     else {
//                         self.labelDescription.text = [NSString stringWithFormat:@"%@ have accepted your request.",self.activityDetail.user_name];
//                     }
                     self.buttonDescription.hidden = YES;
                     self.labelDescription.hidden = NO;
                 }
                 else {
//                     //NSLog(@"Failed");
                 }
                 
                 
             }];
            [request setFailedBlock:^{
                NSError *error = [request error];
                NSLog(@" error:%@",error);
            }];
            
            [request startAsynchronous];
            break;
        }
        case 801:{
            
            NSString *parameters = [NSString stringWithFormat:@"?network_id=%@&user_id=%@&other_user_id=%@&activity_type=%@",self.activityDetail.network_id, self.loginDetail.user_id, self.activityDetail.other_user_id,@"9"];
            
            NSMutableString *urlString = [NSMutableString stringWithString:@"http://agentbridge.com/webservice/accept_network.php"];
            [urlString appendString:parameters];
//            //NSLog(@"url:%@",urlString);
            
            __block NSError *errorData = nil;
            __weak ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlString]];
            //            [self.activityIndicator startAnimating];
            //            self.activityIndicator.hidden = NO;
            [request setCompletionBlock:
             ^{
                 NSData *responseData = [request responseData];
                 NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&errorData];
                 
//                 //NSLog(@"json:%@",json);
                 if ([json objectForKey:@"status"]) {
//                     //NSLog(@"Success");
                     
//                     if ([self.activityDetail.network_status integerValue] == 1) {
                         //                        self.viewForDescription.hidden = NO;
                         self.labelDescription.text = [NSString stringWithFormat:@"You have accepted this request. %@ is now part of your Network.",self.activityDetail.user_name];
                         self.labelDescription.hidden = NO;
                         self.buttonDescription.hidden = YES;
//                     }
//                     else if ([self.activityDetail.network_status integerValue] == 2) {
//                         //                        self.viewForDescription.hidden = NO;
//                         self.labelDescription.text = @"You have declined this request. ";
//                         self.buttonDescription.hidden = YES;
//                         self.labelDescription.hidden = NO;
//                     }
                     
                 }
                 else {
//                     //NSLog(@"Failed");
                 }
                 
                 
             }];
            [request setFailedBlock:^{
                NSError *error = [request error];
                NSLog(@" error:%@",error);
            }];
            
            [request startAsynchronous];
            break;
        }
        case 2801:{
            
            NSString *parameters = [NSString stringWithFormat:@"?network_id=%@&user_id=%@&other_user_id=%@&activity_type=%@",self.activityDetail.network_id,self.loginDetail.user_id, self.activityDetail.other_user_id,@"29"];
            
            NSMutableString *urlString = [NSMutableString stringWithString:@"http://agentbridge.com/webservice/accept_network.php"];
            [urlString appendString:parameters];
//            //NSLog(@"url:%@",urlString);
            
            __block NSError *errorData = nil;
            __weak ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlString]];
            //            [self.activityIndicator startAnimating];
            //            self.activityIndicator.hidden = NO;
            [request setCompletionBlock:
             ^{
                 NSData *responseData = [request responseData];
                 NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&errorData];
                 
//                 //NSLog(@"json:%@",json);
                 if ([json objectForKey:@"status"]) {
//                     //NSLog(@"Success");
                     //                        self.viewForDescription.hidden = NO;
                     self.labelDescription.text = [NSString stringWithFormat:@"You have accepted this request. You are now part of %@'s Network.",self.activityDetail.user_name];
                     self.labelDescription.hidden = NO;
                     self.buttonDescription.hidden = YES;
                 }
                 else {
//                     //NSLog(@"Failed");
                 }
                 
                 
             }];
            [request setFailedBlock:^{
                NSError *error = [request error];
                NSLog(@" error:%@",error);
            }];
            
            [request startAsynchronous];
            break;
        }
        case 2502:case 802:case 2802:{
            
            NSString *parameters = [NSString stringWithFormat:@"?user_id=%@&other_user_id=%@",self.loginDetail.user_id, self.activityDetail.other_user_id];
            
            NSMutableString *urlString = [NSMutableString stringWithString:@"http://agentbridge.com/webservice/request_network.php"];
            [urlString appendString:parameters];
            //            //NSLog(@"url:%@",urlString);
            
            __block NSError *errorData = nil;
            __weak ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlString]];
            //            [self.activityIndicator startAnimating];
            //            self.activityIndicator.hidden = NO;
            [request setCompletionBlock:
             ^{
                 NSData *responseData = [request responseData];
                 NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&errorData];
                 
//                 //NSLog(@"json:%@",json);
                 if ([json objectForKey:@"status"]) {
//                     //NSLog(@"Success");
                     //                        self.viewForDescription.hidden = NO;
                     
                     self.labelDescription.text = @"Pending Approval";
                     self.buttonDescription.hidden = YES;
                     self.labelDescription.hidden = NO;
                 }
                 else {
//                     //NSLog(@"Failed");
                 }
                 
                 
             }];
            [request setFailedBlock:^{
                NSError *error = [request error];
                NSLog(@" error:%@",error);
            }];
            
            [request startAsynchronous];
            break;
        }
        case 2510:{
            
            NSString *parameters = [NSString stringWithFormat:@"?user_id=%@&other_user_id=%@&listing_id=%@",self.loginDetail.user_id, self.activityDetail.other_user_id,self.activityDetail.listing_id];
            
            NSMutableString *urlString = [NSMutableString stringWithString:@"http://agentbridge.com/webservice/request_access.php"];
            [urlString appendString:parameters];
            //            //NSLog(@"url:%@",urlString);
            
            __block NSError *errorData = nil;
            __weak ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlString]];
            //            [self.activityIndicator startAnimating];
            //            self.activityIndicator.hidden = NO;
            [request setCompletionBlock:
             ^{
                 NSData *responseData = [request responseData];
                 NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&errorData];
                 
                 //NSLog(@"json:%@",json);
                 if ([json objectForKey:@"status"]) {
                     //NSLog(@"Success");
                     //                        self.viewForDescription.hidden = NO;
                     
                     self.labelDescription.hidden = NO;
                     self.buttonDescription.hidden = NO;
                     self.labelDescription.text = @"This POPs™ is restricted to private";
                     [self.buttonDescription setTitle:@"Pending" forState:UIControlStateNormal];
                 }
                 else {
                     //NSLog(@"Failed");
                 }
                 
                 
             }];
            [request setFailedBlock:^{
                NSError *error = [request error];
                NSLog(@" error:%@",error);
            }];
            
            [request startAsynchronous];
            break;
        }
        case 1901:{
            
            
//            NSString *parameters = [NSString stringWithFormat:@"?referral_id=%@", self.activityDetail.referral_id];
//            
//            NSString *urlString = [NSString stringWithFormat:@"http://agentbridge.com/webservice/get_closed_referral.php%@", parameters];
//            
//            
////            //NSLog(@"urlString:%@",urlString);
//            __block NSError *errorData = nil;
//            __weak ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlString]];
//            [request setCompletionBlock:^{
//                // Use when fetching text data
//                //                        NSString *responseString = [request responseString];
//                // Use when fetching binary data
//                NSData *responseData = [request responseData];
//                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&errorData];
//                
////                //NSLog(@"json:%@",json);
//                if([[json objectForKey:@"data"] count]){
//                    
//                    if ([[[[json objectForKey:@"data"] firstObject] valueForKey:@"r2_paid"] boolValue] == YES) {
//                        
//                        self.labelDescription.hidden = NO;
//                        self.buttonDescription.hidden = YES;
//                        
//                        self.labelDescription.text = @"Thank you for the payment. You may now change the status of the Referral to Completed.";
//                    }
//                    else {
                        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                        ABridge_FeeCollectionViewController *viewController = (ABridge_FeeCollectionViewController*)[storyboard instantiateViewControllerWithIdentifier:@"FeeCollection"];
                        viewController.modalPresentationStyle = UIModalPresentationFullScreen;
                        viewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
                        
                        viewController.referral_id = self.activityDetail.referral_id;
                        viewController.referral_name = self.activityDetail.referral_buyer_name;
                        viewController.user_id = self.loginDetail.user_id;
                        viewController.delegate = self;
                        viewController.referral_fee = [self.activityDetail.referral_fee floatValue]/100.0f;
                        viewController.grossCommissionValue = self.pricePaid;
            
//            NSLog(@"referral_id:%@", self.activityDetail.referral_id);
                        //                    //NSLog(@"gross:%@",[[[json objectForKey:@"data"] firstObject] valueForKey:@"price_paid"]);
                        [self presentViewController:viewController animated:YES completion:^{
                            
                        }];
//                    }
//                    
//                }
//                
//            }];
//            [request setFailedBlock:^{
//                NSError *error = [request error];
//                NSLog(@" error:%@",error);
//                
//            }];
//            [request startAsynchronous];
            
            
            break;
        }
        default:
        break;
    }
}


#pragma mark ABridge_FeeCollectionViewControllerDelegate
- (void)transactionCompletedSuccessfully {
    
    
    NSString *parameters = [NSString stringWithFormat:@"?user_id=%@&agent_a=%@&activity_type=%@&update_id=%@&buyer_id=%@", self.loginDetail.user_id, self.activityDetail.user_id,@"22",self.activityDetail.referral_id,self.activityDetail.buyer_id];
    
    NSString *urlString = [NSString stringWithFormat:@"http://agentbridge.com/webservice/paid_service_fee.php%@", parameters];
    
    __block NSError *errorData = nil;
    __weak ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setCompletionBlock:^{
        // Use when fetching text data
        //                        NSString *responseString = [request responseString];
        // Use when fetching binary data
        NSData *responseData = [request responseData];
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&errorData];
        
//        //NSLog(@"json:%@",json);
        if([[json objectForKey:@"status"] integerValue] == 1){
            
            self.labelDescription.hidden = YES;
            self.buttonDescription.hidden = YES;
            
            
            NSString *updateCloseReferralString = [NSString stringWithFormat:@"http://agentbridge.com/webservice/save_closed_referral_r1.php?close_referral_id=%@", self.clrf_id];
            
            
            
            __block NSError *errorDataCLRF = nil;
            __weak ASIHTTPRequest *requestCLRF = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:updateCloseReferralString]];
            [requestCLRF setCompletionBlock:^{
                // Use when fetching text data
                //                        NSString *responseString = [request responseString];
                // Use when fetching binary data
                NSData *responseDataCLRF = [requestCLRF responseData];
                NSDictionary *jsonCLRF = [NSJSONSerialization JSONObjectWithData:responseDataCLRF options:NSJSONReadingAllowFragments error:&errorDataCLRF];
                
                NSLog(@"json:%@",jsonCLRF);
                if([[json objectForKey:@"status"] integerValue] == 1){
                    
                    self.labelDescription.hidden = NO;
                    self.buttonDescription.hidden = YES;
                    
                    self.labelDescription.text = @"Thank you for the payment. You may now change the status of the Referral to Completed.";
                    
                }
                
            }];
            [requestCLRF setFailedBlock:^{
                NSError *error = [requestCLRF error];
                NSLog(@" error:%@",error);
                
            }];
            [requestCLRF startAsynchronous];
        }
        
    }];
    [request setFailedBlock:^{
        NSError *error = [request error];
        NSLog(@" error:%@",error);
        
    }];
    [request startAsynchronous];
    
}

@end
