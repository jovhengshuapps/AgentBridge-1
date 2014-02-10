//
//  ABridge_MembershipViewController.m
//  AgentBridge
//
//  Created by host24_iOS Dev on 2/8/14.
//  Copyright (c) 2014 host24_iOS Dev. All rights reserved.
//

#import "ABridge_MembershipViewController.h"

@interface ABridge_MembershipViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewPlans;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UILabel *labelHeader;

@property (weak, nonatomic) IBOutlet UIButton *buttonMembershipMonthly;
@property (weak, nonatomic) IBOutlet UILabel *labelMonthlyCurrent;
@property (weak, nonatomic) IBOutlet UILabel *labelMonthlyName;
@property (weak, nonatomic) IBOutlet UILabel *labelMonthlyCode;
@property (weak, nonatomic) IBOutlet UITableView *tableViewMonthlyBenefits;
@property (weak, nonatomic) IBOutlet UILabel *labelMonthlyCost;
@property (weak, nonatomic) IBOutlet UILabel *labelMonthlySave;

@property (weak, nonatomic) IBOutlet UIButton *buttonMembershipQuarterly;
@property (weak, nonatomic) IBOutlet UILabel *labelQuarterlyCurrent;
@property (weak, nonatomic) IBOutlet UILabel *labelQuarterlyName;
@property (weak, nonatomic) IBOutlet UILabel *labelQuarterlyCode;
@property (weak, nonatomic) IBOutlet UITableView *tableViewQuarterlyBenefits;
@property (weak, nonatomic) IBOutlet UILabel *labelQuarterlyCost;
@property (weak, nonatomic) IBOutlet UILabel *labelQuarterlySave;

@property (weak, nonatomic) IBOutlet UIButton *buttonMembershipAnnual;
@property (weak, nonatomic) IBOutlet UILabel *labelAnnualCurrent;
@property (weak, nonatomic) IBOutlet UILabel *labelAnnualName;
@property (weak, nonatomic) IBOutlet UILabel *labelAnnualCode;
@property (weak, nonatomic) IBOutlet UITableView *tableViewAnnualBenefits;
@property (weak, nonatomic) IBOutlet UILabel *labelAnnualCost;
@property (weak, nonatomic) IBOutlet UILabel *labelAnnualSave;

@property (strong, nonatomic) NSMutableArray *arrayBenefitsMonthly;
@property (strong, nonatomic) NSMutableArray *arrayBenefitsQuarterly;
@property (strong, nonatomic) NSMutableArray *arrayBenefitsAnnual;

- (IBAction)buttonMonthlyPressed:(id)sender;
- (IBAction)buttonQuarterlyPressed:(id)sender;
- (IBAction)buttonAnnualPressed:(id)sender;

@end

@implementation ABridge_MembershipViewController
@synthesize arrayBenefitsMonthly;
@synthesize arrayBenefitsQuarterly;
@synthesize arrayBenefitsAnnual;

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
    
    self.labelHeader.font = FONT_OPENSANS_REGULAR(FONT_SIZE_TITLE);
    
    self.labelMonthlyCurrent.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
    self.labelMonthlyName.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
    self.labelMonthlyCode.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
    self.labelMonthlyCost.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
    self.labelMonthlySave.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
    self.buttonMembershipMonthly.titleLabel.font = FONT_OPENSANS_REGULAR(FONT_SIZE_SMALL);
    
    self.labelQuarterlyCurrent.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
    self.labelQuarterlyName.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
    self.labelQuarterlyCode.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
    self.labelQuarterlyCost.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
    self.labelQuarterlySave.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
    self.buttonMembershipQuarterly.titleLabel.font = FONT_OPENSANS_REGULAR(FONT_SIZE_SMALL);
    
    self.labelAnnualCurrent.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
    self.labelAnnualName.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
    self.labelAnnualCode.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
    self.labelAnnualCost.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
    self.labelAnnualSave.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
    self.buttonMembershipAnnual.titleLabel.font = FONT_OPENSANS_REGULAR(FONT_SIZE_SMALL);
    
dummy_data_monthly:
    {
        if (self.arrayBenefitsMonthly == nil) {
            self.arrayBenefitsMonthly = [NSMutableArray array];
        }
        
        
        NSDictionary *dic1 = [[NSDictionary alloc] initWithObjectsAndKeys:@"Unlimited AgentBridge International Referrals.", @"description", @"1", @"bool", nil];
        
        NSDictionary *dic2 = [[NSDictionary alloc] initWithObjectsAndKeys:@"Unlimited POPs™.", @"description", @"1", @"bool", nil];
        
        NSDictionary *dic3 = [[NSDictionary alloc] initWithObjectsAndKeys:@"Unlimited matches to Buyers.", @"description", @"1", @"bool", nil];
        
        NSDictionary *dic4 = [[NSDictionary alloc] initWithObjectsAndKeys:@"Authorization to use AgentBridge marketing materials for self promotion.", @"description", @"1", @"bool", nil];
        
        
        
        [self.arrayBenefitsMonthly addObject:dic1];
        [self.arrayBenefitsMonthly addObject:dic2];
        [self.arrayBenefitsMonthly addObject:dic3];
        [self.arrayBenefitsMonthly addObject:dic4];
        
        [self.tableViewMonthlyBenefits reloadData];
    }
    
    
dummy_data_quarterly:
    {
        if (self.arrayBenefitsQuarterly == nil) {
            self.arrayBenefitsQuarterly = [NSMutableArray array];
        }
        
        
        NSDictionary *dic1 = [[NSDictionary alloc] initWithObjectsAndKeys:@"Unlimited AgentBridge International Referrals.", @"description", @"1", @"bool", nil];
        
        NSDictionary *dic2 = [[NSDictionary alloc] initWithObjectsAndKeys:@"Unlimited POPs™.", @"description", @"1", @"bool", nil];
        
        NSDictionary *dic3 = [[NSDictionary alloc] initWithObjectsAndKeys:@"Unlimited matches to Buyers.", @"description", @"1", @"bool", nil];
        
        NSDictionary *dic4 = [[NSDictionary alloc] initWithObjectsAndKeys:@"Authorization to use AgentBridge marketing materials for self promotion.", @"description", @"1", @"bool", nil];
        
        
        
        [self.arrayBenefitsQuarterly addObject:dic1];
        [self.arrayBenefitsQuarterly addObject:dic2];
        [self.arrayBenefitsQuarterly addObject:dic3];
        [self.arrayBenefitsQuarterly addObject:dic4];
        
        [self.tableViewQuarterlyBenefits reloadData];
    }
    
    
dummy_data_annual:
    {
        if (self.arrayBenefitsAnnual == nil) {
            self.arrayBenefitsAnnual = [NSMutableArray array];
        }
        
        
        NSDictionary *dic1 = [[NSDictionary alloc] initWithObjectsAndKeys:@"Unlimited AgentBridge International Referrals.", @"description", @"1", @"bool", nil];
        
        NSDictionary *dic2 = [[NSDictionary alloc] initWithObjectsAndKeys:@"Unlimited POPs™.", @"description", @"1", @"bool", nil];
        
        NSDictionary *dic3 = [[NSDictionary alloc] initWithObjectsAndKeys:@"Unlimited matches to Buyers.", @"description", @"1", @"bool", nil];
        
        NSDictionary *dic4 = [[NSDictionary alloc] initWithObjectsAndKeys:@"Authorization to use AgentBridge marketing materials for self promotion.", @"description", @"1", @"bool", nil];
        
        
        
        [self.arrayBenefitsAnnual addObject:dic1];
        [self.arrayBenefitsAnnual addObject:dic2];
        [self.arrayBenefitsAnnual addObject:dic3];
        [self.arrayBenefitsAnnual addObject:dic4];
        
        [self.tableViewAnnualBenefits reloadData];
    }
    
    self.scrollViewPlans.contentSize = CGSizeMake(960.0f, 0.0f);
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
    if (tableView == self.tableViewMonthlyBenefits) {
        return [self.arrayBenefitsMonthly count];
    }
    else if (tableView == self.tableViewQuarterlyBenefits) {
        return [self.arrayBenefitsQuarterly count];
    }
    else {
        return [self.arrayBenefitsAnnual count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *text = @"";
    
    NSArray *arrayData;
    if (tableView == self.tableViewMonthlyBenefits) {
        arrayData = self.arrayBenefitsMonthly;
    }
    else if (tableView == self.tableViewQuarterlyBenefits) {
        arrayData = self.arrayBenefitsQuarterly;
    }
    else {
        arrayData = self.arrayBenefitsAnnual;
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
    else if (tableView == self.tableViewQuarterlyBenefits) {
        arrayData = self.arrayBenefitsQuarterly;
    }
    else {
        arrayData = self.arrayBenefitsAnnual;
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

#pragma 
#pragma mark UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView  {
    if (scrollView.contentOffset.x < 160.0f) {
        [self.pageControl setCurrentPage:0];
    }
    else if (scrollView.contentOffset.x < 480.0f) {
        [self.pageControl setCurrentPage:1];
    }
    else  {
        [self.pageControl setCurrentPage:2];
    }
}


@end
