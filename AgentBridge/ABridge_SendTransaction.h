//
//  ABridge_SendTransaction.h
//  AgentBridge
//
//  Created by host24_iOS Dev on 12/16/13.
//  Copyright (c) 2013 host24_iOS Dev. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "MobileDeviceLoginRequest.h"
//#import "AuthNet.h"


// To run the unit tests, you must enter in your test credentials
#define API_LOGIN_ID @"7fD6L6mV"
#define TRANSACTION_KEY @"2nC2Y5q8LkM9526c"

#define USERNAME @"jovhenni19"
#define PASSWORD @"Vhengshua19"
#define CPUSERNAME @"cardpresentusername"
#define CPPASSWORD @"cardpresentpassword"
//[[NSString stringWithString:[[UIDevice currentDevice] uniqueIdentifier]] stringByReplacingOccurrencesOfString:@"-" withString:@"_"]
#define MOBILE_DEVICE_ID [[[NSUUID UUID] UUIDString] stringByReplacingOccurrencesOfString:@"-" withString:@"_"]


@interface ABridge_SendTransaction : NSObject /*<AuthNetDelegate>*/
- (void) loginToGateway;
@end
