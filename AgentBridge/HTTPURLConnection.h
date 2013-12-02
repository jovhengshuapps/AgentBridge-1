//
//  HTTPURLConnection.h
//  AgentBridge
//
//  Created by host24_iOS Dev on 11/29/13.
//  Copyright (c) 2013 host24_iOS Dev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTTPURLConnection : NSURLConnection {
    NSHTTPURLResponse* _response;
    NSMutableData* _responseData;
}

@property(nonatomic,retain) NSHTTPURLResponse* response;
@property(nonatomic,retain) NSMutableData* responseData;

@end