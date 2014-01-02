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
//#import "ContactInfoNumber.h"

@interface ABridge_ContactInfoViewController ()
@property (weak, nonatomic) IBOutlet UIView *viewContent;
@property (weak, nonatomic) IBOutlet UIButton *buttonSave;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbarAccessory;
@property (strong, nonatomic) NSMutableArray *arrayOfMobileNumber;
@property (strong, nonatomic) NSMutableArray *arrayOfFaxNumber;
@property (strong, nonatomic) NSMutableArray *arrayOfWorkNumber;

@property (strong, nonatomic) NSMutableArray *arrayRemoveMobile;
@property (strong, nonatomic) NSMutableArray *arrayRemoveFax;
@property (strong, nonatomic) NSMutableArray *arrayRemoveWork;

@property (strong, nonatomic) LoginDetails *loginDetails;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UITextField *currentTextField;

@property (strong, nonatomic) UIButton *addButtonMobile;
@property (strong, nonatomic) UIButton *addButtonFax;
@property (strong, nonatomic) UIButton *addButtonWork;
@property (strong, nonatomic) AgentProfile *profile;


@property (assign, nonatomic) NSInteger deleteMobileSuccessful;
@property (assign, nonatomic) NSInteger deleteFaxSuccessful;
@property (assign, nonatomic) NSInteger deleteWorkSuccessful;

@property (assign, nonatomic) NSInteger saveMobileSuccessful;
@property (assign, nonatomic) NSInteger saveFaxSuccessful;
@property (assign, nonatomic) NSInteger saveWorkSuccessful;

- (IBAction)saveContacts:(id)sender;
- (IBAction)dismissKeyboard:(id)sender;

@end

@implementation ABridge_ContactInfoViewController
@synthesize arrayOfMobileNumber;
@synthesize arrayOfFaxNumber;
@synthesize arrayOfWorkNumber;
@synthesize loginDetails;
@synthesize currentTextField;

@synthesize addButtonFax;
@synthesize addButtonMobile;
@synthesize addButtonWork;
@synthesize profile;

@synthesize arrayRemoveFax;
@synthesize arrayRemoveMobile;
@synthesize arrayRemoveWork;

@synthesize deleteMobileSuccessful;
@synthesize deleteFaxSuccessful;
@synthesize deleteWorkSuccessful;
@synthesize saveWorkSuccessful;
@synthesize saveFaxSuccessful;
@synthesize saveMobileSuccessful;


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
    
    self.buttonSave.titleLabel.font = FONT_OPENSANS_BOLD(FONT_SIZE_SMALL);
    
    self.activityIndicator.hidden = YES;
    
    
    [self fetchContactData];
    
}

- (void) fetchContactData {
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
    
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"user_id == %@", loginDetails.user_id];
    [fetchRequestProfile setPredicate:predicate];
    
    NSError *errorProfile = nil;
    self.profile = (AgentProfile*)[[context executeFetchRequest:fetchRequestProfile error:&errorProfile] firstObject];
    
    NSString *parameters = [NSString stringWithFormat:@"?profile_id=%@",self.profile.profile_id];
    
    NSMutableString *urlString = [NSMutableString stringWithString:@"http://keydiscoveryinc.com/agent_bridge/webservice/get_mobilenumber.php"];
    [urlString appendString:parameters];
    
    self.activityIndicator.hidden = NO;
    
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    
    __block NSError *errorData = nil;
    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    [request setCompletionBlock:
     ^{
         NSData *responseData = [request responseData];
         NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&errorData];
         
         //         NSLog(@"urlString:%@",urlString);
         if ([[json objectForKey:@"data"] count]) {
             //             NSMutableString *numbers = [NSMutableString stringWithString:@""];
             //             NSManagedObjectContext *context = ((ABridge_AppDelegate *)[[UIApplication sharedApplication] delegate]).managedObjectContext;
             for (NSDictionary *entry in [json objectForKey:@"data"]) {
                 //                 ContactInfoNumber *contactInfo = nil;
                 //
                 //                 NSPredicate * predicate = [NSPredicate predicateWithFormat:@"pk_id == %@", [entry objectForKey:@"pk_id"]];
                 //                 NSArray *result = [self fetchObjectsWithEntityName:@"ContactInfoNumber" andPredicate:predicate];
                 //                 if ([result count]) {
                 //                     contactInfo = (ContactInfoNumber*)[result firstObject];
                 //                 }
                 //                 else {
                 //                     contactInfo = [NSEntityDescription insertNewObjectForEntityForName: @"ContactInfoNumber" inManagedObjectContext: context];
                 //                 }
                 //
                 //                 [contactInfo setValuesForKeysWithDictionary:entry];
                 //
                 //
                 //                 NSError *error = nil;
                 //                 if (![context save:&error]) {
                 //                     NSLog(@"Error on saving Buyer:%@",[error localizedDescription]);
                 //                 }
                 //                 else {
                 if (self.arrayOfMobileNumber == nil) {
                     self.arrayOfMobileNumber = [[NSMutableArray alloc] init];
                 }
                 //
                 //                     NSLog(@"mobile:%@",[contactInfo valueForKey:@"value"]);
                 //                     [self.arrayOfMobileNumber addObject:contactInfo];
                 //                 }
                 
                 
                 [self.arrayOfMobileNumber addObject:entry];
                 
                 
             }
             
         }
         else {
             
         }
         
         [self.tableView reloadData];
         self.activityIndicator.hidden = YES;
         
         [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
         [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
     }];
    [request setFailedBlock:^{
        NSError *error = [request error];
        NSLog(@" error:%@",error);
    }];
    
    [request startAsynchronous];
    
    parameters = @"";
    [urlString setString: @""];
    
    parameters = [NSString stringWithFormat:@"?profile_id=%@",self.profile.profile_id];
    
    urlString = [NSMutableString stringWithString:@"http://keydiscoveryinc.com/agent_bridge/webservice/get_faxnumber.php"];
    [urlString appendString:parameters];
    
    //    NSLog(@"urlString:%@",urlString);
    self.activityIndicator.hidden = NO;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    
    __block NSError *errorDataFax = nil;
    __block ASIHTTPRequest *requestFax = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    [requestFax setCompletionBlock:
     ^{
         NSData *responseData = [requestFax responseData];
         NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&errorDataFax];
         
         if ([[json objectForKey:@"data"] count]) {
             //             NSMutableString *numbers = [NSMutableString stringWithString:@""];
             //             NSManagedObjectContext *context = ((ABridge_AppDelegate *)[[UIApplication sharedApplication] delegate]).managedObjectContext;
             for (NSDictionary *entry in [json objectForKey:@"data"]) {
                 //                 ContactInfoNumber *contactInfo = nil;
                 //
                 //                 NSPredicate * predicate = [NSPredicate predicateWithFormat:@"pk_id == %@", [entry objectForKey:@"pk_id"]];
                 //                 NSArray *result = [self fetchObjectsWithEntityName:@"ContactInfoNumber" andPredicate:predicate];
                 //                 if ([result count]) {
                 //                     contactInfo = (ContactInfoNumber*)[result firstObject];
                 //                 }
                 //                 else {
                 //                     contactInfo = [NSEntityDescription insertNewObjectForEntityForName: @"ContactInfoNumber" inManagedObjectContext: context];
                 //                 }
                 //
                 //                 [contactInfo setValuesForKeysWithDictionary:entry];
                 //
                 //
                 //                 NSError *error = nil;
                 //                 if (![context save:&error]) {
                 //                     NSLog(@"Error on saving Buyer:%@",[error localizedDescription]);
                 //                 }
                 //                 else {
                 if (self.arrayOfFaxNumber == nil) {
                     self.arrayOfFaxNumber = [[NSMutableArray alloc] init];
                 }
                 //
                 //                     NSLog(@"fax:%@",[contactInfo valueForKey:@"value"]);
                 //                     [self.arrayOfFaxNumber addObject:contactInfo];
                 //                 }
                 
                 [self.arrayOfFaxNumber addObject:entry];
             }
             
         }
         else {
             
         }
         
         [self.tableView reloadData];
         self.activityIndicator.hidden = YES;
         
         [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
         [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
     }];
    [requestFax setFailedBlock:^{
        NSError *error = [requestFax error];
        NSLog(@" error:%@",error);
    }];
    
    [requestFax startAsynchronous];
    
    parameters = @"";
    [urlString setString: @""];
    
    parameters = [NSString stringWithFormat:@"?profile_id=%@",self.profile.profile_id];
    
    urlString = [NSMutableString stringWithString:@"http://keydiscoveryinc.com/agent_bridge/webservice/get_worknumber.php"];
    [urlString appendString:parameters];
    
    //    NSLog(@"urlString:%@",urlString);
    self.activityIndicator.hidden = NO;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    
    __block NSError *errorDataWork = nil;
    __block ASIHTTPRequest *requestWork = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    [requestWork setCompletionBlock:
     ^{
         NSData *responseData = [requestWork responseData];
         NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&errorDataWork];
         
         if ([[json objectForKey:@"data"] count]) {
             //             NSMutableString *numbers = [NSMutableString stringWithString:@""];
             //             NSManagedObjectContext *context = ((ABridge_AppDelegate *)[[UIApplication sharedApplication] delegate]).managedObjectContext;
             for (NSDictionary *entry in [json objectForKey:@"data"]) {
                 //                 ContactInfoNumber *contactInfo = nil;
                 //
                 //                 NSPredicate * predicate = [NSPredicate predicateWithFormat:@"pk_id == %@", [entry objectForKey:@"pk_id"]];
                 //                 NSArray *result = [self fetchObjectsWithEntityName:@"ContactInfoNumber" andPredicate:predicate];
                 //                 if ([result count]) {
                 //                     contactInfo = (ContactInfoNumber*)[result firstObject];
                 //                 }
                 //                 else {
                 //                     contactInfo = [NSEntityDescription insertNewObjectForEntityForName: @"ContactInfoNumber" inManagedObjectContext: context];
                 //                 }
                 //
                 //                 [contactInfo setValuesForKeysWithDictionary:entry];
                 //                 
                 //                 
                 //                 NSError *error = nil;
                 //                 if (![context save:&error]) {
                 //                     NSLog(@"Error on saving Buyer:%@",[error localizedDescription]);
                 //                 }
                 //                 else {
                 if (self.arrayOfWorkNumber == nil) {
                     self.arrayOfWorkNumber = [[NSMutableArray alloc] init];
                 }
                 //
                 //                     NSLog(@"work:%@",[contactInfo valueForKey:@"value"]);
                 //                     [self.arrayOfWorkNumber addObject:contactInfo];
                 //                 }
                 
                 
                 [self.arrayOfWorkNumber addObject:entry];
             }
             
         }
         else {
             
         }
         
         [self.tableView reloadData];
         self.activityIndicator.hidden = YES;
         
         [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
         [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
     }];
    [requestWork setFailedBlock:^{
        NSError *error = [requestWork error];
        NSLog(@" error:%@",error);
    }];
    
    [requestWork startAsynchronous];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveContacts:(id)sender {
    
    BOOL checkIfHasMobile = NO;
    
    for (NSDictionary *entry in self.arrayOfMobileNumber) {
        if (![[entry valueForKey:@"value"] isEqualToString:@""]) {
            checkIfHasMobile = YES;
            break;
        }
    }
    
    if (checkIfHasMobile) {
        
        self.deleteMobileSuccessful = 1;
        self.deleteFaxSuccessful = 1;
        self.deleteWorkSuccessful = 1;
        self.saveWorkSuccessful = 1;
        self.saveMobileSuccessful = 1;
        self.saveFaxSuccessful = 1;
        
        if (self.arrayRemoveMobile != nil) {
            for (NSDictionary *entry in self.arrayRemoveMobile) {
                NSString *parameters = [NSString stringWithFormat:@"?id=%@&user_id=%@",[entry valueForKey:@"pk_id"],[entry valueForKey:@"user_id"]];
                
                NSMutableString *urlString = [NSMutableString stringWithString:@"http://keydiscoveryinc.com/agent_bridge/webservice/delete_mobilenumber.php"];
                [urlString appendString:parameters];
                
                self.activityIndicator.hidden = NO;
                __block NSError *errorData = nil;
                __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlString]];
                
                [request setCompletionBlock:
                 ^{
                     NSData *responseData = [request responseData];
                     NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&errorData];
                     
                     if ([[json objectForKey:@"status"] integerValue] == YES) {
//                         NSLog(@"successfully delete Mobile");
                         self.deleteMobileSuccessful = 2;
                     }
                     else {
//                         NSLog(@"failed to delete Mobile");
                         self.deleteMobileSuccessful = 0;
                     }
                     
                     dispatch_async(dispatch_get_main_queue(), ^{
                         [self showSuccessAlert];
                     });
                 }];
                [request setFailedBlock:^{
                    NSError *error = [request error];
                    NSLog(@" error:%@",error);
                }];
                
                [request startAsynchronous];
                
//                self.activityIndicator.hidden = YES;
                
            }
        }
        else {
            self.deleteMobileSuccessful = 2;
        }
        
        if (self.arrayRemoveFax != nil) {
            for (NSDictionary *entry in self.arrayRemoveFax) {
                NSString *parameters = [NSString stringWithFormat:@"?id=%@&user_id=%@",[entry valueForKey:@"pk_id"],[entry valueForKey:@"user_id"]];
                
                NSMutableString *urlString = [NSMutableString stringWithString:@"http://keydiscoveryinc.com/agent_bridge/webservice/delete_faxnumber.php"];
                [urlString appendString:parameters];
                
                self.activityIndicator.hidden = NO;
                __block NSError *errorData = nil;
                __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlString]];
                
                [request setCompletionBlock:
                 ^{
                     NSData *responseData = [request responseData];
                     NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&errorData];
                     
                     if ([[json objectForKey:@"status"] integerValue] == YES) {
//                         NSLog(@"successfully delete Fax");
                         self.deleteFaxSuccessful = 2;
                     }
                     else {
//                         NSLog(@"failed to delete Fax");
                         self.deleteFaxSuccessful = 0;
                     }
                     
                     dispatch_async(dispatch_get_main_queue(), ^{
                         [self showSuccessAlert];
                     });
                 }];
                [request setFailedBlock:^{
                    NSError *error = [request error];
                    NSLog(@" error:%@",error);
                }];
                
                [request startAsynchronous];
                
//                self.activityIndicator.hidden = YES;
                
            }
        }
        else {
            self.deleteFaxSuccessful = 2;
        }
        
        
        if (self.arrayRemoveWork != nil) {
            for (NSDictionary *entry in self.arrayRemoveWork) {
                NSString *parameters = [NSString stringWithFormat:@"?id=%@&user_id=%@",[entry valueForKey:@"pk_id"],[entry valueForKey:@"user_id"]];
                
                NSMutableString *urlString = [NSMutableString stringWithString:@"http://keydiscoveryinc.com/agent_bridge/webservice/delete_worknumber.php"];
                [urlString appendString:parameters];
                
                self.activityIndicator.hidden = NO;
                __block NSError *errorData = nil;
                __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlString]];
                
                [request setCompletionBlock:
                 ^{
                     NSData *responseData = [request responseData];
                     NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&errorData];
                     
                     if ([[json objectForKey:@"status"] integerValue] == YES) {
                         NSLog(@"successfully delete Work");
                         self.deleteWorkSuccessful = 2;
                     }
                     else {
                         NSLog(@"failed to delete Work");
                         self.deleteWorkSuccessful = 0;
                     }
                     
                     dispatch_async(dispatch_get_main_queue(), ^{
                         [self showSuccessAlert];
                     });
                 }];
                [request setFailedBlock:^{
                    NSError *error = [request error];
                    NSLog(@" error:%@",error);
                }];
                
                [request startAsynchronous];
                
//                self.activityIndicator.hidden = YES;
                
            }
        }
        else {
            self.deleteWorkSuccessful = 2;
        }
        
        
        
        for (NSDictionary *entry in self.arrayOfMobileNumber) {
            
            if (![[entry valueForKey:@"value"] isEqualToString:@""]) {
                self.saveMobileSuccessful = 1;
                if ([[entry valueForKey:@"pk_id"] isEqualToString:@"null"]) {
                    //insert
                    NSString *parameters = [NSString stringWithFormat:@"?user_id=%@&value_number=%@",[entry valueForKey:@"user_id"],[entry valueForKey:@"value"]];
                    
                    NSMutableString *urlString = [NSMutableString stringWithString:@"http://keydiscoveryinc.com/agent_bridge/webservice/add_mobilenumber.php"];
                    [urlString appendString:parameters];
                    
                    self.activityIndicator.hidden = NO;
                    __block NSError *errorData = nil;
                    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding: NSASCIIStringEncoding]]];
                    
                    [request setCompletionBlock:
                     ^{
                         NSData *responseData = [request responseData];
                         NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&errorData];
                         
                         if ([[json objectForKey:@"status"] integerValue] == YES) {
//                             NSLog(@"successfully add Mobile");
                             self.saveMobileSuccessful = 2;
                         }
                         else {
//                             NSLog(@"failed to add Mobile");
                             self.saveMobileSuccessful = 0;
                         }
                         
                         
                     }];
                    [request setFailedBlock:^{
                        NSError *error = [request error];
                        NSLog(@" error:%@",error);
                    }];
                    
                    [request startAsynchronous];
//                    self.activityIndicator.hidden = YES;
                }
                else {
                    self.saveMobileSuccessful = 2;
//                    //update
//                    NSString *parameters = [NSString stringWithFormat:@"?id=%@&user_id=%@&value_number=%@",[entry valueForKey:@"pk_id"],[entry valueForKey:@"user_id"],[entry valueForKey:@"value"]];
//                    
//                    NSMutableString *urlString = [NSMutableString stringWithString:@"http://keydiscoveryinc.com/agent_bridge/webservice/update_mobilenumber.php"];
//                    [urlString appendString:parameters];
//                    
//                    self.activityIndicator.hidden = NO;
//                    __block NSError *errorData = nil;
//                    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding: NSASCIIStringEncoding]]];
//                    
//                    [request setCompletionBlock:
//                     ^{
//                         NSData *responseData = [request responseData];
//                         NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&errorData];
//                         
//                         if ([[json objectForKey:@"status"] integerValue] == YES) {
//                             NSLog(@"successfully add Mobile");
//                             self.saveMobileSuccessful = YES;
//                         }
//                         else {
//                             NSLog(@"failed to add Mobile");
//                             self.saveMobileSuccessful = NO;
//                         }
//                         
//                     }];
//                    [request setFailedBlock:^{
//                        NSError *error = [request error];
//                        NSLog(@" error:%@",error);
//                    }];
//                    
//                    [request startAsynchronous];
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self showSuccessAlert];
                });
            }
            else {
                self.saveMobileSuccessful = 2;
            }
        }
        
        for (NSDictionary *entry in self.arrayOfFaxNumber) {
            if (![[entry valueForKey:@"value"] isEqualToString:@""]) {
                self.saveFaxSuccessful = 1;
                if ([[entry valueForKey:@"pk_id"] isEqualToString:@"null"]) {
                    //insert
                    NSString *parameters = [NSString stringWithFormat:@"?user_id=%@&value_number=%@",[entry valueForKey:@"user_id"],[entry valueForKey:@"value"]];
                    
                    NSMutableString *urlString = [NSMutableString stringWithString:@"http://keydiscoveryinc.com/agent_bridge/webservice/add_faxnumber.php"];
                    [urlString appendString:parameters];
                    
                    
                    self.activityIndicator.hidden = NO;
                    __block NSError *errorData = nil;
                    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding: NSASCIIStringEncoding]]];
                    
                    [request setCompletionBlock:
                     ^{
                         NSData *responseData = [request responseData];
                         NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&errorData];
                         
                         if ([[json objectForKey:@"status"] integerValue] == YES) {
//                             NSLog(@"successfully add Mobile");
                             self.saveFaxSuccessful = 2;
                         }
                         else {
//                             NSLog(@"failed to add Mobile");
                             self.saveFaxSuccessful = 0;
                         }
                         
                     }];
                    [request setFailedBlock:^{
                        NSError *error = [request error];
                        NSLog(@" error:%@",error);
                    }];
                    
                    [request startAsynchronous];
//                    self.activityIndicator.hidden = YES;
                }
                else {
                    self.saveFaxSuccessful = 2;
                    //update
//                    NSString *parameters = [NSString stringWithFormat:@"?id=%@&user_id=%@&value_number=%@",[entry valueForKey:@"pk_id"],[entry valueForKey:@"user_id"],[entry valueForKey:@"value"]];
//                    
//                    NSMutableString *urlString = [NSMutableString stringWithString:@"http://keydiscoveryinc.com/agent_bridge/webservice/update_faxnumber.php"];
//                    [urlString appendString:parameters];
//                    
//                    self.activityIndicator.hidden = NO;
//                    __block NSError *errorData = nil;
//                    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding: NSASCIIStringEncoding]]];
//                    
//                    [request setCompletionBlock:
//                     ^{
//                         NSData *responseData = [request responseData];
//                         NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&errorData];
//                         
//                         if ([[json objectForKey:@"status"] integerValue] == YES) {
//                             NSLog(@"successfully add Mobile");
//                             self.saveMobileSuccessful = YES;
//                         }
//                         else {
//                             NSLog(@"failed to add Mobile");
//                             self.saveMobileSuccessful = NO;
//                         }
//                         
//                     }];
//                    [request setFailedBlock:^{
//                        NSError *error = [request error];
//                        NSLog(@" error:%@",error);
//                    }];
//                    
//                    [request startAsynchronous];
                }
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self showSuccessAlert];
                });
            }
            else {
                self.saveFaxSuccessful = 2;
            }
            
        }
        
        for (NSDictionary *entry in self.arrayOfWorkNumber) {
            if (![[entry valueForKey:@"value"] isEqualToString:@""]) {
                self.saveWorkSuccessful = 1;
                if ([[entry valueForKey:@"pk_id"] isEqualToString:@"null"]) {
                    //insert
                    NSString *parameters = [NSString stringWithFormat:@"?user_id=%@&value_number=%@",[entry valueForKey:@"user_id"],[entry valueForKey:@"value"]];
                    
                    NSMutableString *urlString = [NSMutableString stringWithString:@"http://keydiscoveryinc.com/agent_bridge/webservice/add_worknumber.php"];
                    [urlString appendString:parameters];
                    
                    self.activityIndicator.hidden = NO;
                    __block NSError *errorData = nil;
                    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding: NSASCIIStringEncoding]]];
                    
                    [request setCompletionBlock:
                     ^{
                         NSData *responseData = [request responseData];
                         NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&errorData];
                         
                         if ([[json objectForKey:@"status"] integerValue] == YES) {
//                             NSLog(@"successfully add Mobile");
                             self.saveWorkSuccessful = 2;
                         }
                         else {
//                             NSLog(@"failed to add Mobile");
                             self.saveWorkSuccessful = 0;
                         }
                         
                         dispatch_async(dispatch_get_main_queue(), ^{
                             [self showSuccessAlert];
                         });
                     }];
                    [request setFailedBlock:^{
                        NSError *error = [request error];
                        NSLog(@" error:%@",error);
                    }];
                    
                    [request startAsynchronous];
//                    self.activityIndicator.hidden = YES;
                }
                else {
                    self.saveWorkSuccessful = 2;
                    //update
//                    NSString *parameters = [NSString stringWithFormat:@"?id=%@&user_id=%@&value_number=%@",[entry valueForKey:@"pk_id"],[entry valueForKey:@"user_id"],[entry valueForKey:@"value"]];
//                    
//                    NSMutableString *urlString = [NSMutableString stringWithString:@"http://keydiscoveryinc.com/agent_bridge/webservice/update_worknumber.php"];
//                    [urlString appendString:parameters];
//                    
//                    self.activityIndicator.hidden = NO;
//                    __block NSError *errorData = nil;
//                    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding: NSASCIIStringEncoding]]];
//                    
//                    [request setCompletionBlock:
//                     ^{
//                         NSData *responseData = [request responseData];
//                         NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&errorData];
//                         
//                         if ([[json objectForKey:@"status"] integerValue] == YES) {
//                             NSLog(@"successfully add Mobile");
//                             self.saveMobileSuccessful = YES;
//                         }
//                         else {
//                             NSLog(@"failed to add Mobile");
//                             self.saveMobileSuccessful = NO;
//                         }
//                         
//                     }];
//                    [request setFailedBlock:^{
//                        NSError *error = [request error];
//                        NSLog(@" error:%@",error);
//                    }];
//                    
//                    [request startAsynchronous];
                }
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self showSuccessAlert];
                });
            }
            else {
                self.saveWorkSuccessful = 2;
            }
            
        }
        
    }
    else {
        
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Update Failed" message:@"Mobile Number is Required." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [av show];
    }
    
}

- (void) showSuccessAlert {
//    NSLog(@"[%i, %i, %i] - [%i, %i, %i]",self.deleteMobileSuccessful, self.deleteFaxSuccessful, self.deleteWorkSuccessful, self.saveMobileSuccessful, self.saveFaxSuccessful, self.saveWorkSuccessful);
    if ((self.deleteMobileSuccessful + self.deleteFaxSuccessful + self.deleteWorkSuccessful + self.saveMobileSuccessful + self.saveFaxSuccessful + self.saveWorkSuccessful) == 12) {
        
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Update Success" message:@"Contact Info Successfully Updated" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [av show];
        self.activityIndicator.hidden = YES;
        
        
        self.arrayOfFaxNumber = nil;
        self.arrayOfWorkNumber = nil;
        self.arrayOfMobileNumber = nil;
        
        self.arrayRemoveFax = nil;
        self.arrayRemoveMobile = nil;
        self.arrayRemoveWork = nil;
        
        [self fetchContactData];
        
    }
    else if ((self.deleteMobileSuccessful + self.deleteFaxSuccessful + self.deleteWorkSuccessful + self.saveMobileSuccessful + self.saveFaxSuccessful + self.saveWorkSuccessful) == 0) {
        
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Update Failed" message:@"Contact Info Update Failed" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [av show];
        self.activityIndicator.hidden = YES;
    }
    else {
        //do nothing
    }
}

- (IBAction)backButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)dismissKeyboard:(id)sender {
    [UIView animateWithDuration:0.2 animations:^{
//        CGRect frame = self.viewContent.frame;
//        frame.origin.y = 52.0f;
//        self.viewContent.frame = frame;
        [self.currentTextField resignFirstResponder];
    } completion:^(BOOL finished) {
        
    }];
    
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
    self.currentTextField = textField;
    NSMutableString *mobileNumber = [NSMutableString stringWithString:textField.text];
    [mobileNumber replaceOccurrencesOfString:@"-" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [mobileNumber length])];
    [mobileNumber replaceOccurrencesOfString:@"(" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [mobileNumber length])];
    [mobileNumber replaceOccurrencesOfString:@")" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [mobileNumber length])];
    [mobileNumber replaceOccurrencesOfString:@" " withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [mobileNumber length])];
    textField.text = mobileNumber;
    
    [UIView animateWithDuration:0.2 animations:^{
//        CGRect frame = self.viewContent.frame;
//        if (textField == self.textFieldMobileNumber) {
//            frame.origin.y = 52.0f;
//        }
//        else if (textField == self.textFieldWorkNumber) {
//            frame.origin.y = -12.0f;
//        }
//        else if (textField == self.textFieldFaxNumber) {
//            frame.origin.y = -82.0f;
//        }
//        self.viewContent.frame = frame;
        
        CGRect frame = self.tableView.frame;
        frame.size.height -= 180.0f;
        self.tableView.frame = frame;
        
    } completion:^(BOOL finished) {
        
        UITableViewCell *cell = (UITableViewCell*)[[textField superview] superview];
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        
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
    
    UITableViewCell *cell = (UITableViewCell*)[[textField superview] superview];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    switch ([indexPath section]) {
        case 0:{
            NSMutableDictionary *entry = [NSMutableDictionary dictionaryWithDictionary:[self.arrayOfMobileNumber objectAtIndex:[indexPath row]]];
            [entry setValue:textField.text forKey:@"value"];
            
            [self.arrayOfMobileNumber replaceObjectAtIndex:[indexPath row] withObject:entry];
            break;
        }
        case 1:{
            NSMutableDictionary *entry = [NSMutableDictionary dictionaryWithDictionary:[self.arrayOfFaxNumber objectAtIndex:[indexPath row]]];
            [entry setValue:textField.text forKey:@"value"];
            
            [self.arrayOfFaxNumber replaceObjectAtIndex:[indexPath row] withObject:entry];
            break;
        }
        case 2:{
            NSMutableDictionary *entry = [NSMutableDictionary dictionaryWithDictionary:[self.arrayOfWorkNumber objectAtIndex:[indexPath row]]];
            [entry setValue:textField.text forKey:@"value"];
            
            [self.arrayOfWorkNumber replaceObjectAtIndex:[indexPath row] withObject:entry];
            break;
        }
        default:
            break;
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        
        CGRect frame = self.tableView.frame;
        frame.size.height += 180.0f;
        self.tableView.frame = frame;
        
    } completion:^(BOOL finished) {
        
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch (section) {
        case 0:
            return [self.arrayOfMobileNumber count];
            break;
            
        case 1:
            return [self.arrayOfFaxNumber count];
            break;
            
        case 2:
            return [self.arrayOfWorkNumber count];
            break;
            
        default:
            return 0;
            break;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, tableView.frame.size.width - 20.0f, 40.0f)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 0.0f, header.frame.size.width-30.0f, 20.0f)];
    label.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
    
    [header addSubview:label];
    
    switch (section) {
        case 0:
            label.text = @"Mobile Numbers";
            break;
            
        case 1:
            label.text = @"Fax Numbers";
            break;
            
        case 2:
            label.text = @"Work Numbers";
            break;
            
        default:
            label.text = @"";
            break;
    }
    
    [label sizeToFit];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeContactAdd];
    button.frame = CGRectMake(label.frame.size.width+25.0f, 0.0f, 20.0f, 20.0f);
    [header addSubview:button];
    
    
    switch (section) {
        case 0:
            self.addButtonMobile = button;
            [self.addButtonMobile addTarget:self action:@selector(addNewMobileNumber) forControlEvents:UIControlEventTouchUpInside];
//            self.addButtonMobile.hidden = NO;
//            if (self.addMobileNumber != 0) {
//                self.addButtonMobile.hidden = YES;
//            }
            break;
            
        case 1:
            self.addButtonFax = button;
            [self.addButtonFax addTarget:self action:@selector(addNewFaxNumber) forControlEvents:UIControlEventTouchUpInside];
//            self.addButtonFax.hidden = NO;
//            if (self.addFaxNumber != 0) {
//                self.addButtonFax.hidden = YES;
//            }
            break;
            
        case 2:
            self.addButtonWork = button;
            [self.addButtonWork addTarget:self action:@selector(addNewWorkNumber) forControlEvents:UIControlEventTouchUpInside];
//            self.addButtonWork.hidden = NO;
//            if (self.addWorkNumber != 0) {
//                self.addButtonWork.hidden = YES;
//            }
            break;
            
        default:
            break;
    }
    
    CGPoint center = label.center;
    center.y = header.frame.size.height/2.0f;
    label.center = center;
    
    center = button.center;
    center.y = header.frame.size.height/2.0f;
    button.center = center;
    
    return header;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(10.0f, 5.0f, 250.0f, 30.0f)];
        
        [self addPaddingAndBorder:textField color:[UIColor colorWithRed:178.0f/255.0f green:178.0f/255.0f blue:178.0f/255.0f alpha:1.0f]];
        
        textField.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
        textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        textField.tag = 1;
        textField.keyboardType = UIKeyboardTypeNumberPad;
        textField.delegate = self;
        textField.placeholder = @"Input Number";
        
        
        
//        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//        
//        [button setImage:[UIImage imageNamed:@"delete-blue.png"] forState:UIControlStateNormal];
        
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeContactAdd];
        
//        button.frame = CGRectMake(textField.frame.origin.x + textField.frame.size.width + 2.0f, 5.0f, 30.0f, 30.0f);
        
        button.frame = CGRectMake(textField.frame.origin.x + textField.frame.size.width + 2.0f, 5.0f, 20.0f, 20.0f);
        
        button.tag = 2;
        [button addTarget:self action:@selector(removeDesignation:) forControlEvents:UIControlEventTouchUpInside];
        
//        button.layer.shadowOpacity = 0.75f;
//        button.layer.shadowRadius = 2.0f;
//        button.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
//        button.layer.shadowColor = [UIColor blackColor].CGColor;
        
        
        button.transform = CGAffineTransformMakeRotation(M_PI_4);
        
        CGPoint center = button.center;
        center.y = cell.contentView.center.y;
        button.center = center;
        
        [cell.contentView addSubview:textField];
        [cell.contentView addSubview:button];
    }
    
    UITextField *textField = (UITextField*)[cell viewWithTag:1];
//    UIButton *button = (UIButton*)[cell viewWithTag:2];
    
    NSUInteger section = [indexPath section];
    NSUInteger row = [indexPath row];
    
    
    switch (section) {
        case 0:{
            textField.text = [[self.arrayOfMobileNumber objectAtIndex:row] valueForKey:@"value"];
            if ([[[self.arrayOfMobileNumber objectAtIndex:row] valueForKey:@"value"] isEqualToString:@""]) {
                textField.enabled = YES;
            }
            else {
                textField.enabled = NO;
            }
            break;
        }
        case 1:{
            textField.text = [[self.arrayOfFaxNumber objectAtIndex:row] valueForKey:@"value"];
            if ([[[self.arrayOfFaxNumber objectAtIndex:row] valueForKey:@"value"] isEqualToString:@""]) {
                textField.enabled = YES;
            }
            else {
                textField.enabled = NO;
            }
            break;
        }
        case 2:{
            textField.text = [[self.arrayOfWorkNumber objectAtIndex:row] valueForKey:@"value"];
            if ([[[self.arrayOfWorkNumber objectAtIndex:row] valueForKey:@"value"] isEqualToString:@""]) {
                textField.enabled = YES;
            }
            else {
                textField.enabled = NO;
            }
            break;
        }
        default:
            return 0;
            break;
    }
    
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
    
}

- (void) addNewMobileNumber {
    
    if (self.arrayOfMobileNumber == nil) {
        self.arrayOfMobileNumber = [[NSMutableArray alloc] init];
    }
    
    NSDictionary *entry = [NSDictionary dictionaryWithObjectsAndKeys: @"null", @"pk_id",self.profile.profile_id, @"user_id", @"", @"value", @"1", @"main", @"1", @"show", nil];
    
    [self.arrayOfMobileNumber addObject:entry];
    
    [self.tableView reloadData];
}

- (void) addNewFaxNumber {
    
    if (self.arrayOfFaxNumber == nil) {
        self.arrayOfFaxNumber = [[NSMutableArray alloc] init];
    }
    
    NSDictionary *entry = [NSDictionary dictionaryWithObjectsAndKeys: @"null", @"pk_id", self.profile.profile_id, @"user_id", @"", @"value", @"1", @"main", @"1", @"show", nil];
    
    [self.arrayOfFaxNumber addObject:entry];
    
    [self.tableView reloadData];
}

- (void) addNewWorkNumber {
    
    if (self.arrayOfWorkNumber == nil) {
        self.arrayOfWorkNumber = [[NSMutableArray alloc] init];
    }
    
    NSDictionary *entry = [NSDictionary dictionaryWithObjectsAndKeys: @"null", @"pk_id", self.profile.profile_id, @"user_id", @"", @"value", @"1", @"main", @"1", @"show", nil];
    
    [self.arrayOfWorkNumber addObject:entry];
    
    [self.tableView reloadData];
}


- (void) removeDesignation:(id)sender {
    UITableViewCell *cell = (UITableViewCell*)[[sender superview] superview];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    [self.tableView beginUpdates];
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    
    
    
    switch ([indexPath section]) {
        case 0:
            if ([[self.arrayOfMobileNumber objectAtIndex:[indexPath row]] valueForKey:@"pk_id"] != nil) {
                
                if (self.arrayRemoveMobile == nil) {
                    self.arrayRemoveMobile = [NSMutableArray array];
                }
                
                [self.arrayRemoveMobile addObject:[self.arrayOfMobileNumber objectAtIndex:[indexPath row]]];
            }
            
            [self.arrayOfMobileNumber removeObjectAtIndex:[indexPath row]];
            break;
            
        case 1:
            
            if ([[self.arrayOfFaxNumber objectAtIndex:[indexPath row]] valueForKey:@"pk_id"] != nil) {
                if (self.arrayRemoveFax == nil) {
                    self.arrayRemoveFax = [NSMutableArray array];
                }
                
                [self.arrayRemoveFax addObject:[self.arrayOfFaxNumber objectAtIndex:[indexPath row]]];
            }
            
            
            [self.arrayOfFaxNumber removeObjectAtIndex:[indexPath row]];
            break;
            
        case 2:
            if ([[self.arrayOfWorkNumber objectAtIndex:[indexPath row]] valueForKey:@"pk_id"] != nil) {
                if (self.arrayRemoveWork == nil) {
                    self.arrayRemoveWork = [NSMutableArray array];
                }
                
                [self.arrayRemoveWork addObject:[self.arrayOfWorkNumber objectAtIndex:[indexPath row]]];
            }
            
            
            [self.arrayOfWorkNumber removeObjectAtIndex:[indexPath row]];
            break;
            
        default:
            break;
    }
    
    [self.tableView endUpdates];
    [self.tableView reloadData];
    
}

@end
