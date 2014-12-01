//
//  CoreDataHandler.h
//  DrepNews
//
//  Created by Suman Chatterjee on 01/12/2014.
//  Copyright (c) 2014 Suman Chatterjee. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^SaveCompletionHandler)(BOOL success, NSError *error);

@interface CoreDataHandler : NSObject

@end
