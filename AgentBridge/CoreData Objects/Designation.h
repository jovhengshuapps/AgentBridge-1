//
//  Designation.h
//  AgentBridge
//
//  Created by host24_iOS Dev on 12/19/13.
//  Copyright (c) 2013 host24_iOS Dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Designation : NSManagedObject

@property (nonatomic, retain) NSString * designation_id;
@property (nonatomic, retain) NSString * designations;
@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSString * country_available;

@end
