//
//  CoreDataErrorHandling.m
//  DrepNews
//
//  Created by Suman Chatterjee on 30/11/2014.
//  Copyright (c) 2014 Suman Chatterjee. All rights reserved.
//

#import "CoreDataErrorHandling.h"

static id errorHandlerTarget = nil;
static SEL errorHandlerAction = nil;


@implementation CoreDataErrorHandling

+ (void) cleanUpErrorHanding;
{
    errorHandlerTarget = nil;
    errorHandlerAction = nil;
}

+ (void) defaultErrorHandler:(NSError *)error
{
    NSDictionary *userInfo = [error userInfo];
    for (NSArray *detailedError in [userInfo allValues])
    {
        if ([detailedError isKindOfClass:[NSArray class]])
        {
            for (NSError *e in detailedError)
            {
                if ([e respondsToSelector:@selector(userInfo)])
                {
                    NSLog(@"Error Details: %@", [e userInfo]);
                }
                else
                {
                    NSLog(@"Error Details: %@", e);
                }
            }
        }
        else
        {
            NSLog(@"Error: %@", detailedError);
        }
    }
    NSLog(@"Error Message: %@", [error localizedDescription]);
    NSLog(@"Error Domain: %@", [error domain]);
    NSLog(@"Recovery Suggestion: %@", [error localizedRecoverySuggestion]);
}


+ (void) handleErrors:(NSError *)error
{
    if (error)
    {
        // If a custom error handler is set, call that
        if (errorHandlerTarget != nil && errorHandlerAction != nil)
        {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [errorHandlerTarget performSelector:errorHandlerAction withObject:error];
#pragma clang diagnostic pop
        }
        else
        {
            // Otherwise, fall back to the default error handling
            [self defaultErrorHandler:error];
        }
    }
}

+ (id) errorHandlerTarget
{
    return errorHandlerTarget;
}

+ (SEL) errorHandlerAction
{
    return errorHandlerAction;
}

+ (void) setErrorHandlerTarget:(id)target action:(SEL)action
{
    errorHandlerTarget = target;    /* Deliberately don't retain to avoid potential retain cycles */
    errorHandlerAction = action;
}

- (void) handleErrors:(NSError *)error
{
    [[self class] handleErrors:error];
}


@end
