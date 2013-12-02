//
//  HTTPURLConnection.m
//  AgentBridge
//
//  Created by host24_iOS Dev on 11/29/13.
//  Copyright (c) 2013 host24_iOS Dev. All rights reserved.
//

#import "HTTPURLConnection.h"

@implementation HTTPURLConnection

@synthesize response = _response, responseData = _responseData;

- (id)initWithRequest:(NSURLRequest *)request delegate:(id)delegate {
    NSAssert(self != nil, @"self is nil!");
    
    // Initialize the ivars before initializing with the request
    // because the connection is asynchronous and may start
    // calling the delegates before we even return from this
    // function.
    
    self.response = nil;
    self.responseData = nil;
    
    self = [super initWithRequest:request delegate:delegate];
    return self;
}

//- (void)dealloc {
//    [self.response release];
//    [self.responseData release];
//    
//    [super dealloc];
//}

@end
