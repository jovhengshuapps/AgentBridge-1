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
    
    if (self.selectedScope == 1) {
        
        self.arrayPOPs = nil;
        NSArray *fields = [NSArray arrayWithObjects:@"bedroom", @"bedrooms", @"bathroom", @"bathrooms", @"sqft", @"garage", nil];
        NSArray *keywords = [self.searchDisplayController.searchBar.text componentsSeparatedByString:@" "];
        for (NSInteger index = keywords.count-1; index >= 0; index-- ) {
            if ([[keywords objectAtIndex:index] isEqualToString:@""] == NO) {
                
                NSString *parameters = @"";
                NSMutableString *urlString = [NSMutableString stringWithString:@""];
                
                if ([fields containsObject:[keywords objectAtIndex:index]]) {
                    if (index == 0) {
                        
                        parameters = [NSString stringWithFormat:@"?field=%@&keyword=%@",[keywords objectAtIndex:index], @""];
                    }
                    else {
                        parameters = [NSString stringWithFormat:@"?field=%@&keyword=%@",[keywords objectAtIndex:index], [keywords objectAtIndex:index-1]];
                    }
                    
                    [urlString setString:@"http://keydiscoveryinc.com/agent_bridge/webservice/search_pops_by_field.php"];
                    
                    index--;
                }
                else {
                    parameters = [NSString stringWithFormat:@"?keyword=%@",[keywords objectAtIndex:index]];
                    
                    [urlString setString:@"http://keydiscoveryinc.com/agent_bridge/webservice/search_pops.php"];
                }
                
                [urlString appendString:parameters];
//                NSLog(@"url:%@",urlString);
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
                             NSString *imageString = @"";
                             if ([entry valueForKey:@"pops_image"] == nil || [[entry valueForKey:@"pops_image"] isKindOfClass:[NSNull class]]) {
                                 imageString = [self imageStringForPropertyType:[[entry valueForKey:@"property_type"] integerValue] andSubType:[[entry valueForKey:@"sub_type"] integerValue]];
                             }
                             else {
                                 imageString = [entry valueForKey:@"pops_image"];
                             }
                             [self.arrayPOPs addObject:[NSDictionary dictionaryWithObjectsAndKeys:[entry valueForKey:@"property_name"], @"name_key", [entry valueForKey:@"listing_id"], @"id_key", imageString, @"image_key", nil]];
                             
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
        
    }
    else {
        
        NSString *parameters = [NSString stringWithFormat:@"?keyword=%@",self.searchDisplayController.searchBar.text];
        
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
                     [self.arrayAgents addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@ %@",[entry valueForKey:@"firstname"], [entry valueForKey:@"lastname"]], @"name_key", [entry valueForKey:@"user_id"], @"id_key", [entry valueForKey:@"image"], @"image_key", nil]];
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

-(NSString*)imageStringForPropertyType:(NSInteger)property_type andSubType:(NSInteger)sub_type {
    NSMutableString *imageString = [NSMutableString stringWithString:@""];
    switch (property_type) {
        case RESIDENTIAL_PURCHASE:
            [imageString appendString:@"residential-purchase-"];
            break;
        case RESIDENTIAL_LEASE:
            [imageString appendString:@"residential-lease-"];
            break;
        case COMMERCIAL_PURCHASE:
            [imageString appendString:@"commercial-purchase-"];
            break;
        case COMMERCIAL_LEASE:
            [imageString appendString:@"commercial-lease-"];
            break;
        default:
            [imageString appendString:@"residential-purchase-"];
            break;
    }
    switch (sub_type) {
        case RESIDENTIAL_PURCHASE_SFR: case RESIDENTIAL_LEASE_SFR:
            [imageString appendString:@"sfr"];
            break;
        case RESIDENTIAL_PURCHASE_CONDO: case RESIDENTIAL_LEASE_CONDO:
            [imageString appendString:@"condo"];
            break;
        case RESIDENTIAL_PURCHASE_LAND: case RESIDENTIAL_LEASE_LAND:
            [imageString appendString:@"land"];
            break;
        case RESIDENTIAL_PURCHASE_TOWNHOUSE: case RESIDENTIAL_LEASE_TOWNHOUSE:
            [imageString appendString:@"townhouse"];
            break;
            /*case RESIDENTIAL_LEASE_SFR:
             [imageString appendString:@"sfr"];
             break;
             case RESIDENTIAL_LEASE_CONDO:
             [imageString appendString:@"condo"];
             break;
             case RESIDENTIAL_LEASE_LAND:
             [imageString appendString:@"land"];
             break;
             case RESIDENTIAL_LEASE_TOWNHOUSE:
             [imageString appendString:@"townhouse"];
             break;*/
        case COMMERCIAL_PURCHASE_ASSISTED_CARE:
            [imageString appendString:@"assist"];
            break;
        case COMMERCIAL_PURCHASE_INDUSTRIAL: case COMMERCIAL_LEASE_INDUSTRIAL:
            [imageString appendString:@"industrial"];
            break;
        case COMMERCIAL_PURCHASE_MOTEL:
            [imageString appendString:@"motel"];
            break;
        case COMMERCIAL_PURCHASE_MULTI_FAMILY:
            [imageString appendString:@"multi-family"];
            break;
        case COMMERCIAL_PURCHASE_OFFICE: case COMMERCIAL_LEASE_OFFICE:
            [imageString appendString:@"office"];
            break;
        case COMMERCIAL_PURCHASE_RETAIL: case COMMERCIAL_LEASE_RETAIL:
            [imageString appendString:@"retail"];
            break;
        case COMMERCIAL_PURCHASE_SPECIAL_PURPOSE:
            [imageString appendString:@"special"];
            break;
            /*case COMMERCIAL_LEASE_INDUSTRIAL:
             [imageString appendString:@"industrial"];
             break;
             case COMMERCIAL_LEASE_OFFICE:
             [imageString appendString:@"office"];
             break;
             case COMMERCIAL_LEASE_RETAIL:
             [imageString appendString:@"retail"];
             break;*/
        default:
            [imageString appendString:@"sfr"];
            break;
    }
    [imageString appendString:@".png"];
    
    //    //NSLog(@"image:%@",imageString);
    return imageString;
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
        cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        NSString *imageURLString = [[self.arrayPOPs objectAtIndex:[indexPath row]] objectForKey:@"image_key"];
        
        if ([[imageURLString substringToIndex:4] isEqualToString:@"http"] == NO) {
            
            cell.imageView.image = [UIImage imageNamed:imageURLString];
            
        }
        else {
            
                NSData *image_data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageURLString]];
                cell.imageView.image = [UIImage imageWithData:image_data];
        }
    }
    else {
        cell.textLabel.text = [[self.arrayAgents objectAtIndex:[indexPath row]] objectForKey:@"name_key"];
        cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
        if ([[self.arrayAgents objectAtIndex:[indexPath row]] objectForKey:@"image_key"] == nil || [[[self.arrayAgents objectAtIndex:[indexPath row]] objectForKey:@"image_key"] isEqualToString:@""] == YES || [[[self.arrayAgents objectAtIndex:[indexPath row]] objectForKey:@"image_key"] isEqualToString:@"/agent_bridge/templates/agentbridge/images/temp/blank-image.jpg"] == YES) {
            cell.imageView.image = [UIImage imageNamed:@"blank-image.png"];
            
        }
        else {
            
            NSData *image_data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[[self.arrayAgents objectAtIndex:[indexPath row]] objectForKey:@"image_key"]]];
            cell.imageView.image = [UIImage imageWithData:image_data];
        }
    }
    
    
    
    return cell;
}

@end
