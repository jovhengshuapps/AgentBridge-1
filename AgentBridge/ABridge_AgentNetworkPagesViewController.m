//
//  ABridge_AgentNetworkPagesViewController.m
//  AgentBridge
//
//  Created by host24_iOS Dev on 11/19/13.
//  Copyright (c) 2013 host24_iOS Dev. All rights reserved.
//

#import "ABridge_AgentNetworkPagesViewController.h"
#import "LoginDetails.h"
#import "Constants.h"

@interface ABridge_AgentNetworkPagesViewController ()
    @property (weak, nonatomic) IBOutlet UIImageView *imagePicture;
    @property (weak, nonatomic) IBOutlet UILabel *labelName;
//    @property (weak, nonatomic) IBOutlet UILabel *labelBroker;
//    @property (weak, nonatomic) IBOutlet UILabel *labelAddress;
//    @property (weak, nonatomic) IBOutlet UIButton *buttonMobileNumber;
//    @property (weak, nonatomic) IBOutlet UIButton *buttonEmailAddress;
//    @property (weak, nonatomic) IBOutlet UILabel *labelMobile;
//    @property (weak, nonatomic) IBOutlet UILabel *labelEmail;
    @property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewVerified;
@property (weak, nonatomic) IBOutlet UIView *viewForContacts;

@property (weak, nonatomic) IBOutlet UILabel *labelPage;
//- (IBAction)callMobileNumber:(id)sender;
//- (IBAction)sendEmail:(id)sender;
    @property (strong, nonatomic) NSArray *arrayKTableKeys;

@end

@implementation ABridge_AgentNetworkPagesViewController
    @synthesize index;
    @synthesize profileData;
    @synthesize arrayKTableKeys;

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
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
    self.labelName.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
//    self.labelBroker.font = FONT_OPENSANS_REGULAR(12.0f);
//    self.labelAddress.font = FONT_OPENSANS_REGULAR(12.0f);
//    self.buttonMobileNumber.titleLabel.font = FONT_OPENSANS_REGULAR(12.0f);
//    self.buttonMobileNumber.titleLabel.font = FONT_OPENSANS_REGULAR(12.0f);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.labelPage.text = [NSString stringWithFormat:@"%li",(long)self.index+1];
        });
//    self.arrayKTableKeys = [NSArray arrayWithObjects:@"verify_image", @"zipcodes", @"average_sales", @"total_volume", @"total_sides", nil];
    
    self.arrayKTableKeys = [NSArray arrayWithObjects:/*@"verify_image",*/ @"brokerage", @"address", @"mobile", @"email", @"zipcodes", nil];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.labelName.text = [NSString stringWithFormat:@"%@ %@",self.profileData.firstname, self.profileData.lastname];
            CGSize constraint = CGSizeMake(150.0f, 20000.0f);
            
            CGSize size = [self.labelName.text sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
            
            CGFloat height = MAX(size.height, 27.0f);
            
            CGRect frame = self.viewForContacts.frame;
            frame.size.height += (height - self.labelName.frame.size.height);
            self.viewForContacts.frame = frame;
            
            frame = self.labelName.frame;
            frame.size.height = height;
            self.labelName.frame = frame;
            
            self.tableView.tableHeaderView = self.viewForContacts;
            
            frame = self.imageViewVerified.frame;
            frame.origin.y = self.labelName.frame.origin.y + self.labelName.frame.size.height + 5.0f;
            self.imageViewVerified.frame = frame;
            
            [self.tableView reloadData];
        });
        
            if (self.profileData.image_data == nil) {
                self.profileData.image_data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.profileData.image]];
            }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imagePicture.image = [UIImage imageWithData:self.profileData.image_data];
            
            if ([self.profileData.activation_status integerValue]) {
                self.imageViewVerified.hidden = NO;
                
            }
        });
        
    });
    
    // Add a bottomBorder.
    CALayer *bottomBorder = [CALayer layer];
    
    bottomBorder.frame = CGRectMake(0.0f, self.viewForContacts.frame.size.height - 1.0f, self.viewForContacts.frame.size.width, 1.0f);
    
    bottomBorder.backgroundColor = [UIColor colorWithRed:191.0f/255.0f green:191.0f/255.0f blue:191.0f/255.0f alpha:1.0f].CGColor;
    
    [self.viewForContacts.layer addSublayer:bottomBorder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
    
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
    
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    if([self.profileData.activation_status integerValue])
//        return 6;
//    else
        return 5;
//    if([self.profileData.activation_status integerValue])
//    return 5;
//    else
//    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    NSString *text = @"";
    if ([[self.arrayKTableKeys objectAtIndex:[indexPath row]] isEqualToString:@"brokerage"]) {
        text = self.profileData.broker_name;
    }
    else if ([[self.arrayKTableKeys objectAtIndex:[indexPath row]] isEqualToString:@"address"]) {
        text = [NSString stringWithFormat:@"%@, %@, %@", self.profileData.street_address, self.profileData.city, self.profileData.countries_name];
    }
    else if ([[self.arrayKTableKeys objectAtIndex:[indexPath row]] isEqualToString:@"mobile"]) {
        text = self.profileData.mobile_number;
    }
    else if ([[self.arrayKTableKeys objectAtIndex:[indexPath row]] isEqualToString:@"email"]) {
        text = self.profileData.email;
    }
    else if ([[self.arrayKTableKeys objectAtIndex:[indexPath row]] isEqualToString:@"zipcodes"]) {
        text = self.profileData.zipcodes;
    }
    
    CGSize constraint = CGSizeMake(320.0f - (5.0f * 2), 20000.0f);
    
    CGSize size = [text sizeWithFont:FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR) constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    size.height += 10.0f;
    CGFloat height = MAX(size.height, 44.0f);
    
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"CellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    NSInteger row = [indexPath row];
    
    cell.textLabel.font = FONT_OPENSANS_REGULAR(10.0f);
    cell.detailTextLabel.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
    
    [cell.detailTextLabel setLineBreakMode:UILineBreakModeWordWrap];
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
            row += 1;
        }
        /*if ([[self.arrayKTableKeys objectAtIndex:row] isEqualToString:@"verify_image"]) {
            cell.textLabel.text = @"";
            cell.detailTextLabel.text = @"";
            
        }
        else*/ if ([[self.arrayKTableKeys objectAtIndex:row] isEqualToString:@"brokerage"]) {
            cell.textLabel.text = @"Brokerage";
            cell.detailTextLabel.text = self.profileData.broker_name;
        }
        else if ([[self.arrayKTableKeys objectAtIndex:row] isEqualToString:@"address"]) {
            cell.textLabel.text = @"Address";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@, %@, %@, %@", self.profileData.street_address, self.profileData.city, self.profileData.state_code, self.profileData.countries_iso_code_3];
        }
        else if ([[self.arrayKTableKeys objectAtIndex:row] isEqualToString:@"mobile"]) {
            cell.textLabel.text = @"Mobile";
            cell.detailTextLabel.text = self.profileData.mobile_number;
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        }
        else if ([[self.arrayKTableKeys objectAtIndex:row] isEqualToString:@"email"]) {
            cell.textLabel.text = @"Email";
            cell.detailTextLabel.text = self.profileData.email;
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        }
        
        else if ([[self.arrayKTableKeys objectAtIndex:row] isEqualToString:@"zipcodes"]) {
            cell.textLabel.text = [NSString stringWithFormat:@"%@ works around zip codes",self.profileData.firstname];
            cell.detailTextLabel.text = self.profileData.zipcodes;
        }
//        else if ([[self.arrayKTableKeys objectAtIndex:row] isEqualToString:@"average_sales"]) {
//            NSNumberFormatter * formatter = [[NSNumberFormatter alloc] init];
//            formatter.numberStyle = NSNumberFormatterCurrencyStyle;
//            formatter.currencyCode = @"USD";
//            
//            cell.textLabel.text = [formatter stringFromNumber: [NSNumber numberWithDouble:[self.profileData.average_price doubleValue]]];
//            cell.detailTextLabel.text = @"Average Sales Price";
//        }
//        else if ([[self.arrayKTableKeys objectAtIndex:row] isEqualToString:@"total_volume"]) {
//            NSNumberFormatter * formatter = [[NSNumberFormatter alloc] init];
//            formatter.numberStyle = NSNumberFormatterCurrencyStyle;
//            formatter.currencyCode = @"USD";
//            
//            cell.textLabel.text = [formatter stringFromNumber: [NSNumber numberWithDouble:[self.profileData.total_volume doubleValue]]];
//            cell.detailTextLabel.text = @"Total Volume";
//        }
//        else if ([[self.arrayKTableKeys objectAtIndex:row] isEqualToString:@"total_sides"]) {
//            NSNumberFormatter * formatter = [[NSNumberFormatter alloc] init];
//            formatter.numberStyle = NSNumberFormatterCurrencyStyle;
//            formatter.currencyCode = @"USD";
//            
//            cell.textLabel.text = [formatter stringFromNumber: [NSNumber numberWithDouble:[self.profileData.total_sides doubleValue]]];
//            cell.detailTextLabel.text = @"Total Sides";
//        }
        else {
            cell.textLabel.text = @"";
            cell.detailTextLabel.text = @"";
        }
    }
    
    
    
    CGSize constraint = CGSizeMake(320.0f - (10.0f * 2), 20000.0f);
    
    CGSize size = [cell.detailTextLabel.text sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    
    size.height += 10.0f;
    
    CGRect frame = cell.detailTextLabel.frame;
    frame.size.height =MAX(size.height, 44.0f);
    cell.detailTextLabel.frame = frame;
    
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch ([indexPath row]) {
        case 2:
            [self callMobileNumber:nil];
            break;
        case 3:
            [self sendEmail:nil];
            break;
        default:
            break;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
    
- (IBAction)callMobileNumber:(id)sender {
    NSMutableString *mobileNumber = [NSMutableString stringWithString:self.profileData.mobile_number];
    [mobileNumber replaceOccurrencesOfString:@"-" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [mobileNumber length])];
    [mobileNumber replaceOccurrencesOfString:@"(" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [mobileNumber length])];
    [mobileNumber replaceOccurrencesOfString:@")" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [mobileNumber length])];
    [mobileNumber replaceOccurrencesOfString:@" " withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [mobileNumber length])];
//    NSLog(@"number:%@",mobileNumber);
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",mobileNumber]];
    [[UIApplication sharedApplication] openURL:URL];
}
    
- (IBAction)sendEmail:(id)sender {
    
    if ([MFMailComposeViewController canSendMail]) {
        
        MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
        mailViewController.mailComposeDelegate = self;
        [mailViewController setSubject:[NSString stringWithFormat:@"Hello %@",self.profileData.firstname]];
        [mailViewController setMessageBody:@"Your message goes here." isHTML:NO];
        
        [self presentViewController:mailViewController animated:YES completion:^{
            
        }];
        
    }
    
    else {
        
//        NSLog(@"Device is unable to send email in its current state.");
        
    }
    
}
    
-(void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}


@end
