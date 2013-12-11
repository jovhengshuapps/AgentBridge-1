//
//  ABridge_BuyerViewController.m
//  AgentBridge
//
//  Created by host24_iOS Dev on 11/14/13.
//  Copyright (c) 2013 host24_iOS Dev. All rights reserved.
//

#import "ABridge_BuyerViewController.h"
#import "ABridge_BuyerPagesViewController.h"
#import "ABridge_BuyerPopsViewController.h"
#import "Buyer.h"
#import "RequestNetwork.h"

@interface ABridge_BuyerViewController ()
@property (weak, nonatomic) IBOutlet UILabel *labelNumberOfBuyers;
@property (weak, nonatomic) IBOutlet UIView *viewForPages;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (assign, nonatomic) NSInteger numberOfBuyer;
@property (strong, nonatomic) NSURLConnection *urlConnectionBuyer;
@property (strong, nonatomic) NSMutableData *dataReceived;
@property (strong, nonatomic) LoginDetails *loginDetail;
@property (strong, nonatomic) NSMutableArray *arrayOfBuyer;
@property (assign, nonatomic) BOOL saved_pressed;
@property (assign, nonatomic) NSInteger buyer_id_pops;
@property (strong, nonatomic) NSString *scrollToBuyerId;
@end

@implementation ABridge_BuyerViewController
@synthesize numberOfBuyer;
@synthesize urlConnectionBuyer;
@synthesize dataReceived;
@synthesize loginDetail;
@synthesize arrayOfBuyer;
@synthesize saved_pressed;
@synthesize buyer_id_pops;
@synthesize scrollToBuyerId;

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
    
    NSLog(@"buyer:%@",self.scrollToBuyerId);
    self.labelNumberOfBuyers.font = FONT_OPENSANS_REGULAR(FONT_SIZE_TITLE);
    
    self.labelNumberOfBuyers.text = @"My Buyers";
    [self.labelNumberOfBuyers sizeToFit];
    
    CGRect frame = self.activityIndicator.frame;
    frame.origin.x = self.labelNumberOfBuyers.frame.origin.x + self.labelNumberOfBuyers.frame.size.width + 10.0f;
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
    
    [self loadBuyers];
}

- (void)loadBuyers{
    NSString *parameters = [NSString stringWithFormat:@"?user_id=%@",self.loginDetail.user_id];
    
    self.urlConnectionBuyer = [self urlConnectionWithURLString:@"http://keydiscoveryinc.com/agent_bridge/webservice/getbuyers.php" andParameters:parameters];
    
    if (self.urlConnectionBuyer) {
        //        NSLog(@"Connection Successful");
        [self addURLConnection:self.urlConnectionBuyer];
        self.activityIndicator.hidden = NO;
        [self.activityIndicator startAnimating];
        //        [self showOverlayWithMessage:@"LOADING" withIndicator:YES];
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


- (ABridge_BuyerPagesViewController *)viewControllerAtIndex:(NSUInteger)index {
    
    ABridge_BuyerPagesViewController *pagesViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"BuyerPages"];
    //[[ABridge_BuyerPagesViewController alloc] initWithNibName:@"ABridge_BuyerPagesViewController" bundle:nil];
    pagesViewController.index = index;
    
    pagesViewController.buyerDetail = (Buyer*)[self.arrayOfBuyer objectAtIndex:index];
    
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
    
    [self.pageController.view removeFromSuperview];
    [self.pageController removeFromParentViewController];
    self.pageController = nil;
    self.arrayOfBuyer = nil;
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
    [self.activityIndicator stopAnimating];
    self.activityIndicator.hidden = YES;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Internet Connection" message:@"You have no Internet Connection available." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSError *error = nil;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:self.dataReceived options:NSJSONReadingAllowFragments error:&error];
    
//    NSLog(@"Did Finish:%@", json);
    
    if (connection == self.urlConnectionBuyer) {
        if ([[json objectForKey:@"data"] count]) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
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
                        if (self.arrayOfBuyer == nil) {
                            self.arrayOfBuyer = [[NSMutableArray alloc] init];
                        }
                        
                        [self.arrayOfBuyer addObject:buyer];
                    }
                }
                
                self.numberOfBuyer = [self.arrayOfBuyer count];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
                    
                    self.pageController.dataSource = self;
                    CGRect pageControllerFrame = self.viewForPages.frame;
                    pageControllerFrame.origin.x = 0.0f;
                    pageControllerFrame.origin.y = 1.0f;
                    self.pageController.view.frame = pageControllerFrame;
                    
                    self.labelNumberOfBuyers.text = [NSString stringWithFormat:@"My Buyers (%li)",(long)self.numberOfBuyer];
                    
                    [self.labelNumberOfBuyers sizeToFit];
                    CGRect frame = self.activityIndicator.frame;
                    frame.origin.x = self.labelNumberOfBuyers.frame.origin.x + self.labelNumberOfBuyers.frame.size.width + 10.0f;
                    self.activityIndicator.frame = frame;
                    
                    
                    ABridge_BuyerPagesViewController *initialViewController = [self viewControllerAtIndex:0];
                    
                    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
                    
                    [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
                    
                    [self addChildViewController:self.pageController];
                    [[self viewForPages] addSubview:[self.pageController view]];
                    [self.pageController didMoveToParentViewController:self];
                    
                    if(self.scrollToBuyerId == nil) {
                        [self scrollToBuyer:@"load"];
                    }
                });
                
            });
            [self dismissOverlay];
        }
        else {
            [self.pageController.view removeFromSuperview];
            [self.pageController removeFromParentViewController];
            self.pageController = nil;
            self.numberOfBuyer = 0;
            self.labelNumberOfBuyers.text = @"My Buyers";
            
            [self showOverlayWithMessage:@"You currently don't have any Buyers." withIndicator:NO];
        }
    }
    
    [self.activityIndicator stopAnimating];
    self.activityIndicator.hidden = YES;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    // Do something with responseData
}


-(void)viewSavedPopsWithBuyerId:(NSInteger)buyer_id {
    self.saved_pressed = YES;
    self.buyer_id_pops = buyer_id;
    [self performSegueWithIdentifier:@"showPops" sender:self];
}

-(void)viewNewPopsWithBuyerId:(NSInteger)buyer_id {
    self.saved_pressed = NO;
    self.buyer_id_pops = buyer_id;
    [self performSegueWithIdentifier:@"showPops" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showPops"]) {
        ((ABridge_BuyerPopsViewController*) segue.destinationViewController).is_saved = self.saved_pressed;
        ((ABridge_BuyerPopsViewController*) segue.destinationViewController).buyer_id = self.buyer_id_pops;
    }
}

-(void) scrollToBuyer:(NSString*)buyer_id {
    
    self.scrollToBuyerId = buyer_id;
    
    if (self.arrayOfBuyer == nil) {
        [self loadBuyers];
    }
    
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"buyer_id == %@", buyer_id];
    NSArray *result = [self fetchObjectsWithEntityName:@"Buyer" andPredicate:predicate];
    if ([result count]) {
        Buyer *buyer = (Buyer*)[result firstObject];
        NSInteger index = 0;
        
        if (![buyer_id isEqualToString:@"load"]) {
            index = [self.arrayOfBuyer indexOfObject:buyer];
        }
        
        ABridge_BuyerPagesViewController *initialViewController = [self viewControllerAtIndex:index];
        
        NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
        
        [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
        
    }
}
@end
