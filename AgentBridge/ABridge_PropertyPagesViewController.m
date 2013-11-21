//
//  ABridge_PropertyPagesViewController.m
//  AgentBridge
//
//  Created by host24_iOS Dev on 11/14/13.
//  Copyright (c) 2013 host24_iOS Dev. All rights reserved.
//

#import "ABridge_PropertyPagesViewController.h"
#import "Constants.h"

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

@end

@implementation ABridge_PropertyPagesViewController
@synthesize index;
@synthesize propertyDetails;

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
    self.labelPage.text = [NSString stringWithFormat:@"%li",(long)self.index+1];
    
    self.labelZip.text = self.propertyDetails.zip;
    self.labelPropertyName.text = self.propertyDetails.property_name;
    self.labelPropertyType.text = [NSString stringWithFormat:@"%@ - %@",self.propertyDetails.type_name, self.propertyDetails.sub_type_name];
    NSNumberFormatter * formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterCurrencyStyle;
    formatter.currencyCode = @"USD";
    
    NSMutableString *priceText = [NSMutableString stringWithString:@"$"];
    [priceText appendString:[formatter stringFromNumber: [NSNumber numberWithDouble:[self.propertyDetails.price1 doubleValue]]]];
    if ([self.propertyDetails.price_type integerValue] == YES) {
        [priceText appendFormat:@" - $%@",[formatter stringFromNumber: [NSNumber numberWithDouble:[self.propertyDetails.price2 doubleValue]]]];
    }
    self.labelPrice.text = priceText;
    self.labelExpiry.text = [NSString stringWithFormat:@"Expiry of %@ days", self.propertyDetails.expiry];
    
    NSMutableString *featuresString = [NSMutableString stringWithFormat:@"%@\n\n",self.propertyDetails.desc];
    NSEntityDescription *entity = [self.propertyDetails entity];
    NSDictionary *attributes = [entity attributesByName];
    int count = 0;
    for (NSString *attribute in attributes) {
        if([attribute isEqualToString:@"available_sqft"]||[attribute isEqualToString:@"bathroom"]||[attribute isEqualToString:@"bedroom"]||[attribute isEqualToString:@"bldg_sqft"]||[attribute isEqualToString:@"cap_rate"]||[attribute isEqualToString:@"ceiling_height"]||[attribute isEqualToString:@"condition"]||[attribute isEqualToString:@"furnished"]||[attribute isEqualToString:@"garage"]||[attribute isEqualToString:@"grm"]||[attribute isEqualToString:@"lot_size"]||[attribute isEqualToString:@"lot_sqft"]||[attribute isEqualToString:@"view"]||[attribute isEqualToString:@"year_built"]||[attribute isEqualToString:@"stories"]||[attribute isEqualToString:@"unit_sqft"]){
            
            //            NSLog(@"%@ value:%@",([self isNull:[buyerDetails valueForKey:attribute]])?@"YES":@"NO",[buyerDetails valueForKey:attribute]);
            
            if (count == 5) {
                break;
            }
            else {
                if (![self isNull:[self.propertyDetails valueForKey:attribute]]) {
                    
                    [featuresString appendFormat:@"%@",[NSString stringWithFormat:@"%@ %@, ",[self.propertyDetails valueForKey:attribute],attribute]];
                }
            }
            
            count++;
            
        }
        else if([attribute isEqualToString:@"features1"]||[attribute isEqualToString:@"features2"]||[attribute isEqualToString:@"features3"]){
            [featuresString appendFormat:@"%@, ", [self.propertyDetails valueForKey:attribute]];
        }
    }
    
    NSString *removedLastComma = [featuresString substringToIndex:[featuresString length]-2];
    
    [featuresString setString:removedLastComma];
    
    self.textFeatures.text = featuresString;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.scrollImages.frame.size.width, self.scrollImages.frame.size.height)];
    imageView.contentMode = UIViewContentModeCenter;
    imageView.image = [UIImage imageNamed:[self imageStringForPropertyType:[self.propertyDetails.type_property_type integerValue] andSubType:[self.propertyDetails.sub_type integerValue]]];
    
    [self.scrollImages addSubview:imageView];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
}

-(BOOL)isNull:(id)value {
    return ([[NSNull class] isMemberOfClass:[((NSNull *) value) class]]);
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

@end
