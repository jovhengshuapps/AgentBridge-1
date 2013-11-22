//
//  PropertyImages.h
//  AgentBridge
//
//  Created by host24_iOS Dev on 11/22/13.
//  Copyright (c) 2013 host24_iOS Dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface PropertyImages : NSManagedObject

@property (nonatomic, retain) NSString * image_id;
@property (nonatomic, retain) NSString * image;
@property (nonatomic, retain) NSData * image_data;

@end
