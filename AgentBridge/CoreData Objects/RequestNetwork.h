//
//  RequestNetwork.h
//  AgentBridge
//
//  Created by host24_iOS Dev on 12/2/13.
//  Copyright (c) 2013 host24_iOS Dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface RequestNetwork : NSManagedObject

@property (nonatomic, retain) NSString * network_id;
@property (nonatomic, retain) NSString * user_id;
@property (nonatomic, retain) NSString * other_user_id;
@property (nonatomic, retain) NSString * status;

@end
