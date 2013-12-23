//
//  ABridge_AutocompleteTextField.h
//  AgentBridge
//
//  Created by host24_iOS Dev on 12/23/13.
//  Copyright (c) 2013 host24_iOS Dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface ABridge_AutocompleteTextField : UITextField <UITableViewDelegate, UITableViewDataSource> {
	NSMutableArray *autoCompleteArray;
	NSMutableArray *elementArray, *lowerCaseElementArray;
	UITableView *autoCompleteTableView;
}

@property (strong, nonatomic) NSArray *autoCompleteContents;
@property (assign, nonatomic) CGFloat tableRowHeight;

@end
