//
//  ABridge_AgentNetworkPagesViewController.m
//  AgentBridge
//
//  Created by host24_iOS Dev on 11/19/13.
//  Copyright (c) 2013 host24_iOS Dev. All rights reserved.
//

#import "ABridge_AgentNetworkPagesViewController.h"
#import "LoginDetails.h"

@interface ABridge_AgentNetworkPagesViewController ()
    @property (weak, nonatomic) IBOutlet UIImageView *imagePicture;
    @property (weak, nonatomic) IBOutlet UILabel *labelName;
    @property (weak, nonatomic) IBOutlet UILabel *labelBroker;
    @property (weak, nonatomic) IBOutlet UILabel *labelAddress;
    @property (weak, nonatomic) IBOutlet UIButton *buttonMobileNumber;
    @property (weak, nonatomic) IBOutlet UIButton *buttonEmailAddress;
    @property (weak, nonatomic) IBOutlet UILabel *labelMobile;
    @property (weak, nonatomic) IBOutlet UILabel *labelEmail;
    @property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UILabel *labelPage;
- (IBAction)callMobileNumber:(id)sender;
- (IBAction)sendEmail:(id)sender;
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
    
    
    self.labelPage.text = [NSString stringWithFormat:@"%li",(long)self.index+1];
    
    self.arrayKTableKeys = [NSArray arrayWithObjects:@"verify_image", @"zipcodes", @"average_sales", @"total_volume", @"total_sides", nil];
    
    
    self.labelName.text = [NSString stringWithFormat:@"%@ %@",self.profileData.firstname, self.profileData.lastname];
    self.labelBroker.text = self.profileData.broker_name;
    self.labelAddress.text = [NSString stringWithFormat:@"%@, %@, %@", self.profileData.street_address, self.profileData.city, self.profileData.countries_name];
    [self.buttonMobileNumber setTitle:self.profileData.mobile_number forState:UIControlStateNormal];
    [self.buttonEmailAddress setTitle:self.profileData.email forState:UIControlStateNormal];
    [self.tableView reloadData];
    
    
    if (self.profileData.image_data == nil) {
        self.profileData.image_data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.profileData.image]];
    }
    
    self.imagePicture.image = [UIImage imageWithData:self.profileData.image_data];
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
    
    if([self.profileData.activation_status integerValue])
    return 5;
    else
    return 4;
}
    
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"CellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    NSInteger row = [indexPath row];
    
    if (self.profileData == nil) {
        cell.textLabel.text = @"";
        cell.detailTextLabel.text = @"";
    }
    else {
        if(![self.profileData.activation_status integerValue]){
            row += 1;
        }
        if ([[self.arrayKTableKeys objectAtIndex:row] isEqualToString:@"verify_image"]) {
            cell.textLabel.text = @"";
            cell.detailTextLabel.text = @"";
            if ([self.profileData.activation_status integerValue]) {
                UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"agent-bridge-verified.png"]];
                imageView.frame = CGRectMake(0.0f, 0.0f, 105.0f, cell.frame.size.height);
                imageView.center = CGPointMake(cell.frame.size.width/2, cell.frame.size.height/2);
                imageView.contentMode = UIViewContentModeScaleAspectFit;
                [cell addSubview:imageView];
            }
        }
        else if ([[self.arrayKTableKeys objectAtIndex:row] isEqualToString:@"zipcodes"]) {
            cell.textLabel.text = self.profileData.zipcodes;
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ works around zip codes",self.profileData.firstname];
        }
        else if ([[self.arrayKTableKeys objectAtIndex:row] isEqualToString:@"average_sales"]) {
            NSNumberFormatter * formatter = [[NSNumberFormatter alloc] init];
            formatter.numberStyle = NSNumberFormatterCurrencyStyle;
            formatter.currencyCode = @"USD";
            
            cell.textLabel.text = [formatter stringFromNumber: [NSNumber numberWithDouble:[self.profileData.average_price doubleValue]]];
            cell.detailTextLabel.text = @"Average Sales Price";
        }
        else if ([[self.arrayKTableKeys objectAtIndex:row] isEqualToString:@"total_volume"]) {
            NSNumberFormatter * formatter = [[NSNumberFormatter alloc] init];
            formatter.numberStyle = NSNumberFormatterCurrencyStyle;
            formatter.currencyCode = @"USD";
            
            cell.textLabel.text = [formatter stringFromNumber: [NSNumber numberWithDouble:[self.profileData.total_volume doubleValue]]];
            cell.detailTextLabel.text = @"Total Volume";
        }
        else if ([[self.arrayKTableKeys objectAtIndex:row] isEqualToString:@"total_sides"]) {
            NSNumberFormatter * formatter = [[NSNumberFormatter alloc] init];
            formatter.numberStyle = NSNumberFormatterCurrencyStyle;
            formatter.currencyCode = @"USD";
            
            cell.textLabel.text = [formatter stringFromNumber: [NSNumber numberWithDouble:[self.profileData.total_sides doubleValue]]];
            cell.detailTextLabel.text = @"Total Sides";
        }
        else {
            cell.textLabel.text = @"";
            cell.detailTextLabel.text = @"";
        }
    }
    
    return cell;
}

    
- (IBAction)callMobileNumber:(id)sender {
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.profileData.mobile_number]];
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
