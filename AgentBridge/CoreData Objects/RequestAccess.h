//
//  RequestAccess.h
//  AgentBridge
//
//  Created by host24_iOS Dev on 12/2/13.
//  Copyright (c) 2013 host24_iOS Dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface RequestAccess : NSManagedObject

@property (nonatomic, retain) NSString * user_a;
@property (nonatomic, retain) NSString * user_b;
@property (nonatomic, retain) NSString * property_id;
@property (nonatomic, retain) NSString * permission;
@property (nonatomic, retain) NSString * access_id;

@end
