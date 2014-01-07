//
//  ABridge_AutocompleteTextField.m
//  AgentBridge
//
//  Created by host24_iOS Dev on 12/23/13.
//  Copyright (c) 2013 host24_iOS Dev. All rights reserved.
//

#import "ABridge_AutocompleteTextField.h"
#import "Constants.h"

@implementation ABridge_AutocompleteTextField
@synthesize autoCompleteContents;
@synthesize tableRowHeight;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/



- (void) finishedSearching {
	[self resignFirstResponder];
	autoCompleteTableView.hidden = YES;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.tableRowHeight == 0) {
        self.tableRowHeight = FONT_SIZE_REGULAR;
    }
    
    if ([[self subviews] containsObject:autoCompleteTableView] == NO) {
        
        //Set AutoCorrectionType No
        self.autocorrectionType = UITextAutocorrectionTypeNo;
        self.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
        
        //Autocomplete Table
        autoCompleteTableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, self.tableRowHeight + 10.0f, self.frame.size.width+1.0f, self.tableRowHeight) style:UITableViewStylePlain];
        autoCompleteTableView.delegate = self;
        autoCompleteTableView.dataSource = self;
        autoCompleteTableView.scrollEnabled = YES;
        autoCompleteTableView.hidden = YES;
        autoCompleteTableView.backgroundColor = [UIColor whiteColor];
        autoCompleteTableView.rowHeight = self.tableRowHeight;
        
        
        [self addSubview:autoCompleteTableView];
        
        
        autoCompleteTableView.layer.shadowOpacity = 0.75f;
        autoCompleteTableView.layer.shadowRadius = 10.0f;
        autoCompleteTableView.layer.shadowColor = [UIColor blackColor].CGColor;
        
//        self.clipsToBounds = NO;
        
    }
    
    if ([elementArray count] == 0) {
        
        elementArray = [[NSMutableArray alloc] initWithArray:self.autoCompleteContents];
        autoCompleteArray = [[NSMutableArray alloc] init];
    }
    
    
	NSString *substring = [NSString stringWithString:self.text];
	substring = [substring stringByReplacingCharactersInRange:NSMakeRange(0, [substring length]) withString:substring];
	[self searchAutocompleteEntriesWithSubstring:substring];
}


// Take string from Search Textfield and compare it with autocomplete array
- (void)searchAutocompleteEntriesWithSubstring:(NSString *)substring {
	
    //NSLog(@"reload:%@",NSStringFromCGRect(autoCompleteTableView.frame));
	// Put anything that starts with this substring into the autoCompleteArray
	// The items in this array is what will show up in the table view
	
	[autoCompleteArray removeAllObjects];
    
	for(NSString *curString in elementArray) {
		NSRange substringRangeLowerCase = [[curString lowercaseString] rangeOfString:[substring lowercaseString]];
		NSRange substringRangeUpperCase = [[curString uppercaseString] rangeOfString:[substring uppercaseString]];
        
		if (substringRangeLowerCase.length != 0 || substringRangeUpperCase.length != 0) {
			[autoCompleteArray addObject:curString];
		}
	}
	
	autoCompleteTableView.hidden = NO;
	[autoCompleteTableView reloadData];
}

//// Close keyboard if the Background is touched
//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    //NSLog(@"touches");
//	[self.superview endEditing:YES];
//	[super touchesBegan:touches withEvent:event];
//	[self finishedSearching];
//}

#pragma mark UITextFieldDelegate methods

// Close keyboard when Enter or Done is pressed
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	BOOL isDone = YES;
	
	if (isDone) {
		[self finishedSearching];
		return YES;
	} else {
		return NO;
	}
}

//// String in Search textfield
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//    //NSLog(@"string:%@",string);
//	return YES;
//}

#pragma mark UITableViewDelegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.tableRowHeight + 5.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger) section {
    
	//Resize auto complete table based on how many elements will be displayed in the table
	if (autoCompleteArray.count >=3) {
		autoCompleteTableView.frame = CGRectMake(autoCompleteTableView.frame.origin.x, autoCompleteTableView.frame.origin.y, autoCompleteTableView.frame.size.width, self.tableRowHeight*3);
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.tableRowHeight*5);
		return autoCompleteArray.count;
	}
	
	else if (autoCompleteArray.count == 2) {
		autoCompleteTableView.frame = CGRectMake(autoCompleteTableView.frame.origin.x, autoCompleteTableView.frame.origin.y, autoCompleteTableView.frame.size.width, self.tableRowHeight*2);
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.tableRowHeight*4);
		return autoCompleteArray.count;
	}
	
	else {
		autoCompleteTableView.frame = CGRectMake(autoCompleteTableView.frame.origin.x, autoCompleteTableView.frame.origin.y, autoCompleteTableView.frame.size.width, self.tableRowHeight);
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.tableRowHeight*3);
		return autoCompleteArray.count;
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = nil;
	static NSString *AutoCompleteRowIdentifier = @"AutoCompleteRowIdentifier";
	cell = [tableView dequeueReusableCellWithIdentifier:AutoCompleteRowIdentifier];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AutoCompleteRowIdentifier];
	}
    
	cell.textLabel.text = [autoCompleteArray objectAtIndex:indexPath.row];
    cell.textLabel.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //NSLog(@"selected");
	UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
	self.text = selectedCell.textLabel.text;
	[self finishedSearching];
}


@end
