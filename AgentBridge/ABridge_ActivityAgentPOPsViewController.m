//
//  ABridge_ActivityAgentPOPsViewController.m
//  AgentBridge
//
//  Created by host24_iOS Dev on 12/13/13.
//  Copyright (c) 2013 host24_iOS Dev. All rights reserved.
//

#import "ABridge_ActivityAgentPOPsViewController.h"
#import "ABridge_PropertyPagesViewController.h"
#import "Property.h"

@interface ABridge_ActivityAgentPOPsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *labelNumberOfProperty;
@property (weak, nonatomic) IBOutlet UIView *viewForPages;
@property (weak, nonatomic) IBOutlet UIButton *buttonSave;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewZoom;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (assign, nonatomic) NSInteger numberOfProperty;
@property (strong, nonatomic) LoginDetails *loginDetail;
@property (strong, nonatomic) NSMutableArray *arrayOfProperty;
- (IBAction)goBack:(id)sender;
@property (strong, nonatomic) NSString *scrollToListingId;
@end

@implementation ABridge_ActivityAgentPOPsViewController
@synthesize numberOfProperty;
@synthesize loginDetail;
@synthesize arrayOfProperty;
@synthesize scrollToListingId;
@synthesize user_id;
@synthesize user_name;
@synthesize listing_id;
@synthesize fromSearch;

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
    
    self.labelNumberOfProperty.font = FONT_OPENSANS_BOLD(FONT_SIZE_TITLE);
    self.buttonSave.titleLabel.font = FONT_OPENSANS_BOLD(FONT_SIZE_SMALL);
    
    self.labelNumberOfProperty.text = [NSString stringWithFormat:@"%@'s POPs™",self.user_name];
    
    if (fromSearch) {
        self.labelNumberOfProperty.hidden = NO;
        self.activityIndicator.hidden = YES;
        self.buttonSave.hidden = YES;
    }
    else {
        self.labelNumberOfProperty.hidden = NO;
        self.activityIndicator.hidden = NO;
        self.buttonSave.hidden = NO;
    }
    
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
    
    
    if (fromSearch) {
        NSString *parameters = [NSString stringWithFormat:@"?user_id=%@&listing_id=%@",self.user_id,self.listing_id];
        
        __block NSError *errorData = nil;
        __weak ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://keydiscoveryinc.com/agent_bridge/webservice/getpops_byid.php%@",parameters]]];
        [request setCompletionBlock:^{
            
            // Use when fetching text data
            //                        NSString *responseString = [request responseString];
            // Use when fetching binary data
            NSData *responseData = [request responseData];
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&errorData];
            
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
                        //NSLog(@"Error on saving Property:%@",[error localizedDescription]);
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
                    
                    
                });
                
            }
            
            
        }];
        [request setFailedBlock:^{
            NSError *error = [request error];
            NSLog(@" error:%@",error);
        }];
        
        [request startAsynchronous];
    }
    else {
        
        NSString *parameters = [NSString stringWithFormat:@"?user_id=%@",self.user_id];
        
        __block NSError *errorData = nil;
        __weak ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://keydiscoveryinc.com/agent_bridge/webservice/getpops.php%@",parameters]]];
        [request setCompletionBlock:^{
            
            // Use when fetching text data
            //                        NSString *responseString = [request responseString];
            // Use when fetching binary data
            NSData *responseData = [request responseData];
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&errorData];
            
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
                        //NSLog(@"Error on saving Property:%@",[error localizedDescription]);
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
                    
                    self.labelNumberOfProperty.text = [NSString stringWithFormat:@"%@ POPs™ (%li)", self.user_name,(long)self.numberOfProperty];
                    
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
                    
                });
                
            }
            else {
                [self.pageController.view removeFromSuperview];
                [self.pageController removeFromParentViewController];
                self.pageController = nil;
                self.numberOfProperty = 0;
                self.labelNumberOfProperty.text = [NSString stringWithFormat:@"%@ POPs™",self.user_name];
                self.buttonSave.hidden = YES;
                [self showOverlayWithMessage:@"You currently don't have any POPs™." withIndicator:NO];
            }
            
        }];
        [request setFailedBlock:^{
            NSError *error = [request error];
            NSLog(@" error:%@",error);
        }];
        
        [request startAsynchronous];
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


- (IBAction)goBack:(id)sender {
    
    if (self.fromSearch) {
        
        CATransition *transition = [CATransition animation];
        transition.duration = 0.4;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromLeft;
        [self.view.window.layer addAnimation:transition forKey:nil];
        
        
        [self dismissViewControllerAnimated:NO completion:^{
            
        }];
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
@end
