//
//  Constants.h
//  AgentBridge
//
//  Created by host24_iOS Dev on 11/13/13.
//  Copyright (c) 2013 host24_iOS Dev. All rights reserved.
//

#ifndef AgentBridge_Constants_h
#define AgentBridge_Constants_h

#define isiPhone5  ([[UIScreen mainScreen] bounds].size.height == 568)?TRUE:FALSE
#define FONT_OPENSANS_BOLD(s) [UIFont fontWithName:@"OpenSans-Bold" size:s]
#define FONT_OPENSANS_ITALIC(s) [UIFont fontWithName:@"OpenSans-Italic-webfont" size:s]
#define FONT_OPENSANS_LIGHT(s) [UIFont fontWithName:@"OpenSans-Light-webfont" size:s]
#define FONT_OPENSANS_REGULAR(s) [UIFont fontWithName:@"OpenSans" size:s]
#define FONT_OPENSANS_SEMIBOLD(s) [UIFont fontWithName:@"OpenSans-Semibold-webfont" size:s]
#define CLIENT_INTENTION(choice) (choice == 1)?@"Buying":(choice == 2)?@"Selling":(choice == 3)?@"Buying and Selling":(choice == 4)?@"Leasing":@""
#define REFERRAL_STATUS_UNDERCONTRACT                                               1
#define REFERRAL_STATUS_CLOSED                                                      4
#define REFERRAL_STATUS_NOGO                                                        5
#define REFERRAL_STATUS_NEEDHELP                                                    6
#define REFERRAL_STATUS_PENDING                                                     7
#define REFERRAL_STATUS_ACCEPTED                                                    8
#define REFERRAL_STATUS_COMMISSIONRECEIVED                                          9

#define RESIDENTIAL_PURCHASE                                                        1
#define RESIDENTIAL_LEASE                                                           2
#define COMMERCIAL_PURCHASE                                                         3
#define COMMERCIAL_LEASE                                                            4

#define RESIDENTIAL_PURCHASE_SFR                                                    1
#define RESIDENTIAL_PURCHASE_CONDO                                                  2
#define RESIDENTIAL_PURCHASE_TOWNHOUSE                                              3
#define RESIDENTIAL_PURCHASE_LAND                                                   4
#define RESIDENTIAL_LEASE_SFR                                                       5
#define RESIDENTIAL_LEASE_CONDO                                                     6
#define RESIDENTIAL_LEASE_TOWNHOUSE                                                 7
#define RESIDENTIAL_LEASE_LAND                                                      8
#define COMMERCIAL_PURCHASE_MULTI_FAMILY                                            9
#define COMMERCIAL_PURCHASE_OFFICE                                                  10
#define COMMERCIAL_PURCHASE_INDUSTRIAL                                              11
#define COMMERCIAL_PURCHASE_RETAIL                                                  12
#define COMMERCIAL_PURCHASE_MOTEL                                                   13
#define COMMERCIAL_PURCHASE_ASSISTED_CARE                                           14
#define COMMERCIAL_PURCHASE_SPECIAL_PURPOSE                                         15
#define COMMERCIAL_LEASE_OFFICE                                                     16
#define COMMERCIAL_LEASE_INDUSTRIAL                                                 17
#define COMMERCIAL_LEASE_RETAIL                                                     18

#define FONT_SIZE_TITLE                                                             18.0f
#define FONT_SIZE_REGULAR                                                           16.0f
#define FONT_SIZE_SMALL                                                             14.0f
#define FONT_SIZE_FOR_PROFILE                                                       12.0f

#endif
