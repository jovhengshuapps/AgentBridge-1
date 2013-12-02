//
//  State.h
//  AgentBridge
//
//  Created by host24_iOS Dev on 11/28/13.
//  Copyright (c) 2013 host24_iOS Dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface State : NSManagedObject

@property (nonatomic, retain) NSString * zone_id;
@property (nonatomic, retain) NSString * zone_country_id;
@property (nonatomic, retain) NSString * zone_code;
@property (nonatomic, retain) NSString * zone_name;

@end
