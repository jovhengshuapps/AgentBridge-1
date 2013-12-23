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
#import "ASIHTTPRequest.h"

@interface ABridge_PropertyViewController ()
@property (weak, nonatomic) IBOutlet UILabel *labelNumberOfProperty;
@property (weak, nonatomic) IBOutlet UIView *viewForPages;
@property (weak, nonatomic) IBOutlet UIButton *buttonSave;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewZoom;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
- (IBAction)savePopsToBuyer:(id)sender;

@property (assign, nonatomic) NSInteger numberOfProperty;
@property (strong, nonatomic) NSURLConnection *urlConnectionProperty;
@property (strong, nonatomic) NSMutableData *dataReceived;
@property (strong, nonatomic) LoginDetails *loginDetail;
@property (strong, nonatomic) NSMutableArray *arrayOfProperty;
@property (strong, nonatomic) NSString *scrollToListingId;
@property (strong, nonatomic) NSString *currentListingId;
@property (strong, nonatomic) NSMutableArray *arrayOfBuyerID;
@end

@implementation ABridge_PropertyViewController
@synthesize numberOfProperty;
@synthesize urlConnectionProperty;
@synthesize dataReceived;
@synthesize loginDetail;
@synthesize arrayOfProperty;
@synthesize scrollToListingId;
@synthesize currentListingId;
@synthesize arrayOfBuyerID;

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
    
    self.labelNumberOfProperty.font = FONT_OPENSANS_REGULAR(FONT_SIZE_TITLE);
    self.buttonSave.titleLabel.font = FONT_OPENSANS_BOLD(FONT_SIZE_SMALL);
    
    self.labelNumberOfProperty.text = @"My POPs™";
    
    [self.labelNumberOfProperty sizeToFit];
    
    CGRect frame = self.activityIndicator.frame;
    frame.origin.x = self.labelNumberOfProperty.frame.origin.x + self.labelNumberOfProperty.frame.size.width + 10.0f;
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
    
    [self loadProperty];
}

//-(void)viewDidAppear:(BOOL)animated {
//    [super viewDidAppear:animated];
//    
//    [self loadProperty];
//}

- (void) loadProperty {
    NSString *parameters = [NSString stringWithFormat:@"?user_id=%@",self.loginDetail.user_id];
    
    self.urlConnectionProperty = [self urlConnectionWithURLString:@"http://keydiscoveryinc.com/agent_bridge/webservice/getpops.php" andParameters:parameters];
    
    if (self.urlConnectionProperty) {
        //        NSLog(@"Connection Successful");
        [self addURLConnection:self.urlConnectionProperty];
        //        [self showOverlayWithMessage:@"LOADING" withIndicator:YES];
        
        self.activityIndicator.hidden = NO;
        [self.activityIndicator startAnimating];
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
    pagesViewController.delegate = self;
    
    self.currentListingId = ((Property*)[self.arrayOfProperty objectAtIndex:index]).listing_id;
    pagesViewController.buyers_view = NO;
    
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
    [self.pageController.view removeFromSuperview];
    [self.pageController removeFromParentViewController];
    self.pageController = nil;
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
    
    if ([[json objectForKey:@"data"] count]) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
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
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
                
                self.pageController.dataSource = self;
                CGRect pageControllerFrame = self.viewForPages.frame;
                pageControllerFrame.origin.x = 0.0f;
                pageControllerFrame.origin.y = 1.0f;
                self.pageController.view.frame = pageControllerFrame;
                
                self.labelNumberOfProperty.text = [NSString stringWithFormat:@"My POPs™ (%li)",(long)self.numberOfProperty];
                
                [self.labelNumberOfProperty sizeToFit];
                
                CGRect frame = self.activityIndicator.frame;
                frame.origin.x = self.labelNumberOfProperty.frame.origin.x + self.labelNumberOfProperty.frame.size.width + 10.0f;
                self.activityIndicator.frame = frame;
                
                ABridge_PropertyPagesViewController *initialViewController = [self viewControllerAtIndex:0];
                
                NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
                
                [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
                
                [self addChildViewController:self.pageController];
                [[self viewForPages] addSubview:[self.pageController view]];
                [self.pageController didMoveToParentViewController:self];
                self.buttonSave.hidden = NO;
                
                if(self.scrollToListingId == nil) {
                    [self scrollToPOPs:@"load"];
                }
                
            });
            
        });
        [self dismissOverlay];
    }
    else {
        [self.pageController.view removeFromSuperview];
        [self.pageController removeFromParentViewController];
        self.pageController = nil;
        self.numberOfProperty = 0;
        self.labelNumberOfProperty.text = @"My POPs™";
        self.buttonSave.hidden = YES;
        [self showOverlayWithMessage:@"You currently don't have any POPs™." withIndicator:NO];
    }
    
    [self.activityIndicator stopAnimating];
    self.activityIndicator.hidden = YES;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    // Do something with responseData
}

- (void) zoomImage:(NSData *)image_data {
    
    UIImage *imageZoom = [UIImage imageWithData:image_data];
    
    self.imageView.image = imageZoom;
    
    CGRect frame = self.imageView.frame;
    frame.size.width = imageZoom.size.width;
    frame.size.height = imageZoom.size.height;
    self.imageView.frame = frame;
    
    self.scrollViewZoom.contentSize = self.imageView.frame.size;
    
    self.scrollViewZoom.hidden = NO;
    
    
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    if (scrollView.zoomScale < 0.75) {
        self.scrollViewZoom.hidden = YES;
    }
}

-(void) scrollToPOPs:(NSString*)listing_id {
    self.scrollToListingId = listing_id;
    
    if (self.arrayOfProperty == nil) {
        [self loadProperty];
    }
    
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"listing_id == %@", listing_id];
    NSArray *result = [self fetchObjectsWithEntityName:@"Property" andPredicate:predicate];
    if ([result count]) {
        Property *property = (Property*)[result firstObject];
        NSInteger index = 0;
        
        if (![listing_id isEqualToString:@"load"]) {
            index = [self.arrayOfProperty indexOfObject:property];
        }
        
        ABridge_PropertyPagesViewController *initialViewController = [self viewControllerAtIndex:index];
        
        NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
        
        [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
        
    }
}

- (IBAction)savePopsToBuyer:(id)sender {
    
    NSString *parameters = [NSString stringWithFormat:@"?user_id=%@&listing_id=%@",self.loginDetail.user_id,self.currentListingId];
    
    NSMutableString *urlString = [NSMutableString stringWithString:@"http://keydiscoveryinc.com/agent_bridge/webservice/getbuyer_list_pops.php"];
    [urlString appendString:parameters];
    
    self.activityIndicator.hidden = NO;
    __block NSError *errorData = nil;
    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlString]];
    //            [self.activityIndicator startAnimating];
    //            self.activityIndicator.hidden = NO;
    [request setCompletionBlock:
     ^{
         NSData *responseData = [request responseData];
         NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&errorData];
         
         NSMutableArray *arrayOfBuyers = nil;
         if ([[json objectForKey:@"data"] count]) {
             for (NSDictionary *entry in [json objectForKey:@"data"]) {
//                 NSLog(@"buyer:%@",[entry valueForKey:@"name"]);
                 
                 if (arrayOfBuyers == nil) {
                     arrayOfBuyers = [NSMutableArray array];
                     
                 }
                 
                 [arrayOfBuyers addObject:[entry valueForKey:@"name"]];
                 
                 if (self.arrayOfBuyerID == nil) {
                     self.arrayOfBuyerID = [NSMutableArray array];
                 }
                 
                 [self.arrayOfBuyerID addObject:[entry valueForKey:@"buyer_id"]];
             }
             
         }
         
//         NSLog(@"json:%@",json);
         
         if (arrayOfBuyers == nil) {
             
             UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"You have no Buyers" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"Cancel" otherButtonTitles:nil];
             
             [actionSheet showFromTabBar:self.tabBarController.tabBar];
         }
         else {
             UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Buyers" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"Cancel" otherButtonTitles:nil];
             
             for (NSString *name in arrayOfBuyers) {
                 [actionSheet addButtonWithTitle:name];
             }
             
             
             [actionSheet showFromTabBar:self.tabBarController.tabBar];
         }
         
         self.activityIndicator.hidden = YES;
         
     }];
    [request setFailedBlock:^{
        NSError *error = [request error];
        NSLog(@" error:%@",error);
    }];
    
    [request startAsynchronous];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"index:%i",buttonIndex);
    if (buttonIndex != 0) {
        NSString *buyer_id = [self.arrayOfBuyerID objectAtIndex:buttonIndex-1];
        
        NSString *parameters = [NSString stringWithFormat:@"?user_id=%@&listing_id=%@&buyer_id=%@",self.loginDetail.user_id,self.currentListingId, buyer_id];
        
        NSMutableString *urlString = [NSMutableString stringWithString:@"http://keydiscoveryinc.com/agent_bridge/webservice/save_buyer.php"];
        [urlString appendString:parameters];
        //    NSLog(@"url:%@",urlString);
        self.activityIndicator.hidden = NO;
        __block NSError *errorData = nil;
        __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlString]];
        //            [self.activityIndicator startAnimating];
        //            self.activityIndicator.hidden = NO;
        [request setCompletionBlock:
         ^{
             NSData *responseData = [request responseData];
             NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&errorData];
             
             //         NSLog(@"json:%@",json);
             if ([json objectForKey:@"status"]) {
                 NSLog(@"Success");
                 UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"POPs™ Saved" message:[NSString stringWithFormat:@"This POPs™ is saved to %@",[actionSheet buttonTitleAtIndex:buttonIndex]] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                 [av show];
             }
             else {
                 NSLog(@"Failed");
             }
             
             
             self.activityIndicator.hidden = YES;
             
         }];
        [request setFailedBlock:^{
            NSError *error = [request error];
            NSLog(@" error:%@",error);
        }];
        
        [request startAsynchronous];
    }
}
@end
