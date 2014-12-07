//
//  AppDelegate.h
//  DrepNews
//
//  Created by Suman Chatterjee on 27/11/2014.
//  Copyright (c) 2014 Suman Chatterjee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory;


@end

