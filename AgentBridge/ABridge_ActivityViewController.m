//
//  ABridge_ActivityViewController.m
//  AgentBridge
//
//  Created by host24_iOS Dev on 11/14/13.
//  Copyright (c) 2013 host24_iOS Dev. All rights reserved.
//

#import "ABridge_ActivityViewController.h"
#import "ABridge_ActivityPagesViewController.h"

@interface ABridge_ActivityViewController ()
@property (weak, nonatomic) IBOutlet UILabel *labelNumberOfActivity;
@property (weak, nonatomic) IBOutlet UIView *viewForPages;

@property (assign, nonatomic) NSInteger numberOfActivity;
@property (strong, nonatomic) NSURLConnection *urlConnectionActivity;
@property (strong, nonatomic) NSMutableData *dataReceived;
@property (strong, nonatomic) LoginDetails *loginDetail;
@end

@implementation ABridge_ActivityViewController
@synthesize numberOfActivity;
@synthesize urlConnectionActivity;
@synthesize dataReceived;
@synthesize loginDetail;

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
    
    self.labelNumberOfActivity.font = FONT_OPENSANS_REGULAR(20.0f);
    
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
    
    NSString *parameters = [NSString stringWithFormat:@"?user_id=%@", self.loginDetail.user_id];
    
    self.urlConnectionActivity = [self urlConnectionWithURLString:@"http://keydiscoveryinc.com/agent_bridge/webservice/getactivities.php" andParameters:parameters];
    
    if (self.urlConnectionActivity) {
        [self addURLConnection:self.urlConnectionActivity];
//        NSLog(@"Connection Successful");
        
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


- (ABridge_ActivityPagesViewController *)viewControllerAtIndex:(NSUInteger)index {
    
    ABridge_ActivityPagesViewController *pagesViewController = [[ABridge_ActivityPagesViewController alloc] initWithNibName:@"ABridge_ActivityPagesViewController" bundle:nil];
    pagesViewController.index = index;
    
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
    [self dismissOverlay];
    NSError *error = nil;
    
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:self.dataReceived options:NSJSONReadingAllowFragments error:&error];
    
//    NSLog(@"Did Finish:%@", json);
    
    if ([[json objectForKey:@"data"] count]) {
    
    self.numberOfActivity = [[json objectForKey:@"data"] count];
    
    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
        self.pageController.dataSource = self;
        CGRect pageControllerFrame = self.viewForPages.frame;
        pageControllerFrame.origin.x = 0.0f;
        pageControllerFrame.origin.y = 1.0f;
        self.pageController.view.frame = pageControllerFrame;
        
        
    self.labelNumberOfActivity.text = [NSString stringWithFormat:@"My Activity (%li)",(long)self.numberOfActivity];
    
    ABridge_ActivityPagesViewController *initialViewController = [self viewControllerAtIndex:0];
    
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
        self.numberOfActivity = 0;
        self.labelNumberOfActivity.text = [NSString stringWithFormat:@"My Activity (%li)",(long)self.numberOfActivity];
        
        [self showOverlayWithMessage:@"You currently don't have any Activities." withIndicator:NO];
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    // Do something with responseData
}


@end
