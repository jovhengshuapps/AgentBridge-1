//
//  HTAutocompleteManager.m
//  HotelTonight
//
//  Created by Jonathan Sibley on 12/6/12.
//  Copyright (c) 2012 Hotel Tonight. All rights reserved.
//

#import "HTAutocompleteManager.h"

static HTAutocompleteManager *sharedManager;

@implementation HTAutocompleteManager
@synthesize arrayOfBroker;

+ (HTAutocompleteManager *)sharedManager
{
	static dispatch_once_t done;
	dispatch_once(&done, ^{ sharedManager = [[HTAutocompleteManager alloc] init]; });
	return sharedManager;
}

#pragma mark - HTAutocompleteTextFieldDelegate

- (NSString *)textField:(HTAutocompleteTextField *)textField
    completionForPrefix:(NSString *)prefix
             ignoreCase:(BOOL)ignoreCase
{
    if (textField.autocompleteType == HTAutocompleteTypeBrokerage)
    {
        
    
        // If no domain is entered, use the first domain in the list
//        if ([prefix length] == 0)
//        {
//            return [self.arrayOfBroker objectAtIndex:0];
//        }
//        
        
        NSString *stringToLookFor;
        if (ignoreCase)
        {
            stringToLookFor = [prefix lowercaseString];
        }
        else
        {
            stringToLookFor = prefix;
        }
        
        for (NSString *stringFromReference in self.arrayOfBroker)
        {
            NSString *stringToCompare;
            if (ignoreCase)
            {
                stringToCompare = [stringFromReference lowercaseString];
            }
            else
            {
                stringToCompare = stringFromReference;
            }
            
            if ([stringToCompare hasPrefix:stringToLookFor])
            {
                return [stringFromReference stringByReplacingCharactersInRange:[stringToCompare rangeOfString:stringToLookFor] withString:@""];
            }
            
        }
        
    }
    else if (textField.autocompleteType == HTAutocompleteTypeDesignation)
    {
        
        
        // If no domain is entered, use the first domain in the list
//        if ([prefix length] == 0)
//        {
//            return [self.arrayOfDesignation objectAtIndex:0];
//        }
        
        
        NSString *stringToLookFor;
        if (ignoreCase)
        {
            stringToLookFor = [prefix lowercaseString];
        }
        else
        {
            stringToLookFor = prefix;
        }
        
        for (NSString *stringFromReference in self.arrayOfDesignation)
        {
            NSString *stringToCompare;
            if (ignoreCase)
            {
                stringToCompare = [stringFromReference lowercaseString];
            }
            else
            {
                stringToCompare = stringFromReference;
            }
            
            if ([stringToCompare hasPrefix:stringToLookFor])
            {
                return [stringFromReference stringByReplacingCharactersInRange:[stringToCompare rangeOfString:stringToLookFor] withString:@""];
            }
            
        }
    }
    
    return @"";
}

@end
