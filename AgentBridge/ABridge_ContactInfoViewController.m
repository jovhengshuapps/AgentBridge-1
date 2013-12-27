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
#import "ContactInfoNumber.h"

@interface ABridge_ContactInfoViewController ()
@property (weak, nonatomic) IBOutlet UIView *viewContent;
@property (weak, nonatomic) IBOutlet UIButton *buttonSave;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbarAccessory;
@property (strong, nonatomic) NSMutableArray *arrayOfMobileNumber;
@property (strong, nonatomic) NSMutableArray *arrayOfFaxNumber;
@property (strong, nonatomic) NSMutableArray *arrayOfWorkNumber;
@property (strong, nonatomic) LoginDetails *loginDetails;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UITextField *currentTextField;
@property (assign, nonatomic) NSInteger addMobileNumber;
@property (assign, nonatomic) NSInteger addFaxNumber;
@property (assign, nonatomic) NSInteger addWorkNumber;
@property (strong, nonatomic) UIButton *addButtonMobile;
@property (strong, nonatomic) UIButton *addButtonFax;
@property (strong, nonatomic) UIButton *addButtonWork;
- (IBAction)saveContacts:(id)sender;
- (IBAction)dismissKeyboard:(id)sender;

@end

@implementation ABridge_ContactInfoViewController
@synthesize arrayOfMobileNumber;
@synthesize arrayOfFaxNumber;
@synthesize arrayOfWorkNumber;
@synthesize loginDetails;
@synthesize currentTextField;
@synthesize addFaxNumber;
@synthesize addMobileNumber;
@synthesize addWorkNumber;
@synthesize addButtonFax;
@synthesize addButtonMobile;
@synthesize addButtonWork;

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
    AgentProfile *profile = (AgentProfile*)[[context executeFetchRequest:fetchRequestProfile error:&errorProfile] firstObject];
    
    
    NSString *parameters = [NSString stringWithFormat:@"?profile_id=%@",profile.profile_id];
    
    NSMutableString *urlString = [NSMutableString stringWithString:@"http://keydiscoveryinc.com/agent_bridge/webservice/get_mobilenumber.php"];
    [urlString appendString:parameters];
    
    self.activityIndicator.hidden = NO;
    __block NSError *errorData = nil;
    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    [request setCompletionBlock:
     ^{
         NSData *responseData = [request responseData];
         NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&errorData];
         
         NSLog(@"urlString:%@",urlString);
         if ([[json objectForKey:@"data"] count]) {
//             NSMutableString *numbers = [NSMutableString stringWithString:@""];
             NSManagedObjectContext *context = ((ABridge_AppDelegate *)[[UIApplication sharedApplication] delegate]).managedObjectContext;
             for (NSDictionary *entry in [json objectForKey:@"data"]) {
                 ContactInfoNumber *contactInfo = nil;
                 
                 NSPredicate * predicate = [NSPredicate predicateWithFormat:@"pk_id == %@", [entry objectForKey:@"pk_id"]];
                 NSArray *result = [self fetchObjectsWithEntityName:@"ContactInfoNumber" andPredicate:predicate];
                 if ([result count]) {
                     contactInfo = (ContactInfoNumber*)[result firstObject];
                 }
                 else {
                     contactInfo = [NSEntityDescription insertNewObjectForEntityForName: @"ContactInfoNumber" inManagedObjectContext: context];
                 }
                 
                 [contactInfo setValuesForKeysWithDictionary:entry];
                 
                 
                 NSError *error = nil;
                 if (![context save:&error]) {
                     NSLog(@"Error on saving Buyer:%@",[error localizedDescription]);
                 }
                 else {
                     if (self.arrayOfMobileNumber == nil) {
                         self.arrayOfMobileNumber = [[NSMutableArray alloc] init];
                     }
                     
                     [self.arrayOfMobileNumber addObject:contactInfo];
                 }
                 
                 [self.tableView reloadData];
//                 [numbers appendString:[entry valueForKey:@"value"]];
//                 if (![entry isEqualToDictionary:[[json objectForKey:@"data"] lastObject]]) {
//                     [numbers appendString:@","];
//                 }
             }
             
         }
         else {
             
         }
         
         self.activityIndicator.hidden = YES;
         
     }];
    [request setFailedBlock:^{
        NSError *error = [request error];
        NSLog(@" error:%@",error);
    }];
    
    [request startAsynchronous];
    
    parameters = @"";
    [urlString setString: @""];
    
    parameters = [NSString stringWithFormat:@"?profile_id=%@",profile.profile_id];
    
    urlString = [NSMutableString stringWithString:@"http://keydiscoveryinc.com/agent_bridge/webservice/get_faxnumber.php"];
    [urlString appendString:parameters];
    
    NSLog(@"urlString:%@",urlString);
    self.activityIndicator.hidden = NO;
    __block NSError *errorDataFax = nil;
    __block ASIHTTPRequest *requestFax = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    [requestFax setCompletionBlock:
     ^{
         NSData *responseData = [requestFax responseData];
         NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&errorDataFax];
         
         if ([[json objectForKey:@"data"] count]) {
             NSMutableString *numbers = [NSMutableString stringWithString:@""];
             NSManagedObjectContext *context = ((ABridge_AppDelegate *)[[UIApplication sharedApplication] delegate]).managedObjectContext;
             for (NSDictionary *entry in [json objectForKey:@"data"]) {
                 ContactInfoNumber *contactInfo = nil;
                 
                 NSPredicate * predicate = [NSPredicate predicateWithFormat:@"pk_id == %@", [entry objectForKey:@"pk_id"]];
                 NSArray *result = [self fetchObjectsWithEntityName:@"ContactInfoNumber" andPredicate:predicate];
                 if ([result count]) {
                     contactInfo = (ContactInfoNumber*)[result firstObject];
                 }
                 else {
                     contactInfo = [NSEntityDescription insertNewObjectForEntityForName: @"ContactInfoNumber" inManagedObjectContext: context];
                 }
                 
                 [contactInfo setValuesForKeysWithDictionary:entry];
                 
                 
                 NSError *error = nil;
                 if (![context save:&error]) {
                     NSLog(@"Error on saving Buyer:%@",[error localizedDescription]);
                 }
                 else {
                     if (self.arrayOfFaxNumber == nil) {
                         self.arrayOfFaxNumber = [[NSMutableArray alloc] init];
                     }
                     
                     [self.arrayOfFaxNumber addObject:contactInfo];
                 }
                 
                 [self.tableView reloadData];
//                 [numbers appendString:[entry valueForKey:@"value"]];
//                 if (![entry isEqualToDictionary:[[json objectForKey:@"data"] lastObject]]) {
//                     [numbers appendString:@","];
//                 }
             }
             
         }
         else {
             
         }
         
         self.activityIndicator.hidden = YES;
         
     }];
    [requestFax setFailedBlock:^{
        NSError *error = [requestFax error];
        NSLog(@" error:%@",error);
    }];
    
    [requestFax startAsynchronous];
    
    parameters = @"";
    [urlString setString: @""];
    
    parameters = [NSString stringWithFormat:@"?profile_id=%@",profile.profile_id];
    
    urlString = [NSMutableString stringWithString:@"http://keydiscoveryinc.com/agent_bridge/webservice/get_worknumber.php"];
    [urlString appendString:parameters];
    
    NSLog(@"urlString:%@",urlString);
    self.activityIndicator.hidden = NO;
    __block NSError *errorDataWork = nil;
    __block ASIHTTPRequest *requestWork = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    [requestWork setCompletionBlock:
     ^{
         NSData *responseData = [requestWork responseData];
         NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&errorDataWork];
         
         if ([[json objectForKey:@"data"] count]) {
             NSMutableString *numbers = [NSMutableString stringWithString:@""];
             NSManagedObjectContext *context = ((ABridge_AppDelegate *)[[UIApplication sharedApplication] delegate]).managedObjectContext;
             for (NSDictionary *entry in [json objectForKey:@"data"]) {
                 ContactInfoNumber *contactInfo = nil;
                 
                 NSPredicate * predicate = [NSPredicate predicateWithFormat:@"pk_id == %@", [entry objectForKey:@"pk_id"]];
                 NSArray *result = [self fetchObjectsWithEntityName:@"ContactInfoNumber" andPredicate:predicate];
                 if ([result count]) {
                     contactInfo = (ContactInfoNumber*)[result firstObject];
                 }
                 else {
                     contactInfo = [NSEntityDescription insertNewObjectForEntityForName: @"ContactInfoNumber" inManagedObjectContext: context];
                 }
                 
                 [contactInfo setValuesForKeysWithDictionary:entry];
                 
                 
                 NSError *error = nil;
                 if (![context save:&error]) {
                     NSLog(@"Error on saving Buyer:%@",[error localizedDescription]);
                 }
                 else {
                     if (self.arrayOfWorkNumber == nil) {
                         self.arrayOfWorkNumber = [[NSMutableArray alloc] init];
                     }
                     
                     [self.arrayOfWorkNumber addObject:contactInfo];
                 }
                 
//                 [numbers appendString:[entry valueForKey:@"value"]];
//                 if (![entry isEqualToDictionary:[[json objectForKey:@"data"] lastObject]]) {
//                     [numbers appendString:@","];
//                 }
                 
                 [self.tableView reloadData];
             }
             
         }
         else {
             
         }
         
         self.activityIndicator.hidden = YES;
         
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
//    if([self.textFieldMobileNumber.text isEqualToString:@""]) {
//        
//    }
//    else {
//        for (NSString *number in [self.textFieldMobileNumber.text componentsSeparatedByString:@","]) {
//            if(![number isEqualToString:@""]) {
//                
//                NSPredicate * predicate = [NSPredicate predicateWithFormat:@"value == %@", number];
//                NSString *number_id = ((ContactInfoNumber*)[[self fetchObjectsWithEntityName:@"ContactInfoNumber" andPredicate:predicate] firstObject]).pk_id;
//                
//                NSString *parameters = [NSString stringWithFormat:@"?id=%@&user_id=%@value_number=%@",number_id,self.loginDetails.user_id,number];
//                
//                NSMutableString *urlString = [NSMutableString stringWithString:@"http://keydiscoveryinc.com/agent_bridge/webservice/change_mobilenumber.php"];
//                [urlString appendString:parameters];
//                
//                self.activityIndicator.hidden = NO;
//                __block NSError *errorData = nil;
//                __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlString]];
//                
//                [request setCompletionBlock:
//                 ^{
//                     NSData *responseData = [request responseData];
//                     NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&errorData];
//                     
//                     if ([[json objectForKey:@"status"] count]) {
//                         NSLog(@"successfully saved");
//                     }
//                     else {
//                         NSLog(@"failed to saved");
//                     }
//                     
//                 }];
//                [request setFailedBlock:^{
//                    NSError *error = [request error];
//                    NSLog(@" error:%@",error);
//                }];
//                
//                [request startAsynchronous];
//            }
//        }
//    }
    
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
            return [self.arrayOfMobileNumber count] + self.addMobileNumber;
            break;
            
        case 1:
            return [self.arrayOfFaxNumber count] + self.addFaxNumber;
            break;
            
        case 2:
            return [self.arrayOfWorkNumber count] + self.addWorkNumber;
            break;
            
        default:
            return 0;
            break;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, tableView.frame.size.width - 20.0f, 20.0f)];
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
            break;
            
        case 1:
            self.addButtonFax = button;
            [self.addButtonFax addTarget:self action:@selector(addNewFaxNumber) forControlEvents:UIControlEventTouchUpInside];
            break;
            
        case 2:
            self.addButtonWork = button;
            [self.addButtonWork addTarget:self action:@selector(addNewWorkNumber) forControlEvents:UIControlEventTouchUpInside];
            break;
            
        default:
            break;
    }
    
    return header;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    switch (section) {
        case 0:
            return @"Mobile Numbers";
            break;
            
        case 1:
            return @"Fax Numbers";
            break;
            
        case 2:
            return @"Work Numbers";
            break;
            
        default:
            return 0;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = @"CellIdentifier";
    
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
        
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [button setImage:[UIImage imageNamed:@"delete-blue.png"] forState:UIControlStateNormal];
        
        button.frame = CGRectMake(textField.frame.origin.x + textField.frame.size.width + 5.0f, 5.0f, 30.0f, 30.0f);
        button.tag = 2;
        
        [cell.contentView addSubview:textField];
        [cell.contentView addSubview:button];
    }
    
    UITextField *textField = (UITextField*)[cell viewWithTag:1];
    UIButton *button = (UIButton*)[cell viewWithTag:2];
    
    NSUInteger section = [indexPath section];
    NSUInteger row = [indexPath row];
    
    
    switch (section) {
        case 0:{
            if (row < [self.arrayOfMobileNumber count]) {
                ContactInfoNumber *info = (ContactInfoNumber*)[self.arrayOfMobileNumber objectAtIndex:row];
                textField.text = info.value;
                textField.userInteractionEnabled = NO;
                button.hidden = NO;
            }
            else {
                button.hidden = YES;
            }
            break;
        }
        case 1:{
            if (row < [self.arrayOfFaxNumber count]) {
                ContactInfoNumber *info = (ContactInfoNumber*)[self.arrayOfFaxNumber objectAtIndex:row];
                textField.text = info.value;
                textField.userInteractionEnabled = NO;
                button.hidden = NO;
            }
            else {
                button.hidden = YES;
            }
            break;
        }
        case 2:{
            if (row < [self.arrayOfWorkNumber count]) {
                ContactInfoNumber *info = (ContactInfoNumber*)[self.arrayOfWorkNumber objectAtIndex:row];
                textField.text = info.value;
                textField.userInteractionEnabled = NO;
                button.hidden = NO;
            }
            else {
                button.hidden = YES;
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
    self.addButtonMobile.hidden = YES;
    self.addMobileNumber = 1;
    [self.tableView reloadData];
}

- (void) addNewFaxNumber {
    self.addButtonFax.hidden = YES;
    self.addFaxNumber = 1;
    [self.tableView reloadData];
}

- (void) addNewWorkNumber {
    self.addButtonWork.hidden = YES;
    self.addWorkNumber = 1;
    [self.tableView reloadData];
}
@end
