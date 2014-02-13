//
//  ABridge_AppDelegate.h
//  AgentBridge
//
//  Created by host24_iOS Dev on 11/13/13.
//  Copyright (c) 2013 host24_iOS Dev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ABridge_AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) UIStoryboard* initalStoryboard;
@property (strong, nonatomic) NSString *deviceTokenString;
@property (strong, nonatomic) NSString *tokenId;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
- (void) resetWindowToInitialView;

@end
