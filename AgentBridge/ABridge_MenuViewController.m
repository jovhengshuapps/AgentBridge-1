//
//  ABridge_MenuViewController.m
//  AgentBridge
//
//  Created by host24_iOS Dev on 11/13/13.
//  Copyright (c) 2013 host24_iOS Dev. All rights reserved.
//

#import "ABridge_MenuViewController.h"
#import "ABridge_AppDelegate.h"

@interface ABridge_MenuViewController ()
- (IBAction)gotoMain:(id)sender;
- (IBAction)gotoProfile:(id)sender;
- (IBAction)gotoNetwork:(id)sender;
- (IBAction)gotoSetting:(id)sender;
- (IBAction)gotoLogOut:(id)sender;

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
    
    [self.slidingViewController setAnchorRightRevealAmount:280.0f];
    self.slidingViewController.underLeftWidthLayout = ECFullWidth;
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
}

- (IBAction)gotoSetting:(id)sender {
}

- (IBAction)gotoLogOut:(id)sender {
    UIAlertView *alertLogout = [[UIAlertView alloc] initWithTitle:@"Log Out?" message:@"Are you sure you want to Log Out?" delegate:self cancelButtonTitle:@"YES" otherButtonTitles:@"NO", nil];
    [alertLogout show];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        
        
        NSManagedObjectContext *context = ((ABridge_AppDelegate *)[[UIApplication sharedApplication] delegate]).managedObjectContext;
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"LoginDetails"
                                                  inManagedObjectContext:context];
        [fetchRequest setEntity:entity];
        NSError *error = nil;
        NSArray *fetchedObjects = [context
                                   executeFetchRequest:fetchRequest error:&error];
        for (NSManagedObject *obj in fetchedObjects) {
            [context deleteObject:obj];
        }
        
        NSError *errorSave = nil;
        if (![context save:&errorSave]) {
            NSLog(@"Error occurred in saving Login Details:%@",[errorSave localizedDescription]);
        }
        else {
            [((ABridge_AppDelegate *)[[UIApplication sharedApplication] delegate]) resetWindowToInitialView];
        }
    }
}


@end
