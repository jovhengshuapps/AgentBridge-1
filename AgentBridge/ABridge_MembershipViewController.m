//
//  ABridge_MembershipViewController.m
//  AgentBridge
//
//  Created by host24_iOS Dev on 2/8/14.
//  Copyright (c) 2014 host24_iOS Dev. All rights reserved.
//

#import "ABridge_MembershipViewController.h"
#import "AgentProfile.h"

@interface ABridge_MembershipViewController ()
@property (weak, nonatomic) IBOutlet UILabel *labelHeader;

@property (weak, nonatomic) IBOutlet UIButton *buttonMembershipMonthly;
@property (weak, nonatomic) IBOutlet UILabel *labelMonthlyName;
@property (weak, nonatomic) IBOutlet UITableView *tableViewMonthlyBenefits;


@property (strong, nonatomic) NSMutableArray *arrayBenefitsMonthly;

- (IBAction)buttonMonthlyPressed:(id)sender;

@end

@implementation ABridge_MembershipViewController
@synthesize arrayBenefitsMonthly;

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
    self.labelHeader.font = FONT_OPENSANS_BOLD(FONT_SIZE_TITLE);
    
    self.labelMonthlyName.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
    self.buttonMembershipMonthly.titleLabel.font = FONT_OPENSANS_REGULAR(FONT_SIZE_SMALL);
    
    
    //get profile user_id
    
    
    NSManagedObjectContext *context = ((ABridge_AppDelegate *)[[UIApplication sharedApplication] delegate]).managedObjectContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"LoginDetails"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    NSInteger login_user_id = [[[fetchedObjects firstObject] valueForKey:@"user_id"] integerValue];
    
    
    NSFetchRequest *fetchRequestProfile = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityProfile = [NSEntityDescription entityForName:@"AgentProfile"
                                              inManagedObjectContext:context];
    [fetchRequestProfile setEntity:entityProfile];
    
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"user_id == %i",login_user_id];
//    
//    [fetchRequestProfile setPredicate:predicate];
    
    NSError *errorProfile = nil;
    NSArray *fetchedObjectsProfile = [context executeFetchRequest:fetchRequestProfile error:&errorProfile];
    
//    BOOL found = NO;
    AgentProfile *profileFound;
    
    for (AgentProfile *profile in fetchedObjectsProfile) {
        if ([profile.user_id integerValue] == login_user_id) {
//            found = YES;
            profileFound = profile;
            break;
        }
    }
    
    NSInteger profile_user_id = [profileFound.profile_id integerValue];
    
    NSString *parameters = [NSString stringWithFormat:@"?user_id=%i",profile_user_id];
    
    NSMutableString *urlString = [NSMutableString stringWithString:@"http://agentbridge.com/webservice/get_membership_fee.php"];
    [urlString appendString:parameters];
//    NSLog(@"url:%@",urlString);
    __block NSError *errorData = nil;
    __weak ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlString]];
    //            [self.activityIndicator startAnimating];
    //            self.activityIndicator.hidden = NO;
    [request setCompletionBlock:
     ^{
         NSData *responseData = [request responseData];
         NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&errorData];
//         NSLog(@"json:%@",json);
         if ([[json objectForKey:@"data"] count]) {
             self.labelMonthlyName.text = [@"Your current plan: " stringByAppendingString:[[[json objectForKey:@"data"] firstObject] objectForKey:@"fee_title"]];
             
         }
         else {
             
             self.labelMonthlyName.text = @"Your current plan: Charter";
         }
         
         [self.searchDisplayController.searchResultsTableView reloadData];
     }];
    [request setFailedBlock:^{
        NSError *error = [request error];
        NSLog(@" error:%@",error);
    }];
    
    [request startAsynchronous];
    
dummy_data_monthly:
    {
        if (self.arrayBenefitsMonthly == nil) {
            self.arrayBenefitsMonthly = [NSMutableArray array];
        }
        
        
        NSDictionary *dic1 = [[NSDictionary alloc] initWithObjectsAndKeys:@"Unlimited AgentBridge International Referrals.", @"description", @"1", @"bool", nil];
        
        NSDictionary *dic2 = [[NSDictionary alloc] initWithObjectsAndKeys:@"Unlimited POPs™.", @"description", @"1", @"bool", nil];
        
        NSDictionary *dic3 = [[NSDictionary alloc] initWithObjectsAndKeys:@"Unlimited matches to Buyers.", @"description", @"1", @"bool", nil];
        
        NSDictionary *dic4 = [[NSDictionary alloc] initWithObjectsAndKeys:@"Authorization to use AgentBridge marketing materials for self promotion.", @"description", @"1", @"bool", nil];
        
        NSDictionary *dic5 = [[NSDictionary alloc] initWithObjectsAndKeys:@"Unlimited use of AgentBridge mobile app.", @"description", @"1", @"bool", nil];
        
        
        [self.arrayBenefitsMonthly addObject:dic1];
        [self.arrayBenefitsMonthly addObject:dic4];
        [self.arrayBenefitsMonthly addObject:dic5];
        [self.arrayBenefitsMonthly addObject:dic2];
        [self.arrayBenefitsMonthly addObject:dic3];
        
        [self.tableViewMonthlyBenefits reloadData];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonMonthlyPressed:(id)sender {
}

- (IBAction)buttonQuarterlyPressed:(id)sender {
}

- (IBAction)buttonAnnualPressed:(id)sender {
}


#pragma 
#pragma mark UITableView Data Source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
        return [self.arrayBenefitsMonthly count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *text = @"";
    
    NSArray *arrayData;
    if (tableView == self.tableViewMonthlyBenefits) {
        arrayData = self.arrayBenefitsMonthly;
    }
    
    // if agent search
    text = [[arrayData objectAtIndex:[indexPath row]] objectForKey:@"description"];
    
    CGSize constraint = CGSizeMake(tableView.frame.size.width - 20.0f, 20000.0f);
    
    CGSize size = [text sizeWithFont:FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR) constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    
    CGFloat height = MAX(size.height, 33.0f);
    
    return height + 10.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellidentifier = @"CellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellidentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellidentifier];
        cell.textLabel.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    }
    
    NSArray *arrayData;
    if (tableView == self.tableViewMonthlyBenefits) {
        arrayData = self.arrayBenefitsMonthly;
    }
    
    
    cell.textLabel.text = [[arrayData objectAtIndex:[indexPath row]] objectForKey:@"description"];
    
    if ([[[arrayData objectAtIndex:[indexPath row]] objectForKey:@"bool"] boolValue] == YES) {
        cell.imageView.image = [UIImage imageNamed:@"check2.png"];
    }
    else {
         cell.imageView.image = nil/*[UIImage imageNamed:@"box.png"]*/;
    }
    
    return cell;
}



@end
