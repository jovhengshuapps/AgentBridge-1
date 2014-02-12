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

#import "ABridge_ActivityAgentProfileViewController.h"
#import "UIImage+ImageResize.h"
#import "ABridge_ActivityAgentPOPsViewController.h"

@interface ABridge_SearchViewController ()
@property (nonatomic, assign) CGFloat peekLeftAmount;
@property (assign, nonatomic) NSUInteger selectedScope;

@property (strong, nonatomic) NSMutableArray *arrayAgents;
@property (strong, nonatomic) NSMutableArray *arrayPOPs;
@property (strong, nonatomic) NSTimer* timer;
@property (strong, nonatomic) UIView *viewOverlay;
@property (assign, nonatomic) NSInteger login_user_id;
@property (strong, nonatomic) NSString *agent_name;
@end

@implementation ABridge_SearchViewController
@synthesize peekLeftAmount;
@synthesize selectedScope;
@synthesize arrayAgents;
@synthesize arrayPOPs;
@synthesize viewOverlay;
@synthesize timer;
@synthesize login_user_id;
@synthesize agent_name;

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
    
    self.searchDisplayController.searchBar.showsScopeBar = YES;
    
    
    self.viewOverlay = [[UIView alloc] initWithFrame:CGRectMake(10.0f, 10.0f, 50.0f, 50.0f)];
    self.viewOverlay.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.0f];
    self.viewOverlay.layer.cornerRadius = 10.0f;
    self.viewOverlay.layer.masksToBounds = YES;
    
    CGPoint center = self.view.center;
    self.viewOverlay.center = center;
    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    activityIndicator.frame = CGRectMake(15.0, 15.0f, 20.0f, 20.0f);
    activityIndicator.hidden = NO;
        [activityIndicator startAnimating];
        
        [self.viewOverlay addSubview:activityIndicator];

    
    [self.view addSubview:self.viewOverlay];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(checkIfLoading) userInfo:nil repeats:YES];
    
    NSManagedObjectContext *context = ((ABridge_AppDelegate *)[[UIApplication sharedApplication] delegate]).managedObjectContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"LoginDetails"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    self.login_user_id = [[[fetchedObjects firstObject] valueForKey:@"user_id"] integerValue];
    self.agent_name = [[[[fetchedObjects firstObject] valueForKey:@"name"] componentsSeparatedByString:@" "] firstObject];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) checkIfLoading {
    if ([UIApplication sharedApplication].networkActivityIndicatorVisible) {
        self.viewOverlay.hidden = NO;
    }
    else {
        self.viewOverlay.hidden = YES;
        [timer invalidate];
    }
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
    
    searchBar.showsScopeBar = YES;
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
    
    searchBar.showsScopeBar = YES;
    [searchBar sizeToFit];
}

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope_ {
    searchBar.showsScopeBar = YES;
    self.selectedScope = selectedScope_;
//    [self loadResults];

    self.arrayPOPs = nil;
    self.arrayAgents = nil;
    
    [self.searchDisplayController.searchResultsTableView reloadData];
}

- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    searchBar.showsScopeBar = YES;
    [self loadResults];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    searchBar.showsScopeBar = YES;
    [searchBar sizeToFit];
}

- (void) loadResults {
    
    self.viewOverlay.hidden = NO;
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
                    parameters = [NSString stringWithFormat:@"?keyword=%@&user_id=%i",[keywords objectAtIndex:index],self.login_user_id];
                    
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
                     
//                    NSLog(@"jsonSearch:%@",json);
                     if ([[json objectForKey:@"data"] count]) {
                         
                         if (self.arrayPOPs == nil) {
                             self.arrayPOPs = [[NSMutableArray alloc] init];
                         }
                         
                         for (NSDictionary *entry in [json objectForKey:@"data"]) {
                             NSString *imageString = @"";
                             
                             if (self.login_user_id == [[entry valueForKey:@"user_id"] integerValue] || ([[json objectForKey:@"network_status"] integerValue] == 1 && [[json objectForKey:@"access_status"] integerValue] == 1)) {
                                 
                                 if ([entry valueForKey:@"pops_image"] == nil || [[entry valueForKey:@"pops_image"] isKindOfClass:[NSNull class]]) {
                                     imageString = [self imageStringForPropertyType:[[entry valueForKey:@"property_type"] integerValue] andSubType:[[entry valueForKey:@"sub_type"] integerValue]];
                                 }
                                 else {
                                     imageString = [entry valueForKey:@"pops_image"];
                                 }
                             }
                             else {
                                 imageString = [self imageStringForPropertyType:[[entry valueForKey:@"property_type"] integerValue] andSubType:[[entry valueForKey:@"sub_type"] integerValue]];
                                 imageString = [imageString stringByReplacingOccurrencesOfString:@".png" withString:@"_bw.png"];
                             }
                             
                             
                             [self.arrayPOPs addObject:[NSDictionary dictionaryWithObjectsAndKeys:[entry valueForKey:@"property_name"], @"name_key", [entry valueForKey:@"listing_id"], @"id_key",[entry valueForKey:@"user_id"], @"user_id_key", [entry valueForKey:@"agent_name"], @"agent_name_key", imageString, @"image_key",[json objectForKey:@"network_status"],@"network_key", [json objectForKey:@"access_status"],@"access_key", nil]];
                             
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
                     [self.arrayAgents addObject:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@ %@",[entry valueForKey:@"firstname"], [entry valueForKey:@"lastname"]], @"name_key", [entry valueForKey:@"unique_id"], @"id_key", [entry valueForKey:@"image"], @"image_key", nil]];
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
    
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(checkIfLoading) userInfo:nil repeats:YES];
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
    tableView.backgroundColor = [UIColor clearColor];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    CGRect frame = self.searchDisplayController.searchResultsTableView.frame;
    frame.size.height = 360.0f;
    frame.origin.x = 10.0f;
    self.searchDisplayController.searchResultsTableView.frame = frame;
    
    
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
    
    CGSize size = [text sizeWithFont:FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR) constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    
    CGFloat height = MAX(size.height, 44.0f);
    
    return height + 2.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"CellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
        cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.backgroundColor = [UIColor clearColor];
        
    }
    
    if (self.selectedScope == 1) {
        cell.textLabel.text = [[self.arrayPOPs objectAtIndex:[indexPath row]] objectForKey:@"name_key"];
        cell.imageView.contentMode = UIViewContentModeRedraw;
        
        NSString *imageURLString = [[self.arrayPOPs objectAtIndex:[indexPath row]] objectForKey:@"image_key"];
        
        if ([[imageURLString substringToIndex:4] isEqualToString:@"http"] == NO) {
            
            cell.imageView.image = [[UIImage imageNamed:imageURLString] imageByScalingAndCroppingForSize:CGSizeMake(44.0f, 44.0f)];
            
        }
        else {
            
                NSData *image_data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageURLString]];
             UIImage *image =[UIImage imageWithData:image_data];
                cell.imageView.image = [image imageByScalingAndCroppingForSize:CGSizeMake(44.0f, 44.0f)];
        }
        
    }
    else {
        cell.textLabel.text = [[self.arrayAgents objectAtIndex:[indexPath row]] objectForKey:@"name_key"];
        
        if ([[self.arrayAgents objectAtIndex:[indexPath row]] objectForKey:@"image_key"] == nil || [[[self.arrayAgents objectAtIndex:[indexPath row]] objectForKey:@"image_key"] isEqualToString:@""] == YES || [[[self.arrayAgents objectAtIndex:[indexPath row]] objectForKey:@"image_key"] isEqualToString:@"/agent_bridge/templates/agentbridge/images/temp/blank-image.jpg"] == YES) {
            cell.imageView.image = [[UIImage imageNamed:@"blank-image.png"] imageByScalingAndCroppingForSize:CGSizeMake(44.0f, 44.0f)];
            
        }
        else {
            
            NSData *image_data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[[self.arrayAgents objectAtIndex:[indexPath row]] objectForKey:@"image_key"]]];
            UIImage *image =[UIImage imageWithData:image_data];
            
            cell.imageView.image = [image imageByScalingAndCroppingForSize:CGSizeMake(44.0f, 44.0f)];
            
        }
        
    }
    
    
    return cell;
}

#pragma
#pragma mark UITableView Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selectedScope == 1) {
        NSString * pops_user_id = [[self.arrayPOPs objectAtIndex:[indexPath row]] objectForKey:@"user_id_key"];
        
        
//        if(self.login_user_id == [pops_user_id integerValue]) {
            ABridge_ActivityAgentPOPsViewController *popsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ActivityAgentPOPs"];
            popsViewController.user_id = pops_user_id;
            popsViewController.listing_id = [[self.arrayPOPs objectAtIndex:[indexPath row]] objectForKey:@"id_key"];
            popsViewController.fromSearch = YES;
            popsViewController.user_name = [[self.arrayPOPs objectAtIndex:[indexPath row]] objectForKey:@"agent_name_key"];
            
            CATransition *transition = [CATransition animation];
            transition.duration = 0.4;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            transition.type = kCATransitionPush;
            transition.subtype = kCATransitionFromRight;
            [self.view.window.layer addAnimation:transition forKey:nil];
            
            [self presentViewController:popsViewController animated:NO completion:^{
                
            }];
//        }
        
        
        
    }
    else {
        
        ABridge_ActivityAgentProfileViewController *profileViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ActivityAgentProfile"];
        profileViewController.user_id = [[self.arrayAgents objectAtIndex:[indexPath row]] objectForKey:@"id_key"];
        profileViewController.fromSearch = YES;
        
        CATransition *transition = [CATransition animation];
        transition.duration = 0.4;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromRight;
        [self.view.window.layer addAnimation:transition forKey:nil];
        
        [self presentViewController:profileViewController animated:NO completion:^{
            
        }];
        
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
