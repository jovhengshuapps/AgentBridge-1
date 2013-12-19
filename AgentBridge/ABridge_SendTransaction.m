//
//  ABridge_SendTransaction.m
//  AgentBridge
//
//  Created by host24_iOS Dev on 12/16/13.
//  Copyright (c) 2013 host24_iOS Dev. All rights reserved.
//

#import "ABridge_SendTransaction.h"

@interface ABridge_SendTransaction ()
@property (strong, nonatomic) NSString *sessionToken;
@end

@implementation ABridge_SendTransaction
@synthesize sessionToken;

- (void) loginToGateway {
//    MobileDeviceLoginRequest *mobileDeviceLoginRequest = [MobileDeviceLoginRequest mobileDeviceLoginRequest];
//    mobileDeviceLoginRequest.anetApiRequest.merchantAuthentication.name = USERNAME;
//    mobileDeviceLoginRequest.anetApiRequest.merchantAuthentication.password = PASSWORD;
//    mobileDeviceLoginRequest.anetApiRequest.merchantAuthentication.mobileDeviceId = MOBILE_DEVICE_ID;
//    
//    
//    AuthNet *an = [AuthNet getInstance];
//    [an setDelegate:self];
//    [an mobileDeviceLoginRequest: mobileDeviceLoginRequest];
    
    // First time we need to do a mobile device registration request. Remember that if this is the first time you've registered your
    // device, the transaction will fail, however your device will now be in "pending" status in the test portal
    // (https://test.authorize.net).
//    MobileDeviceRegistrationRequest *mobileDeviceRegistrationRequest = [MobileDeviceRegistrationRequest mobileDeviceRegistrationRequest];
//    mobileDeviceRegistrationRequest.mobileDevice.mobileDeviceId = [[[NSUUID UUID] UUIDString] stringByReplacingOccurrencesOfString:@"-" withString:@"_"];
//    mobileDeviceRegistrationRequest.mobileDevice.mobileDescription = @"My_Device";
//    mobileDeviceRegistrationRequest.mobileDevice.phoneNumber = @"1234567890";
//    mobileDeviceRegistrationRequest.anetApiRequest.merchantAuthentication.name = API_LOGIN_ID;
//    mobileDeviceRegistrationRequest.anetApiRequest.merchantAuthentication.password = TRANSACTION_KEY;
//    
//    // Create our login request.
//    MobileDeviceLoginRequest *mobileDeviceLoginRequest = [MobileDeviceLoginRequest mobileDeviceLoginRequest];
//    mobileDeviceLoginRequest.anetApiRequest.merchantAuthentication.name = API_LOGIN_ID;
//    mobileDeviceLoginRequest.anetApiRequest.merchantAuthentication.password = TRANSACTION_KEY;
//    mobileDeviceLoginRequest.anetApiRequest.merchantAuthentication.mobileDeviceId = [[[NSUUID UUID] UUIDString] stringByReplacingOccurrencesOfString:@"-" withString:@"_"];
//    
//    // Set up an AuthNet instance.
//    AuthNet *an = [[AuthNet alloc]init];
//    
//    [an setDelegate:self];
//    
//    // Process a mobile device registration request.
//    [an mobileDeviceRegistrationRequest:mobileDeviceRegistrationRequest];
//    
//    NSLog(@"make request:%@",MOBILE_DEVICE_ID);
//    // Process a mobile device login request.
//    [an mobileDeviceLoginRequest:mobileDeviceLoginRequest];
}

//- (void) createTransaction {
//    AuthNet *an = [[AuthNet alloc]init];
//    
//    [an setDelegate:self];
//    NSLog(@"creating transaction");
//    CreditCardType *creditCardType = [CreditCardType creditCardType];
//    creditCardType.cardNumber = @"4111111111111111";
//    creditCardType.cardCode = @"100";
//    creditCardType.expirationDate = @"1212";
//    
//    PaymentType *paymentType = [PaymentType paymentType];
//    paymentType.creditCard = creditCardType;
//    
//    ExtendedAmountType *extendedAmountTypeTax = [ExtendedAmountType extendedAmountType];
//    extendedAmountTypeTax.amount = @"0";
//    extendedAmountTypeTax.name = @"Tax";
//    
//    ExtendedAmountType *extendedAmountTypeShipping = [ExtendedAmountType extendedAmountType];
//    extendedAmountTypeShipping.amount = @"0";
//    extendedAmountTypeShipping.name = @"Shipping";
//    
//    LineItemType *lineItem = [LineItemType lineItem];
//    lineItem.itemName = @"Soda";
//    lineItem.itemDescription = @"Soda";
//    lineItem.itemQuantity = @"1";
//    lineItem.itemPrice = @"1.00";
//    lineItem.itemID = @"1";
//    
//    TransactionRequestType *requestType = [TransactionRequestType transactionRequest];
//    requestType.lineItems = [NSMutableArray arrayWithObject:lineItem];//[NSArray arrayWithObject:lineItem];
//    requestType.amount = @"1.00";
//    requestType.payment = paymentType;
//    requestType.tax = extendedAmountTypeTax;
//    requestType.shipping = extendedAmountTypeShipping;
//    
//    CreateTransactionRequest *request = [CreateTransactionRequest createTransactionRequest];
//    request.transactionRequest = requestType;
//    request.transactionType = AUTH_ONLY;
//    request.anetApiRequest.merchantAuthentication.mobileDeviceId = MOBILE_DEVICE_ID;
//    request.anetApiRequest.merchantAuthentication.sessionToken = sessionToken;
//    NSLog(@"sending request");
//    [an purchaseWithRequest:request];
//}
//
//- (void) requestFailed:(AuthNetResponse *)response {
//    // Handle a failed request
//    NSLog(@"failed request");
//}
//
//- (void) connectionFailed:(AuthNetResponse *)response {
//    // Handle a failed connection
//    NSLog(@"failed connection");
//}
//
//- (void) paymentSucceeded:(CreateTransactionResponse *) response {
//    // Handle payment success
//    NSLog(@"success");
//}
//
//- (void) mobileDeviceLoginSucceeded:(MobileDeviceLoginResponse *)response {
//    sessionToken = response.sessionToken;
//    [self createTransaction];
//};
@end
