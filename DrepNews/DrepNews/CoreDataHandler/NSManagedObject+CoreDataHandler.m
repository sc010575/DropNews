//
//  NSManagedObject+CoreDataHandler.m
//  DrepNews
//
//  Created by Suman Chatterjee on 29/11/2014.
//  Copyright (c) 2014 Suman Chatterjee. All rights reserved.
//

#import "NSManagedObject+CoreDataHandler.h"
#import "CoreDataErrorHandling.h"

@implementation NSManagedObject (CoreDataHandler)

+ (NSEntityDescription *) entityDescriptionInContext:(NSManagedObjectContext *)context
{
        NSString *entityName = [self entityName];
        return [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
}


+ (NSFetchRequest *) createFetchRequestInContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[self entityDescriptionInContext:context]];
    
    return request;
}

+ (NSArray *) executeFetchRequest:(NSFetchRequest *)request inContext:(NSManagedObjectContext *)context
{
    __block NSArray *results = nil;
    [context performBlockAndWait:^{
        
        NSError *error = nil;
        
        results = [context executeFetchRequest:request error:&error];
        
        if (results == nil)
        {
            [CoreDataErrorHandling handleErrors:error];
        }
        
    }];
    return results;
}


+ (NSString *) entityName
{
    return NSStringFromClass(self);
}


+ (id) createInContext:(NSManagedObjectContext *)context
{
      return [NSEntityDescription insertNewObjectForEntityForName:[self entityName] inManagedObjectContext:context];
}


+ (NSArray *) findAllWithPredicate:(NSPredicate *)searchTerm inContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [self createFetchRequestInContext:context];
    [request setPredicate:searchTerm];
    
    return [self executeFetchRequest:request
                              inContext:context];
}


@end
