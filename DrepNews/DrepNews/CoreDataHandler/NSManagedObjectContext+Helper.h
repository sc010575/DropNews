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

+ (instancetype)managedObjectContextWithName:(NSString *)name;

- (void)updateOnBackgroundThread:(NSManagedObjectContextUpdateBlock)updateBlock completion:(NSManagedObjectContextCompletionBlock)completionBlock;
- (void)updateOnMainThread:(NSManagedObjectContextUpdateBlock)updateBlock completion:(NSManagedObjectContextCompletionBlock)completionBlock;


@end
