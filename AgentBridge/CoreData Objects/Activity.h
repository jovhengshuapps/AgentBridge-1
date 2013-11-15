//
//  Activity.h
//  AgentBridge
//
//  Created by host24_iOS Dev on 11/15/13.
//  Copyright (c) 2013 host24_iOS Dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Activity : NSManagedObject

@property (nonatomic, retain) NSNumber * activity_id;
@property (nonatomic, retain) NSNumber * activity_type;
@property (nonatomic, retain) NSNumber * buyer_id;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * has_multiples;
@property (nonatomic, retain) NSNumber * other_user_id;
@property (nonatomic, retain) NSNumber * pkId;
@property (nonatomic, retain) NSNumber * user_id;

@end
