//
//  HTAutocompleteManager.h
//  HotelTonight
//
//  Created by Jonathan Sibley on 12/6/12.
//  Copyright (c) 2012 Hotel Tonight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTAutocompleteTextField.h"

typedef enum {
    HTAutocompleteTypeBrokerage, // Default
    HTAutocompleteTypeDesignation,
} HTAutocompleteType;

@interface HTAutocompleteManager : NSObject <HTAutocompleteDataSource>

+ (HTAutocompleteManager *)sharedManager;

@property (strong, nonatomic) NSArray *arrayOfBroker;
@property (strong, nonatomic) NSArray *arrayOfDesignation;

@end
