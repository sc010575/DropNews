//
//  NSManagedObject+CoreDataHandler.h
//  DrepNews
//
//  Created by Suman Chatterjee on 29/11/2014.
//  Copyright (c) 2014 Suman Chatterjee. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (CoreDataHandler)

+ (id) createInContext:(NSManagedObjectContext *)context;
+ (NSArray *) findAllWithPredicate:(NSPredicate *)searchTerm inContext:(NSManagedObjectContext *)context;

@end
