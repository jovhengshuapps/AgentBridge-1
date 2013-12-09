//
//  Activity.h
//  AgentBridge
//
//  Created by host24_iOS Dev on 12/5/13.
//  Copyright (c) 2013 host24_iOS Dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Activity : NSManagedObject

@property (nonatomic, retain) NSString * activities_id;
@property (nonatomic, retain) NSString * activity_id;
@property (nonatomic, retain) NSString * activity_type;
@property (nonatomic, retain) NSString * buyer_id;
@property (nonatomic, retain) NSString * buyer_name;
@property (nonatomic, retain) NSString * date;
@property (nonatomic, retain) NSString * image;
@property (nonatomic, retain) NSData * image_data;
@property (nonatomic, retain) NSString * listing_id;
@property (nonatomic, retain) NSString * other_user_id;
@property (nonatomic, retain) NSString * other_user_name;
@property (nonatomic, retain) NSString * pops_user_id;
@property (nonatomic, retain) NSString * pops_user_name;
@property (nonatomic, retain) NSString * property_name;
@property (nonatomic, retain) NSString * user_id;
@property (nonatomic, retain) NSString * referral_id;
@property (nonatomic, retain) NSString * referral_status;
@property (nonatomic, retain) NSString * referral_response;
@property (nonatomic, retain) NSString * referral_fee;
@property (nonatomic, retain) NSString * client_id;
@property (nonatomic, retain) NSString * referral_buyer_name;
@property (nonatomic, retain) NSString * referral_date;
@property (nonatomic, retain) NSString * setting;
@property (nonatomic, retain) NSString * user_name;

@end
