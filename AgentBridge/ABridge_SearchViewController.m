//
//  ABridge_SearchViewController.m
//  AgentBridge
//
//  Created by host24_iOS Dev on 11/13/13.
//  Copyright (c) 2013 host24_iOS Dev. All rights reserved.
//

#import "ABridge_SearchViewController.h"
#import "ASIHTTPRequest.h"
#import "Constants.h"

@interface ABridge_SearchViewController ()
@property (nonatomic, assign) CGFloat peekLeftAmount;
@property (assign, nonatomic) NSUInteger selectedScope;

@property (strong, nonatomic) NSMutableArray *arrayAgents;
@property (strong, nonatomic) NSMutableArray *arrayPOPs;
@end

@implementation ABridge_SearchViewController
@synthesize peekLeftAmount;
@synthesize selectedScope;
@synthesize arrayAgents;
@synthesize arrayPOPs;

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
    
    self.peekLeftAmount = 50.0f;
    [self.slidingViewController setAnchorLeftPeekAmount:self.peekLeftAmount];
    self.slidingViewController.underRightWidthLayout = ECVariableRevealWidth;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [self.slidingViewController anchorTopViewOffScreenTo:ECLeft animations:^{
        CGRect frame = self.view.frame;
        frame.origin.x = 0.0f;
        if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
            frame.size.width = [UIScreen mainScreen].bounds.size.height;
        } else if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
            frame.size.width = [UIScreen mainScreen].bounds.size.width;
        }
        self.view.frame = frame;
    } onComplete:nil];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [self.slidingViewController anchorTopViewTo:ECLeft animations:^{
        CGRect frame = self.view.frame;
        frame.origin.x = self.peekLeftAmount;
        if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
            frame.size.width = [UIScreen mainScreen].bounds.size.height - self.peekLeftAmount;
        } else if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
            frame.size.width = [UIScreen mainScreen].bounds.size.width - self.peekLeftAmount;
        }
        self.view.frame = frame;
    } onComplete:nil];
}

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope_ {
    self.selectedScope = selectedScope_;
//    [self loadResults];
    
    [self.searchDisplayController.searchResultsTableView reloadData];
}

- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self loadResults];
}

- (void) loadResults {
    NSString *parameters = [NSString stringWithFormat:@"?keyword=%@",self.searchDisplayController.searchBar.text];
    
    if (self.selectedScope == 1) {
        NSMutableString *urlString = [NSMutableString stringWithString:@"http://keydiscoveryinc.com/agent_bridge/webservice/search_pops.php"];
        [urlString appendString:parameters];
        
        self.arrayPOPs = nil;
        __block NSError *errorData = nil;
        __weak ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlString]];
        //            [self.activityIndicator startAnimating];
        //            self.activityIndicator.hidden = NO;
        [request setCompletionBlock:
         ^{
             NSData *responseData = [request responseData];
             NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&errorData];
             
             if ([[json objectForKey:@"data"] count]) {
                 
                 if (self.arrayPOPs == nil) {
                     self.arrayPOPs = [[NSMutableArray alloc] init];
                 }
                 
                 for (NSDictionary *entry in [json objectForKey:@"data"]) {
                     [self.arrayPOPs addObject:[NSDictionary dictionaryWithObjectsAndKeys:[entry valueForKey:@"property_name"], @"name_key", [entry valueForKey:@"listing_id"], @"id_key", nil]];
                 }
                 
             }
             else {
                 
             }
             
             [self.searchDisplayController.searchResultsTableView reloadData];
         }];
        [request setFailedBlock:^{
            NSError *error = [request error];
            NSLog(@" error:%@",error);
        }];
        
        [request startAsynchronous];
    }
    else {
        NSMutableString *urlString = [NSMutableString stringWithString:@"http://keydiscoveryinc.com/agent_bridge/webservice/search_agents.php"];
        [urlString appendString:parameters];
        
        self.arrayAgents = nil;
        __block NSError *errorData = nil;
        __weak ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlString]];
        //            [self.activityIndicator startAnimating];
        //            self.activityIndicator.hidden = NO;
        [request setCompletionBlock:
         ^{
             NSData *responseData = [request responseData];
             NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&errorData];
             
             if ([[json objectForKey:@"data"] count]) {
                 
                 if (self.arrayAgents == nil) {
                     self.arrayAgents = [[NSMutableArray alloc] init];
                 }
                 
                 for (NSDictionary *entry in [json objectForKey:@"data"]) {
                     [self.arrayAgents addObject:[NSDictionary dictionaryWithObjectsAndKeys:[entry valueForKey:@"name"], @"name_key", [entry valueForKey:@"id"], @"id_key", nil]];
                 }
                 
             }
             else {
                 
             }
             
             [self.searchDisplayController.searchResultsTableView reloadData];
         }];
        [request setFailedBlock:^{
            NSError *error = [request error];
            NSLog(@" error:%@",error);
        }];
        
        [request startAsynchronous];
    }
    
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.selectedScope == 1) {
        return [self.arrayPOPs count];
    }
    return [self.arrayAgents count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *text = @"";
    
    // if agent search
    text = [[self.arrayAgents objectAtIndex:[indexPath row]] objectForKey:@"name_key"];
    
    if (self.selectedScope == 1) {
        text = [[self.arrayPOPs objectAtIndex:[indexPath row]] objectForKey:@"name_key"];
    }
    
    
    CGSize constraint = CGSizeMake(tableView.frame.size.width - 20.0f, 20000.0f);
    
    CGSize size = [text sizeWithFont:FONT_OPENSANS_REGULAR(22.0f) constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    
    CGFloat height = MAX(size.height, 22.0f);
    
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"CellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.font = FONT_OPENSANS_REGULAR(22.0f);
        cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        cell.textLabel.numberOfLines = 0;
    }
    
    if (self.selectedScope == 1) {
        cell.textLabel.text = [[self.arrayPOPs objectAtIndex:[indexPath row]] objectForKey:@"name_key"];
    }
    else {
        cell.textLabel.text = [[self.arrayAgents objectAtIndex:[indexPath row]] objectForKey:@"name_key"];
    }
    
    return cell;
}

@end
