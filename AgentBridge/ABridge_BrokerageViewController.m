//
//  ABridge_BrokerageViewController.m
//  AgentBridge
//
//  Created by host24_iOS Dev on 11/28/13.
//  Copyright (c) 2013 host24_iOS Dev. All rights reserved.
//

#import "ABridge_BrokerageViewController.h"
#import "AgentProfile.h"
#import "ASIHTTPRequest.h"
#import "Brokerage.h"
#import "Designation.h"
#import "ABridge_AppDelegate.h"
#import "ABridge_UILabelInset.h"

@interface ABridge_BrokerageViewController ()
@property (weak, nonatomic) IBOutlet UILabel *aboutMeTitle;
@property (weak, nonatomic) IBOutlet UILabel *brokerageHeader;
@property (weak, nonatomic) IBOutlet UILabel *designationHeader;
@property (weak, nonatomic) IBOutlet MLPAutoCompleteTextField *textFieldBrokerage;
@property (weak, nonatomic) IBOutlet UIButton *buttonSave;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewDesignations;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorMain;
@property (weak, nonatomic) IBOutlet UILabel *labelNoneSpecified;
@property (strong, nonatomic) NSURLConnection *urlConnectionDesignation;
@property (strong, nonatomic) NSMutableData *dataReceived;
@property (strong, nonatomic) NSMutableArray *arrayOfDesignation;
@property (strong, nonatomic) NSMutableArray *arrayOfUserDesignation;
@property (strong, nonatomic) NSMutableArray *arrayOfDesignationAutocomplete;
@property (strong, nonatomic) NSMutableArray *arrayOfBroker;
@property (strong, nonatomic) NSMutableArray *arrayOfBrokerAutocomplete;
@property (strong, nonatomic) NSMutableArray *arrayOfBrokerIDAutocomplete;
@property (strong, nonatomic) NSMutableArray *arrayOfDesignationDetails;
@property (strong, nonatomic) NSMutableArray *arrayOfDesignationToRemove;
@property (strong, nonatomic) NSString *selectedBrokerId;
@property (weak, nonatomic) IBOutlet UILabel *labelBroker;
@property (weak, nonatomic) IBOutlet UIButton *buttonDeleteBroker;
@property (weak, nonatomic) IBOutlet MLPAutoCompleteTextField *textFieldDesignation;
@property (weak, nonatomic) IBOutlet UIView *viewContent;
@property (weak, nonatomic) IBOutlet UITableView *tableViewDesignations;
@property (strong, nonatomic) AgentProfile *profile;
@property (assign, nonatomic) BOOL brokerUpdatedFlag;
@property (assign, nonatomic) BOOL designationDeletedFlag;
@property (assign, nonatomic) BOOL designationAddedFlag;

- (IBAction)saveBrokerage:(id)sender;
- (IBAction)backButton:(id)sender;
- (IBAction)deleteBroker:(id)sender;

@end

@implementation ABridge_BrokerageViewController
@synthesize urlConnectionDesignation;
@synthesize dataReceived;
@synthesize arrayOfDesignation;
@synthesize arrayOfDesignationAutocomplete;

@synthesize arrayOfBroker;
@synthesize arrayOfBrokerAutocomplete;
@synthesize arrayOfBrokerIDAutocomplete;
@synthesize arrayOfDesignationDetails;
@synthesize arrayOfUserDesignation;
@synthesize arrayOfDesignationToRemove;
@synthesize selectedBrokerId;

@synthesize profile;
@synthesize brokerUpdatedFlag;
@synthesize designationDeletedFlag;
@synthesize designationAddedFlag;

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
    self.labelBroker.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
    self.buttonSave.titleLabel.font = FONT_OPENSANS_BOLD(FONT_SIZE_SMALL);
    
    self.textFieldDesignation.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
    self.activityIndicator.hidden = YES;
    self.activityIndicatorMain.hidden = YES;
    
    [self addPaddingAndBorder:self.textFieldBrokerage color:[UIColor colorWithRed:178.0f/255.0f green:178.0f/255.0f blue:178.0f/255.0f alpha:1.0f]];
    
    [self addPaddingAndBorder:self.textFieldDesignation color:[UIColor colorWithRed:178.0f/255.0f green:178.0f/255.0f blue:178.0f/255.0f alpha:1.0f]];
    
    
    self.buttonDeleteBroker.transform = CGAffineTransformMakeRotation(M_PI_4);
    
//    self.buttonDeleteBroker.layer.shadowOpacity = 0.75f;
//    self.buttonDeleteBroker.layer.shadowRadius = 2.0f;
//    self.buttonDeleteBroker.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
//    self.buttonDeleteBroker.layer.shadowColor = [UIColor blackColor].CGColor;
    
    NSMutableString *urlStringBroker = [NSMutableString stringWithString:@"http://keydiscoveryinc.com/agent_bridge/webservice/get_broker_list.php"];
    
    __block NSError *errorDataBroker = nil;
    __block ASIHTTPRequest *requestBroker = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStringBroker]];
    [requestBroker setCompletionBlock:
     ^{
         NSData *responseData = [requestBroker responseData];
         NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&errorDataBroker];
         
         if ([[json objectForKey:@"data"] count]) {
             //                 NSManagedObjectContext *context = ((ABridge_AppDelegate *)[[UIApplication sharedApplication] delegate]).managedObjectContext;
             for(NSDictionary *entry in [json objectForKey:@"data"]){
                 //                     Brokerage *broker = nil;
                 //
                 //                     NSPredicate * predicate = [NSPredicate predicateWithFormat:@"broker_id == %@", [entry objectForKey:@"broker_id"]];
                 //
                 //                     NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
                 //                     [fetchRequest setPredicate:predicate];
                 //                     [fetchRequest setEntity:[NSEntityDescription entityForName:@"Brokerage" inManagedObjectContext:context]];
                 //                     NSError * error = nil;
                 //                     NSArray * result = [context executeFetchRequest:fetchRequest error:&error];
                 //                     if ([result count]) {
                 //                         broker = (Brokerage*)[result firstObject];
                 //                     }
                 //                     else {
                 //                         broker = [NSEntityDescription insertNewObjectForEntityForName: @"Brokerage" inManagedObjectContext: context];
                 //
                 //                         NSError *errorSave = nil;
                 //                         if (![context save:&errorSave]) {
                 //                             NSLog(@"Error on saving RequestNetwork:%@",[errorSave localizedDescription]);
                 //                         }
                 //                     }
                 //
                 //                     [broker setValuesForKeysWithDictionary:entry];
                 
                 if(self.arrayOfBroker == nil) {
                     self.arrayOfBroker = [NSMutableArray array];
                     self.arrayOfBrokerAutocomplete = [NSMutableArray array];
                     self.arrayOfBrokerIDAutocomplete = [NSMutableArray array];
                 }
                 
                 //                     [arrayOfBroker addObject:broker.broker_name];
//                 [self.arrayOfBroker addObject:[entry valueForKey:@"broker_name"]];
                 
                 [self.arrayOfBroker addObject:entry];
             }
             
             // Set a default data source for all instances.  Otherwise, you can specify the data source on individual text fields via the autocompleteDataSource property
             
//             HTAutocompleteManager *manager = [HTAutocompleteManager sharedManager];
//             manager.arrayOfBroker = arrayOfBroker;
//             [HTAutocompleteTextField setDefaultAutocompleteDataSource:manager];
//             
//             self.textFieldBrokerage.autocompleteType = HTAutocompleteTypeBrokerage;
             
             
         }
         
     }];
    [requestBroker setFailedBlock:^{
        NSError *error = [requestBroker error];
        NSLog(@" error:%@",error);
    }];
    
    [requestBroker startAsynchronous];
    
    self.textFieldBrokerage.autoCompleteFontSize = FONT_SIZE_REGULAR;
    self.textFieldBrokerage.autoCompleteRegularFontName = @"OpenSans-Bold";
    self.textFieldBrokerage.autoCompleteBoldFontName = @"OpenSans";
    self.textFieldBrokerage.autoCompleteRowHeight = FONT_SIZE_REGULAR + 10.0f;
    self.textFieldBrokerage.autoCompleteTableAppearsAsKeyboardAccessory = NO;
    self.textFieldBrokerage.autoCompleteTableBackgroundColor = [UIColor whiteColor];
    self.textFieldBrokerage.autoCompleteTableViewHidden = YES;
    
    NSMutableString *urlString = [NSMutableString stringWithString:@"http://keydiscoveryinc.com/agent_bridge/webservice/get_designation_list.php"];
    
    __block NSError *errorData = nil;
    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setCompletionBlock:
     ^{
         NSData *responseData = [request responseData];
         NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&errorData];
         
         if ([[json objectForKey:@"data"] count]) {
             
             for(NSDictionary *entry in [json objectForKey:@"data"]){
                 
                 if(self.arrayOfDesignation == nil) {
                     self.arrayOfDesignation = [NSMutableArray array];
                     self.arrayOfDesignationAutocomplete = [NSMutableArray array];
                     self.arrayOfDesignationDetails = [NSMutableArray array];
                 }
                 
                 
//                 [self.arrayOfDesignation addObject:[entry valueForKey:@"designations"]];
                 [self.arrayOfDesignation addObject:entry];
             }
             
             // Set a default data source for all instances.  Otherwise, you can specify the data source on individual text fields via the autocompleteDataSource property
             
             
         }
         
     }];
    [request setFailedBlock:^{
        NSError *error = [request error];
        NSLog(@" error:%@",error);
    }];
    
    [request startAsynchronous];
    
    self.textFieldDesignation.autoCompleteFontSize = FONT_SIZE_REGULAR;
    self.textFieldDesignation.autoCompleteRegularFontName = @"OpenSans-Bold";
    self.textFieldDesignation.autoCompleteBoldFontName = @"OpenSans";
    self.textFieldDesignation.autoCompleteRowHeight = FONT_SIZE_REGULAR + 10.0f;
    self.textFieldDesignation.autoCompleteTableAppearsAsKeyboardAccessory = NO;
    self.textFieldDesignation.autoCompleteTableBackgroundColor = [UIColor whiteColor];
    self.textFieldDesignation.autoCompleteTableViewHidden = YES;
    
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
    self.profile = (AgentProfile*)[[context executeFetchRequest:fetchRequestProfile error:&errorProfile] firstObject];
    
    
    
    self.textFieldBrokerage.text = @"";
    self.textFieldBrokerage.text = self.profile.broker_name;
    self.labelBroker.text = self.profile.broker_name;
    
//    NSString *urlString = @"http://keydiscoveryinc.com/agent_bridge/webservice/getuser_designations.php";
//    
//    urlString = [NSString stringWithFormat:@"%@?user_id=%@",urlString, loginDetails.user_id];
//    
//    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
//    
//    self.urlConnectionDesignation = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self startImmediately:YES];
//    
//    if (self.urlConnectionDesignation) {
//        self.activityIndicator.hidden = NO;
//        [self.activityIndicator startAnimating];
//        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
//        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
//    }
    
    NSMutableString *urlStringUserDesignation = [NSMutableString stringWithString:@"http://keydiscoveryinc.com/agent_bridge/webservice/getuser_designations.php"];
    [urlStringUserDesignation appendFormat:@"?user_id=%@", loginDetails.user_id];
    
    __block NSError *errorDataUserDesignation = nil;
    __block ASIHTTPRequest *requestUserDesignation = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStringUserDesignation]];
    [requestUserDesignation setCompletionBlock:
     ^{
         NSData *responseData = [requestUserDesignation responseData];
         NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&errorDataUserDesignation];
         
//         NSLog(@"json:%@",json);
         if ([[json objectForKey:@"data"] count]) {
             
             for(NSDictionary *entry in [json objectForKey:@"data"]){
//                 
//                 if(self.arrayOfUserDesignation == nil) {
//                     self.arrayOfUserDesignation = [NSMutableArray array];
//                 }
                 
                 
//                 [self.arrayOfUserDesignation addObject:[entry valueForKey:@"designation_name"]];
                 
//                 [self addDesignationLabel:[entry valueForKey:@"designation_name"]];
                 [self addDesignationLabel:entry];
//                 NSLog(@"name:%@",[entry valueForKey:@"designation_name"]);
             }
             
             // Set a default data source for all instances.  Otherwise, you can specify the data source on individual text fields via the autocompleteDataSource property
             
             
         }
         
         
         if ([self.arrayOfUserDesignation count] == 0) {
             self.labelNoneSpecified.hidden = NO;
             [self.activityIndicator stopAnimating];
             self.activityIndicator.hidden = YES;
         }
         else {
             self.labelNoneSpecified.hidden = YES;
         }
         
     }];
    [requestUserDesignation setFailedBlock:^{
        NSError *error = [requestUserDesignation error];
        NSLog(@" error:%@",error);
    }];
    
    [requestUserDesignation startAsynchronous];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveBrokerage:(id)sender {
    if ([self.labelBroker.text isEqualToString:@""] == NO) {
        
        self.brokerUpdatedFlag = 1;
        self.designationDeletedFlag = 1;
        self.designationAddedFlag = 1;
        
        if(self.selectedBrokerId == nil) {
            
            self.brokerUpdatedFlag = 2;
        }
        else {
            NSString *parameters = [NSString stringWithFormat:@"?profile_id=%@&broker_id=%@",self.profile.profile_id,self.selectedBrokerId];
            
            NSMutableString *urlString = [NSMutableString stringWithString:@"http://keydiscoveryinc.com/agent_bridge/webservice/update_broker.php"];
            [urlString appendString:parameters];
            
            self.activityIndicator.hidden = NO;
            __block NSError *errorData = nil;
            __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlString]];
            //            [self.activityIndicator startAnimating];
            //            self.activityIndicator.hidden = NO;
            [request setCompletionBlock:
             ^{
                 NSData *responseData = [request responseData];
                 NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&errorData];
                 
                 
                 if ([[json objectForKey:@"status"] integerValue] == YES) {
                     
                     self.brokerUpdatedFlag = 2;
                 }
                 else {
                     self.brokerUpdatedFlag = 0;
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
        }
            
        
        
        if (self.arrayOfDesignationToRemove == nil) {
            self.designationDeletedFlag = 2;
        }
        else {
            for (NSDictionary *entry in self.arrayOfDesignationToRemove) {
//                designationDeleted = YES;
                if ([entry objectForKey:@"user_id"] != nil && [entry objectForKey:@"designation_id"] != nil) {
//                    designationDeleted = NO;
                    NSString *parameters = [NSString stringWithFormat:@"?user_id=%@&designation_id=%@",[entry objectForKey:@"user_id"],[entry objectForKey:@"designation_id"]];
                    
                    NSMutableString *urlString = [NSMutableString stringWithString:@"http://keydiscoveryinc.com/agent_bridge/webservice/delete_designation.php"];
                    [urlString appendString:parameters];
                    
                    self.activityIndicator.hidden = NO;
                    __block NSError *errorData = nil;
                    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlString]];
                    //            [self.activityIndicator startAnimating];
                    //            self.activityIndicator.hidden = NO;
                    [request setCompletionBlock:
                     ^{
                         NSData *responseData = [request responseData];
                         NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&errorData];
                         
                         if ([[json objectForKey:@"status"] integerValue] == YES) {
                             
                             self.designationDeletedFlag = 2;
                         }
                         else {
                             self.designationDeletedFlag = 0;
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
                }
                else {
                    
                    self.designationDeletedFlag = 2;
                }
                
            }
        }
        
        
        if (self.arrayOfUserDesignation == nil) {
            self.designationAddedFlag = 2;
        }
        else {
            
            for (NSDictionary *entry in self.arrayOfUserDesignation) {
//                designationAdded = YES;
                if ([entry objectForKey:@"user_id"] == nil) {
//                    designationAdded = NO;
                    NSString *parameters = [NSString stringWithFormat:@"?user_id=%@&designation_id=%@",self.profile.user_id,[entry objectForKey:@"designation_id"]];
                    
                    NSMutableString *urlString = [NSMutableString stringWithString:@"http://keydiscoveryinc.com/agent_bridge/webservice/add_designation.php"];
                    [urlString appendString:parameters];
                    
                    self.activityIndicator.hidden = NO;
                    __block NSError *errorData = nil;
                    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlString]];
                    //            [self.activityIndicator startAnimating];
                    //            self.activityIndicator.hidden = NO;
                    [request setCompletionBlock:
                     ^{
                         NSData *responseData = [request responseData];
                         NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&errorData];
                         
                         if ([[json objectForKey:@"status"] integerValue] == YES) {
                             
                             self.designationAddedFlag = 2;
                         }
                         else {
                             self.designationAddedFlag = 0;
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
                }
                else {
                    
                    self.designationAddedFlag = 2;
                }
                
            }
        }
        
    }
    else {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please input your Broker Name" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [av show];
    }
}

-(void) showSuccessAlert {
    
//    NSLog(@"%i, %i, %i",self.brokerUpdatedFlag, self.designationAddedFlag, self.designationDeletedFlag);
    
    if ((self.brokerUpdatedFlag + self.designationAddedFlag + self.designationDeletedFlag) == 6) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Saved" message:@"Successful in saving Broker and Designation Details" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [av show];
        
        self.activityIndicator.hidden = YES;
        [self.arrayOfDesignationToRemove removeAllObjects];
        self.arrayOfDesignationToRemove = nil;
    }
    else if ((self.brokerUpdatedFlag + self.designationAddedFlag + self.designationDeletedFlag) == 0){
        
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Failed" message:@"Failed in saving Broker and Designation Details" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [av show];
    }
    else {
        //do nothing
    }
}

- (IBAction)backButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)deleteBroker:(id)sender {
    self.labelBroker.hidden = YES;
    self.textFieldBrokerage.hidden = NO;
    self.buttonDeleteBroker.hidden = YES;
}

- (void) addPaddingAndBorder:(UITextField*)textField color:(UIColor*)color {
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 20)];
    textField.leftView = paddingView;
    textField.leftViewMode = UITextFieldViewModeAlways;
    
    textField.layer.borderColor = color.CGColor;
    textField.layer.borderWidth = 1.0f;
}


- (void) addDesignationLabel:(NSDictionary*)entry{//(NSString*)name {
    
    if(self.arrayOfUserDesignation == nil) {
        self.arrayOfUserDesignation = [NSMutableArray array];
    }
    
    [self.arrayOfUserDesignation addObject:entry];
    
//    if ([self.arrayOfUserDesignation count] > 2) {
//        CGRect frame = self.tableViewDesignations.frame;
//        frame.size.height += 30.0f;
//        self.tableViewDesignations.frame = frame;
//        
//        frame = self.buttonSave.frame;
//        frame.origin.y += 30.0f;
//        self.buttonSave.frame = frame;
//    }

    
    if (self.tableViewDesignations.frame.size.height + self.tableViewDesignations.frame.origin.y + 10.0f < self.viewContent.frame.size.height - 140.0f) {
        if (self.tableViewDesignations.contentSize.height > self.tableViewDesignations.frame.size.height) {
            CGRect frame = self.tableViewDesignations.frame;
            frame.size.height = self.tableViewDesignations.contentSize.height;
            self.tableViewDesignations.frame = frame;
            
            frame = self.buttonSave.frame;
            frame.origin.y = self.tableViewDesignations.frame.size.height + self.tableViewDesignations.frame.origin.y + 10.0f;
            self.buttonSave.frame = frame;
            
        }
    }
    
    
    [self.tableViewDesignations reloadData];
}

- (NSArray *)autoCompleteTextField:(MLPAutoCompleteTextField *)textField possibleCompletionsForString:(NSString *)string {
    if (textField == self.textFieldBrokerage) {
        
        [self.arrayOfBrokerAutocomplete removeAllObjects];
        [self.arrayOfBrokerIDAutocomplete removeAllObjects];
        for(NSDictionary *entry in self.arrayOfBroker) {
            NSString *curString = [entry objectForKey:@"broker_name"];
            NSString *currentID = [entry objectForKey:@"broker_id"];
            NSRange substringRangeLowerCase = [[curString lowercaseString] rangeOfString:[string lowercaseString]];
            NSRange substringRangeUpperCase = [[curString uppercaseString] rangeOfString:[string uppercaseString]];
            
            if (substringRangeLowerCase.location == 0 || substringRangeUpperCase.location == 0) {
                [self.arrayOfBrokerAutocomplete addObject:curString];
                [self.arrayOfBrokerIDAutocomplete addObject:currentID];
            }
        }
        
        textField.autoCompleteTableViewHidden = NO;
        
        return self.arrayOfBrokerAutocomplete;
    }
    else {
        [self.arrayOfDesignationAutocomplete removeAllObjects];
        [self.arrayOfDesignationDetails removeAllObjects];
        for(NSDictionary *entry in self.arrayOfDesignation) {
            NSString *curString = [entry objectForKey:@"designations"];
            NSRange substringRangeLowerCase = [[curString lowercaseString] rangeOfString:[string lowercaseString]];
            NSRange substringRangeUpperCase = [[curString uppercaseString] rangeOfString:[string uppercaseString]];
            
            if (substringRangeLowerCase.location == 0 || substringRangeUpperCase.location == 0) {
                if (![self.arrayOfUserDesignation containsObject:entry]) {
                    [self.arrayOfDesignationAutocomplete addObject:curString];
                    [self.arrayOfDesignationDetails addObject:entry];
                }
            }
        }
        
        textField.autoCompleteTableViewHidden = NO;
        return self.arrayOfDesignationAutocomplete;
    }
}

- (void)autoCompleteTextField:(MLPAutoCompleteTextField *)textField didSelectAutoCompleteString:(NSString *)selectedString withAutoCompleteObject:(id<MLPAutoCompletionObject>)selectedObject forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    textField.text = selectedString;
    if (textField == self.textFieldBrokerage) {
        self.labelBroker.text = selectedString;
        self.textFieldBrokerage.hidden = YES;
        self.labelBroker.hidden = NO;
        self.buttonDeleteBroker.hidden = NO;
        
        self.selectedBrokerId = [self.arrayOfBrokerIDAutocomplete objectAtIndex:[indexPath row]];
    }
    else {
        
        self.textFieldDesignation.text = @"";
        [self addDesignationLabel:[self.arrayOfDesignationDetails objectAtIndex:[indexPath row]]];
//        [self.arrayOfUserDesignation addObject:selectedString];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == self.textFieldBrokerage) {
        
        NSString *selectedString = [self.arrayOfBrokerAutocomplete firstObject];
        self.textFieldBrokerage.text = selectedString;
        self.labelBroker.text = selectedString;
        self.textFieldBrokerage.hidden = YES;
        self.labelBroker.hidden = NO;
        self.buttonDeleteBroker.hidden = NO;
        
        self.selectedBrokerId = [self.arrayOfBrokerIDAutocomplete objectAtIndex:0];
        [self.textFieldBrokerage resignFirstResponder];
    }
    else {
        
//        NSString *selectedString = [self.arrayOfDesignationAutocomplete firstObject];
        self.textFieldDesignation.text = @"";
        [self addDesignationLabel:[self.arrayOfDesignationDetails objectAtIndex:0]];
//        [self.arrayOfUserDesignation addObject:selectedString];
        
        [self.textFieldDesignation resignFirstResponder];
    }
    return YES;
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == self.textFieldDesignation) {
        
        [UIView animateWithDuration:0.2 animations:^{
            CGRect frame = self.viewContent.frame;
            frame.origin.y = -37.0f;
            self.viewContent.frame = frame;
        } completion:^(BOOL finished) {
            
        }];
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == self.textFieldDesignation) {
        
        [UIView animateWithDuration:0.2 animations:^{
            CGRect frame = self.viewContent.frame;
            frame.origin.y = 52.0f;
            self.viewContent.frame = frame;
        } completion:^(BOOL finished) {
            
        }];
    }
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.arrayOfUserDesignation count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGSize constraint = CGSizeMake(250.0f - (10.0f * 2) - 50.0f, 20000.0f);
    
    
    NSString *designation_name = [[self.arrayOfUserDesignation objectAtIndex:[indexPath row]] objectForKey:@"designation_name"];
    
    if (designation_name == nil) {
        designation_name = [[self.arrayOfUserDesignation objectAtIndex:[indexPath row]] objectForKey:@"designations"];
    }
    
    CGSize size = [designation_name sizeWithFont:FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR)  constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    
    size.height += FONT_SIZE_REGULAR;
    
    CGFloat height = MAX(size.height, 30.0f);
    
    
    return height + 10.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   NSString *cellIdentifier = @"CellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
        ABridge_UILabelInset *label = [[ABridge_UILabelInset alloc] initWithFrame:CGRectMake(0.0f, 5.0f, 250.0f, 30.0f)];
        
        label.layer.borderColor = [UIColor colorWithRed:178.0f/255.0f green:178.0f/255.0f blue:178.0f/255.0f alpha:1.0f].CGColor;
        label.layer.borderWidth = 1.0f;
        label.backgroundColor = [UIColor colorWithRed:53.0f/255.0f green:156.0f/255.0f blue:206.0f/255.0f alpha:0.7f];
        label.layer.masksToBounds = YES;
        label.layer.cornerRadius = 20.0f;
        
        label.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
        label.lineBreakMode = NSLineBreakByWordWrapping;
        label.numberOfLines = 0;
        label.tag = 1;
        
        
//        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeContactAdd];
        
//        [button setImage:[UIImage imageNamed:@"delete-blue.png"] forState:UIControlStateNormal];
        
//        button.frame = CGRectMake(label.frame.origin.x + label.frame.size.width + 2.0f, 5.0f, 30.0f, 30.0f);
        button.frame = CGRectMake(label.frame.origin.x + label.frame.size.width + 2.0f, 5.0f, 20.0f, 20.0f);
        button.tag = 2;
        
        self.buttonDeleteBroker.transform = CGAffineTransformMakeRotation(M_PI_4);
        
        [button addTarget:self action:@selector(removeDesignation:) forControlEvents:UIControlEventTouchUpInside];
        
//        button.layer.shadowOpacity = 0.75f;
//        button.layer.shadowRadius = 2.0f;
//        button.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
//        button.layer.shadowColor = [UIColor blackColor].CGColor;
        
        CGPoint center = button.center;
        center.y = cell.contentView.center.y;
        button.center = center;
        
        [cell.contentView addSubview:label];
        [cell.contentView addSubview:button];
        
    }
    
    ABridge_UILabelInset *label = (ABridge_UILabelInset*)[cell viewWithTag:1];
    UIButton *button = (UIButton*)[cell viewWithTag:2];
    
    NSString *designation_name = [[self.arrayOfUserDesignation objectAtIndex:[indexPath row]] objectForKey:@"designation_name"];
    if (designation_name == nil) {
        designation_name = [[self.arrayOfUserDesignation objectAtIndex:[indexPath row]] objectForKey:@"designations"];
    }
    
    label.text = designation_name;
    
    CGSize constraint = CGSizeMake(250.0f - (10.0f * 2) - 50.0f, 20000.0f);
    
    CGSize size = [label.text sizeWithFont:FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR)  constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    
    size.height += FONT_SIZE_REGULAR;
    
    CGRect frame = label.frame;
    frame.size.height = MAX(size.height, 30.0f);
    label.frame = frame;
    
    CGPoint center = button.center;
    center.y = label.frame.size.height/2.0f;
    button.center = center;
    
    return cell;
}


//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    [tableView beginUpdates];
//    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
//    [self.arrayOfUserDesignation removeObjectAtIndex:[indexPath row]];
//    [tableView endUpdates];
//    [tableView reloadData];
//}

- (void) removeDesignation:(id)sender {
    UITableViewCell *cell = (UITableViewCell*)[[sender superview] superview];
    NSIndexPath *indexPath = [self.tableViewDesignations indexPathForCell:cell];
    if (self.arrayOfDesignationToRemove == nil) {
        self.arrayOfDesignationToRemove = [NSMutableArray array];
    }
    
    [self.tableViewDesignations beginUpdates];
    [self.tableViewDesignations deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    
    [self.arrayOfDesignationToRemove addObject:[self.arrayOfUserDesignation objectAtIndex:[indexPath row]]];
    
    [self.arrayOfUserDesignation removeObjectAtIndex:[indexPath row]];
    [self.tableViewDesignations endUpdates];
    [self.tableViewDesignations reloadData];

    
    if (self.tableViewDesignations.frame.size.height > 30.0f) {
        if (self.tableViewDesignations.contentSize.height < self.tableViewDesignations.frame.size.height) {
            CGRect frame = self.tableViewDesignations.frame;
            frame.size.height = self.tableViewDesignations.contentSize.height;
            self.tableViewDesignations.frame = frame;
            
            frame = self.buttonSave.frame;
            frame.origin.y = self.tableViewDesignations.frame.size.height + self.tableViewDesignations.frame.origin.y + 10.0f;
            self.buttonSave.frame = frame;
            
            
        }
    }
}

@end
