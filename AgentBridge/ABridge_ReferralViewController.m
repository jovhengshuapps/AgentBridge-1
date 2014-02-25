//
//  ABridge_ReferralViewController.m
//  AgentBridge
//
//  Created by host24_iOS Dev on 11/14/13.
//  Copyright (c) 2013 host24_iOS Dev. All rights reserved.
//

#import "ABridge_ReferralViewController.h"
#import "ABridge_ReferralPagesViewController.h"
#import "Referral.h"

@interface ABridge_ReferralViewController ()
@property (weak, nonatomic) IBOutlet UILabel *labelNumberOfReferral;
@property (weak, nonatomic) IBOutlet UIView *viewForPages;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (assign, nonatomic) NSInteger numberOfReferral;
@property (strong, nonatomic) NSURLConnection *urlConnectionReferral;
@property (strong, nonatomic) NSMutableData *dataReceived;
@property (strong, nonatomic) LoginDetails *loginDetail;
@property (strong, nonatomic) NSMutableArray *arrayOfReferralOut;
@property (strong, nonatomic) NSMutableArray *arrayOfReferralIn;
@property (strong, nonatomic) NSString *scrollToClientId;
@property (assign, nonatomic) BOOL fromActivity;


- (IBAction)segmentedControlChange:(id)sender;
@end

@implementation ABridge_ReferralViewController
@synthesize numberOfReferral;
@synthesize urlConnectionReferral;
@synthesize dataReceived;
@synthesize loginDetail;
@synthesize arrayOfReferralOut;
@synthesize arrayOfReferralIn;

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
    
    self.labelNumberOfReferral.font = FONT_OPENSANS_BOLD(FONT_SIZE_TITLE);
    
    self.labelNumberOfReferral.text = @"My Referrals";
    [self.labelNumberOfReferral sizeToFit];
    
    CGRect frame = self.activityIndicator.frame;
    frame.origin.x = self.labelNumberOfReferral.frame.origin.x + self.labelNumberOfReferral.frame.size.width + 10.0f;
    self.activityIndicator.frame = frame;
    [self defineSegmentControlStyle];
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
    
    
    [self reloadPageController:@"In"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) reloadPageController:(NSString*)value {
    
    NSString *parameters = [NSString stringWithFormat:@"?user_id=%@",self.loginDetail.user_id];
    
    
    __block NSError *errorData = nil;
    __weak ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:([value isEqualToString:@"In"])?@"http://agentbridge.com/webservice/getreferral_in.php%@":@"http://agentbridge.com/webservice/getreferral_out.php%@",parameters]]];
    [self.activityIndicator startAnimating];
    self.activityIndicator.hidden = NO;
    [self.pageController.view removeFromSuperview];
    [self.pageController removeFromParentViewController];
    self.pageController = nil;
    [request setCompletionBlock:^{
        
        if (self.scrollToClientId == nil) {
            self.arrayOfReferralIn = nil;
            self.arrayOfReferralOut = nil;
        }
        else {
            
            if ([value isEqualToString:@"In"]) {
                self.arrayOfReferralIn = nil;
            }
            else {
                self.arrayOfReferralOut = nil;
            }
        }
        // Use when fetching text data
        //                        NSString *responseString = [request responseString];
        // Use when fetching binary data
        NSData *responseData = [request responseData];
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&errorData];
        
        [self dismissOverlay];
            if ([[json objectForKey:@"data"] count]) {
                
                NSLog(@"json:%@",json);
                NSManagedObjectContext *context = ((ABridge_AppDelegate *)[[UIApplication sharedApplication] delegate]).managedObjectContext;
                for (NSDictionary *entry in [json objectForKey:@"data"]) {
                    Referral *referral = nil;
                    
                    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"referral_id == %@", [entry objectForKey:@"referral_id"]];
                    NSArray *result = [self fetchObjectsWithEntityName:@"Referral" andPredicate:predicate];
                    if ([result count]) {
                        referral = (Referral*)[result firstObject];
                    }
                    else {
                        referral = [NSEntityDescription insertNewObjectForEntityForName: @"Referral" inManagedObjectContext: context];
                    }
                    
                    [referral setValuesForKeysWithDictionary:entry];
                    
                    NSError *error = nil;
                    if (![context save:&error]) {
                        //NSLog(@"Error on saving Referral:%@",[error localizedDescription]);
                    }
                    else {
                        if (self.segmentedControl.selectedSegmentIndex) {
                            
                            if (self.arrayOfReferralOut == nil) {
                                self.arrayOfReferralOut = [[NSMutableArray alloc] init];
                            }
                            
                            [self.arrayOfReferralOut addObject:referral];
                        }
                        else {
                            
                            if (self.arrayOfReferralIn == nil) {
                                self.arrayOfReferralIn = [[NSMutableArray alloc] init];
                            }
                            
                            [self.arrayOfReferralIn addObject:referral];
                        }
                    }
                }
                
                if (self.segmentedControl.selectedSegmentIndex) {
                    self.numberOfReferral = [self.arrayOfReferralOut count];
                }
                else {
                    self.numberOfReferral = [self.arrayOfReferralIn count];
                }
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self.pageController.view removeFromSuperview];
                    [self.pageController removeFromParentViewController];
                    self.pageController = nil;
                    
                    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
                    
                    self.pageController.dataSource = self;
                    CGRect pageControllerFrame = self.viewForPages.frame;
                    pageControllerFrame.origin.x = 0.0f;
                    pageControllerFrame.origin.y = 1.0f;
                    self.pageController.view.frame = pageControllerFrame;
                    
                    self.labelNumberOfReferral.text = [NSString stringWithFormat:@"My Referrals (%li)",(long)self.numberOfReferral];
                    [self.labelNumberOfReferral sizeToFit];
                    
                    CGRect frame = self.activityIndicator.frame;
                    frame.origin.x = self.labelNumberOfReferral.frame.origin.x + self.labelNumberOfReferral.frame.size.width + 10.0f;
                    self.activityIndicator.frame = frame;
                    
                    ABridge_ReferralPagesViewController *initialViewController = [self viewControllerAtIndex:0];
                    
                    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
                    
                    [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
                    
                    [self addChildViewController:self.pageController];
                    [[self viewForPages] addSubview:[self.pageController view]];
                    [self.pageController didMoveToParentViewController:self];
                    
                    
                    if(self.scrollToClientId == nil) {
                        if (self.segmentedControl.selectedSegmentIndex == 0) {
                            [self scrollToReferralIn:@"load"];
                        }
                        else {
                            [self scrollToReferralOut:@"load"];
                        }
                    }
                    
                    [self.activityIndicator stopAnimating];
                    self.activityIndicator.hidden = YES;
                });
                
            }
            
            else {
                [self.pageController.view removeFromSuperview];
                [self.pageController removeFromParentViewController];
                self.pageController = nil;
                self.numberOfReferral = 0;
                self.labelNumberOfReferral.text = @"My Referrals";
                [self.labelNumberOfReferral sizeToFit];
                
                CGRect frame = self.activityIndicator.frame;
                frame.origin.x = self.labelNumberOfReferral.frame.origin.x + self.labelNumberOfReferral.frame.size.width + 10.0f;
                self.activityIndicator.frame = frame;
                if (self.segmentedControl.selectedSegmentIndex) {
                    [self showOverlayWithMessage:@"You currently don't have any outgoing Referrals." withIndicator:NO];
                }
                else {
                    [self showOverlayWithMessage:@"You currently don't have any incoming Referrals." withIndicator:NO];
                }
                [self.activityIndicator stopAnimating];
                self.activityIndicator.hidden = YES;
            }
        
    }];
    [request setFailedBlock:^{
        NSError *error = [request error];
        NSLog(@" error:%@",error);
    }];
    
    [request startAsynchronous];
    
//    self.urlConnectionReferral = [self urlConnectionWithURLString:([value isEqualToString:@"In"])?@"http://agentbridge.com/webservice/getreferral_in.php":@"http://agentbridge.com/webservice/getreferral_out.php" andParameters:parameters];
//
//    if (self.urlConnectionReferral) {
////        //NSLog(@"Connection Successful");
//        [self addURLConnection:self.urlConnectionReferral];
////        [self showOverlayWithMessage:@"LOADING" withIndicator:YES];
//        self.activityIndicator.hidden = NO;
//        [self.activityIndicator startAnimating];
//    }
//    else {
////        //NSLog(@"Connection Failed");
//    }
}

- (ABridge_ReferralPagesViewController *)viewControllerAtIndex:(NSUInteger)index {
    
    ABridge_ReferralPagesViewController *pagesViewController = [[ABridge_ReferralPagesViewController alloc] initWithNibName:@"ABridge_ReferralPagesViewController" bundle:nil];
    pagesViewController.index = index;
    
    
    if (self.segmentedControl.selectedSegmentIndex) {
        self.numberOfReferral = [self.arrayOfReferralOut count];
    }
    else {
        self.numberOfReferral = [self.arrayOfReferralIn count];
    }
    
    self.labelNumberOfReferral.text = [NSString stringWithFormat:@"My Referrals (%li)",(long)self.numberOfReferral];
    [self.labelNumberOfReferral sizeToFit];
    
    CGRect frame = self.activityIndicator.frame;
    frame.origin.x = self.labelNumberOfReferral.frame.origin.x + self.labelNumberOfReferral.frame.size.width + 10.0f;
    self.activityIndicator.frame = frame;
    
    if (self.segmentedControl.selectedSegmentIndex) {
        pagesViewController.referralDetails = (Referral*)[self.arrayOfReferralOut objectAtIndex:index];
        pagesViewController.isReferralOut = YES;
    }
    else {
        pagesViewController.referralDetails = (Referral*)[self.arrayOfReferralIn objectAtIndex:index];
        pagesViewController.isReferralOut = NO;
    }
    
    return pagesViewController;
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(ABridge_ReferralPagesViewController *)viewController index];
    
    if (index == 0) {
        return nil;
    }
    
    // Decrease the index by 1 to return
    index--;
    
    return [self viewControllerAtIndex:index];
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(ABridge_ReferralPagesViewController *)viewController index];
    
    index++;
    
    if (index >= self.numberOfReferral || self.numberOfReferral == 0) {
        return nil;
    }
    
    return [self viewControllerAtIndex:index];
    
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    // The number of items reflected in the page indicator.
    return self.numberOfReferral;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    // The selected item reflected in the page indicator.
    return 0;
}


- (void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse *)response
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self.pageController.view removeFromSuperview];
    [self.pageController removeFromParentViewController];
    self.pageController = nil;
    self.arrayOfReferralIn = nil;
    self.arrayOfReferralOut = nil;
    self.dataReceived = nil;
    self.dataReceived = [[NSMutableData alloc]init];
}
- (void)connection:(NSURLConnection*)connection didReceiveData:(NSData*)data
{
    ////NSLog(@"Did Receive Data %@", data);
    [self.dataReceived appendData:data];
}
- (void)connection:(NSURLConnection*)connection didFailWithError:(NSError*)error
{
//    //NSLog(@"Did Fail");
    [self dismissOverlay];
    [self.activityIndicator stopAnimating];
    self.activityIndicator.hidden = YES;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Internet Connection" message:@"You have no Internet Connection available." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
//    NSError *error = nil;
//    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:self.dataReceived options:NSJSONReadingAllowFragments error:&error];
//    
//    //NSLog(@"Did Finish:%@", json);
    
//    if ([[json objectForKey:@"data"] count]) {
//    
//        
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            NSManagedObjectContext *context = ((ABridge_AppDelegate *)[[UIApplication sharedApplication] delegate]).managedObjectContext;
//            for (NSDictionary *entry in [json objectForKey:@"data"]) {
//                Referral *referral = nil;
//                
//                NSPredicate * predicate = [NSPredicate predicateWithFormat:@"referral_id == %@", [entry objectForKey:@"referral_id"]];
//                NSArray *result = [self fetchObjectsWithEntityName:@"Referral" andPredicate:predicate];
//                if ([result count]) {
//                    referral = (Referral*)[result firstObject];
//                }
//                else {
//                    referral = [NSEntityDescription insertNewObjectForEntityForName: @"Referral" inManagedObjectContext: context];
//                }
//                
//                [referral setValuesForKeysWithDictionary:entry];
//                
//                NSError *error = nil;
//                if (![context save:&error]) {
//                    //NSLog(@"Error on saving Referral:%@",[error localizedDescription]);
//                }
//                else {
//                    if (self.segmentedControl.selectedSegmentIndex) {
//                        
//                        if (self.arrayOfReferralOut == nil) {
//                            self.arrayOfReferralOut = [[NSMutableArray alloc] init];
//                        }
//                        
//                        [self.arrayOfReferralOut addObject:referral];
//                    }
//                    else {
//                        
//                        if (self.arrayOfReferralIn == nil) {
//                            self.arrayOfReferralIn = [[NSMutableArray alloc] init];
//                        }
//                        
//                        [self.arrayOfReferralIn addObject:referral];
//                    }
//                }
//            }
//            
//            if (self.segmentedControl.selectedSegmentIndex) {
//                self.numberOfReferral = [self.arrayOfReferralOut count];
//            }
//            else {
//                self.numberOfReferral = [self.arrayOfReferralIn count];
//            }
//            
//            
//            dispatch_async(dispatch_get_main_queue(), ^{
//                self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
//                
//                self.pageController.dataSource = self;
//                CGRect pageControllerFrame = self.viewForPages.frame;
//                pageControllerFrame.origin.x = 0.0f;
//                pageControllerFrame.origin.y = 1.0f;
//                self.pageController.view.frame = pageControllerFrame;
//                
//                self.labelNumberOfReferral.text = [NSString stringWithFormat:@"My Referrals (%li)",(long)self.numberOfReferral];
//                [self.labelNumberOfReferral sizeToFit];
//                
//                CGRect frame = self.activityIndicator.frame;
//                frame.origin.x = self.labelNumberOfReferral.frame.origin.x + self.labelNumberOfReferral.frame.size.width + 10.0f;
//                self.activityIndicator.frame = frame;
//                
//                ABridge_ReferralPagesViewController *initialViewController = [self viewControllerAtIndex:0];
//                
//                NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
//                
//                [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
//                
//                [self addChildViewController:self.pageController];
//                [[self viewForPages] addSubview:[self.pageController view]];
//                [self.pageController didMoveToParentViewController:self];
//                
//                
//                if(self.scrollToClientId == nil) {
//                    if (self.segmentedControl.selectedSegmentIndex == 0) {
//                        [self scrollToReferralIn:@"load"];
//                    }
//                    else {
//                        [self scrollToReferralOut:@"load"];
//                    }
//                }
//
//            });
//        });
//        [self dismissOverlay];
//    }
//    else {
//        [self.pageController.view removeFromSuperview];
//        [self.pageController removeFromParentViewController];
//        self.pageController = nil;
//        self.numberOfReferral = 0;
//        self.labelNumberOfReferral.text = @"My Referrals";
//        [self.labelNumberOfReferral sizeToFit];
//        
//        CGRect frame = self.activityIndicator.frame;
//        frame.origin.x = self.labelNumberOfReferral.frame.origin.x + self.labelNumberOfReferral.frame.size.width + 10.0f;
//        self.activityIndicator.frame = frame;
//        if (self.segmentedControl.selectedSegmentIndex) {
//            [self showOverlayWithMessage:@"You currently don't have any outgoing Referrals." withIndicator:NO];
//        }
//        else {
//            [self showOverlayWithMessage:@"You currently don't have any incoming Referrals." withIndicator:NO];
//        }
//    }
//    
//    [self.activityIndicator stopAnimating];
//    self.activityIndicator.hidden = YES;
//    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    // Do something with responseData
}

- (IBAction)segmentedControlChange:(id)sender {
    //NSLog(@"change");
//    if (self.fromActivity == NO) {
        [self.urlConnectionReferral cancel];
        NSString *value = (((UISegmentedControl*)sender).selectedSegmentIndex)?@"Out":@"In";
        self.arrayOfReferralIn = nil;
        self.arrayOfReferralOut = nil;
        [self reloadPageController:value];
//    }
//    self.fromActivity = NO;
}

-(void)defineSegmentControlStyle
{
    
    [self.segmentedControl setBackgroundImage:[UIImage imageNamed:@"nav_bg.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    [self.segmentedControl setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                  [UIColor colorWithWhite:1.0f alpha:1.0f], UITextAttributeTextColor,
                                                  [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0], UITextAttributeTextShadowColor,
                                                  [NSValue valueWithUIOffset:UIOffsetMake(0, 0.5f)], UITextAttributeTextShadowOffset,
                                                  FONT_OPENSANS_REGULAR(FONT_SIZE_SMALL), UITextAttributeFont,
                                                   nil]  forState:UIControlStateNormal];
    
    [self.segmentedControl setBackgroundImage:[UIImage imageNamed:@"nav_bg_hover_light.png"] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    
    [self.segmentedControl setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                   [UIColor colorWithRed:44.0f/255.0f green:153.0f/255.0f blue:206.0f/255.0f alpha:1.0], UITextAttributeTextColor,
                                                   [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0], UITextAttributeTextShadowColor,
                                                   [NSValue valueWithUIOffset:UIOffsetMake(0, 0.5f)], UITextAttributeTextShadowOffset,
                                                   FONT_OPENSANS_REGULAR(FONT_SIZE_SMALL), UITextAttributeFont,
                                                   nil]  forState:UIControlStateSelected];
    
    [self.segmentedControl setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor darkGrayColor],NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    
    self.segmentedControl.layer.cornerRadius = 4.0f;
    self.segmentedControl.layer.masksToBounds = YES;
    
//    CGRect frame = self.segmentedControl.frame;
//    frame.size.height = 24.0f;
//    self.segmentedControl.frame = frame;
}


-(void) scrollToReferralIn:(NSString *)client_id {
    
    [self dismissOverlay];
    self.scrollToClientId = client_id;
    
    if ([self.arrayOfReferralIn count] == 0) {
        
        [self.pageController.view removeFromSuperview];
        [self.pageController removeFromParentViewController];
        self.pageController = nil;
        [self reloadPageController:@"In"];
    }
    
//    self.fromActivity = YES;
    [self.segmentedControl setSelectedSegmentIndex:0];
    
//    NSString *value = (self.segmentedControl.selectedSegmentIndex)?@"Out":@"In";
//    self.arrayOfReferralIn = nil;
//    self.arrayOfReferralOut = nil;
//    [self reloadPageController:value];
    
    
    
    
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"client_id == %@ AND agent_b == %@", client_id, self.loginDetail.user_id];

    NSArray *result = [self fetchObjectsWithEntityName:@"Referral" andPredicate:predicate];
    if ([result count]) {
        Referral *client = (Referral*)[result firstObject];
        NSInteger index = 0;
        
        if (![client_id isEqualToString:@"load"]) {
            index = [self.arrayOfReferralIn indexOfObject:client];
        }
        
        ABridge_ReferralPagesViewController *initialViewController = [self viewControllerAtIndex:index];
        
        NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
        
        [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
        
        
    }
}


-(void) scrollToReferralOut:(NSString *)client_id {
    
    [self dismissOverlay];
    self.scrollToClientId = client_id;
    
    if ([self.arrayOfReferralOut count] == 0) {
        
        [self.pageController.view removeFromSuperview];
        [self.pageController removeFromParentViewController];
        self.pageController = nil;
        [self reloadPageController:@"Out"];
    }
    
//    self.fromActivity = YES;
    [self.segmentedControl setSelectedSegmentIndex:1];
    
//    NSString *value = (self.segmentedControl.selectedSegmentIndex)?@"Out":@"In";
//    self.arrayOfReferralIn = nil;
//    self.arrayOfReferralOut = nil;
//    [self reloadPageController:value];
    
    
    
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"client_id == %@ AND agent_a == %@", client_id, self.loginDetail.user_id];
    
    NSArray *result = [self fetchObjectsWithEntityName:@"Referral" andPredicate:predicate];
    if ([result count]) {
        Referral *client = (Referral*)[result firstObject];
        NSInteger index = 0;
        
        if (![client_id isEqualToString:@"load"]) {
            index = [self.arrayOfReferralOut indexOfObject:client];
        }
        
        
        ABridge_ReferralPagesViewController *initialViewController = [self viewControllerAtIndex:index];
        
        NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
        
        [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
        
    }
}

@end
