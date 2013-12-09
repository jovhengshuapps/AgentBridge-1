//
//  ABridge_ActivityViewController.m
//  AgentBridge
//
//  Created by host24_iOS Dev on 11/14/13.
//  Copyright (c) 2013 host24_iOS Dev. All rights reserved.
//

#import "ABridge_ActivityViewController.h"
#import "ABridge_ActivityPagesViewController.h"
#import "Activity.h"
#import "HTTPURLConnection.h"

@interface ABridge_ActivityViewController ()
@property (weak, nonatomic) IBOutlet UILabel *labelNumberOfActivity;
@property (weak, nonatomic) IBOutlet UIView *viewForPages;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (assign, nonatomic) NSInteger numberOfActivity;
@property (strong, nonatomic) NSURLConnection *urlConnectionActivity;
@property (strong, nonatomic) HTTPURLConnection *urlConnectionActivity11;
@property (strong, nonatomic) HTTPURLConnection *urlConnectionActivity25;
@property (strong, nonatomic) NSMutableData *dataReceived;
@property (strong, nonatomic) LoginDetails *loginDetail;
@property (strong, nonatomic) NSMutableArray *arrayOfActivity;
@property (strong, nonatomic) NSMutableArray *arrayOfURL_11;
@property (strong, nonatomic) NSMutableArray *arrayOfURL_25;
@property (assign, nonatomic) NSInteger index_11;
@property (assign, nonatomic) NSInteger index_25;
@end

@implementation ABridge_ActivityViewController
@synthesize numberOfActivity;
@synthesize urlConnectionActivity;
@synthesize urlConnectionActivity11;
@synthesize urlConnectionActivity25;
@synthesize dataReceived;
@synthesize loginDetail;
@synthesize arrayOfActivity;
@synthesize arrayOfURL_11;
@synthesize arrayOfURL_25;
@synthesize index_11;
@synthesize index_25;

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
    
    self.labelNumberOfActivity.font = FONT_OPENSANS_REGULAR(FONT_SIZE_TITLE);
    self.labelNumberOfActivity.text = @"My Activity";
    [self.labelNumberOfActivity sizeToFit];
    
    CGRect frame = self.activityIndicator.frame;
    frame.origin.x = self.labelNumberOfActivity.frame.origin.x + self.labelNumberOfActivity.frame.size.width + 10.0f;
    self.activityIndicator.frame = frame;
    
    // Add a topBorder.
    CALayer *topBorder = [CALayer layer];
    
    topBorder.frame = CGRectMake(0.0f, 0.0f, self.viewForPages.frame.size.width, 1.0f);
    
    topBorder.backgroundColor = [UIColor colorWithRed:191.0f/255.0f green:191.0f/255.0f blue:191.0f/255.0f alpha:1.0f].CGColor;
    
    [self.viewForPages.layer addSublayer:topBorder];
    
    NSManagedObjectContext *context = ((ABridge_AppDelegate *)[[UIApplication sharedApplication] delegate]).managedObjectContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"LoginDetails"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error = nil;
    NSArray *fetchedObjects = [context
                               executeFetchRequest:fetchRequest error:&error];
    
    self.loginDetail = (LoginDetails*)[fetchedObjects firstObject];
    
    if ([fetchedObjects count] > 0) {
        [self reloadData];
    }
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.arrayOfActivity == nil) {
        [self reloadData];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (ABridge_ActivityPagesViewController *)viewControllerAtIndex:(NSUInteger)index {
    
    ABridge_ActivityPagesViewController *pagesViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ActivityPages"];//[[ABridge_ActivityPagesViewController alloc] initWithNibName:@"ABridge_ActivityPagesViewController" bundle:nil];
    pagesViewController.index = index;
    pagesViewController.activityDetail = (Activity*)[self.arrayOfActivity objectAtIndex:index];
    
    return pagesViewController;
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(ABridge_ActivityPagesViewController *)viewController index];
    
    if (index == 0) {
        return nil;
    }
    
    // Decrease the index by 1 to return
    index--;
    
    return [self viewControllerAtIndex:index];
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(ABridge_ActivityPagesViewController *)viewController index];
    
    index++;
    
    if (index == self.numberOfActivity) {
        return nil;
    }
    
    return [self viewControllerAtIndex:index];
    
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    // The number of items reflected in the page indicator.
    return self.numberOfActivity;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    // The selected item reflected in the page indicator.
    return 0;
}


- (void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse *)response
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    
    if (connection == self.urlConnectionActivity) {
        [self.pageController.view removeFromSuperview];
        [self.pageController removeFromParentViewController];
        self.pageController = nil;
        self.arrayOfActivity = nil;
        self.dataReceived = nil;
        self.dataReceived = [[NSMutableData alloc]init];
    }
    else if ((HTTPURLConnection*)connection == self.urlConnectionActivity11) {
        
        self.urlConnectionActivity11.response = (NSHTTPURLResponse*)response;
        self.urlConnectionActivity11.responseData = [[NSMutableData alloc] init];
    }
    else if ((HTTPURLConnection*)connection == self.urlConnectionActivity25) {
        
        self.urlConnectionActivity25.response = (NSHTTPURLResponse*)response;
        self.urlConnectionActivity25.responseData = [[NSMutableData alloc] init];
    }
    
}
- (void)connection:(NSURLConnection*)connection didReceiveData:(NSData*)data
{
    //NSLog(@"Did Receive Data %@", data);
    if (connection == self.urlConnectionActivity) {
        [self.dataReceived appendData:data];
    }
    else if ((HTTPURLConnection*)connection == self.urlConnectionActivity11) {
        [self.urlConnectionActivity11.responseData appendData:data];
    }
    else if ((HTTPURLConnection*)connection == self.urlConnectionActivity25) {
        [self.urlConnectionActivity25.responseData appendData:data];
    }
}
- (void)connection:(NSURLConnection*)connection didFailWithError:(NSError*)error
{
//    NSLog(@"Did Fail");
//    [self dismissOverlay];
    [self.activityIndicator stopAnimating];
    self.activityIndicator.hidden = YES;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Internet Connection" message:@"You have no Internet Connection available." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
//    [self dismissOverlay];
    
//    NSLog(@"Did Finish:%@", json);
    
    if(connection == self.urlConnectionActivity) {
        NSError *error = nil;
        
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:self.dataReceived options:NSJSONReadingAllowFragments error:&error];
        
        if ([[json objectForKey:@"data"] count]) {
            NSLog(@"total:%i",[[json objectForKey:@"data"] count]);
            for (NSDictionary *entry in [json objectForKey:@"data"]) {
                if ([[entry valueForKey:@"activity_type"] integerValue] == 25) {
                    NSString *parameters = [NSString stringWithFormat:@"?user_id=%@&activities_id=%@", self.loginDetail.user_id, [entry valueForKey:@"activities_id"]];
                    //    NSLog(@"parameters:%@",parameters);
                    NSString *urlString = [NSString stringWithFormat:@"http://keydiscoveryinc.com/agent_bridge/webservice/getactivity-25.php%@",parameters];
                    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
//                    NSLog(@"url:%@",urlString);
                    HTTPURLConnection *HTTP_urlConnectionActivity25 = [[HTTPURLConnection alloc] initWithRequest:urlRequest delegate:self startImmediately:YES];
                    
                    if (self.arrayOfURL_25 == nil) {
                        self.arrayOfURL_25 = [[NSMutableArray alloc] init];
                    }
                    
                    [self.arrayOfURL_25 addObject:HTTP_urlConnectionActivity25];
                    
                }
                else if ([[entry valueForKey:@"activity_type"] integerValue] == 11) {
                    NSString *parameters = [NSString stringWithFormat:@"?user_id=%@&activities_id=%@", self.loginDetail.user_id, [entry valueForKey:@"activities_id"]];
                    //    NSLog(@"parameters:%@",parameters);
                    
                    NSString *urlString = [NSString stringWithFormat:@"http://keydiscoveryinc.com/agent_bridge/webservice/getactivity-11.php%@",parameters];
                    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
//                    NSLog(@"url 11:%@",urlString);
                    
                    HTTPURLConnection *HTTP_urlConnectionActivity11 = [[HTTPURLConnection alloc] initWithRequest:urlRequest delegate:self startImmediately:YES];
                    
                    if (self.arrayOfURL_11 == nil) {
                        self.arrayOfURL_11 = [[NSMutableArray alloc] init];
                    }
                    
                    [self.arrayOfURL_11 addObject:HTTP_urlConnectionActivity11];
                    
                }
            }
            
            NSLog(@"25_:%i, 11_:%i",[self.arrayOfURL_25 count], [self.arrayOfURL_11 count]);
            
            self.index_25 = [self.arrayOfURL_25 count]-1;
            self.urlConnectionActivity25 = [self.arrayOfURL_25 objectAtIndex:self.index_25];
            
            if (self.urlConnectionActivity25) {
                [self.arrayOfURL_25 removeObjectAtIndex:self.index_25];
                self.index_25--;
                [self addURLConnection:self.urlConnectionActivity25];
                //                        NSLog(@"Connection Successful");
                
                //        [self showOverlayWithMessage:@"LOADING" withIndicator:YES];
                
                self.activityIndicator.hidden = NO;
                [self.activityIndicator startAnimating];
            }
            
            self.index_11 = [self.arrayOfURL_11 count]-1;
            self.urlConnectionActivity11 = [self.arrayOfURL_11 objectAtIndex:self.index_11];
            
            if (self.urlConnectionActivity11) {
                [self.arrayOfURL_11 removeObjectAtIndex:self.index_11];
                self.index_11--;
                [self addURLConnection:self.urlConnectionActivity11];
                //                         NSLog(@"Connection Successful");
                
                //        [self showOverlayWithMessage:@"LOADING" withIndicator:YES];
                
                self.activityIndicator.hidden = NO;
                [self.activityIndicator startAnimating];
            }
        }
        else {
            [self.pageController.view removeFromSuperview];
            [self.pageController removeFromParentViewController];
            self.pageController = nil;
            self.numberOfActivity = 0;
            self.labelNumberOfActivity.text = @"My Activity";
            [self.labelNumberOfActivity sizeToFit];
            
            CGRect frame = self.activityIndicator.frame;
            frame.origin.x = self.labelNumberOfActivity.frame.origin.x + self.labelNumberOfActivity.frame.size.width + 10.0f;
            self.activityIndicator.frame = frame;
            
            [self showOverlayWithMessage:@"You currently don't have any Activities." withIndicator:NO];
        }
    }
    else if(connection == self.urlConnectionActivity25) {
        NSError *error = nil;
        
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:self.urlConnectionActivity25.responseData options:NSJSONReadingAllowFragments error:&error];
        
        if ([[json objectForKey:@"data"] count]) {
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSManagedObjectContext *context = ((ABridge_AppDelegate *)[[UIApplication sharedApplication] delegate]).managedObjectContext;
//                for (NSDictionary *entry in [json objectForKey:@"data"]) {
                NSDictionary *entry = [[json objectForKey:@"data"] firstObject];
                    Activity *activity = nil;
                    
                    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"activities_id == %@", [entry objectForKey:@"activities_id"]];
                    NSArray *result = [self fetchObjectsWithEntityName:@"Activity" andPredicate:predicate];
                    if ([result count]) {
                        activity = (Activity*)[result firstObject];
                    }
                    else {
                        activity = [NSEntityDescription insertNewObjectForEntityForName: @"Activity" inManagedObjectContext: context];
                    }
                    
                    [activity setValuesForKeysWithDictionary:entry];
                    
                    //                NSLog(@"activity:%@",activity);
                    NSError *error = nil;
                    if (![context save:&error]) {
                        NSLog(@"Error on saving Activity:%@",[error localizedDescription]);
                    }
                    else {
                        if (self.arrayOfActivity == nil) {
                            self.arrayOfActivity = [[NSMutableArray alloc] init];
                        }
                        
                        [self.arrayOfActivity addObject:activity];
                    }
                    
                    NSLog(@"25 Did Finish:%i   [%i] %i", [self.arrayOfURL_25 count], [self.arrayOfActivity count], self.index_25);
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        self.numberOfActivity = [self.arrayOfActivity count];
                        self.labelNumberOfActivity.text = [NSString stringWithFormat:@"My Activity (%li)",(long)self.numberOfActivity];
                        [self.labelNumberOfActivity sizeToFit];
                        
                        CGRect frame = self.activityIndicator.frame;
                        frame.origin.x = self.labelNumberOfActivity.frame.origin.x + self.labelNumberOfActivity.frame.size.width + 10.0f;
                        self.activityIndicator.frame = frame;
                    });
//                    if (self.pageController == nil && [self.arrayOfActivity count]) {
//                        [self reloadPages];
//                    }
//                }
                
                
                self.urlConnectionActivity25 = nil;
                self.urlConnectionActivity25 = [self.arrayOfURL_25 objectAtIndex:self.index_25];
                
                if (self.urlConnectionActivity25) {
                    [self.arrayOfURL_25 removeObjectAtIndex:self.index_25];
                    self.index_25--;
                    [self addURLConnection:self.urlConnectionActivity25];
                    //                        NSLog(@"Connection Successful");
                    
                    //        [self showOverlayWithMessage:@"LOADING" withIndicator:YES];
                    
                    self.activityIndicator.hidden = NO;
                    [self.activityIndicator startAnimating];
                }
            });
        }
        else {
            NSLog(@"11 json:%@",json);
        }
    }
    else if(connection == self.urlConnectionActivity11) {
        NSError *error = nil;
        
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:self.urlConnectionActivity11.responseData options:NSJSONReadingAllowFragments error:&error];
        if ([[json objectForKey:@"data"] count]) {
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSManagedObjectContext *context = ((ABridge_AppDelegate *)[[UIApplication sharedApplication] delegate]).managedObjectContext;
//                for (NSDictionary *entry in [json objectForKey:@"data"]) {
                NSDictionary *entry = [[json objectForKey:@"data"] firstObject];
                    Activity *activity = nil;
                    
                    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"activities_id == %@", [entry objectForKey:@"activities_id"]];
                    NSArray *result = [self fetchObjectsWithEntityName:@"Activity" andPredicate:predicate];
                    if ([result count]) {
                        activity = (Activity*)[result firstObject];
                    }
                    else {
                        activity = [NSEntityDescription insertNewObjectForEntityForName: @"Activity" inManagedObjectContext: context];
                    }
                    
                    [activity setValuesForKeysWithDictionary:entry];
                    
                    //                NSLog(@"activity:%@",activity);
                    NSError *error = nil;
                    if (![context save:&error]) {
                        NSLog(@"Error on saving Activity:%@",[error localizedDescription]);
                    }
                    else {
                        if (self.arrayOfActivity == nil) {
                            self.arrayOfActivity = [[NSMutableArray alloc] init];
                        }
                        
                        [self.arrayOfActivity addObject:activity];
                    }
                    
                    NSLog(@"11 Did Finish:%i   [%i]%i", [self.arrayOfURL_11 count], [self.arrayOfActivity count],self.index_11);
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        self.numberOfActivity = [self.arrayOfActivity count];
                        self.labelNumberOfActivity.text = [NSString stringWithFormat:@"My Activity (%li)",(long)self.numberOfActivity];
                        [self.labelNumberOfActivity sizeToFit];
                        
                        CGRect frame = self.activityIndicator.frame;
                        frame.origin.x = self.labelNumberOfActivity.frame.origin.x + self.labelNumberOfActivity.frame.size.width + 10.0f;
                        self.activityIndicator.frame = frame;
                    });
//                    if (self.pageController == nil && [self.arrayOfActivity count]) {
//                        [self reloadPages];
//                    }
//                }
                
                self.urlConnectionActivity11 = nil;
                self.urlConnectionActivity11 = [self.arrayOfURL_11 objectAtIndex:self.index_11];
                
                if (self.urlConnectionActivity11) {
                    [self.arrayOfURL_11 removeObjectAtIndex:self.index_11];
                    self.index_11--;
                    [self addURLConnection:self.urlConnectionActivity11];
                    //                        NSLog(@"Connection Successful");
                    
                    //        [self showOverlayWithMessage:@"LOADING" withIndicator:YES];
                    
                    self.activityIndicator.hidden = NO;
                    [self.activityIndicator startAnimating];
                }
            });
        }
        else {
            NSLog(@"11 json:%@",json);
        }
    }
    
    
    [self.activityIndicator stopAnimating];
    self.activityIndicator.hidden = YES;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    // Do something with responseData
}

- (void) reloadPages {
    
    dispatch_async(dispatch_get_main_queue(), ^{
    
        self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        
        self.pageController.dataSource = self;
        CGRect pageControllerFrame = self.viewForPages.frame;
        pageControllerFrame.origin.x = 0.0f;
        pageControllerFrame.origin.y = 1.0f;
        self.pageController.view.frame = pageControllerFrame;
        
        ABridge_ActivityPagesViewController *initialViewController = [self viewControllerAtIndex:0];
        
        NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
        
        [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
        
        [self addChildViewController:self.pageController];
        [[self viewForPages] addSubview:[self.pageController view]];
        [self.pageController didMoveToParentViewController:self];
        
    });
}

- (void) reloadData {
    [self dismissOverlay];
    NSManagedObjectContext *context = ((ABridge_AppDelegate *)[[UIApplication sharedApplication] delegate]).managedObjectContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"LoginDetails"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error = nil;
    NSArray *fetchedObjects = [context
                               executeFetchRequest:fetchRequest error:&error];
    
    self.loginDetail = (LoginDetails*)[fetchedObjects firstObject];
    
    NSString *parameters = [NSString stringWithFormat:@"?user_id=%@", self.loginDetail.user_id];
//    NSLog(@"parameters:%@",parameters);
    self.urlConnectionActivity = [self urlConnectionWithURLString:@"http://keydiscoveryinc.com/agent_bridge/webservice/getactivity.php" andParameters:parameters];
    
    if (self.urlConnectionActivity) {
        [self addURLConnection:self.urlConnectionActivity];
        //        NSLog(@"Connection Successful");
        
        //        [self showOverlayWithMessage:@"LOADING" withIndicator:YES];
        
        self.activityIndicator.hidden = NO;
        [self.activityIndicator startAnimating];
    }
    else {
        //        NSLog(@"Connection Failed");
    }
}

@end
