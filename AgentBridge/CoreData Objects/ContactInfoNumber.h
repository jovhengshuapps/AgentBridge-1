//
//  ContactInfoNumber.h
//  AgentBridge
//
//  Created by host24_iOS Dev on 12/19/13.
//  Copyright (c) 2013 host24_iOS Dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ContactInfoNumber : NSManagedObject

@property (nonatomic, retain) NSString * pk_id;
@property (nonatomic, retain) NSString * value;
@property (nonatomic, retain) NSString * user_id;
@property (nonatomic, retain) NSString * main;
@property (nonatomic, retain) NSString * show;

@end
