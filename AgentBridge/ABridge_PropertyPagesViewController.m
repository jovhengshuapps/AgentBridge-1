//
//  ABridge_PropertyPagesViewController.m
//  AgentBridge
//
//  Created by host24_iOS Dev on 11/14/13.
//  Copyright (c) 2013 host24_iOS Dev. All rights reserved.
//

#import "ABridge_PropertyPagesViewController.h"
#import "Constants.h"
#import "PropertyImages.h"
#import "ABridge_AppDelegate.h"
#import "LoginDetails.h"
#import "RequestNetwork.h"
#import "RequestAccess.h"
#import "ASIHTTPRequest.h"

@interface ABridge_PropertyPagesViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollImages;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UILabel *labelZip;
@property (weak, nonatomic) IBOutlet UILabel *labelPropertyName;
@property (weak, nonatomic) IBOutlet UILabel *labelPropertyType;
@property (weak, nonatomic) IBOutlet UITextView *textFeatures;
@property (weak, nonatomic) IBOutlet UILabel *labelPrice;
@property (weak, nonatomic) IBOutlet UILabel *labelExpiry;
@property (weak, nonatomic) IBOutlet UILabel *labelPage;
@property (weak, nonatomic) IBOutlet UIView *viewForScroll;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingImageIndicator;
@property (weak, nonatomic) IBOutlet UIView *viewForDescription;
@property (weak, nonatomic) IBOutlet UILabel *labelDescription;
@property (weak, nonatomic) IBOutlet UIButton *buttonDescription;

@property (strong, nonatomic) NSURLConnection *urlConnectionImages;
@property (strong, nonatomic) NSMutableData *dataReceived;
@property (strong, nonatomic) NSMutableArray *arrayOfImageData;
@property (strong, nonatomic) NSURLConnection * urlConnectionRequestNetwork;
@property (strong, nonatomic) NSURLConnection * urlConnectionRequestAccess;
- (IBAction)buttonDescriptionPressed:(id)sender;
@property (strong, nonatomic) LoginDetails *loginDetail;
@end

@implementation ABridge_PropertyPagesViewController
@synthesize index;
@synthesize propertyDetails;
@synthesize urlConnectionRequestNetwork;
@synthesize urlConnectionRequestAccess;
@synthesize urlConnectionImages;
@synthesize delegate;
@synthesize buyers_view;
@synthesize loginDetail;
@synthesize buyer_id;
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
    // Do any additional setup after loading the view from its nib.
    NSManagedObjectContext *context = ((ABridge_AppDelegate *)[[UIApplication sharedApplication] delegate]).managedObjectContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"LoginDetails"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error = nil;
    NSArray *fetchedObjects = [context
                               executeFetchRequest:fetchRequest error:&error];
    
    self.loginDetail = (LoginDetails*)[fetchedObjects firstObject];
//    if ([self.delegate respondsToSelector:@selector(hideSaveButton:)]) {
//        [self.delegate hideSaveButton:NO];
//    }
    
    self.labelZip.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
    self.labelPrice.font = FONT_OPENSANS_BOLD(FONT_SIZE_REGULAR);
    self.labelPropertyName.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
    self.labelPropertyType.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
    
    self.labelExpiry.font = FONT_OPENSANS_REGULAR(FONT_SIZE_SMALL);
    self.labelExpiry.hidden = NO;
    self.textFeatures.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
    
    self.buttonDescription.titleLabel.font = FONT_OPENSANS_BOLD(FONT_SIZE_SMALL);
    self.labelDescription.font = FONT_OPENSANS_REGULAR(FONT_SIZE_SMALL);
    
    self.labelPage.text = [NSString stringWithFormat:@"%li",(long)self.index+1];
    
    self.labelZip.text = self.propertyDetails.zip;
    self.labelPropertyName.text = self.propertyDetails.property_name;
    self.labelPropertyType.text = [NSString stringWithFormat:@"%@ - %@",self.propertyDetails.type_name, self.propertyDetails.sub_type_name];
    
    if (buyers_view) {
        
        NSString *parameters = [NSString stringWithFormat:@"?user_id=%@&listing_id=%@&buyer_id=%i",self.loginDetail.user_id,self.propertyDetails.listing_id, self.buyer_id];
        
        NSMutableString *urlString = [NSMutableString stringWithString:@"http://keydiscoveryinc.com/agent_bridge/webservice/check_new_if_saved.php"];
        [urlString appendString:parameters];
//        NSLog(@"url:%@",urlString);
        
        
        if ([self.delegate respondsToSelector:@selector(hideSaveButton:)]) {
            [self.delegate hideSaveButton:YES];
        }
        __block NSError *errorData = nil;
        __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlString]];
        //            [self.activityIndicator startAnimating];
        //            self.activityIndicator.hidden = NO;
        [request setCompletionBlock:
         ^{
             NSData *responseData = [request responseData];
             NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&errorData];
             
//              NSLog(@"json:%@",json);
             if ([[json objectForKey:@"status"] integerValue] == 1) {
                 if ([self.delegate respondsToSelector:@selector(replaceSaveWithText:)]) {
                     [self.delegate replaceSaveWithText:[NSString stringWithFormat:@"Saved to %@",self.buyer_name]];
                 }
             }
             else {
                 NSLog(@"Failed");
                 
                 if ([self.delegate respondsToSelector:@selector(hideSaveButton:)]) {
                     [self.delegate hideSaveButton:NO];
                 }
             }
             
             
         }];
        [request setFailedBlock:^{
            NSError *error = [request error];
            NSLog(@" error:%@",error);
        }];
        
        [request startAsynchronous];
        
        if ([self.loginDetail.user_id integerValue] != [self.propertyDetails.user_id integerValue]) {
            NSString *parameters = [NSString stringWithFormat:@"?user_id=%@&other_user_id=%@",self.propertyDetails.user_id,self.loginDetail.user_id];
            
            NSMutableString *urlString_ = [NSMutableString stringWithString:@"http://keydiscoveryinc.com/agent_bridge/webservice/get_request_network.php"];
            [urlString_ appendString:parameters];
            //        NSLog(@"url:%@",urlString_);
            NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlString_]];
            
            self.urlConnectionRequestNetwork = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self startImmediately:YES];
            
            if (self.urlConnectionRequestNetwork) {
                [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
                [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
            }
        }
        else {
            [self getPriceText];
        }
        
    }
    else {
        [self getPriceText];
    }
    
    [self getExpiredText];
    
    CGSize constraint = CGSizeMake(309.0f, 20000.0f);
    
    CGSize size = [self.labelDescription.text sizeWithFont:FONT_OPENSANS_REGULAR(FONT_SIZE_SMALL) constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    
    CGFloat height = MAX(size.height, 20.0f);
    CGRect frame = self.labelDescription.frame;
    frame.size.height = height;
    self.labelDescription.frame = frame;
    
    frame = self.buttonDescription.frame;
    frame.origin.y = self.labelDescription.frame.origin.y + self.labelDescription.frame.size.height + 5.0f;
    self.buttonDescription.frame = frame;
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.scrollImages.frame.size.width, self.scrollImages.frame.size.height)];
    imageView.contentMode = UIViewContentModeCenter;
    imageView.image = [UIImage imageNamed:[self imageStringForPropertyType:[self.propertyDetails.type_property_type integerValue] andSubType:[self.propertyDetails.sub_type integerValue]]];
    
    
    
    [self.scrollImages addSubview:imageView];
    
    // Add a bottomBorder.
    CALayer *bottomBorder = [CALayer layer];
    
    bottomBorder.frame = CGRectMake(0.0f, self.viewForScroll.frame.size.height - 1.0f, self.scrollImages.frame.size.width, 1.0f);
    
    bottomBorder.backgroundColor = [UIColor colorWithRed:191.0f/255.0f green:191.0f/255.0f blue:191.0f/255.0f alpha:1.0f].CGColor;
    
    [self.viewForScroll.layer addSublayer:bottomBorder];
    
    
    [self loadPOPsImages];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.labelDescription.hidden == NO || self.buttonDescription.hidden == NO) {
        
        if ([self.delegate respondsToSelector:@selector(hideSaveButton:)]) {
            [self.delegate hideSaveButton:YES];
        }
    }
    else {
        
        if ([self.delegate respondsToSelector:@selector(hideSaveButton:)]) {
            [self.delegate hideSaveButton:NO];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
}

-(BOOL)isNull:(id)value {
    return ((NSNull*)value == nil || [value isEqualToString:@""]);
}

-(NSString*)imageStringForPropertyType:(NSInteger)property_type andSubType:(NSInteger)sub_type {
    NSMutableString *imageString = [NSMutableString stringWithString:@""];
    switch (property_type) {
        case RESIDENTIAL_PURCHASE:
            [imageString appendString:@"residential-purchase-"];
            break;
        case RESIDENTIAL_LEASE:
            [imageString appendString:@"residential-lease-"];
            break;
        case COMMERCIAL_PURCHASE:
            [imageString appendString:@"commercial-purchase-"];
            break;
        case COMMERCIAL_LEASE:
            [imageString appendString:@"commercial-lease-"];
            break;
        default:
            [imageString appendString:@"residential-purchase-"];
            break;
    }
    switch (sub_type) {
        case RESIDENTIAL_PURCHASE_SFR: case RESIDENTIAL_LEASE_SFR:
            [imageString appendString:@"sfr"];
            break;
        case RESIDENTIAL_PURCHASE_CONDO: case RESIDENTIAL_LEASE_CONDO:
            [imageString appendString:@"condo"];
            break;
        case RESIDENTIAL_PURCHASE_LAND: case RESIDENTIAL_LEASE_LAND:
            [imageString appendString:@"land"];
            break;
        case RESIDENTIAL_PURCHASE_TOWNHOUSE: case RESIDENTIAL_LEASE_TOWNHOUSE:
            [imageString appendString:@"townhouse"];
            break;
            /*case RESIDENTIAL_LEASE_SFR:
             [imageString appendString:@"sfr"];
             break;
             case RESIDENTIAL_LEASE_CONDO:
             [imageString appendString:@"condo"];
             break;
             case RESIDENTIAL_LEASE_LAND:
             [imageString appendString:@"land"];
             break;
             case RESIDENTIAL_LEASE_TOWNHOUSE:
             [imageString appendString:@"townhouse"];
             break;*/
        case COMMERCIAL_PURCHASE_ASSISTED_CARE:
            [imageString appendString:@"assist"];
            break;
        case COMMERCIAL_PURCHASE_INDUSTRIAL: case COMMERCIAL_LEASE_INDUSTRIAL:
            [imageString appendString:@"industrial"];
            break;
        case COMMERCIAL_PURCHASE_MOTEL:
            [imageString appendString:@"motel"];
            break;
        case COMMERCIAL_PURCHASE_MULTI_FAMILY:
            [imageString appendString:@"multi-family"];
            break;
        case COMMERCIAL_PURCHASE_OFFICE: case COMMERCIAL_LEASE_OFFICE:
            [imageString appendString:@"office"];
            break;
        case COMMERCIAL_PURCHASE_RETAIL: case COMMERCIAL_LEASE_RETAIL:
            [imageString appendString:@"retail"];
            break;
        case COMMERCIAL_PURCHASE_SPECIAL_PURPOSE:
            [imageString appendString:@"special"];
            break;
            /*case COMMERCIAL_LEASE_INDUSTRIAL:
             [imageString appendString:@"industrial"];
             break;
             case COMMERCIAL_LEASE_OFFICE:
             [imageString appendString:@"office"];
             break;
             case COMMERCIAL_LEASE_RETAIL:
             [imageString appendString:@"retail"];
             break;*/
        default:
            [imageString appendString:@"sfr"];
            break;
    }
    [imageString appendString:@".png"];
    
//    NSLog(@"image:%@",imageString);
    return imageString;
}

- (void) loadPOPsImages {
    
    
    self.loadingImageIndicator.hidden = NO;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        __block CGFloat xOffset = 0.0f;
        __block NSInteger i = 0;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[[self.scrollImages subviews] firstObject] removeFromSuperview]; //remove default image
        });
        
        
        // Update UI
        if (self.arrayOfImageData == nil) {
            self.arrayOfImageData = [[NSMutableArray alloc] init];
        }
        
        if (self.propertyDetails.images_data == nil) {
            
            NSArray *arrayOfImageURLs = [self.propertyDetails.images componentsSeparatedByString:@","];
            
            //            NSLog(@"array:%@",arrayOfImageURLs);
            
            NSMutableArray *arrayOfImageData_coreData = [[NSMutableArray alloc] init];
            
            for (NSString *URLstring in arrayOfImageURLs) {
                [arrayOfImageData_coreData addObject:[NSData dataWithContentsOfURL:[NSURL URLWithString:URLstring]]];
            }
            
            self.propertyDetails.images_data = [NSKeyedArchiver archivedDataWithRootObject:arrayOfImageData_coreData];
        }
        
        
        NSArray* arrayDataImages = [NSKeyedUnarchiver unarchiveObjectWithData:self.propertyDetails.images_data];
        
        for (NSData *imageData in arrayDataImages) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.loadingImageIndicator.hidden = NO;
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(xOffset, 0.0f, self.scrollImages.frame.size.width, self.scrollImages.frame.size.height)];
                imageView.contentMode = UIViewContentModeScaleAspectFill;
                imageView.image = [UIImage imageWithData:imageData];
                
                [self.arrayOfImageData addObject:imageData];
                
                
                [self.scrollImages addSubview:imageView];
                
                xOffset += imageView.frame.size.width;
                i++;
                
                [self.scrollImages setContentSize:CGSizeMake(xOffset, 0.0f)];
                
                UITapGestureRecognizer *tapZoom = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sendDelegateImage:)];
                
                tapZoom.numberOfTapsRequired = 1;
                tapZoom.numberOfTouchesRequired = 1;
                [self.scrollImages addGestureRecognizer:tapZoom];
                self.loadingImageIndicator.hidden = YES;
            });
        }
        
        
    });
    
////    self.loadingImageIndicator.hidden = NO;
////        NSMutableString *urlString_ = [NSMutableString stringWithString:@"http://keydiscoveryinc.com/agent_bridge/webservice/getpops_images.php"];
////        [urlString_ appendString:[NSString stringWithFormat:@"?listing_id=%@",self.propertyDetails.listing_id]];
//////        NSLog(@"url:%@",urlString_);
////        NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlString_]];
////        
////        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
////        self.urlConnectionImages = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self startImmediately:YES];
//    NSString *parameters = [NSString stringWithFormat:@"?listing_id=%@",self.propertyDetails.listing_id];
//    
//    NSMutableString *urlString = [NSMutableString stringWithString:@"http://keydiscoveryinc.com/agent_bridge/webservice/getpops_images.php"];
//    [urlString appendString:parameters];
//    
//    __block NSError *errorData = nil;
//    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlString]];
//    //            [self.activityIndicator startAnimating];
//    //            self.activityIndicator.hidden = NO;
//    [request setCompletionBlock:
//     ^{
//         NSData *responseData = [request responseData];
//         NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&errorData];
//         
//         if ([[json objectForKey:@"data"] count]) {
//             
//                 __block CGFloat xOffset = 0.0f;
//                 __block NSInteger i = 0;
//                 
////                 dispatch_async(dispatch_get_main_queue(), ^{
//                     [[[self.scrollImages subviews] firstObject] removeFromSuperview]; //remove default image
////                 });
//                 
//                 for (NSDictionary *entry in [json objectForKey:@"data"]) {
//                     PropertyImages *image = nil;
//                     
//                     NSPredicate * predicate = [NSPredicate predicateWithFormat:@"image_id == %@", [entry objectForKey:@"image_id"]];
//                     NSManagedObjectContext *context = ((ABridge_AppDelegate *)[[UIApplication sharedApplication] delegate]).managedObjectContext;
//                     NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
//                     [fetchRequest setPredicate:predicate];
//                     [fetchRequest setEntity:[NSEntityDescription entityForName:@"PropertyImages" inManagedObjectContext:context]];
//                     NSError * error = nil;
//                     NSArray * results = [context executeFetchRequest:fetchRequest error:&error];
//                     if ([results count]) {
//                         image = (PropertyImages*)[results firstObject];
//                     }
//                     else {
//                         image = [NSEntityDescription insertNewObjectForEntityForName: @"PropertyImages" inManagedObjectContext: context];
//                     }
//                     
//                     [image setValuesForKeysWithDictionary:entry];
//                     
//                     NSError *errorSave = nil;
//                     if (![context save:&errorSave]) {
//                         NSLog(@"Error on saving PropertyImages:%@",[errorSave localizedDescription]);
//                     }
//                     else {
//                         
////                         dispatch_async(dispatch_get_main_queue(), ^{
//                             // Update UI
//                             if (self.arrayOfImageData == nil) {
//                                 self.arrayOfImageData = [[NSMutableArray alloc] init];
//                             }
//                             
//                             if (image.image_data == nil) {
//                                 image.image_data = [NSData dataWithContentsOfURL:[NSURL URLWithString:image.image]];
//                             }
//                             
//                             UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(xOffset, 0.0f, self.scrollImages.frame.size.width, self.scrollImages.frame.size.height)];
//                             imageView.contentMode = UIViewContentModeScaleAspectFill;
//                             imageView.image = [UIImage imageWithData:image.image_data];
//                             
//                             [self.arrayOfImageData addObject:image.image_data];
//                             
//                             [self.scrollImages addSubview:imageView];
//                             
//                             xOffset += imageView.frame.size.width;
//                             i++;
//                             
//                             [self.scrollImages setContentSize:CGSizeMake(xOffset, 0.0f)];
////                         });
//                         
//                     }
//                 }
//                 
//                 
//                 
////                 dispatch_async(dispatch_get_main_queue(), ^{
//                     UITapGestureRecognizer *tapZoom = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sendDelegateImage:)];
//                     
//                     tapZoom.numberOfTapsRequired = 1;
//                     tapZoom.numberOfTouchesRequired = 1;
//                     [self.scrollImages addGestureRecognizer:tapZoom];
//                     self.loadingImageIndicator.hidden = YES;
////                 });
//         }
//         else {
//             
//         }
//         
//     }];
//    [request setFailedBlock:^{
//        NSError *error = [request error];
//        NSLog(@" error:%@",error);
//    }];
//    
//    [request startAsynchronous];
}

- (void) getPriceText {
    NSNumberFormatter * formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterCurrencyStyle;
    [formatter setMaximumFractionDigits:0];
    formatter.currencyCode = @"USD";
    
    NSMutableString *priceText = [NSMutableString stringWithString:@""];
    [priceText appendString:[formatter stringFromNumber: [NSNumber numberWithDouble:[self.propertyDetails.price1 doubleValue]]]];
    if ([self.propertyDetails.price_type integerValue] == YES) {
        [priceText appendFormat:@" - %@",[formatter stringFromNumber: [NSNumber numberWithDouble:[self.propertyDetails.price2 doubleValue]]]];
    }
    self.labelPrice.text = priceText;
}

- (void) getExpiredText {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date_tested = [dateFormatter dateFromString:self.propertyDetails.date_created];
    NSDate *date_expired = [dateFormatter dateFromString:self.propertyDetails.date_expired];
    NSDate *date_now = [NSDate date];
    
    if ([date_now compare:date_tested] == NSOrderedDescending || date_tested == nil) {
        date_tested = date_now;
    }
    
    NSTimeInterval interval = [date_expired timeIntervalSinceDate:date_tested];
    
    NSInteger remainingDays = (NSInteger)(interval/86400.0f);
    
    if (remainingDays > -1) {
        remainingDays += 1;
        
        if (remainingDays == 1) {
            self.labelExpiry.text = @"Expires in 1 day";
        }
        else {
            self.labelExpiry.text = [NSString stringWithFormat:@"Expires in %li days",(long)remainingDays];
        }
    }
    else {
        
        self.labelExpiry.text = [NSString stringWithFormat:@"Expired"];
    }
}


- (void) checkSettingGetPrice {
    
    if ([self.loginDetail.user_id integerValue] == [self.propertyDetails.user_id integerValue]) {
        [self getPriceText];
    }
    else {
        if ([self.propertyDetails.disclose boolValue]) {
            [self getPriceText];
        }
        else {
            self.labelPrice.text = @"Price Undisclosed";
        }
    }
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
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Internet Connection" message:@"You have no Internet Connection available." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSError *error = nil;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:self.dataReceived options:NSJSONReadingAllowFragments error:&error];
    
//    NSLog(@"Did Finish:%@", json);
    if (connection == self.urlConnectionImages) {
        
        if ([[json objectForKey:@"data"] count]) {
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                __block CGFloat xOffset = 0.0f;
                __block NSInteger i = 0;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[[self.scrollImages subviews] firstObject] removeFromSuperview]; //remove default image
                });
                
                for (NSDictionary *entry in [json objectForKey:@"data"]) {
                    PropertyImages *image = nil;
                    
                    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"image_id == %@", [entry objectForKey:@"image_id"]];
                    NSManagedObjectContext *context = ((ABridge_AppDelegate *)[[UIApplication sharedApplication] delegate]).managedObjectContext;
                    NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
                    [fetchRequest setPredicate:predicate];
                    [fetchRequest setEntity:[NSEntityDescription entityForName:@"PropertyImages" inManagedObjectContext:context]];
                    NSError * error = nil;
                    NSArray * results = [context executeFetchRequest:fetchRequest error:&error];
                    if ([results count]) {
                        image = (PropertyImages*)[results firstObject];
                    }
                    else {
                        image = [NSEntityDescription insertNewObjectForEntityForName: @"PropertyImages" inManagedObjectContext: context];
                    }
                    
                    [image setValuesForKeysWithDictionary:entry];
                    
                    NSError *errorSave = nil;
                    if (![context save:&errorSave]) {
                        NSLog(@"Error on saving PropertyImages:%@",[errorSave localizedDescription]);
                    }
                    else {
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            // Update UI
                            if (self.arrayOfImageData == nil) {
                                self.arrayOfImageData = [[NSMutableArray alloc] init];
                            }
                            
                            if (image.image_data == nil) {
                                image.image_data = [NSData dataWithContentsOfURL:[NSURL URLWithString:image.image]];
                            }
                            
                            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(xOffset, 0.0f, self.scrollImages.frame.size.width, self.scrollImages.frame.size.height)];
                            imageView.contentMode = UIViewContentModeScaleAspectFill;
                            imageView.image = [UIImage imageWithData:image.image_data];
                            
                            [self.arrayOfImageData addObject:image.image_data];
                            
                            [self.scrollImages addSubview:imageView];
                            
                            xOffset += imageView.frame.size.width;
                            i++;
                            
                            [self.scrollImages setContentSize:CGSizeMake(xOffset, 0.0f)];
                        });
                        
                    }
                }
                
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    UITapGestureRecognizer *tapZoom = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sendDelegateImage:)];
                    
                    tapZoom.numberOfTapsRequired = 1;
                    tapZoom.numberOfTouchesRequired = 1;
                    [self.scrollImages addGestureRecognizer:tapZoom];
                });
            });
            
        }
        else {
            NSLog(@"no data");
        }
        
        self.loadingImageIndicator.hidden = YES;
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    }
    else if (connection == self.urlConnectionRequestNetwork) {
        if ([[json objectForKey:@"data"] count]) {
//            NSLog(@"Did Finish:%@", json);
                NSManagedObjectContext *context = ((ABridge_AppDelegate *)[[UIApplication sharedApplication] delegate]).managedObjectContext;
                
                NSDictionary *entry = [[json objectForKey:@"data"] firstObject];
                if ([[json objectForKey:@"data"] count]) {
                    RequestNetwork *network = nil;
                    
                    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"network_id == %@", [entry objectForKey:@"network_id"]];
                    
                    NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
                    [fetchRequest setPredicate:predicate];
                    [fetchRequest setEntity:[NSEntityDescription entityForName:@"RequestNetwork" inManagedObjectContext:context]];
                    NSError * error = nil;
                    NSArray * result = [context executeFetchRequest:fetchRequest error:&error];
                    if ([result count]) {
                        network = (RequestNetwork*)[result firstObject];
                    }
                    else {
                        network = [NSEntityDescription insertNewObjectForEntityForName: @"RequestNetwork" inManagedObjectContext: context];
                    }
                    
                    [network setValuesForKeysWithDictionary:entry];
                    
                    NSError *errorSave = nil;
                    if (![context save:&errorSave]) {
                        NSLog(@"Error on saving RequestNetwork:%@",[errorSave localizedDescription]);
                    }
                    
                    if ([network.status integerValue] == 1) {
                        if ([self.propertyDetails.setting integerValue] == 1) {
                            [self checkSettingGetPrice];
                        }
                        else if ([self.propertyDetails.setting integerValue] == 2) {
                            
                            NSString *parameters = [NSString stringWithFormat:@"?user_id=%@&other_user_id=%@&property_id=%@",self.propertyDetails.user_id,self.loginDetail.user_id, self.propertyDetails.listing_id];
                            
                            NSMutableString *urlString_ = [NSMutableString stringWithString:@"http://keydiscoveryinc.com/agent_bridge/webservice/get_request_access.php"];
                            [urlString_ appendString:parameters];
                            //        NSLog(@"url:%@",urlString_);
                            NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlString_]];
                            
                            self.urlConnectionRequestAccess = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self startImmediately:YES];
                            
                            if (self.urlConnectionRequestAccess) {
                                    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
                                    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
                            }
                        }
                        
                    }
                    else if ([network.status integerValue] == 0){
                        self.labelExpiry.text = @"";
                        self.labelExpiry.hidden = YES;
//                        self.viewForDescription.hidden = NO;
                        self.labelDescription.hidden = NO;
                        self.buttonDescription.hidden = NO;
                        self.labelDescription.text = [NSString stringWithFormat:@"This POPs™ is restricted to %@'s Network members only",self.propertyDetails.name];
                        [self.buttonDescription setTitle:@"Pending" forState:UIControlStateNormal];
                        
                        if ([self.delegate respondsToSelector:@selector(hideSaveButton:)]) {
                            [self.delegate hideSaveButton:YES];
                        }
                        
                        
                    }
                }
                else {
                    self.labelExpiry.text = @"";
                    self.labelExpiry.hidden = YES;
//                    self.viewForDescription.hidden = NO;
                    self.labelDescription.hidden = NO;
                    self.buttonDescription.hidden = NO;
                    self.labelDescription.text = [NSString stringWithFormat:@"This POPs™ is restricted to %@'s Network members only",self.propertyDetails.name];
                    [self.buttonDescription setTitle:@"Request To View" forState:UIControlStateNormal];
                    self.buttonDescription.tag = 10001;
                    
//                    if ([self.delegate respondsToSelector:@selector(hideSaveButton:)]) {
//                        [self.delegate hideSaveButton:YES];
//                    }
                }
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
            
        }
        else {
            self.labelExpiry.text = @"";
            self.labelExpiry.hidden = YES;
//            self.viewForDescription.hidden = NO;
            self.labelDescription.hidden = NO;
            self.buttonDescription.hidden = NO;
            self.labelDescription.text = [NSString stringWithFormat:@"This POPs™ is restricted to %@'s Network members only",self.propertyDetails.name];
            [self.buttonDescription setTitle:@"Request To View" forState:UIControlStateNormal];
            self.buttonDescription.tag = 10001;
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
            
//            if ([self.delegate respondsToSelector:@selector(hideSaveButton:)]) {
//                [self.delegate hideSaveButton:YES];
//            }
        }
        
    }
    else if (connection == self.urlConnectionRequestAccess) {
        if ([[json objectForKey:@"data"] count]) {
//            NSLog(@"Did Finish:%@", json);
            NSManagedObjectContext *context = ((ABridge_AppDelegate *)[[UIApplication sharedApplication] delegate]).managedObjectContext;
            NSDictionary *entry = [[json objectForKey:@"data"] firstObject];
            
            if ([[json objectForKey:@"data"] count]) {
                RequestAccess *access = nil;
                
                NSPredicate * predicate = [NSPredicate predicateWithFormat:@"access_id == %@", [entry objectForKey:@"access_id"]];
                
                NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
                [fetchRequest setPredicate:predicate];
                [fetchRequest setEntity:[NSEntityDescription entityForName:@"RequestAccess" inManagedObjectContext:context]];
                NSError * error = nil;
                NSArray * result = [context executeFetchRequest:fetchRequest error:&error];
                
                if ([result count]) {
                    access = (RequestAccess*)[result firstObject];
                }
                else {
                    access = [NSEntityDescription insertNewObjectForEntityForName: @"RequestAccess" inManagedObjectContext: context];
                }
                
                [access setValuesForKeysWithDictionary:entry];
                
                NSError *errorSave = nil;
                if (![context save:&errorSave]) {
                    NSLog(@"Error on saving RequestAccess:%@",[errorSave localizedDescription]);
                }
                
                if ([access.permission boolValue] == YES) {
                    [self getPriceText];
                }
                else if ([access.permission boolValue] == NO){
                    self.labelExpiry.text = @"";
                    self.labelExpiry.hidden = YES;
//                    self.viewForDescription.hidden = NO;
                    self.labelDescription.hidden = NO;
                    self.buttonDescription.hidden = NO;
                    self.labelDescription.text = @"This POPs™ is restricted to private";
                    [self.buttonDescription setTitle:@"Pending" forState:UIControlStateNormal];
                    
                    if ([self.delegate respondsToSelector:@selector(hideSaveButton:)]) {
                        [self.delegate hideSaveButton:YES];
                    }
                }
                
            }
            else {
                self.labelExpiry.text = @"";
                self.labelExpiry.hidden = YES;
//                self.viewForDescription.hidden = NO;
                self.labelDescription.hidden = NO;
                self.buttonDescription.hidden = NO;
                self.labelDescription.text = [NSString stringWithFormat:@"This POPs™ is restricted to %@'s Network members only",self.propertyDetails.name];
                [self.buttonDescription setTitle:@"Request To View" forState:UIControlStateNormal];
                self.buttonDescription.tag = 20002;
                
//                if ([self.delegate respondsToSelector:@selector(hideSaveButton:)]) {
//                    [self.delegate hideSaveButton:YES];
//                }
            }
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
        }
        else {
            self.labelExpiry.text = @"";
            self.labelExpiry.hidden = YES;
//            self.viewForDescription.hidden = NO;
            self.labelDescription.hidden = NO;
            self.buttonDescription.hidden = NO;
            self.labelDescription.text = [NSString stringWithFormat:@"This POPs™ is restricted to %@'s Network members only",self.propertyDetails.name];
            [self.buttonDescription setTitle:@"Request To View" forState:UIControlStateNormal];
            self.buttonDescription.tag = 20002;
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
            
//            if ([self.delegate respondsToSelector:@selector(hideSaveButton:)]) {
//                [self.delegate hideSaveButton:YES];
//            }
        }
    }
    // Do something with responseData
}

- (void) sendDelegateImage:(UIGestureRecognizer*)gestureRecognizer {
    UIScrollView *scrollView = (UIScrollView*)gestureRecognizer.view;
    
    NSInteger image_index = (scrollView.contentOffset.x/scrollView.frame.size.width);
    
    [self.delegate zoomImage:[self.arrayOfImageData objectAtIndex:image_index]];
    
}

- (IBAction)buttonDescriptionPressed:(id)sender {
    switch ([((UIButton*)sender) tag]) {
        case 10001:{
            
            NSString *parameters = [NSString stringWithFormat:@"?user_id=%@&other_user_id=%@",self.loginDetail.user_id, self.propertyDetails.user_id];
            
            NSMutableString *urlString = [NSMutableString stringWithString:@"http://keydiscoveryinc.com/agent_bridge/webservice/request_network.php"];
            [urlString appendString:parameters];
            //            NSLog(@"url:%@",urlString);
            
            __block NSError *errorData = nil;
            __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlString]];
            //            [self.activityIndicator startAnimating];
            //            self.activityIndicator.hidden = NO;
            [request setCompletionBlock:
             ^{
                 NSData *responseData = [request responseData];
                 NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&errorData];
                 
                 NSLog(@"json:%@",json);
                 if ([json objectForKey:@"status"]) {
                     NSLog(@"Success");
                     //                        self.viewForDescription.hidden = NO;
                     
                     self.labelDescription.hidden = NO;
                     self.buttonDescription.hidden = NO;
                     self.labelDescription.text = [NSString stringWithFormat:@"This POPs™ is restricted to %@'s Network members only",self.propertyDetails.name];
                     [self.buttonDescription setTitle:@"Pending" forState:UIControlStateNormal];
                 }
                 else {
                     NSLog(@"Failed");
                 }
                 
                 
             }];
            [request setFailedBlock:^{
                NSError *error = [request error];
                NSLog(@" error:%@",error);
            }];
            
            [request startAsynchronous];
            break;
        }
        case 20002:{
            
            NSString *parameters = [NSString stringWithFormat:@"?user_id=%@&other_user_id=%@&listing_id=%@",self.loginDetail.user_id, self.propertyDetails.user_id,self.propertyDetails.listing_id];
            
            NSMutableString *urlString = [NSMutableString stringWithString:@"http://keydiscoveryinc.com/agent_bridge/webservice/request_access.php"];
            [urlString appendString:parameters];
            //            NSLog(@"url:%@",urlString);
            
            __block NSError *errorData = nil;
            __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlString]];
            //            [self.activityIndicator startAnimating];
            //            self.activityIndicator.hidden = NO;
            [request setCompletionBlock:
             ^{
                 NSData *responseData = [request responseData];
                 NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&errorData];
                 
                 NSLog(@"json:%@",json);
                 if ([json objectForKey:@"status"]) {
                     NSLog(@"Success");
                     //                        self.viewForDescription.hidden = NO;
                     
                     self.labelDescription.hidden = NO;
                     self.buttonDescription.hidden = NO;
                     self.labelDescription.text = @"This POPs™ is restricted to private";
                     [self.buttonDescription setTitle:@"Pending" forState:UIControlStateNormal];
                 }
                 else {
                     NSLog(@"Failed");
                 }
                 
                 
             }];
            [request setFailedBlock:^{
                NSError *error = [request error];
                NSLog(@" error:%@",error);
            }];
            
            [request startAsynchronous];
            break;
        }
        default:
            break;
    }
}
@end
