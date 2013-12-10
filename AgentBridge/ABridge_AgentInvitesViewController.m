//
//  ABridge_AgentInvitesViewController.m
//  AgentBridge
//
//  Created by host24_iOS Dev on 12/10/13.
//  Copyright (c) 2013 host24_iOS Dev. All rights reserved.
//

#import "ABridge_AgentInvitesViewController.h"

@interface ABridge_AgentInvitesViewController ()
@property (weak, nonatomic) IBOutlet UILabel *labelInviteTitle;
@property (weak, nonatomic) IBOutlet UITextField *textFieldFirstname;
@property (weak, nonatomic) IBOutlet UITextField *textFieldLastname;
@property (weak, nonatomic) IBOutlet UITextField *textFieldEmail;
@property (weak, nonatomic) IBOutlet UITextField *textFieldZipcode;
@property (weak, nonatomic) IBOutlet UIButton *buttonSend;
- (IBAction)sendInvite:(id)sender;

@end

@implementation ABridge_AgentInvitesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.slidingViewController.underRightViewController = nil;
    
    self.labelInviteTitle.font = FONT_OPENSANS_REGULAR(FONT_SIZE_TITLE);
    self.textFieldFirstname.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
    self.textFieldLastname.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
    self.textFieldEmail.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
    self.textFieldZipcode.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
    self.buttonSend.titleLabel.font = FONT_OPENSANS_BOLD(FONT_SIZE_REGULAR);
    
    [self addPaddingAndBorder:self.textFieldEmail color:[UIColor colorWithRed:178.0f/255.0f green:178.0f/255.0f blue:178.0f/255.0f alpha:1.0f]];
    
    [self addPaddingAndBorder:self.textFieldFirstname color:[UIColor colorWithRed:178.0f/255.0f green:178.0f/255.0f blue:178.0f/255.0f alpha:1.0f]];
    
    [self addPaddingAndBorder:self.textFieldLastname color:[UIColor colorWithRed:178.0f/255.0f green:178.0f/255.0f blue:178.0f/255.0f alpha:1.0f]];
    
    [self addPaddingAndBorder:self.textFieldZipcode color:[UIColor colorWithRed:178.0f/255.0f green:178.0f/255.0f blue:178.0f/255.0f alpha:1.0f]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sendInvite:(id)sender {
}


- (void) addPaddingAndBorder:(UITextField*)textField color:(UIColor*)color {
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 20)];
    textField.leftView = paddingView;
    textField.leftViewMode = UITextFieldViewModeAlways;
    
    textField.layer.borderColor = color.CGColor;
    textField.layer.borderWidth = 1.0f;
}
@end
