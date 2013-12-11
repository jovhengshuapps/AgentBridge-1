//
//  ABridge_BuyerPagesViewController.m
//  AgentBridge
//
//  Created by host24_iOS Dev on 12/3/13.
//  Copyright (c) 2013 host24_iOS Dev. All rights reserved.
//

#import "ABridge_BuyerPagesViewController.h"
#import "ABridge_BuyerPopsViewController.h"
#import "Constants.h"

@interface ABridge_BuyerPagesViewController ()

@end

@implementation ABridge_BuyerPagesViewController
@synthesize viewTop;
@synthesize labelBuyerName;
@synthesize labelBuyerType;
@synthesize labelBuyerZip;
@synthesize labelExpiry;
@synthesize labelMatching;
@synthesize labelPrice;
@synthesize textViewDescription;
@synthesize imageProperty;
@synthesize buttonNew;
@synthesize buttonSaved;
@synthesize buyerDetail;
@synthesize index;

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
    
    self.labelExpiry.font = FONT_OPENSANS_REGULAR(FONT_SIZE_SMALL);
    self.textViewDescription.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
    self.labelBuyerName.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
    self.labelBuyerType.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
    
    self.labelPrice.font = FONT_OPENSANS_BOLD(FONT_SIZE_REGULAR);
    self.labelBuyerZip.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
    self.buttonNew.titleLabel.font = FONT_OPENSANS_REGULAR(FONT_SIZE_SMALL);
    self.buttonSaved.titleLabel.font = FONT_OPENSANS_REGULAR(FONT_SIZE_SMALL);
    self.labelMatching.font = FONT_OPENSANS_REGULAR(FONT_SIZE_SMALL);
    
    // Add a bottomBorder.
    CALayer *bottomBorder = [CALayer layer];
    
    bottomBorder.frame = CGRectMake(0.0f, self.viewTop.frame.size.height - 1.0f, self.viewTop.frame.size.width, 1.0f);
    
    bottomBorder.backgroundColor = [UIColor colorWithRed:191.0f/255.0f green:191.0f/255.0f blue:191.0f/255.0f alpha:1.0f].CGColor;
    
    [self.viewTop.layer addSublayer:bottomBorder];
    
    
    NSString *numberSaved = [self.buyerDetail valueForKey:@"saved_pops"];
    NSString *numberNew = [self.buyerDetail valueForKey:@"new_pops"];
    if ([self isNull:numberSaved] && [self isNull:numberNew]) {
        self.labelMatching.text = @"Matching POPs™ may be available on the website.";
        self.labelMatching.hidden = NO;
        self.buttonSaved.hidden = YES;
        self.buttonNew.hidden = YES;

    }
    else {
        self.labelMatching.hidden = YES;
        self.buttonSaved.hidden = [self isNull:numberSaved];
        self.buttonNew.hidden = [self isNull:numberNew];
        if (self.buttonSaved.hidden == NO) {
            [self.buttonSaved setTitle:[NSString stringWithFormat:@"Saved POPs™(%@)",numberSaved] forState:UIControlStateNormal];
        }
        if (self.buttonNew.hidden == NO) {
            [self.buttonNew setTitle:[NSString stringWithFormat:@"New POPs™(%@)",numberNew] forState:UIControlStateNormal];
        }
    }
    

    
    
    self.labelBuyerName.text = self.buyerDetail.name;
    self.labelBuyerType.text = self.buyerDetail.buyer_type;
    self.labelBuyerZip.text = self.buyerDetail.zip;
    NSNumberFormatter * formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterCurrencyStyle;
    [formatter setMaximumFractionDigits:0];
    formatter.currencyCode = @"USD";
    
    NSMutableString *priceText = [NSMutableString stringWithString:@""];
    
    if ([self.buyerDetail.price_value rangeOfString:@"-"].location != NSNotFound) {
        [priceText setString:[formatter stringFromNumber: [NSNumber numberWithDouble:[[self.buyerDetail.price_value substringToIndex:[self.buyerDetail.price_value rangeOfString:@"-"].location] doubleValue]]]];
        [priceText appendString:@" - "];
        [priceText appendString:[formatter stringFromNumber: [NSNumber numberWithDouble:[[self.buyerDetail.price_value substringFromIndex:[self.buyerDetail.price_value rangeOfString:@"-"].location+1] doubleValue]]]];
        
    }
    else {
        [priceText setString:[formatter stringFromNumber: [NSNumber numberWithDouble:[self.buyerDetail.price_value doubleValue]]]];
    }
    
    self.labelPrice.text = priceText;
    
    NSMutableString *featuresString = [NSMutableString stringWithFormat:@""];
    NSEntityDescription *entity = [self.buyerDetail entity];
    NSDictionary *attributes = [entity attributesByName];
    int count = 0;
    for (NSString *attribute in attributes) {
        if([attribute isEqualToString:@"available_sqft"]||[attribute isEqualToString:@"bathroom"]||[attribute isEqualToString:@"bedroom"]||[attribute isEqualToString:@"bldg_sqft"]||[attribute isEqualToString:@"cap_rate"]||[attribute isEqualToString:@"ceiling_height"]||[attribute isEqualToString:@"condition"]||[attribute isEqualToString:@"furnished"]||[attribute isEqualToString:@"garage"]||[attribute isEqualToString:@"grm"]||[attribute isEqualToString:@"lot_size"]||[attribute isEqualToString:@"lot_sqft"]||[attribute isEqualToString:@"view"]||[attribute isEqualToString:@"year_built"]||[attribute isEqualToString:@"stories"]||[attribute isEqualToString:@"unit_sqft"]||[attribute isEqualToString:@"features1"]||[attribute isEqualToString:@"features2"]||[attribute isEqualToString:@"features3"]){
            
            
            if (count == 5) {
                break;
            }
            else {
                if (![self isNull:[self.buyerDetail valueForKey:attribute]]) {
                    if([attribute isEqualToString:@"features1"]||[attribute isEqualToString:@"features2"]||[attribute isEqualToString:@"features3"]){
                        [featuresString appendFormat:@"%@, ", [self.buyerDetail valueForKey:attribute]];
                    }
                    else {
                        NSMutableString *unit = [NSMutableString stringWithString:attribute];
                        [unit replaceOccurrencesOfString:@"_sqft" withString:@" sq.ft." options:NSCaseInsensitiveSearch range:NSMakeRange(0, [unit length])];
                        [unit replaceOccurrencesOfString:@"_" withString:@" " options:NSCaseInsensitiveSearch range:NSMakeRange(0, [unit length])];
                        [featuresString appendFormat:@"%@",[NSString stringWithFormat:@"%@ %@, ",[self.buyerDetail valueForKey:attribute],unit]];
                    }
                    
                    count++;
                }
            }
            
            
        }
    }
    
    if ([featuresString rangeOfString:@","].location != NSNotFound) {
        NSString *removedLastComma = [featuresString substringToIndex:[featuresString length]-2];
        
        [featuresString setString:[NSString stringWithFormat:@"%@\n\n",removedLastComma]];
    }
    
    self.textViewDescription.text = featuresString;
    
    
    self.labelExpiry.text = [NSString stringWithFormat:@"Expiry of %@ days", self.buyerDetail.expiry];
    
    
    self.imageProperty.image = [UIImage imageNamed:[self imageStringForPropertyType:[self.buyerDetail.property_type integerValue] andSubType:[self.buyerDetail.sub_type integerValue]]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return imageString;
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"show_saved_pops"]) {
        ((ABridge_BuyerPopsViewController*) segue.destinationViewController).is_saved = YES;
        ((ABridge_BuyerPopsViewController*) segue.destinationViewController).buyer_id = [self.buyerDetail.buyer_id integerValue];
    }
    else if ([segue.identifier isEqualToString:@"show_new_pops"]) {
        ((ABridge_BuyerPopsViewController*) segue.destinationViewController).is_saved = NO;
        ((ABridge_BuyerPopsViewController*) segue.destinationViewController).buyer_id = [self.buyerDetail.buyer_id integerValue];
    }
}
@end
