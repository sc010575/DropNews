//
//  NSManagedObjectContext+Helper.m
//  DrepNews
//
//  Created by Suman Chatterjee on 01/12/2014.
//  Copyright (c) 2014 Suman Chatterjee. All rights reserved.
//

#import "NSManagedObjectContext+Helper.h"

@implementation NSManagedObjectContext (Helper)



+ (instancetype)managedObjectContextWithName:(NSString *)name {
    NSManagedObjectContext *managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    managedObjectContext.persistentStoreCoordinator = [self persistentStoreCoordinatorWithName:name];
    managedObjectContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy;
    
    return managedObjectContext;
}

+ (instancetype)managedObjectContextWithStoreCoordinator:(NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    NSManagedObjectContext *managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator;
    managedObjectContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy;
    
    return managedObjectContext;
}


- (void)updateOnBackgroundThread:(NSManagedObjectContextUpdateBlock)updateBlock completion:(NSManagedObjectContextCompletionBlock)completionBlock {
    
    NSManagedObjectContext *backgroundContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    backgroundContext.persistentStoreCoordinator = self.persistentStoreCoordinator;
    
    __weak NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    __block id observer = nil;
    observer = [notificationCenter addObserverForName:NSManagedObjectContextDidSaveNotification
                                               object:backgroundContext
                                                queue:[NSOperationQueue mainQueue]
                                           usingBlock:^(NSNotification *notification) {
                                               [self mergeChangesFromContextDidSaveNotification:notification];
                                               
                                               [notificationCenter removeObserver:observer];
                                               observer = nil;
                                               
                                               completionBlock();
                                           }];
    
    [backgroundContext performBlock:^{
        updateBlock(backgroundContext);
        
        [backgroundContext save:NULL];
    }];
}

- (void)updateOnMainThread:(NSManagedObjectContextUpdateBlock)updateBlock completion:(NSManagedObjectContextCompletionBlock)completionBlock {
    
    NSAssert([NSThread isMainThread], @"performOnMainThread:completion: should be called from main thread");
    
    updateBlock(self);
    completionBlock();
    [self save:NULL];
}

+ (NSPersistentStoreCoordinator *)persistentStoreCoordinatorWithName:(NSString *)name {
    NSManagedObjectModel *managedObjectModel = [self managedObjectModelWithName:name];
    
    NSString *storeFilename = [name stringByAppendingPathExtension:@"sqlite"];
    NSURL *applicationSupportDirectory = [self applicationSupportDirectory];
    NSURL *storeUrl = [applicationSupportDirectory URLByAppendingPathComponent:storeFilename];
    
    NSPersistentStoreCoordinator *persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel];
    
    NSDictionary *options = @{ NSMigratePersistentStoresAutomaticallyOption : @YES,
                               NSInferMappingModelAutomaticallyOption       : @YES };
    
    [persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                             configuration:nil
                                                       URL:storeUrl
                                                   options:options
                                                     error:NULL];
    
    return persistentStoreCoordinator;
}

+ (NSManagedObjectModel *)managedObjectModelWithName:(NSString *)name {
    NSURL *modelUrl = [[NSBundle mainBundle] URLForResource:name withExtension:@"momd"];
    return [[NSManagedObjectModel alloc] initWithContentsOfURL:modelUrl];
}

+ (NSURL *)applicationSupportDirectory {
    return [[NSFileManager defaultManager] URLForDirectory:NSApplicationSupportDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:NULL];
}

@end
