//
//  LoginDetails.h
//  AgentBridge
//
//  Created by host24_iOS Dev on 11/15/13.
//  Copyright (c) 2013 host24_iOS Dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface LoginDetails : NSManagedObject

@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * profile_id;
@property (nonatomic, retain) NSNumber * user_id;
@property (nonatomic, retain) NSString * username;

@end
