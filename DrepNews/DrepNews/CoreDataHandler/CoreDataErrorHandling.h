//
//  CoreDataErrorHandling.h
//  DrepNews
//
//  Created by Suman Chatterjee on 30/11/2014.
//  Copyright (c) 2014 Suman Chatterjee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoreDataErrorHandling : NSObject

+ (void) handleErrors:(NSError *)error;
- (void) handleErrors:(NSError *)error;

+ (void) setErrorHandlerTarget:(id)target action:(SEL)action;
+ (SEL)  errorHandlerAction;
+ (id)   errorHandlerTarget;


@end
