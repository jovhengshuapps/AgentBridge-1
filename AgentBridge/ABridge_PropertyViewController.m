//
//  ABridge_PropertyViewController.m
//  AgentBridge
//
//  Created by host24_iOS Dev on 11/13/13.
//  Copyright (c) 2013 host24_iOS Dev. All rights reserved.
//

#import "ABridge_PropertyViewController.h"
#import "ABridge_PropertyPagesViewController.h"
#import "Property.h"

@interface ABridge_PropertyViewController ()
@property (weak, nonatomic) IBOutlet UILabel *labelNumberOfProperty;
@property (weak, nonatomic) IBOutlet UIView *viewForPages;
@property (weak, nonatomic) IBOutlet UIButton *buttonSave;

@property (assign, nonatomic) NSInteger numberOfProperty;
@property (strong, nonatomic) NSURLConnection *urlConnectionProperty;
@property (strong, nonatomic) NSMutableData *dataReceived;
@property (strong, nonatomic) LoginDetails *loginDetail;
@property (strong, nonatomic) NSMutableArray *arrayOfProperty;
@end

@implementation ABridge_PropertyViewController
@synthesize numberOfProperty;
@synthesize urlConnectionProperty;
@synthesize dataReceived;
@synthesize loginDetail;
@synthesize arrayOfProperty;

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
    
    self.labelNumberOfProperty.font = FONT_OPENSANS_REGULAR(20.0f);
    
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
    
    NSString *parameters = [NSString stringWithFormat:@"?user_id=%@",self.loginDetail.user_id];
    
    self.urlConnectionProperty = [self urlConnectionWithURLString:@"http://keydiscoveryinc.com/agent_bridge/webservice/getpops.php" andParameters:parameters];
    
    if (self.urlConnectionProperty) {
//        NSLog(@"Connection Successful");
        [self addURLConnection:self.urlConnectionProperty];
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


- (ABridge_PropertyPagesViewController *)viewControllerAtIndex:(NSUInteger)index {
    
    ABridge_PropertyPagesViewController *pagesViewController = [[ABridge_PropertyPagesViewController alloc] initWithNibName:@"ABridge_PropertyPagesViewController" bundle:nil];
    pagesViewController.index = index;
    pagesViewController.propertyDetails = (Property*)[self.arrayOfProperty objectAtIndex:index];
    
    return pagesViewController;
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(ABridge_PropertyPagesViewController *)viewController index];
    
    if (index == 0) {
        return nil;
    }
    
    // Decrease the index by 1 to return
    index--;
    
    return [self viewControllerAtIndex:index];
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(ABridge_PropertyPagesViewController *)viewController index];
    
    index++;
    
    if (index == self.numberOfProperty) {
        return nil;
    }
    
    return [self viewControllerAtIndex:index];
    
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    // The number of items reflected in the page indicator.
    return self.numberOfProperty;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    // The selected item reflected in the page indicator.
    return 0;
}


- (void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse *)response
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    self.arrayOfProperty = nil;
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
            Property *property = nil;
            
            NSPredicate * predicate = [NSPredicate predicateWithFormat:@"listing_id == %@", [entry objectForKey:@"listing_id"]];
            NSArray *result = [self fetchObjectsWithEntityName:@"Property" andPredicate:predicate];
            if ([result count]) {
                property = (Property*)[result firstObject];
            }
            else {
                property = [NSEntityDescription insertNewObjectForEntityForName: @"Property" inManagedObjectContext: context];
            }
            
            [property setValuesForKeysWithDictionary:entry];
            
            NSError *error = nil;
            if (![context save:&error]) {
                NSLog(@"Error on saving Property:%@",[error localizedDescription]);
            }
            else {
                if (self.arrayOfProperty == nil) {
                    self.arrayOfProperty = [[NSMutableArray alloc] init];
                }
                
                [self.arrayOfProperty addObject:property];
            }
        }
    
        self.numberOfProperty = [self.arrayOfProperty count];
        
        self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        
        self.pageController.dataSource = self;
        CGRect pageControllerFrame = self.viewForPages.frame;
        pageControllerFrame.origin.x = 0.0f;
        pageControllerFrame.origin.y = 1.0f;
        self.pageController.view.frame = pageControllerFrame;
        
        self.labelNumberOfProperty.text = [NSString stringWithFormat:@"My POPs™ (%li)",(long)self.numberOfProperty];
        
        ABridge_PropertyPagesViewController *initialViewController = [self viewControllerAtIndex:0];
        
        NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
        
        [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
        
        [self addChildViewController:self.pageController];
        [[self viewForPages] addSubview:[self.pageController view]];
        [self.pageController didMoveToParentViewController:self];
        self.buttonSave.hidden = NO;
    }
    else {
        [self.pageController.view removeFromSuperview];
        [self.pageController removeFromParentViewController];
        self.pageController = nil;
        self.numberOfProperty = 0;
        self.labelNumberOfProperty.text = [NSString stringWithFormat:@"My POPs™ (%li)",(long)self.numberOfProperty];
        self.buttonSave.hidden = YES;
        [self showOverlayWithMessage:@"You currently don't have any POPs™." withIndicator:NO];
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    // Do something with responseData
}

@end
