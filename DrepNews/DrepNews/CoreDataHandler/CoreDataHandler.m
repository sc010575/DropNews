//
//  CoreDataHandler.m
//  DrepNews
//
//  Created by Suman Chatterjee on 01/12/2014.
//  Copyright (c) 2014 Suman Chatterjee. All rights reserved.
//

#import "CoreDataHandler.h"

@implementation CoreDataHandler


+ (void) saveUsingCurrentThreadContextWithBlock:(void (^)(NSManagedObjectContext *localContext))block completion:(SaveCompletionHandler)completion;
{
    NSManagedObjectContext *localContext = [NSManagedObjectContext MR_contextForCurrentThread];
    
    [localContext performBlock:^{
        if (block) {
            block(localContext);
        }
        
        [localContext MR_saveWithOptions:MRSaveParentContexts completion:completion];
    }];
}


@end
