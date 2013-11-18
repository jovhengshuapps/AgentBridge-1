//
//  ABridge_BuyerViewController.m
//  AgentBridge
//
//  Created by host24_iOS Dev on 11/14/13.
//  Copyright (c) 2013 host24_iOS Dev. All rights reserved.
//

#import "ABridge_BuyerViewController.h"
#import "ABridge_BuyerPagesViewController.h"
#import "Buyer.h"

@interface ABridge_BuyerViewController ()
@property (weak, nonatomic) IBOutlet UILabel *labelNumberOfBuyers;
@property (weak, nonatomic) IBOutlet UIView *viewForPages;

@property (assign, nonatomic) NSInteger numberOfBuyer;
@property (strong, nonatomic) NSURLConnection *urlConnectionBuyer;
@property (strong, nonatomic) NSMutableData *dataReceived;
@property (strong, nonatomic) LoginDetails *loginDetail;
@property (strong, nonatomic) NSMutableArray *arrayOfBuyer;
@end

@implementation ABridge_BuyerViewController
@synthesize numberOfBuyer;
@synthesize urlConnectionBuyer;
@synthesize dataReceived;
@synthesize loginDetail;
@synthesize arrayOfBuyer;

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
    
//    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
//        CGRect frame = self.viewForPages.frame;
//        frame.size.height = 315.0f;
//        self.viewForPages.frame = frame;
//        
//        frame = self.labelNumberOfSaved.frame;
//        frame.origin.y = 400.0f;
//        self.labelNumberOfSaved.frame = frame;
//        
//        frame = self.labelNumberOfNew.frame;
//        frame.origin.y = 400.0f;
//        self.labelNumberOfNew.frame = frame;
//        
//        [self.view autoresizesSubviews];
//    }
    
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
    
    self.urlConnectionBuyer = [self urlConnectionWithURLString:@"http://keydiscoveryinc.com/agent_bridge/webservice/getbuyers.php" andParameters:parameters];
    
    if (self.urlConnectionBuyer) {
        NSLog(@"Connection Successful");
        [self addURLConnection:self.urlConnectionBuyer];
    }
    else {
        NSLog(@"Connection Failed");
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (ABridge_BuyerPagesViewController *)viewControllerAtIndex:(NSUInteger)index {
    
    ABridge_BuyerPagesViewController *pagesViewController = [[ABridge_BuyerPagesViewController alloc] initWithNibName:@"ABridge_BuyerPagesViewController" bundle:nil];
    pagesViewController.index = index;
    pagesViewController.buyerDetails = (Buyer*)[self.arrayOfBuyer objectAtIndex:index];
    
    return pagesViewController;
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(ABridge_BuyerPagesViewController *)viewController index];
    
    if (index == 0) {
        return nil;
    }
    
    // Decrease the index by 1 to return
    index--;
    
    return [self viewControllerAtIndex:index];
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(ABridge_BuyerPagesViewController *)viewController index];
    
    index++;
    
    if (index == self.numberOfBuyer) {
        return nil;
    }
    
    return [self viewControllerAtIndex:index];
    
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    // The number of items reflected in the page indicator.
    return self.numberOfBuyer;
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
            Buyer *buyer = nil;
            
            NSPredicate * predicate = [NSPredicate predicateWithFormat:@"buyer_id == %@", [entry objectForKey:@"buyer_id"]];
            NSArray *result = [self fetchObjectsWithEntityName:@"Buyer" andPredicate:predicate];
            if ([result count]) {
                buyer = (Buyer*)[result firstObject];
            }
            else {
                buyer = [NSEntityDescription insertNewObjectForEntityForName: @"Buyer" inManagedObjectContext: context];
            }
            
            [buyer setValuesForKeysWithDictionary:entry];
            
            NSError *error = nil;
            if (![context save:&error]) {
                NSLog(@"Error on saving Buyer:%@",[error localizedDescription]);
            }
            else {
                if (arrayOfBuyer == nil) {
                    arrayOfBuyer = [[NSMutableArray alloc] init];
                }
                
                [arrayOfBuyer addObject:buyer];
            }
        }
    
        self.numberOfBuyer = [[json objectForKey:@"data"] count];
        
        self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        
        self.pageController.dataSource = self;
        CGRect pageControllerFrame = self.viewForPages.frame;
        pageControllerFrame.origin.x = 0.0f;
        pageControllerFrame.origin.y = 0.0f;
        self.pageController.view.frame = pageControllerFrame;
        
        self.labelNumberOfBuyers.text = [NSString stringWithFormat:@"My Buyers (%li)",(long)self.numberOfBuyer];
        
        ABridge_BuyerPagesViewController *initialViewController = [self viewControllerAtIndex:0];
        
        NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
        
        [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
        
        [self addChildViewController:self.pageController];
        [[self viewForPages] addSubview:[self.pageController view]];
        [self.pageController didMoveToParentViewController:self];
        
    }
    
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    // Do something with responseData
}

@end
