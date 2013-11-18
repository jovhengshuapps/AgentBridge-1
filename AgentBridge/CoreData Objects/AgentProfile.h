//
//  AgentProfile.h
//  AgentBridge
//
//  Created by host24_iOS Dev on 11/18/13.
//  Copyright (c) 2013 host24_iOS Dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface AgentProfile : NSManagedObject

@property (nonatomic, retain) NSString * about;
@property (nonatomic, retain) NSString * activation_status;
@property (nonatomic, retain) NSString * broker_name;
@property (nonatomic, retain) NSString * brokerage_license;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * countries_name;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * firstname;
@property (nonatomic, retain) NSString * image;
@property (nonatomic, retain) NSString * image_data;
@property (nonatomic, retain) NSString * is_premium;
@property (nonatomic, retain) NSString * lastname;
@property (nonatomic, retain) NSString * licence;
@property (nonatomic, retain) NSString * mobile_number;
@property (nonatomic, retain) NSString * mobile_number_main;
@property (nonatomic, retain) NSString * mobile_number_show;
@property (nonatomic, retain) NSString * registration_date;
@property (nonatomic, retain) NSString * state;
@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) NSString * street_address;
@property (nonatomic, retain) NSString * suburb;
@property (nonatomic, retain) NSString * tax_id_num;
@property (nonatomic, retain) NSString * user_id;
@property (nonatomic, retain) NSString * zip;

@end
