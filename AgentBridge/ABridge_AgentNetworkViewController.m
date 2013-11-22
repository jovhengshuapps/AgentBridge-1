//
//  ABridge_AgentNetworkViewController.m
//  AgentBridge
//
//  Created by host24_iOS Dev on 11/19/13.
//  Copyright (c) 2013 host24_iOS Dev. All rights reserved.
//

#import "ABridge_AgentNetworkViewController.h"
#import "ABridge_AgentNetworkPagesViewController.h"
#import "AgentProfile.h"

@interface ABridge_AgentNetworkViewController ()
    @property (weak, nonatomic) IBOutlet UILabel *labelNumberOfAgentNetwork;
    @property (weak, nonatomic) IBOutlet UIView *viewForPages;
    
    @property (assign, nonatomic) NSInteger numberOfAgentNetwork;
    @property (strong, nonatomic) NSURLConnection *urlConnectionAgentNetwork;
    @property (strong, nonatomic) NSMutableData *dataReceived;
@property (strong, nonatomic) NSMutableArray *arrayOfAgents;

@end

@implementation ABridge_AgentNetworkViewController
@synthesize numberOfAgentNetwork;
@synthesize urlConnectionAgentNetwork;
@synthesize dataReceived;
@synthesize arrayOfAgents;

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
    
    self.labelNumberOfAgentNetwork.font = FONT_OPENSANS_REGULAR(20.0f);
    self.slidingViewController.underRightViewController = nil;
    
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
    
    LoginDetails *loginDetail = (LoginDetails*)[fetchedObjects firstObject];
    
    
    NSString *parameters = [NSString stringWithFormat:@"?user_id=%@",loginDetail.user_id];
    
    self.urlConnectionAgentNetwork = [self urlConnectionWithURLString:@"http://keydiscoveryinc.com/agent_bridge/webservice/getuser_network_info.php" andParameters:parameters];
    
    if (self.urlConnectionAgentNetwork) {
//        NSLog(@"Connection Successful");
        [self addURLConnection:self.urlConnectionAgentNetwork];
        [self showOverlayWithMessage:@"LOADING" withIndicator:YES];
    }
    else {
//        NSLog(@"Connection Failed");
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (ABridge_AgentNetworkPagesViewController *)viewControllerAtIndex:(NSUInteger)index {
    
    ABridge_AgentNetworkPagesViewController *pagesViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"NetworkPages"];
    pagesViewController.index = index;
    pagesViewController.profileData = (AgentProfile*)[self.arrayOfAgents objectAtIndex:index];
    
    return pagesViewController;
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(ABridge_AgentNetworkPagesViewController *)viewController index];
    
    if (index == 0) {
        return nil;
    }
    
    // Decrease the index by 1 to return
    index--;
    
    return [self viewControllerAtIndex:index];
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(ABridge_AgentNetworkPagesViewController *)viewController index];
    
    index++;
    
    if (index == self.numberOfAgentNetwork) {
        return nil;
    }
    
    return [self viewControllerAtIndex:index];
    
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    // The number of items reflected in the page indicator.
    return self.numberOfAgentNetwork;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    // The selected item reflected in the page indicator.
    return 0;
}


- (void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse *)response
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    self.arrayOfAgents = nil;
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
//    NSLog(@"Did Fail");
    [self dismissOverlay];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Internet Connection" message:@"You have no Internet Connection available." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSError *error = nil;
    [self dismissOverlay];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:self.dataReceived options:NSJSONReadingAllowFragments error:&error];
    
//    NSLog(@"Did Finish:%@", json);
    
    if ([[json objectForKey:@"data"] count]) {
        
        NSManagedObjectContext *context = ((ABridge_AppDelegate *)[[UIApplication sharedApplication] delegate]).managedObjectContext;
        for (NSDictionary *entry in [json objectForKey:@"data"]) {
            AgentProfile *agent = nil;
            
            NSPredicate * predicate = [NSPredicate predicateWithFormat:@"user_id == %@", [entry objectForKey:@"user_id"]];
            NSArray *result = [self fetchObjectsWithEntityName:@"AgentProfile" andPredicate:predicate];
            if ([result count]) {
                agent = (AgentProfile*)[result firstObject];
            }
            else {
                agent = [NSEntityDescription insertNewObjectForEntityForName: @"AgentProfile" inManagedObjectContext: context];
            }
            
            [agent setValuesForKeysWithDictionary:entry];
            
            NSError *error = nil;
            if (![context save:&error]) {
                NSLog(@"Error on saving Buyer:%@",[error localizedDescription]);
            }
            else {
                if (self.arrayOfAgents == nil) {
                    self.arrayOfAgents = [[NSMutableArray alloc] init];
                }
                
                [self.arrayOfAgents addObject:agent];
            }
        }
        
        self.numberOfAgentNetwork = [self.arrayOfAgents count];
        
        self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        
        self.pageController.dataSource = self;
        CGRect pageControllerFrame = self.viewForPages.frame;
        pageControllerFrame.origin.x = 0.0f;
        pageControllerFrame.origin.y = 1.0f;
        self.pageController.view.frame = pageControllerFrame;
        
        self.labelNumberOfAgentNetwork.text = [NSString stringWithFormat:@"My Network (%li)",(long)self.numberOfAgentNetwork];
        
        ABridge_AgentNetworkPagesViewController *initialViewController = [self viewControllerAtIndex:0];
        
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
        self.numberOfAgentNetwork = 0;
        self.labelNumberOfAgentNetwork.text = [NSString stringWithFormat:@"My Network (%li)",(long)self.numberOfAgentNetwork];
        
        [self showOverlayWithMessage:@"You currently have no members in your Network." withIndicator:NO];
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    // Do something with responseData
}

@end
