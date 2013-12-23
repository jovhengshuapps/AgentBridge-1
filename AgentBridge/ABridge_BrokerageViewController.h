//
//  ABridge_BrokerageViewController.h
//  AgentBridge
//
//  Created by host24_iOS Dev on 11/28/13.
//  Copyright (c) 2013 host24_iOS Dev. All rights reserved.
//

#import "ABridge_ParentViewController.h"
#import "MLPAutoCompleteTextField.h"

@interface ABridge_BrokerageViewController : ABridge_ParentViewController<UITextFieldDelegate, NSURLConnectionDelegate, UIScrollViewDelegate, MLPAutoCompleteTextFieldDataSource, MLPAutoCompleteTextFieldDelegate, UITableViewDataSource, UITableViewDelegate>

@end
