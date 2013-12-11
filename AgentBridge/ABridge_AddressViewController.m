//
//  ABridge_AddressViewController.m
//  AgentBridge
//
//  Created by host24_iOS Dev on 11/28/13.
//  Copyright (c) 2013 host24_iOS Dev. All rights reserved.
//

#import "ABridge_AddressViewController.h"
#import "AgentProfile.h"
#import "State.h"
#import "Country.h"
#import "HTTPURLConnection.h"

@interface ABridge_AddressViewController ()
@property (weak, nonatomic) IBOutlet UILabel *aboutMeTitle;
@property (weak, nonatomic) IBOutlet UILabel *addressHeader;
@property (weak, nonatomic) IBOutlet UITextField *textFieldAddress1;
@property (weak, nonatomic) IBOutlet UITextField *textFieldAddress2;
@property (weak, nonatomic) IBOutlet UITextField *textFieldZipCode;
@property (weak, nonatomic) IBOutlet UITextField *textFieldCity;
@property (weak, nonatomic) IBOutlet UIButton *buttonCountry;
@property (weak, nonatomic) IBOutlet UIButton *buttonState;
@property (weak, nonatomic) IBOutlet UIButton *buttonSave;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerState;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerCountry;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorState;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorCountry;
@property (weak, nonatomic) IBOutlet UIView *viewPickerCountry;
@property (weak, nonatomic) IBOutlet UIView *viewPickerState;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
- (IBAction)saveAddress:(id)sender;
- (IBAction)backButton:(id)sender;
- (IBAction)selectState:(id)sender;
- (IBAction)selectCountry:(id)sender;

@property (strong, nonatomic) NSString *state_code;
@property (strong, nonatomic) NSString *country_code_3;
@property (strong, nonatomic) HTTPURLConnection *urlConnectionState;
@property (strong, nonatomic) HTTPURLConnection *urlConnectionCountry;
//@property (strong, nonatomic) NSMutableData *dataReceivedState;
//@property (strong, nonatomic) NSMutableData *dataReceivedCountry;
@property (strong, nonatomic) NSMutableArray *arrayOfState;
@property (strong, nonatomic) NSMutableArray *arrayOfCountry;
@property (strong, nonatomic) NSMutableArray *arrayOfCountry_ID;
//@property (strong, nonatomic) UIActionSheet *actionSheetState;
//@property (strong, nonatomic) UIActionSheet *actionSheetCountry;
@end

@implementation ABridge_AddressViewController
@synthesize state_code;
@synthesize country_code_3;
@synthesize urlConnectionState;
@synthesize urlConnectionCountry;
//@synthesize dataReceivedState;
//@synthesize dataReceivedCountry;
@synthesize arrayOfState;
@synthesize arrayOfCountry;
@synthesize arrayOfCountry_ID;
//@synthesize actionSheetCountry;
//@synthesize actionSheetState;

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
    self.addressHeader.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
    self.textFieldAddress1.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
    self.textFieldAddress2.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
    self.textFieldZipCode.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
    self.textFieldCity.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
    self.buttonSave.titleLabel.font = FONT_OPENSANS_BOLD(FONT_SIZE_SMALL);
    self.buttonState.titleLabel.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
    self.buttonCountry.titleLabel.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
    
    self.activityIndicator.hidden = YES;
    
    [self addPaddingAndBorder:self.textFieldAddress1 color:[UIColor colorWithRed:178.0f/255.0f green:178.0f/255.0f blue:178.0f/255.0f alpha:1.0f]];
    
    [self addPaddingAndBorder:self.textFieldAddress2 color:[UIColor colorWithRed:178.0f/255.0f green:178.0f/255.0f blue:178.0f/255.0f alpha:1.0f]];
    
    [self addPaddingAndBorder:self.textFieldZipCode color:[UIColor colorWithRed:178.0f/255.0f green:178.0f/255.0f blue:178.0f/255.0f alpha:1.0f]];
    
    [self addPaddingAndBorder:self.textFieldCity color:[UIColor colorWithRed:178.0f/255.0f green:178.0f/255.0f blue:178.0f/255.0f alpha:1.0f]];
    
    self.buttonState.layer.borderColor = [UIColor colorWithRed:178.0f/255.0f green:178.0f/255.0f blue:178.0f/255.0f alpha:1.0f].CGColor;
    self.buttonState.layer.borderWidth = 1.0f;
    
    self.buttonCountry.layer.borderColor = [UIColor colorWithRed:178.0f/255.0f green:178.0f/255.0f blue:178.0f/255.0f alpha:1.0f].CGColor;
    self.buttonCountry.layer.borderWidth = 1.0f;
    
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
    
    self.textFieldAddress1.text = @"";
    self.textFieldAddress1.text = profile.street_address;
    
    self.textFieldAddress2.text = @"";
    self.textFieldAddress2.text = profile.suburb;
    
    self.textFieldCity.text = @"";
    self.textFieldCity.text = profile.city;
    
    self.textFieldZipCode.text = @"";
    self.textFieldZipCode.text = profile.zip;
    
    [self.buttonState setTitle:profile.state_name forState:UIControlStateNormal];
    [self.buttonCountry setTitle:profile.countries_name forState:UIControlStateNormal];
    
    //get Countries
    self.buttonCountry.enabled = NO;
    self.buttonCountry.backgroundColor = [UIColor lightGrayColor];
    self.activityIndicatorCountry.hidden = NO;
    NSString *urlString = @"http://keydiscoveryinc.com/agent_bridge/webservice/getdb_country.php";
    
//    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
//    
//    self.urlConnectionCountry = [[HTTPURLConnection alloc] initWithRequest:urlRequest delegate:self startImmediately:YES];
    
//    self.actionSheetCountry = [[UIActionSheet alloc] initWithTitle:@"Country" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:nil];
    
    
    __block NSError *errorData = nil;
    __block ASIHTTPRequest *requestCountry = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlString]];
    [requestCountry setCompletionBlock:^{
        // Use when fetching text data
        //                        NSString *responseString = [request responseString];
        // Use when fetching binary data
        NSData *responseData = [requestCountry responseData];
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&errorData];
        
        if (self.arrayOfCountry == nil) {
            self.arrayOfCountry = [[NSMutableArray alloc] init];
        }
        
        for (NSDictionary *entry in [json objectForKey:@"data"]) {
            [self.self.arrayOfCountry addObject:[entry objectForKey:@"countries_name"]];
        }
        
        
        if (self.arrayOfCountry_ID == nil) {
            self.arrayOfCountry_ID = [[NSMutableArray alloc] init];
        }
        
        for (NSDictionary *entry in [json objectForKey:@"data"]) {
            [self.self.arrayOfCountry_ID addObject:[entry objectForKey:@"countries_id"]];
        }
        
//        NSManagedObjectContext *context = ((ABridge_AppDelegate *)[[UIApplication sharedApplication] delegate]).managedObjectContext;
//        for (NSDictionary *entry in [json objectForKey:@"data"]) {
//            Country *country = nil;
//            
//            NSPredicate * predicate = [NSPredicate predicateWithFormat:@"countries_id == %@", [entry objectForKey:@"countries_id"]];
//            NSArray *result = [self fetchObjectsWithEntityName:@"Country" andPredicate:predicate];
//            if ([result count]) {
//                country = (Country*)[result firstObject];
//            }
//            else {
//                country = [NSEntityDescription insertNewObjectForEntityForName: @"Country" inManagedObjectContext: context];
//            }
//            
//            [country setValuesForKeysWithDictionary:entry];
//            
//            NSError *error = nil;
//            if (![context save:&error]) {
//                NSLog(@"Error on saving Property:%@",[error localizedDescription]);
//            }
//            else {
//                if (self.arrayOfCountry == nil) {
//                    self.arrayOfCountry = [[NSMutableArray alloc] init];
//                }
//                
//                [self.arrayOfCountry addObject:country.countries_name];
//                if (self.arrayOfCountry_ID == nil) {
//                    self.arrayOfCountry_ID = [[NSMutableArray alloc] init];
//                }
//                
//                [self.arrayOfCountry_ID addObject:country.countries_id];
//            }
//        }

        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.buttonCountry.enabled = YES;
            self.buttonCountry.backgroundColor = [UIColor whiteColor];
            self.activityIndicatorCountry.hidden = YES;
            
            [self.pickerCountry reloadAllComponents];
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
            
        });
        
    }];
    [requestCountry setFailedBlock:^{
        NSError *error = [requestCountry error];
        NSLog(@"error:%@",error);
        
    }];
    [requestCountry startAsynchronous];
    
    //get States
    self.buttonState.enabled = NO;
    self.buttonState.backgroundColor = [UIColor lightGrayColor];
    self.activityIndicatorState.hidden = NO;
    urlString = @"http://keydiscoveryinc.com/agent_bridge/webservice/getdb_state.php";
    
//    urlRequest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
//    
//    self.urlConnectionState = [[HTTPURLConnection alloc] initWithRequest:urlRequest delegate:self startImmediately:YES];
    
//    self.actionSheetState = [[UIActionSheet alloc] initWithTitle:@"State" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:nil];
    
    __block ASIHTTPRequest *requestState = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlString]];
    [requestState setCompletionBlock:^{
        // Use when fetching text data
        //                        NSString *responseString = [request responseString];
        // Use when fetching binary data
        NSData *responseData = [requestState responseData];
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&errorData];
        
        if (self.arrayOfState == nil) {
            self.arrayOfState = [[NSMutableArray alloc] init];
        }
        
        for (NSDictionary *entry in [json objectForKey:@"data"]) {
            [self.self.arrayOfState addObject:[entry objectForKey:@"zone_name"]];
        }
        
//        NSManagedObjectContext *context = ((ABridge_AppDelegate *)[[UIApplication sharedApplication] delegate]).managedObjectContext;
//        for (NSDictionary *entry in [json objectForKey:@"data"]) {
//            State *state = nil;
//            
//            NSPredicate * predicate = [NSPredicate predicateWithFormat:@"zone_id == %@", [entry objectForKey:@"zone_id"]];
//            NSArray *result = [self fetchObjectsWithEntityName:@"State" andPredicate:predicate];
//            if ([result count]) {
//                state = (State*)[result firstObject];
//            }
//            else {
//                state = [NSEntityDescription insertNewObjectForEntityForName: @"State" inManagedObjectContext: context];
//            }
//            
//            [state setValuesForKeysWithDictionary:entry];
//            
//            NSError *error = nil;
//            if (![context save:&error]) {
//                NSLog(@"Error on saving Property:%@",[error localizedDescription]);
//            }
//            else {
//                if (self.arrayOfState == nil) {
//                    self.arrayOfState = [[NSMutableArray alloc] init];
//                }
//                
//                [self.arrayOfState addObject:state.zone_name];
//            }
//        }

        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.buttonState.enabled = YES;
            self.buttonState.backgroundColor = [UIColor whiteColor];
            self.activityIndicatorState.hidden = YES;
            
            [self.pickerState reloadAllComponents];
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
        });
        
    }];
    [requestState setFailedBlock:^{
        NSError *error = [requestState error];
        NSLog(@"error:%@",error);
        
    }];
    [requestState startAsynchronous];
    
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveAddress:(id)sender {
}

- (IBAction)backButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)selectState:(id)sender {
//    [self.actionSheetState showFromRect:CGRectMake(0.0f, 200.0f, 320.0f, 150.0f) inView:self.view animated:YES];
    self.viewPickerState.hidden = NO;
}

- (IBAction)selectCountry:(id)sender {
//    [self.actionSheetCountry showFromRect:CGRectMake(0.0f, 200.0f, 320.0f, 150.0f) inView:self.view animated:YES];
    self.viewPickerCountry.hidden = NO;
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
    if (connection == self.urlConnectionState) {
        
        self.arrayOfState = nil;
        
        self.urlConnectionState.response = (NSHTTPURLResponse*)response;
        self.urlConnectionState.responseData = [[NSMutableData alloc] init];
    }
    else if (connection == self.urlConnectionCountry) {
        
        self.arrayOfCountry = nil;
        self.arrayOfCountry_ID = nil;
        
        self.urlConnectionCountry.response = (NSHTTPURLResponse*)response;
        self.urlConnectionCountry.responseData = [[NSMutableData alloc] init];
    }
    
}
- (void)connection:(NSURLConnection*)connection didReceiveData:(NSData*)data
{
    //NSLog(@"Did Receive Data %@", data);
    if (connection == self.urlConnectionState) {
        
        [self.urlConnectionState.responseData appendData:data];
        
    }
    else if (connection == self.urlConnectionCountry) {
        
        [self.urlConnectionCountry.responseData appendData:data];
    }
}
- (void)connection:(NSURLConnection*)connection didFailWithError:(NSError*)error
{
    //    NSLog(@"Did Fail");
    
//    [self.activityIndicator stopAnimating];
//    self.activityIndicator.hidden = YES;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Internet Connection" message:@"You have no Internet Connection available." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    if (connection == self.urlConnectionState) {
        NSError *error = nil;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:self.urlConnectionState.responseData options:NSJSONReadingAllowFragments error:&error];
        
//        NSLog(@"Did Finish:%@", json);
        
        if ([[json objectForKey:@"data"] count]) {
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
//                NSManagedObjectContext *context = ((ABridge_AppDelegate *)[[UIApplication sharedApplication] delegate]).managedObjectContext;
//                for (NSDictionary *entry in [json objectForKey:@"data"]) {
//                    State *state = nil;
//                    
//                    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"zone_id == %@", [entry objectForKey:@"zone_id"]];
//                    NSArray *result = [self fetchObjectsWithEntityName:@"State" andPredicate:predicate];
//                    if ([result count]) {
//                        state = (State*)[result firstObject];
//                    }
//                    else {
//                        state = [NSEntityDescription insertNewObjectForEntityForName: @"State" inManagedObjectContext: context];
//                    }
//                    
//                    [state setValuesForKeysWithDictionary:entry];
//                    
//                    NSError *error = nil;
//                    if (![context save:&error]) {
//                        NSLog(@"Error on saving Property:%@",[error localizedDescription]);
//                    }
//                    else {
//                        if (self.arrayOfState == nil) {
//                            self.arrayOfState = [[NSMutableArray alloc] init];
//                        }
//
//                        [self.arrayOfState addObject:state.zone_name];
//                    }
//                }
                
                if (self.arrayOfState == nil) {
                    self.arrayOfState = [[NSMutableArray alloc] init];
                }

                for (NSDictionary *entry in [json objectForKey:@"data"]) {
                    [self.self.arrayOfState addObject:[entry objectForKey:@"zone_name"]];
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.buttonState.enabled = YES;
                    self.buttonState.backgroundColor = [UIColor whiteColor];
                    self.activityIndicatorState.hidden = YES;
                    
//                    for (NSString *state_name in self.arrayOfState) {
//                        [self.actionSheetState addButtonWithTitle:state_name];
//                    }
                    
                    [self.pickerState reloadAllComponents];
                    
                    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
                });
                
            });
        }
    }
    else if (connection == self.urlConnectionCountry) {
        
        NSError *error = nil;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:self.urlConnectionCountry.responseData options:NSJSONReadingAllowFragments error:&error];
        
//        NSLog(@"Did Finish:%@", json);
        
        if ([[json objectForKey:@"data"] count]) {
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
//                NSManagedObjectContext *context = ((ABridge_AppDelegate *)[[UIApplication sharedApplication] delegate]).managedObjectContext;
//                for (NSDictionary *entry in [json objectForKey:@"data"]) {
//                    Country *country = nil;
//                    
//                    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"countries_id == %@", [entry objectForKey:@"countries_id"]];
//                    NSArray *result = [self fetchObjectsWithEntityName:@"Country" andPredicate:predicate];
//                    if ([result count]) {
//                        country = (Country*)[result firstObject];
//                    }
//                    else {
//                        country = [NSEntityDescription insertNewObjectForEntityForName: @"Country" inManagedObjectContext: context];
//                    }
//                    
//                    [country setValuesForKeysWithDictionary:entry];
//                    
//                    NSError *error = nil;
//                    if (![context save:&error]) {
//                        NSLog(@"Error on saving Property:%@",[error localizedDescription]);
//                    }
//                    else {
//                        if (self.arrayOfCountry == nil) {
//                            self.arrayOfCountry = [[NSMutableArray alloc] init];
//                        }
//
//                        [self.arrayOfCountry addObject:country.countries_name];
//                        if (self.arrayOfCountry_ID == nil) {
//                            self.arrayOfCountry_ID = [[NSMutableArray alloc] init];
//                        }
//
//                        [self.arrayOfCountry_ID addObject:country.countries_id];
//                    }
//                }
                
                if (self.arrayOfCountry == nil) {
                    self.arrayOfCountry = [[NSMutableArray alloc] init];
                }

                for (NSDictionary *entry in [json objectForKey:@"data"]) {
                    [self.self.arrayOfCountry addObject:[entry objectForKey:@"countries_name"]];
                }
                
                
                if (self.arrayOfCountry_ID == nil) {
                    self.arrayOfCountry_ID = [[NSMutableArray alloc] init];
                }

                for (NSDictionary *entry in [json objectForKey:@"data"]) {
                    [self.self.arrayOfCountry_ID addObject:[entry objectForKey:@"countries_id"]];
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.buttonCountry.enabled = YES;
                    self.buttonCountry.backgroundColor = [UIColor whiteColor];
                    self.activityIndicatorCountry.hidden = YES;
                    
                    
//                    for (NSString *country_name in self.arrayOfCountry) {
//                        [self.actionSheetCountry addButtonWithTitle:country_name];
//                    }
                    
                    [self.pickerCountry reloadAllComponents];
                    
                    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
                    
                });
            });
        }
    }
}


//- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
//    
//}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (pickerView == self.pickerCountry) {
        return [self.arrayOfCountry count];
    }
    else if (pickerView == self.pickerState) {
        return [self.arrayOfState count];
    }
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (pickerView == self.pickerCountry) {
        return [self.arrayOfCountry objectAtIndex:row];
    }
    else if (pickerView == self.pickerState) {
        return [self.arrayOfState objectAtIndex:row];
    }
    return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (pickerView == self.pickerCountry) {
        [self.buttonCountry setTitle:[self.arrayOfCountry objectAtIndex:row] forState:UIControlStateNormal];
        [self reloadStateValues:[self.arrayOfCountry_ID objectAtIndex:row]];
        self.viewPickerCountry.hidden = YES;
    }
    else if (pickerView == self.pickerState) {
        [self.buttonState setTitle:[self.arrayOfState objectAtIndex:row] forState:UIControlStateNormal];
        self.viewPickerState.hidden = YES;
    }
}

- (void)reloadStateValues:(NSString*)country_id {
    
    self.activityIndicatorState.hidden = NO;
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"zone_country_id == %@", country_id];
    NSArray *result = [self fetchObjectsWithEntityName:@"State" andPredicate:predicate];
    
    [self.arrayOfState removeAllObjects];
    
    for (State *state in result) {
        [self.arrayOfState addObject:state.zone_name];
    }
    
    [self.buttonState setTitle:[self.arrayOfState firstObject] forState:UIControlStateNormal];
    
    if ([self.arrayOfState count] == 0) {
        self.buttonState.enabled = NO;
        self.buttonState.backgroundColor = [UIColor lightGrayColor];
    }
    else {
        self.buttonState.enabled = YES;
        self.buttonState.backgroundColor = [UIColor whiteColor];
    }
    
    [self.pickerState reloadAllComponents];
    self.activityIndicatorState.hidden = YES;
}


@end
