//
//  ABridge_ActivityAgentProfileViewController.m
//  AgentBridge
//
//  Created by host24_iOS Dev on 12/13/13.
//  Copyright (c) 2013 host24_iOS Dev. All rights reserved.
//

#import "ABridge_ActivityAgentProfileViewController.h"
#import "AgentProfile.h"

@interface ABridge_ActivityAgentProfileViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imagePicture;
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *viewContacts;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewVerified;

- (IBAction)goBack:(id)sender;

@property (strong, nonatomic) LoginDetails *loginDetail;
@property (strong, nonatomic) AgentProfile *profileData;
@property (strong, nonatomic) NSMutableArray *arrayKTableKeys;

@end

@implementation ABridge_ActivityAgentProfileViewController

@synthesize loginDetail;
@synthesize profileData;
@synthesize arrayKTableKeys;
@synthesize user_id;

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
    
    
    NSString *parameters = [NSString stringWithFormat:@"?user_id=%@",self.user_id];
    
    __block NSError *errorData = nil;
    __weak ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://keydiscoveryinc.com/agent_bridge/webservice/getprofile.php%@",parameters]]];
    [request setCompletionBlock:^{
        
        // Use when fetching text data
        //                        NSString *responseString = [request responseString];
        // Use when fetching binary data
        NSData *responseData = [request responseData];
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&errorData];
        
            if ([[json objectForKey:@"data"] count]) {
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
                }
                
                
                self.arrayKTableKeys = [[NSMutableArray alloc] init];
                
                if (![self isNull:self.profileData.broker_name]) {
                    [self.arrayKTableKeys addObject:@"brokerage"];
                }
                
                if (![self isNull:self.profileData.street_address] || ![self isNull:self.profileData.suburb] || ![self isNull:self.profileData.city] || ![self isNull:self.profileData.state_code] || ![self isNull:self.profileData.zip] || ![self isNull:self.profileData.countries_iso_code_3]) {
                    [self.arrayKTableKeys addObject:@"address"];
                }
                
                if (![self isNull:self.profileData.mobile_number]) {
                    if ([self.profileData.mobile_number rangeOfString:@","].location == NSNotFound) {
                        [self.arrayKTableKeys addObject:@"mobile1"];
                    }
                    else {
                        NSInteger counter = 1;
                        NSArray *array = [self.profileData.mobile_number componentsSeparatedByString:@","];
                        for (NSString *number in array) {
                            if (![self isNull:number]) {
                                [self.arrayKTableKeys addObject:[NSString stringWithFormat:@"mobile%li",(long)counter]];
                                counter++;
                            }
                        }
                    }
                }
                
                if (![self isNull:self.profileData.email]) {
                    [self.arrayKTableKeys addObject:@"email"];
                }
                
                if (![self isNull:self.profileData.zipcodes]) {
                    [self.arrayKTableKeys addObject:@"zipcodes"];
                }
                
                if (![self isNull:self.profileData.average_price]) {
                    [self.arrayKTableKeys addObject:@"average_price"];
                }
                
                if (![self isNull:self.profileData.total_volume]) {
                    [self.arrayKTableKeys addObject:@"total_volume"];
                }
                
                if (![self isNull:self.profileData.total_sides]) {
                    [self.arrayKTableKeys addObject:@"total_sides"];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    self.labelName.text = [NSString stringWithFormat:@"%@ %@",self.profileData.firstname, self.profileData.lastname];
                    CGSize constraint = CGSizeMake(150.0f, 20000.0f);
                    
                    CGSize size = [self.labelName.text sizeWithFont:FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR) constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
                    
                    CGFloat height = MAX(size.height, 27.0f);
                    
                    CGRect frame = self.viewContacts.frame;
                    frame.size.height += (height - self.labelName.frame.size.height);
                    self.viewContacts.frame = frame;
                    
                    frame = self.labelName.frame;
                    frame.size.height = height;
                    self.labelName.frame = frame;
                    
                    self.tableView.tableHeaderView = self.viewContacts;
                    
                    frame = self.imageViewVerified.frame;
                    frame.origin.y = self.labelName.frame.origin.y + self.labelName.frame.size.height + 5.0f;
                    self.imageViewVerified.frame = frame;
                    
                    if([self.profileData.activation_status integerValue])
                        self.imageViewVerified.hidden = NO;
                    else
                        self.imageViewVerified.hidden = YES;
                    
                    [self.tableView reloadData];
                });
                
                
                if (self.profileData.image_data == nil && ![self isNull:self.profileData.image]) {
                    self.profileData.image_data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.profileData.image]];
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (self.profileData.image_data != nil) {
                        self.imagePicture.image = [UIImage imageWithData:self.profileData.image_data];
                    }
                });

                
            }
        
        
    }];
    [request setFailedBlock:^{
        NSError *error = [request error];
        //NSLog(@" error:%@",error);
    }];
    
    [request startAsynchronous];
    
    self.labelName.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
    
    // Add a bottomBorder.
    CALayer *bottomBorder = [CALayer layer];
    
    bottomBorder.frame = CGRectMake(0.0f, self.viewContacts.frame.size.height - 1.0f, self.viewContacts.frame.size.width, 1.0f);
    
    bottomBorder.backgroundColor = [UIColor colorWithRed:191.0f/255.0f green:191.0f/255.0f blue:191.0f/255.0f alpha:1.0f].CGColor;
    
    [self.viewContacts.layer addSublayer:bottomBorder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)isNull:(id)value {
    return ((NSNull*)value == nil || [value isEqualToString:@""]);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.arrayKTableKeys count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    NSString *text = @"";
    CGFloat decreaseHeight = 0.0f;
    if ([[self.arrayKTableKeys objectAtIndex:[indexPath row]] isEqualToString:@"brokerage"]) {
        text = self.profileData.broker_name;
    }
    else if ([[self.arrayKTableKeys objectAtIndex:[indexPath row]] isEqualToString:@"address"]) {
//        text = @"";
        NSMutableString *string = [NSMutableString stringWithString:@""];
        if (![self isNull:self.profileData.street_address]) {
            [string appendFormat:@"%@\n",self.profileData.street_address];
        }
        if (![self isNull:self.profileData.suburb]) {
            [string appendFormat:@"%@\n",self.profileData.suburb];
        }
        if (![self isNull:self.profileData.city]) {
            [string appendFormat:@"%@ ",self.profileData.city];
        }
        if (![self isNull:self.profileData.state_code]) {
            [string appendFormat:@"%@ ",self.profileData.state_code];
        }
        if (![self isNull:self.profileData.zip]) {
            [string appendFormat:@"%@\n",self.profileData.zip];
        }
        if (![self isNull:self.profileData.countries_iso_code_3]) {
            [string appendFormat:@"%@ ",self.profileData.countries_iso_code_3];
        }
        
        NSString *removedLastChar = [string substringToIndex:[string length]-1];
        
        [string setString:[NSString stringWithString:removedLastChar]];
        
        text = string;
    }
    else if ([[self.arrayKTableKeys objectAtIndex:[indexPath row]] rangeOfString:@"mobile"].location != NSNotFound) {
        
        if ([self.profileData.mobile_number rangeOfString:@","].location == NSNotFound) {
            text = self.profileData.mobile_number;
        }
        else {
            NSMutableArray *array = [NSMutableArray arrayWithArray:[self.profileData.mobile_number componentsSeparatedByString:@","]];
            NSString *key = [self.arrayKTableKeys objectAtIndex:[indexPath row]];
            
            NSInteger array_index = [[key substringFromIndex:[key rangeOfString:@"mobile"].length] integerValue];
            text = [array objectAtIndex:array_index - 1];
            if (array_index == 2) {
                decreaseHeight = FONT_SIZE_FOR_PROFILE * array_index;
            }
            if ([self isNull:text]) {
                text = [array objectAtIndex:array_index];
            }
        }
    }
    else if ([[self.arrayKTableKeys objectAtIndex:[indexPath row]] isEqualToString:@"email"]) {
        text = self.profileData.email;
    }
    else if ([[self.arrayKTableKeys objectAtIndex:[indexPath row]] isEqualToString:@"zipcodes"]) {
        text = self.profileData.zipcodes;
    }
    else if ([[self.arrayKTableKeys objectAtIndex:[indexPath row]] isEqualToString:@"average_price"]) {
        text = self.profileData.average_price;
    }
    else if ([[self.arrayKTableKeys objectAtIndex:[indexPath row]] isEqualToString:@"total_volume"]) {
        text = self.profileData.total_volume;
    }
    else if ([[self.arrayKTableKeys objectAtIndex:[indexPath row]] isEqualToString:@"total_sides"]) {
        text = self.profileData.total_sides;
    }
    
    CGSize constraint = CGSizeMake(320.0f - (10.0f * 2), 20000.0f);
    
    CGSize size = [text sizeWithFont:FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR) constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    
    size.height += FONT_SIZE_REGULAR;
    
    CGFloat height = MAX(size.height, 44.0f);
    
    return height + 5.0f - decreaseHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"CellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
//    NSInteger row = [indexPath row];
    
    cell.textLabel.font = FONT_OPENSANS_REGULAR(FONT_SIZE_FOR_PROFILE);
    cell.detailTextLabel.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
    
    [cell.detailTextLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [cell.detailTextLabel setNumberOfLines:0];
    
    cell.textLabel.textColor = [UIColor lightGrayColor];
    cell.detailTextLabel.textColor = [UIColor blackColor];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (self.profileData == nil) {
        cell.textLabel.text = @"";
        cell.detailTextLabel.text = @"";
    }
    else {
        if(![self.profileData.activation_status integerValue]){
//            row += 1;
        }
        if ([[self.arrayKTableKeys objectAtIndex:[indexPath row]] isEqualToString:@"brokerage"]) {
            cell.textLabel.text = @"Brokerage";
            cell.detailTextLabel.text = self.profileData.broker_name;
        }
        else if ([[self.arrayKTableKeys objectAtIndex:[indexPath row]] isEqualToString:@"address"]) {
            cell.textLabel.text = @"Address";
            cell.detailTextLabel.text = @"";
            NSMutableString *string = [NSMutableString stringWithString:@""];
            if (![self isNull:self.profileData.street_address]) {
                [string appendFormat:@"%@\n",self.profileData.street_address];
            }
            if (![self isNull:self.profileData.suburb]) {
                [string appendFormat:@"%@\n",self.profileData.suburb];
            }
            if (![self isNull:self.profileData.city]) {
                [string appendFormat:@"%@ ",self.profileData.city];
            }
            if (![self isNull:self.profileData.state_code]) {
                [string appendFormat:@"%@ ",self.profileData.state_code];
            }
            if (![self isNull:self.profileData.zip]) {
                [string appendFormat:@"%@\n",self.profileData.zip];
            }
            if (![self isNull:self.profileData.countries_iso_code_3]) {
                [string appendFormat:@"%@ ",self.profileData.countries_iso_code_3];
            }
            
            NSString *removedLastChar = [string substringToIndex:[string length]-1];
            
            [string setString:[NSString stringWithString:removedLastChar]];
            
            cell.detailTextLabel.text = string;
        }
        else if ([[self.arrayKTableKeys objectAtIndex:[indexPath row]] rangeOfString:@"mobile"].location != NSNotFound) {
            
            if ([self.profileData.mobile_number rangeOfString:@","].location == NSNotFound) {
                cell.detailTextLabel.text = self.profileData.mobile_number;
            }
            else {
                NSArray *array = [self.profileData.mobile_number componentsSeparatedByString:@","];
                NSString *key = [self.arrayKTableKeys objectAtIndex:[indexPath row]];
                NSInteger array_index = [[key substringFromIndex:[key rangeOfString:@"mobile"].length] integerValue];
                cell.detailTextLabel.text = [array objectAtIndex:array_index - 1];
                if ([self isNull:cell.detailTextLabel.text]) {
                    cell.detailTextLabel.text = [array objectAtIndex:array_index];
                }
            }
            if ([[self.arrayKTableKeys objectAtIndex:[indexPath row]] isEqualToString:@"mobile1"]) {
                cell.textLabel.text = @"Mobile";
            }
            else {
                cell.textLabel.text = @"";
            }
            
            cell.detailTextLabel.textColor = [UIColor colorWithRed:44.0f/255.0f green:153.0f/255.0f blue:206.0f/255.0f alpha:1.0f];
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        }
        else if ([[self.arrayKTableKeys objectAtIndex:[indexPath row]] isEqualToString:@"email"]) {
            cell.textLabel.text = @"Email";
            cell.detailTextLabel.text = self.profileData.email;
            cell.detailTextLabel.textColor = [UIColor colorWithRed:44.0f/255.0f green:153.0f/255.0f blue:206.0f/255.0f alpha:1.0f];
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        }
        else if ([[self.arrayKTableKeys objectAtIndex:[indexPath row]] isEqualToString:@"zipcodes"]) {
            cell.textLabel.text = [NSString stringWithFormat:@"%@ works around zip codes",self.profileData.firstname];
            cell.detailTextLabel.text = self.profileData.zipcodes;
        }
        else if ([[self.arrayKTableKeys objectAtIndex:[indexPath row]] isEqualToString:@"average_price"]) {
            cell.textLabel.text = @"Average Sales Price";
            NSNumberFormatter * formatter = [[NSNumberFormatter alloc] init];
            formatter.numberStyle = NSNumberFormatterCurrencyStyle;
            [formatter setMaximumFractionDigits:0];
            formatter.currencyCode = @"USD";
            cell.detailTextLabel.text = [formatter stringFromNumber:[NSNumber numberWithDouble:[self.profileData.average_price doubleValue]]];
        }
        else if ([[self.arrayKTableKeys objectAtIndex:[indexPath row]] isEqualToString:@"total_volume"]) {
            cell.textLabel.text = @"Total Volume";
            NSNumberFormatter * formatter = [[NSNumberFormatter alloc] init];
            formatter.numberStyle = NSNumberFormatterCurrencyStyle;
            [formatter setMaximumFractionDigits:0];
            formatter.currencyCode = @"USD";
            cell.detailTextLabel.text = [formatter stringFromNumber:[NSNumber numberWithDouble:[self.profileData.total_volume doubleValue]]];
        }
        else if ([[self.arrayKTableKeys objectAtIndex:[indexPath row]] isEqualToString:@"total_sides"]) {
            cell.textLabel.text = @"Total Sides";
            cell.detailTextLabel.text = self.profileData.total_sides;
        }
        else {
            cell.textLabel.text = @"";
            cell.detailTextLabel.text = @"";
        }
    }
    
    CGSize constraint = CGSizeMake(320.0f - (10.0f * 2), 20000.0f);
    
    CGSize size = [cell.detailTextLabel.text sizeWithFont:FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR)  constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    
    size.height += FONT_SIZE_REGULAR;
    
    CGRect frame = cell.detailTextLabel.frame;
    frame.size.height = MAX(size.height, 44.0f);
    cell.detailTextLabel.frame = frame;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([[self.arrayKTableKeys objectAtIndex:[indexPath row]] rangeOfString:@"mobile"].location != NSNotFound) {
        [self callMobileNumber:nil];
    }
    else if ([indexPath row] == [self.arrayKTableKeys indexOfObject:@"email"]) {
        [self sendEmail:nil];
    }
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



- (IBAction)callMobileNumber:(id)sender {
    NSMutableString *mobileNumber = [NSMutableString stringWithString:self.profileData.mobile_number];
    [mobileNumber replaceOccurrencesOfString:@"-" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [mobileNumber length])];
    [mobileNumber replaceOccurrencesOfString:@"(" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [mobileNumber length])];
    [mobileNumber replaceOccurrencesOfString:@")" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [mobileNumber length])];
    [mobileNumber replaceOccurrencesOfString:@" " withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [mobileNumber length])];
    //    //NSLog(@"number:[%@]",mobileNumber);
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",mobileNumber]];
    [[UIApplication sharedApplication] openURL:URL];
}

- (IBAction)sendEmail:(id)sender {
    
    
    if ([MFMailComposeViewController canSendMail]) {
        
        MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
        mailViewController.mailComposeDelegate = self;
        [mailViewController setSubject:[NSString stringWithFormat:@"Hello %@",self.profileData.firstname]];
        [mailViewController setToRecipients:[NSArray arrayWithObjects:self.profileData.email, nil]];
        [mailViewController setMessageBody:@"Your message goes here." isHTML:NO];
        
        [self presentViewController:mailViewController animated:YES completion:^{
            
        }];
        
    }
    
    else {
        
        //        //NSLog(@"Device is unable to send email in its current state.");
        
    }
    
}

-(void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
