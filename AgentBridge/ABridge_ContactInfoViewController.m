//
//  ABridge_ContactInfoViewController.m
//  AgentBridge
//
//  Created by host24_iOS Dev on 11/28/13.
//  Copyright (c) 2013 host24_iOS Dev. All rights reserved.
//

#import "ABridge_ContactInfoViewController.h"
#import "AgentProfile.h"

@interface ABridge_ContactInfoViewController ()
@property (weak, nonatomic) IBOutlet UILabel *aboutMeTitle;
@property (weak, nonatomic) IBOutlet UILabel *mobileHeader;
@property (weak, nonatomic) IBOutlet UILabel *workHeader;
@property (weak, nonatomic) IBOutlet UILabel *faxHeader;
@property (weak, nonatomic) IBOutlet UITextField *textFieldMobileNumber;
@property (weak, nonatomic) IBOutlet UITextField *textFieldWorkNumber;
@property (weak, nonatomic) IBOutlet UITextField *textFieldFaxNumber;
@property (weak, nonatomic) IBOutlet UIButton *buttonSave;
- (IBAction)saveContacts:(id)sender;
- (IBAction)backButton:(id)sender;

@end

@implementation ABridge_ContactInfoViewController

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
    self.aboutMeTitle.font = FONT_OPENSANS_REGULAR(FONT_SIZE_TITLE);
    self.mobileHeader.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
    self.workHeader.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
    self.faxHeader.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
    self.textFieldMobileNumber.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
    self.textFieldWorkNumber.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
    self.textFieldFaxNumber.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
    self.buttonSave.titleLabel.font = FONT_OPENSANS_REGULAR(FONT_SIZE_SMALL);
    
    [self addPaddingAndBorder:self.textFieldMobileNumber color:[UIColor colorWithRed:178.0f/255.0f green:178.0f/255.0f blue:178.0f/255.0f alpha:1.0f]];
    
    [self addPaddingAndBorder:self.textFieldFaxNumber color:[UIColor colorWithRed:178.0f/255.0f green:178.0f/255.0f blue:178.0f/255.0f alpha:1.0f]];
    
    [self addPaddingAndBorder:self.textFieldWorkNumber color:[UIColor colorWithRed:178.0f/255.0f green:178.0f/255.0f blue:178.0f/255.0f alpha:1.0f]];
    
    NSManagedObjectContext *context = ((ABridge_AppDelegate *)[[UIApplication sharedApplication] delegate]).managedObjectContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"LoginDetails"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error = nil;
    LoginDetails *loginDetails = (LoginDetails*)[[context executeFetchRequest:fetchRequest error:&error] firstObject];
    
    NSFetchRequest *fetchRequestProfile = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityProfile = [NSEntityDescription entityForName:@"AgentProfile"
                                                     inManagedObjectContext:context];
    [fetchRequestProfile setEntity:entityProfile];
    
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"user_id == %@", loginDetails.user_id];
    [fetchRequestProfile setPredicate:predicate];
    
    NSError *errorProfile = nil;
    AgentProfile *profile = (AgentProfile*)[[context executeFetchRequest:fetchRequestProfile error:&errorProfile] firstObject];
    
    self.textFieldMobileNumber.text = @"";
    self.textFieldMobileNumber.text = profile.mobile_number;
    
    self.textFieldFaxNumber.text = @"";
    self.textFieldWorkNumber.text = @"";
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveContacts:(id)sender {
}

- (IBAction)backButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) addPaddingAndBorder:(UITextField*)textField color:(UIColor*)color {
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 20)];
    textField.leftView = paddingView;
    textField.leftViewMode = UITextFieldViewModeAlways;
    
    textField.layer.borderColor = color.CGColor;
    textField.layer.borderWidth = 1.0f;
}
@end
