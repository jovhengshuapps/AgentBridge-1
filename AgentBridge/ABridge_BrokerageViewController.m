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
@property (weak, nonatomic) IBOutlet UILabel *labelBroker;
@property (weak, nonatomic) IBOutlet UIButton *buttonDeleteBroker;
@property (weak, nonatomic) IBOutlet MLPAutoCompleteTextField *textFieldDesignation;
@property (weak, nonatomic) IBOutlet UIView *viewContent;
@property (weak, nonatomic) IBOutlet UITableView *tableViewDesignations;

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
@synthesize arrayOfUserDesignation;

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
                 }
                 
                 //                     [arrayOfBroker addObject:broker.broker_name];
                 [self.arrayOfBroker addObject:[entry valueForKey:@"broker_name"]];
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
                 }
                 
                 
                 [self.arrayOfDesignation addObject:[entry valueForKey:@"designations"]];
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
    AgentProfile *profile = (AgentProfile*)[[context executeFetchRequest:fetchRequestProfile error:&errorProfile] firstObject];
    
    
    
    self.textFieldBrokerage.text = @"";
    self.textFieldBrokerage.text = profile.broker_name;
    self.labelBroker.text = profile.broker_name;
    
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
         
         NSLog(@"json:%@",json);
         if ([[json objectForKey:@"data"] count]) {
             
             for(NSDictionary *entry in [json objectForKey:@"data"]){
//                 
//                 if(self.arrayOfUserDesignation == nil) {
//                     self.arrayOfUserDesignation = [NSMutableArray array];
//                 }
                 
                 
//                 [self.arrayOfUserDesignation addObject:[entry valueForKey:@"designation_name"]];
                 
                 [self addDesignationLabel:[entry valueForKey:@"designation_name"]];
                 NSLog(@"name:%@",[entry valueForKey:@"designation_name"]);
             }
             
             // Set a default data source for all instances.  Otherwise, you can specify the data source on individual text fields via the autocompleteDataSource property
             
             if ([self.arrayOfUserDesignation count] == 0) {
                 self.labelNoneSpecified.hidden = NO;
                 [self.activityIndicator stopAnimating];
                 self.activityIndicator.hidden = YES;
             }
             else {
                 self.labelNoneSpecified.hidden = YES;
             }
             
             
             
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

- (void) addDesignationLabel:(NSString*)name {
    
    if(self.arrayOfUserDesignation == nil) {
        self.arrayOfUserDesignation = [NSMutableArray array];
    }
    
    [self.arrayOfUserDesignation addObject:name];
    
    if ([self.arrayOfUserDesignation count] > 2) {
        CGRect frame = self.tableViewDesignations.frame;
        frame.size.height += 30.0f;
        self.tableViewDesignations.frame = frame;
        
        frame = self.buttonSave.frame;
        frame.origin.y += 30.0f;
        self.buttonSave.frame = frame;
    }

    
    [self.tableViewDesignations reloadData];
    [self.tableViewDesignations setEditing:YES animated:YES];
    
//    CGFloat yOffset = self.scrollViewDesignations.contentSize.height;
//    if ([self.arrayOfUserDesignation count] > 2) {
//        CGRect frame = self.scrollViewDesignations.frame;
//        frame.size.height += 30.0f;
//        self.scrollViewDesignations.frame = frame;
//        
//        frame = self.buttonSave.frame;
//        frame.origin.y += 30.0f;
//        self.buttonSave.frame = frame;
//    }
//
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(35.0f, yOffset + 5.0f, self.scrollViewDesignations.frame.size.width-35.0f, 30.0f)];
//    label.text = name;
//    label.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
//    label.numberOfLines = 0;
//    label.lineBreakMode = NSLineBreakByWordWrapping;
//    [self.scrollViewDesignations addSubview:label];
//    label.tag = yOffset;
//    
//    [label sizeToFit];
//    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.frame = CGRectMake(0.0f, label.frame.origin.y, 30.0f, 30.0f);
//    [button setTitle:@"x" forState:UIControlStateNormal];
//    button.titleLabel.font = FONT_OPENSANS_BOLD(FONT_SIZE_SMALL);
//    button.titleLabel.textColor = [UIColor redColor];
//    [self.scrollViewDesignations addSubview:button];
//    button.tag = yOffset;
//    
//    [button addTarget:self action:@selector(removeDesignationLabel:) forControlEvents:UIControlEventTouchUpInside];
//    
//    [self.scrollViewDesignations setContentSize:CGSizeMake(0.0f, yOffset + label.frame.size.height + 5.0f + 5.0f)];
//    
//    [self.scrollViewDesignations scrollRectToVisible:label.frame animated:YES];
}

- (void) removeDesignationLabel:(id)sender {
    NSInteger tag = [sender tag];
    
    for (int index = 0; index < [[self.scrollViewDesignations subviews] count]; index++) {
        UIView *view = [[self.scrollViewDesignations subviews] objectAtIndex:index];
        if ([view tag] == tag) {
            [view removeFromSuperview];
        }
    }
}

- (NSArray *)autoCompleteTextField:(MLPAutoCompleteTextField *)textField possibleCompletionsForString:(NSString *)string {
    if (textField == self.textFieldBrokerage) {
        
        [self.arrayOfBrokerAutocomplete removeAllObjects];
        for(NSString *curString in self.arrayOfBroker) {
            NSRange substringRangeLowerCase = [[curString lowercaseString] rangeOfString:[string lowercaseString]];
            NSRange substringRangeUpperCase = [[curString uppercaseString] rangeOfString:[string uppercaseString]];
            
            if (substringRangeLowerCase.location == 0 || substringRangeUpperCase.location == 0) {
                [self.arrayOfBrokerAutocomplete addObject:curString];
            }
        }
        
        textField.autoCompleteTableViewHidden = NO;
        
        return self.arrayOfBrokerAutocomplete;
    }
    else {
        [self.arrayOfDesignationAutocomplete removeAllObjects];
        for(NSString *curString in self.arrayOfDesignation) {
            NSRange substringRangeLowerCase = [[curString lowercaseString] rangeOfString:[string lowercaseString]];
            NSRange substringRangeUpperCase = [[curString uppercaseString] rangeOfString:[string uppercaseString]];
            
            if (substringRangeLowerCase.location == 0 || substringRangeUpperCase.location == 0) {
                if (![self.arrayOfUserDesignation containsObject:curString]) {
                    [self.arrayOfDesignationAutocomplete addObject:curString];
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
    }
    else {
        self.textFieldDesignation.text = @"";
        [self addDesignationLabel:selectedString];
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
        
        [self.textFieldBrokerage resignFirstResponder];
    }
    else {
        
        NSString *selectedString = [self.arrayOfDesignationAutocomplete firstObject];
        self.textFieldDesignation.text = @"";
        [self addDesignationLabel:selectedString];
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
    CGSize constraint = CGSizeMake(self.tableViewDesignations.frame.size.width - (10.0f * 2), 20000.0f);
    
    CGSize size = [[self.arrayOfUserDesignation objectAtIndex:[indexPath row]] sizeWithFont:FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR)  constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    
    size.height += FONT_SIZE_REGULAR;
    
    CGFloat height = MAX(size.height, 44.0f);
    
    
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   NSString *cellIdentifier = @"CellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = [self.arrayOfUserDesignation objectAtIndex:[indexPath row]];
    cell.textLabel.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.numberOfLines = 0;
    
    CGSize constraint = CGSizeMake(self.tableViewDesignations.frame.size.width - (10.0f * 2) - 50.0f, 20000.0f);
    
    CGSize size = [cell.detailTextLabel.text sizeWithFont:FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR)  constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    
    size.height += FONT_SIZE_REGULAR;
    
    CGRect frame = cell.textLabel.frame;
    frame.size.height = MAX(size.height, 44.0f);
    cell.textLabel.frame = frame;
    
    return cell;
}

- (UITableViewCellEditingStyle) tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView beginUpdates];
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    [self.arrayOfUserDesignation removeObjectAtIndex:[indexPath row]];
    [tableView endUpdates];
    [tableView reloadData];
}

@end
