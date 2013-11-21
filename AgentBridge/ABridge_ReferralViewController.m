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

@property (assign, nonatomic) NSInteger numberOfReferral;
@property (strong, nonatomic) NSURLConnection *urlConnectionReferral;
@property (strong, nonatomic) NSMutableData *dataReceived;
@property (strong, nonatomic) LoginDetails *loginDetail;
@property (strong, nonatomic) NSMutableArray *arrayOfReferralOut;
@property (strong, nonatomic) NSMutableArray *arrayOfReferralIn;


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
    
    self.labelNumberOfReferral.font = FONT_OPENSANS_REGULAR(20.0f);
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
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self reloadPageController:@"In"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) reloadPageController:(NSString*)value {
    
    NSString *parameters = [NSString stringWithFormat:@"?user_id=%@",self.loginDetail.user_id];
    
    self.urlConnectionReferral = [self urlConnectionWithURLString:([value isEqualToString:@"In"])?@"http://keydiscoveryinc.com/agent_bridge/webservice/getreferral_in.php":@"http://keydiscoveryinc.com/agent_bridge/webservice/getreferral_out.php" andParameters:parameters];
    
    if (self.urlConnectionReferral) {
        NSLog(@"Connection Successful");
        [self addURLConnection:self.urlConnectionReferral];
    }
    else {
        NSLog(@"Connection Failed");
    }
}

- (ABridge_ReferralPagesViewController *)viewControllerAtIndex:(NSUInteger)index {
    
    ABridge_ReferralPagesViewController *pagesViewController = [[ABridge_ReferralPagesViewController alloc] initWithNibName:@"ABridge_ReferralPagesViewController" bundle:nil];
    pagesViewController.index = index;
    
    if (self.segmentedControl.selectedSegmentIndex) {
        pagesViewController.referralDetails = (Referral*)[self.arrayOfReferralOut objectAtIndex:index];
    }
    else {
        pagesViewController.referralDetails = (Referral*)[self.arrayOfReferralIn objectAtIndex:index];
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
    
    if (index == self.numberOfReferral || self.numberOfReferral == 0) {
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
    self.dataReceived = nil;
    self.dataReceived = [[NSMutableData alloc]init];
}
- (void)connection:(NSURLConnection*)connection didReceiveData:(NSData*)data
{
    //NSLog(@"Did Receive Data %@", data);
    [self.dataReceived appendData:data];
}
- (void)connection:(NSURLConnection*)connection didFailWithError:(NSError*)error
{
    NSLog(@"Did Fail");
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Internet Connection" message:@"You have no Internet Connection available." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSError *error = nil;
    
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:self.dataReceived options:NSJSONReadingAllowFragments error:&error];
    
//    NSLog(@"Did Finish:%@", json);
    
    if ([[json objectForKey:@"data"] count]) {
    
        
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
                NSLog(@"Error on saving Referral:%@",[error localizedDescription]);
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
    
        self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
        self.pageController.dataSource = self;
        CGRect pageControllerFrame = self.viewForPages.frame;
        pageControllerFrame.origin.x = 0.0f;
        pageControllerFrame.origin.y = 1.0f;
        self.pageController.view.frame = pageControllerFrame;
    
        self.labelNumberOfReferral.text = [NSString stringWithFormat:@"My Referrals (%li)",(long)self.numberOfReferral];
    
        ABridge_ReferralPagesViewController *initialViewController = [self viewControllerAtIndex:0];
    
        NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    
        [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
        
        [self addChildViewController:self.pageController];
        [[self viewForPages] addSubview:[self.pageController view]];
        [self.pageController didMoveToParentViewController:self];
        
    
    }
    else {
        [self.pageController.view removeFromSuperview];
        [self.pageController removeFromParentViewController];
        self.pageController = nil;
        self.numberOfReferral = 0;
        self.labelNumberOfReferral.text = [NSString stringWithFormat:@"My Referrals (%li)",(long)self.numberOfReferral];
    }
    
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    // Do something with responseData
}

- (IBAction)segmentedControlChange:(id)sender {
    [self.urlConnectionReferral cancel];
    NSString *value = (((UISegmentedControl*)sender).selectedSegmentIndex)?@"Out":@"In";
    self.arrayOfReferralIn = nil;
    self.arrayOfReferralOut = nil;
    [self reloadPageController:value];
}

-(void)defineSegmentControlStyle
{
    
    [self.segmentedControl setBackgroundImage:[UIImage imageNamed:@"nav_bg.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    [self.segmentedControl setBackgroundImage:[UIImage imageNamed:@"nav_bg_hover.png"] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    
    self.segmentedControl.layer.cornerRadius = 4.0f;
    self.segmentedControl.layer.masksToBounds = YES;
    
    CGRect frame = self.segmentedControl.frame;
    frame.size.height = 24.0f;
    self.segmentedControl.frame = frame;
}

@end
