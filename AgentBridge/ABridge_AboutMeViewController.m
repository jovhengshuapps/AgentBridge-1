//
//  ABridge_AboutMeViewController.m
//  AgentBridge
//
//  Created by host24_iOS Dev on 11/28/13.
//  Copyright (c) 2013 host24_iOS Dev. All rights reserved.
//

#import "ABridge_AboutMeViewController.h"
#import "AgentProfile.h"

@interface ABridge_AboutMeViewController ()
@property (weak, nonatomic) IBOutlet UILabel *aboutMeTitle;
@property (weak, nonatomic) IBOutlet UILabel *aboutHeader;
@property (weak, nonatomic) IBOutlet UITextView *textViewAbout;
@property (weak, nonatomic) IBOutlet UIButton *buttonSave;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
- (IBAction)saveAboutMe:(id)sender;
- (IBAction)backButton:(id)sender;

@end

@implementation ABridge_AboutMeViewController

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
    
    self.aboutMeTitle.font = FONT_OPENSANS_REGULAR(FONT_SIZE_TITLE);
    self.aboutHeader.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
    self.textViewAbout.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
    self.buttonSave.titleLabel.font = FONT_OPENSANS_BOLD(FONT_SIZE_SMALL);
    
    self.activityIndicator.hidden = YES;
    
    self.textViewAbout.layer.borderColor = [UIColor colorWithRed:178.0f/255.0f green:178.0f/255.0f blue:178.0f/255.0f alpha:1.0f].CGColor;
    self.textViewAbout.layer.borderWidth = 1.0f;
    
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
    

    
    self.textViewAbout.text = @"";
    self.textViewAbout.text = profile.about;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveAboutMe:(id)sender {
}

- (IBAction)backButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
