//
//  ABridge_MenuViewController.m
//  AgentBridge
//
//  Created by host24_iOS Dev on 11/13/13.
//  Copyright (c) 2013 host24_iOS Dev. All rights reserved.
//

#import "ABridge_MenuViewController.h"
#import "ABridge_AppDelegate.h"
#import "LoginDetails.h"
#import "AgentProfile.h"
#import "Constants.h"

@interface ABridge_MenuViewController ()
@property (weak, nonatomic) IBOutlet UIButton *buttonProfile;
@property (weak, nonatomic) IBOutlet UIButton *buttonNetwork;
@property (weak, nonatomic) IBOutlet UIButton *buttonAccountSettings;
@property (weak, nonatomic) IBOutlet UIButton *buttonContactInfo;
@property (weak, nonatomic) IBOutlet UIButton *buttonBrokerage;
@property (weak, nonatomic) IBOutlet UIButton *buttonNotification;
@property (weak, nonatomic) IBOutlet UIButton *buttonSecurity;
@property (weak, nonatomic) IBOutlet UIButton *buttonLogOut;
@property (weak, nonatomic) IBOutlet UIButton *buttonInvites;
    
    
- (IBAction)gotoMain:(id)sender;
- (IBAction)gotoProfile:(id)sender;
- (IBAction)gotoNetwork:(id)sender;
- (IBAction)gotoSetting:(id)sender;
- (IBAction)gotoLogOut:(id)sender;
- (IBAction)gotoSecurity:(id)sender;
- (IBAction)gotoInvites:(id)sender;
- (IBAction)gotoContact:(id)sender;
- (IBAction)gotoBrokerage:(id)sender;

@end

@implementation ABridge_MenuViewController

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
    
    [self.slidingViewController setAnchorRightRevealAmount:255.0f];
    self.slidingViewController.underLeftWidthLayout = ECFullWidth;
    
}
    
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.buttonProfile.titleLabel.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
    self.buttonNetwork.titleLabel.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
    self.buttonAccountSettings.titleLabel.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
    self.buttonContactInfo.titleLabel.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
    self.buttonBrokerage.titleLabel.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
    self.buttonNotification.titleLabel.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
    self.buttonSecurity.titleLabel.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
    self.buttonLogOut.titleLabel.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
    self.buttonInvites.titleLabel.font = FONT_OPENSANS_REGULAR(FONT_SIZE_REGULAR);
    
    
    // Add a bottomBorder.
    CALayer *bottomBorder = [CALayer layer];
    
    bottomBorder.frame = CGRectMake(0.0f, self.buttonContactInfo.frame.size.height-1.0f, self.buttonContactInfo.frame.size.width, 1.0f);
    
    bottomBorder.backgroundColor = [UIColor colorWithRed:60.0f/255.0f green:60.0f/255.0f blue:60.0f/255.0f alpha:1.0f].CGColor;
    
    [self.buttonContactInfo.layer addSublayer:bottomBorder];
    
    // Add a bottomBorder.
    CALayer *bottomBorder1 = [CALayer layer];
    
    bottomBorder1.frame = CGRectMake(0.0f, self.buttonBrokerage.frame.size.height-1.0f, self.buttonBrokerage.frame.size.width, 1.0f);
    
    bottomBorder1.backgroundColor = [UIColor colorWithRed:60.0f/255.0f green:60.0f/255.0f blue:60.0f/255.0f alpha:1.0f].CGColor;
    
    [self.buttonBrokerage.layer addSublayer:bottomBorder1];
    
    
    // Add a bottomBorder.
    CALayer *bottomBorder2 = [CALayer layer];
    
    bottomBorder2.frame = CGRectMake(0.0f, self.buttonNotification.frame.size.height-1.0f, self.buttonNotification.frame.size.width, 1.0f);
    
    bottomBorder2.backgroundColor = [UIColor colorWithRed:60.0f/255.0f green:60.0f/255.0f blue:60.0f/255.0f alpha:1.0f].CGColor;
    
    [self.buttonNotification.layer addSublayer:bottomBorder2];
    
    
    
    if (self.buttonProfile.tag == NO) {
        
        NSManagedObjectContext *context = ((ABridge_AppDelegate *)[[UIApplication sharedApplication] delegate]).managedObjectContext;
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"LoginDetails" inManagedObjectContext:context];
        [fetchRequest setEntity:entity];
        NSError *error = nil;
        NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
        
//        LoginDetails *loginDetail = (LoginDetails*)[fetchedObjects firstObject];
        
        fetchRequest = [[NSFetchRequest alloc] init];
        entity = [NSEntityDescription entityForName:@"AgentProfile"
                             inManagedObjectContext:context];
        [fetchRequest setEntity:entity];
//        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"user_id=%@",loginDetail.user_id];
//        [fetchRequest setPredicate:predicate];
        error = nil;
        fetchedObjects = nil;
        fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
        
//        AgentProfile *profileData = (AgentProfile*)[fetchedObjects firstObject];
        
        AgentProfile *profileData = nil;
        for (AgentProfile *profile in fetchedObjects) {
            if ([profile.user_id integerValue] == [[[fetchedObjects firstObject] valueForKey:@"user_id"] integerValue]) {
                profileData = profile;
                break;
            }
        }
        
        
        if (profileData.image_data == nil) {
            profileData.image_data = [NSData dataWithContentsOfURL:[NSURL URLWithString:profileData.image]];
        }
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20.0f, 5.0f, 60.0f, 60.0f)];
        imageView.contentMode = UIViewContentModeScaleAspectFill ;
        imageView.image = [UIImage imageWithData:profileData.image_data];
        
        [self.buttonProfile addSubview:imageView];
        self.buttonProfile.tag = YES;
        
        if ([profileData.is_premium boolValue]) {
            self.buttonInvites.hidden = NO;
            
            CGRect frame = self.buttonAccountSettings.frame;
            frame.origin.y += 33.0f;
            self.buttonAccountSettings.frame = frame;
            
            frame = self.buttonContactInfo.frame;
            frame.origin.y += 33.0f;
            self.buttonContactInfo.frame = frame;
            
            frame = self.buttonBrokerage.frame;
            frame.origin.y += 33.0f;
            self.buttonBrokerage.frame = frame;
            
            frame = self.buttonNotification.frame;
            frame.origin.y += 33.0f;
            self.buttonNotification.frame = frame;
            
            frame = self.buttonSecurity.frame;
            frame.origin.y += 33.0f;
            self.buttonSecurity.frame = frame;
            
            frame = self.buttonLogOut.frame;
            frame.origin.y += 33.0f;
            self.buttonLogOut.frame = frame;
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)gotoMain:(id)sender {
    UIViewController *newTopViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TabBarController"];
    
    [self.slidingViewController anchorTopViewOffScreenTo:ECRight animations:nil onComplete:^{
        CGRect frame = self.slidingViewController.topViewController.view.frame;
        self.slidingViewController.topViewController = newTopViewController;
        self.slidingViewController.topViewController.view.frame = frame;
        [self.slidingViewController resetTopView];
    }];
}

- (IBAction)gotoProfile:(id)sender {
    UIViewController *newTopViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Profile"];
    
    [self.slidingViewController anchorTopViewOffScreenTo:ECRight animations:nil onComplete:^{
        CGRect frame = self.slidingViewController.topViewController.view.frame;
        self.slidingViewController.topViewController = newTopViewController;
        self.slidingViewController.topViewController.view.frame = frame;
        [self.slidingViewController resetTopView];
    }];
}

- (IBAction)gotoNetwork:(id)sender {
    UIViewController *newTopViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Network"];
    
    [self.slidingViewController anchorTopViewOffScreenTo:ECRight animations:nil onComplete:^{
        CGRect frame = self.slidingViewController.topViewController.view.frame;
        self.slidingViewController.topViewController = newTopViewController;
        self.slidingViewController.topViewController.view.frame = frame;
        [self.slidingViewController resetTopView];
    }];
}

- (IBAction)gotoSetting:(id)sender {
    UIViewController *newTopViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"NavAccntSetting"];
    
    [self.slidingViewController anchorTopViewOffScreenTo:ECRight animations:nil onComplete:^{
        CGRect frame = self.slidingViewController.topViewController.view.frame;
        self.slidingViewController.topViewController = newTopViewController;
        self.slidingViewController.topViewController.view.frame = frame;
        [self.slidingViewController resetTopView];
    }];
}

- (IBAction)gotoLogOut:(id)sender {
    UIAlertView *alertLogout = [[UIAlertView alloc] initWithTitle:@"Log Out?" message:@"Are you sure you want to Log Out?" delegate:self cancelButtonTitle:@"YES" otherButtonTitles:@"NO", nil];
    [alertLogout show];
}

- (IBAction)gotoSecurity:(id)sender {
    UIViewController *newTopViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Security"];
    
    [self.slidingViewController anchorTopViewOffScreenTo:ECRight animations:nil onComplete:^{
        CGRect frame = self.slidingViewController.topViewController.view.frame;
        self.slidingViewController.topViewController = newTopViewController;
        self.slidingViewController.topViewController.view.frame = frame;
        [self.slidingViewController resetTopView];
    }];
}

- (IBAction)gotoInvites:(id)sender {
    UIViewController *newTopViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Invites"];
    
    [self.slidingViewController anchorTopViewOffScreenTo:ECRight animations:nil onComplete:^{
        CGRect frame = self.slidingViewController.topViewController.view.frame;
        self.slidingViewController.topViewController = newTopViewController;
        self.slidingViewController.topViewController.view.frame = frame;
        [self.slidingViewController resetTopView];
    }];
}

- (IBAction)gotoContact:(id)sender {
    UIViewController *newTopViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ContactInfo"];
    
    [self.slidingViewController anchorTopViewOffScreenTo:ECRight animations:nil onComplete:^{
        CGRect frame = self.slidingViewController.topViewController.view.frame;
        self.slidingViewController.topViewController = newTopViewController;
        self.slidingViewController.topViewController.view.frame = frame;
        [self.slidingViewController resetTopView];
    }];
}

- (IBAction)gotoBrokerage:(id)sender {
    UIViewController *newTopViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Brokerage"];
    
    [self.slidingViewController anchorTopViewOffScreenTo:ECRight animations:nil onComplete:^{
        CGRect frame = self.slidingViewController.topViewController.view.frame;
        self.slidingViewController.topViewController = newTopViewController;
        self.slidingViewController.topViewController.view.frame = frame;
        [self.slidingViewController resetTopView];
    }];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        
        if ([self deleteDataFromEntity:@"LoginDetails"] &&
            [self deleteDataFromEntity:@"AgentProfile"] &&
            [self deleteDataFromEntity:@"Activity"] &&
            [self deleteDataFromEntity:@"Buyer"] &&
            [self deleteDataFromEntity:@"Property"] &&
            [self deleteDataFromEntity:@"Referral"] &&
            [self deleteDataFromEntity:@"PropertyImages"] &&
            [self deleteDataFromEntity:@"RequestNetwork"] &&
            [self deleteDataFromEntity:@"RequestAccess"]) {

            [((ABridge_AppDelegate *)[[UIApplication sharedApplication] delegate]) resetWindowToInitialView];
        }
        else {
            //NSLog(@"error on deleting");
        }
        
    }
}

- (BOOL) deleteDataFromEntity:(NSString*)entityString {
    NSManagedObjectContext *context = ((ABridge_AppDelegate *)[[UIApplication sharedApplication] delegate]).managedObjectContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityString
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error = nil;
    NSArray *fetchedObjects = [context
                               executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *obj in fetchedObjects) {
        [context deleteObject:obj];
    }
    
    NSError *errorSave = nil;
    return [context save:&errorSave];
    
}

- (NSArray *)fetchObjectsWithEntityName:(NSString *)entity andPredicate:(NSPredicate *)predicate {
    NSManagedObjectContext *context = ((ABridge_AppDelegate *)[[UIApplication sharedApplication] delegate]).managedObjectContext;
    NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setEntity:[NSEntityDescription entityForName:entity inManagedObjectContext:context]];
    NSError * error = nil;
    NSArray * results = [context executeFetchRequest:fetchRequest error:&error];
    return results;
}
    
@end
