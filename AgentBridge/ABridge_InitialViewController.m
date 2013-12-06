//
//  ABridge_InitialViewController.m
//  AgentBridge
//
//  Created by host24_iOS Dev on 11/13/13.
//  Copyright (c) 2013 host24_iOS Dev. All rights reserved.
//

#import "ABridge_InitialViewController.h"
#import "ABridge_LoginViewController.h"
#import "ABridge_AppDelegate.h"
#import "LoginDetails.h"
#import "AgentProfile.h"

@interface ABridge_InitialViewController ()

@end

@implementation ABridge_InitialViewController

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
    //[FONT NAME TEST]
//    for (NSString* family in [UIFont familyNames])
//    {
//        NSLog(@"%@", family);
//        
//        for (NSString* name in [UIFont fontNamesForFamilyName: family])
//        {
//            NSLog(@"  %@", name);
//        }
//    }
    
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
        self.shouldAdjustChildViewHeightForStatusBar = YES;
        self.statusBarBackgroundView.backgroundColor = [UIColor blackColor];
    }
    else {
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    }
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    
    self.topViewController = [storyboard instantiateViewControllerWithIdentifier:@"TabBarController"];
    
    CGRect viewFrame=((UITabBarController*)self.topViewController).tabBar.frame;
    viewFrame.origin.y += 5.0f;
    viewFrame.size.height=44.0f;
    ((UITabBarController*)self.topViewController).tabBar.frame=viewFrame;
    
    
    self.shouldAddPanGestureRecognizerToTopViewSnapshot = NO;
    
    
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    
    NSManagedObjectContext *context = ((ABridge_AppDelegate *)[[UIApplication sharedApplication] delegate]).managedObjectContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"LoginDetails"
                                              inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error = nil;
    NSArray *fetchedObjects = [context
                               executeFetchRequest:fetchRequest error:&error];
   
    
    if ([fetchedObjects count] == 0) {
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ABridge_LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"Login"];
        
        loginViewController.modalPresentationStyle = UIModalPresentationFullScreen;
        loginViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        
        [self presentViewController:loginViewController animated:YES completion:^{
            
        }];
    }
    else {
        NSFetchRequest *fetchRequestProfile = [[NSFetchRequest alloc] init];
        NSEntityDescription *entityProfile = [NSEntityDescription entityForName:@"AgentProfile" inManagedObjectContext:context];
        [fetchRequestProfile setEntity:entityProfile];
        
        NSError *error = nil;
        NSArray *fetchedProfile = [context executeFetchRequest:fetchRequestProfile error:&error];
        
        BOOL found = NO;
        
        for (AgentProfile *profile in fetchedProfile) {
            if ([profile.user_id integerValue] == [[[fetchedObjects firstObject] valueForKey:@"user_id"] integerValue]) {
                found = YES;
                break;
            }
        }
        
        if ([fetchedProfile count] == 0 && !found) {
            
            NSFetchRequest *fetchRequest_ = [[NSFetchRequest alloc] init];
            NSEntityDescription *entity_ = [NSEntityDescription entityForName:@"LoginDetails"
                                                      inManagedObjectContext:context];
            [fetchRequest_ setEntity:entity_];
            NSError *error = nil;
            NSArray *fetchedObjects_ = [context
                                       executeFetchRequest:fetchRequest_ error:&error];
            for (NSManagedObject *obj in fetchedObjects_) {
                [context deleteObject:obj];
            }
            
            NSError *errorSave = nil;
            if (![context save:&errorSave]) {
                NSLog(@"Error occurred in saving Login Details:%@",[errorSave localizedDescription]);
            }
            else {
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                ABridge_LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"Login"];
                
                loginViewController.modalPresentationStyle = UIModalPresentationFullScreen;
                loginViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
                
                [self presentViewController:loginViewController animated:YES completion:^{
                    
                }];
            }
            
            
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
