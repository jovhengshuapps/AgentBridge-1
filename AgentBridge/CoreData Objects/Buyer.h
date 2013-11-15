//
//  Buyer.h
//  AgentBridge
//
//  Created by host24_iOS Dev on 11/15/13.
//  Copyright (c) 2013 host24_iOS Dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Buyer : NSManagedObject

@property (nonatomic, retain) NSString * zoned;
@property (nonatomic, retain) NSNumber * zip;
@property (nonatomic, retain) NSNumber * year_built;
@property (nonatomic, retain) NSString * view;
@property (nonatomic, retain) NSString * units;
@property (nonatomic, retain) NSString * unit_sqft;
@property (nonatomic, retain) NSString * type_lease2;
@property (nonatomic, retain) NSString * type_lease;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * term;
@property (nonatomic, retain) NSNumber * sub_type;
@property (nonatomic, retain) NSString * style;
@property (nonatomic, retain) NSString * stories;
@property (nonatomic, retain) NSString * state;
@property (nonatomic, retain) NSNumber * setting;
@property (nonatomic, retain) NSString * room_count;
@property (nonatomic, retain) NSNumber * property_type;
@property (nonatomic, retain) NSString * property_name;
@property (nonatomic, retain) NSString * price_value;
@property (nonatomic, retain) NSNumber * price_type;
@property (nonatomic, retain) NSString * possession;
@property (nonatomic, retain) NSString * pool_spa;
@property (nonatomic, retain) NSString * pet;
@property (nonatomic, retain) NSString * parking_ratio;
@property (nonatomic, retain) NSString * occupancy;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * lot_sqft;
@property (nonatomic, retain) NSString * lot_size;
@property (nonatomic, retain) NSNumber * listingcount;
@property (nonatomic, retain) NSString * listing_class;
@property (nonatomic, retain) NSNumber * hasnew_2;
@property (nonatomic, retain) NSNumber * hasnew;
@property (nonatomic, retain) NSString * grm;
@property (nonatomic, retain) NSNumber * garage;
@property (nonatomic, retain) NSString * furnished;
@property (nonatomic, retain) NSString * features1;
@property (nonatomic, retain) NSString * features2;
@property (nonatomic, retain) NSString * features3;
@property (nonatomic, retain) NSNumber * expiry;
@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSNumber * contact_type;
@property (nonatomic, retain) NSNumber * contact_method;
@property (nonatomic, retain) NSString * condition;
@property (nonatomic, retain) NSNumber * closed;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * ceiling_height;
@property (nonatomic, retain) NSString * cap_rate;
@property (nonatomic, retain) NSString * buyer_type;
@property (nonatomic, retain) NSString * bldg_sqft;
@property (nonatomic, retain) NSNumber * bedroom;
@property (nonatomic, retain) NSNumber * bathroom;
@property (nonatomic, retain) NSString * available_sqft;

@end
