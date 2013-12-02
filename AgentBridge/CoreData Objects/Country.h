//
//  Country.h
//  AgentBridge
//
//  Created by host24_iOS Dev on 11/28/13.
//  Copyright (c) 2013 host24_iOS Dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Country : NSManagedObject

@property (nonatomic, retain) NSString * countries_id;
@property (nonatomic, retain) NSString * countries_name;
@property (nonatomic, retain) NSString * countries_iso_code_2;
@property (nonatomic, retain) NSString * countries_iso_code_3;
@property (nonatomic, retain) NSString * address_format_id;

@end
