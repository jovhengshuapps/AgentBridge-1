//
//  ABridge_BuyerPopsViewController.m
//  AgentBridge
//
//  Created by host24_iOS Dev on 11/27/13.
//  Copyright (c) 2013 host24_iOS Dev. All rights reserved.
//

#import "ABridge_BuyerPopsViewController.h"
#import "ABridge_PropertyPagesViewController.h"
#import "Property.h"
#import "RequestNetwork.h"
#import "RequestAccess.h"
#import "ASIHTTPRequest.h"

@interface ABridge_BuyerPopsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *labelNumberOfProperty;
@property (weak, nonatomic) IBOutlet UIView *viewForPages;
@property (weak, nonatomic) IBOutlet UIButton *buttonSave;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewZoom;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UILabel *labelSavedto;
- (IBAction)backToBuyers:(id)sender;
- (IBAction)saveButtonPressed:(id)sender;

@property (assign, nonatomic) NSInteger numberOfProperty;
@property (strong, nonatomic) NSURLConnection *urlConnectionProperty;
@property (strong, nonatomic) NSMutableData *dataReceived;
@property (strong, nonatomic) NSMutableArray *arrayOfProperty;
@property (strong, nonatomic) NSString *currentListingId;
@end

@implementation ABridge_BuyerPopsViewController
@synthesize numberOfProperty;
@synthesize urlConnectionProperty;
@synthesize dataReceived;
@synthesize arrayOfProperty;
@synthesize is_saved;
@synthesize buyer_id;
@synthesize currentListingId;
@synthesize buyer_name;

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
    self.labelSavedto.font = FONT_OPENSANS_REGULAR(FONT_SIZE_SMALL-2.0f);
    
    if (is_saved) {
        self.labelNumberOfProperty.text = @"Saved POPs™";
    }
    else {
        self.labelNumberOfProperty.text = @"New POPs™";
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
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSString *parameters = [NSString stringWithFormat:@"?buyer_id=%li",(long)self.buyer_id];
    
    if (is_saved) {
        
        self.urlConnectionProperty = [self urlConnectionWithURLString:@"http://keydiscoveryinc.com/agent_bridge/webservice/getbuyers_saved.php" andParameters:parameters];
    }
    else {
        
        self.urlConnectionProperty = [self urlConnectionWithURLString:@"http://keydiscoveryinc.com/agent_bridge/webservice/getbuyers_new.php" andParameters:parameters];
    }
    
//    NSLog(@"url:%@",self.urlConnectionProperty.originalRequest.URL);
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
    Property *property = (Property*)[self.arrayOfProperty objectAtIndex:index];
    pagesViewController.propertyDetails = property;
    pagesViewController.delegate = self;
    pagesViewController.buyers_view = YES;
    pagesViewController.buyer_id = self.buyer_id;
    pagesViewController.buyer_name = self.buyer_name;
    
    self.currentListingId = property.listing_id;
    
//    pagesViewController.modify_view_type = MODIFYVIEW_NORMAL;
//    
//    if ([self.loginDetail.user_id integerValue] != [property.user_id integerValue]) {
//        for (RequestNetwork *network in self.arrayRequestNetwork) {
//            NSLog(@"%@network:%@",property.user_id,network);
//            if ([property.user_id integerValue] == [network.other_user_id integerValue]) {
//                if ([network.status integerValue] == 0) {
//                    pagesViewController.modify_view_type = MODIFYVIEW_PENDINGREQUEST;
//                }
//                else if ([network.status integerValue] == 1) {
//                    pagesViewController.modify_view_type = MODIFYVIEW_CHECKSETTING;
//                    if ([property.setting integerValue] == 2) {
//                        
//                        if ([self.arrayRequestAccess count] == 0) {
//                            pagesViewController.modify_view_type = MODIFYVIEW_REQUESTVIEWPRICE;
//                        }
//                        else {
//                            for (RequestAccess *access in self.arrayRequestAccess) {
//                                if ([property.user_id integerValue] == [access.user_b integerValue]) {
//                                    
//                                    pagesViewController.user_has_permission = [access.permission boolValue];
//                                    
//                                    break;
//                                }
//                            }
//                        }
//                        
//                    }
//                }
//                else if ([network.status integerValue] == 2) {
//                    pagesViewController.modify_view_type = MODIFYVIEW_REQUESTTOVIEW;
//                }
//                break;
//            }
//            else {
//                pagesViewController.modify_view_type = MODIFYVIEW_REQUESTTOVIEW;
//            }
//        }
//    }
    
    
    
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
    if (connection == self.urlConnectionProperty) {
        self.arrayOfProperty = nil;
        [self.pageController.view removeFromSuperview];
        [self.pageController removeFromParentViewController];
        self.pageController = nil;
    }
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
    
//    NSLog(@"%@ Did Finish:%@", (is_saved)?@"YES":@"NO", json);
    if (connection == self.urlConnectionProperty) {
        
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
                    
                    if (is_saved) {
                        self.labelNumberOfProperty.text = [NSString stringWithFormat:@"Saved POPs™ (%li)",(long)self.numberOfProperty];
                        self.buttonSave.hidden = YES;
                    }
                    else {
                        self.labelNumberOfProperty.text = [NSString stringWithFormat:@"New POPs™ (%li)",(long)self.numberOfProperty];
                        self.buttonSave.hidden = NO;
                    }
                    
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
                
            });
            
            [self dismissOverlay];
        }
        else {
            [self.pageController.view removeFromSuperview];
            [self.pageController removeFromParentViewController];
            self.pageController = nil;
            self.numberOfProperty = 0;
            if (is_saved) {
                self.labelNumberOfProperty.text = @"Saved POPs™";
            }
            else {
                self.labelNumberOfProperty.text = @"New POPs™";
            }
            [self.labelNumberOfProperty sizeToFit];
            
            CGRect frame = self.activityIndicator.frame;
            frame.origin.x = self.labelNumberOfProperty.frame.origin.x + self.labelNumberOfProperty.frame.size.width + 10.0f;
            self.activityIndicator.frame = frame;
            //        self.buttonSave.hidden = YES;
            [self showOverlayWithMessage:@"You currently don't have any POPs™." withIndicator:NO];
        }
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

- (void)hideSaveButton:(BOOL)hide {
    
    self.buttonSave.hidden = hide;
    self.labelSavedto.hidden = YES;
}

- (void)replaceSaveWithText:(NSString *)string {
    self.labelSavedto.text = string;
    self.labelSavedto.hidden = NO;
    self.buttonSave.hidden = YES;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    if (scrollView.zoomScale < 0.75) {
        self.scrollViewZoom.hidden = YES;
    }
}

- (IBAction)backToBuyers:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)saveButtonPressed:(id)sender {
    
    NSManagedObjectContext *context = ((ABridge_AppDelegate *)[[UIApplication sharedApplication] delegate]).managedObjectContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"LoginDetails"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error = nil;
    NSArray *fetchedObjects = [context
                               executeFetchRequest:fetchRequest error:&error];
    
    LoginDetails *loginDetail = (LoginDetails*)[fetchedObjects firstObject];
    
    NSString *parameters = [NSString stringWithFormat:@"?user_id=%@&listing_id=%@&buyer_id=%i",loginDetail.user_id,self.currentListingId, self.buyer_id];
    
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
             [self replaceSaveWithText:[NSString stringWithFormat:@"Saved to %@",self.buyer_name]];
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
@end
