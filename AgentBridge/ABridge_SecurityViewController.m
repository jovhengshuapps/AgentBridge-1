//
//  ABridge_SecurityViewController.m
//  AgentBridge
//
//  Created by host24_iOS Dev on 11/28/13.
//  Copyright (c) 2013 host24_iOS Dev. All rights reserved.
//

#import "ABridge_SecurityViewController.h"

@interface ABridge_SecurityViewController ()
//@property (weak, nonatomic) IBOutlet UILabel *securityTitle;
//@property (weak, nonatomic) IBOutlet UILabel *newPasswordHeader;
//@property (weak, nonatomic) IBOutlet UILabel *confirmPasswordHeader;
//@property (weak, nonatomic) IBOutlet UITextField *textFieldNewPassword;
//@property (weak, nonatomic) IBOutlet UITextField *textFieldConfirmPassword;
//@property (weak, nonatomic) IBOutlet UIButton *buttonSave;
//- (IBAction)savePassword:(id)sender;

@end

@implementation ABridge_SecurityViewController

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
//    self.textFieldNewPassword.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
//    self.textFieldConfirmPassword.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
//    self.buttonSave.titleLabel.font = FONT_OPENSANS_REGULAR(FONT_SIZE_SMALL);
//    
//    [self addPaddingAndBorder:self.textFieldNewPassword color:[UIColor colorWithRed:178.0f/255.0f green:178.0f/255.0f blue:178.0f/255.0f alpha:1.0f]];
//    
//    [self addPaddingAndBorder:self.textFieldConfirmPassword color:[UIColor colorWithRed:178.0f/255.0f green:178.0f/255.0f blue:178.0f/255.0f alpha:1.0f]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)savePassword:(id)sender {
}


- (void) addPaddingAndBorder:(UITextField*)textField color:(UIColor*)color {
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 20)];
    textField.leftView = paddingView;
    textField.leftViewMode = UITextFieldViewModeAlways;
    
    textField.layer.borderColor = color.CGColor;
    textField.layer.borderWidth = 1.0f;
}
@end
