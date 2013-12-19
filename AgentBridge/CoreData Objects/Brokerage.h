//
//  Brokerage.h
//  AgentBridge
//
//  Created by host24_iOS Dev on 12/19/13.
//  Copyright (c) 2013 host24_iOS Dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Brokerage : NSManagedObject

@property (nonatomic, retain) NSString * broker_id;
@property (nonatomic, retain) NSString * broker_name;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * zone_id;
@property (nonatomic, retain) NSString * state;
@property (nonatomic, retain) NSString * country_id;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * address_line1;
@property (nonatomic, retain) NSString * address_line2;
@property (nonatomic, retain) NSString * postal_code;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSString * site;
@property (nonatomic, retain) NSString * tax_id;

@end
