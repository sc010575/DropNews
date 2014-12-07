//
//  NSManagedObjectContext+Helper.h
//  DrepNews
//
//  Created by Suman Chatterjee on 01/12/2014.
//  Copyright (c) 2014 Suman Chatterjee. All rights reserved.
//

#import <CoreData/CoreData.h>


typedef void (^NSManagedObjectContextUpdateBlock)(NSManagedObjectContext *updateContext);
typedef void (^NSManagedObjectContextCompletionBlock)();


@interface NSManagedObjectContext (Helper)

//manageobject creation
+ (instancetype)managedObjectContextWithName:(NSString *)name;
+ (instancetype)managedObjectContextWithStoreCoordinator:(NSPersistentStoreCoordinator *)persistentStoreCoordinator;

//persistance store Coordinator
+ (NSPersistentStoreCoordinator *)persistentStoreCoordinatorWithName:(NSString *)name;

//save or update
- (void)updateOnBackgroundThread:(NSManagedObjectContextUpdateBlock)updateBlock completion:(NSManagedObjectContextCompletionBlock)completionBlock;
- (void)updateOnMainThread:(NSManagedObjectContextUpdateBlock)updateBlock completion:(NSManagedObjectContextCompletionBlock)completionBlock;


@end
