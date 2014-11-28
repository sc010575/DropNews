//
//  Categories.h
//  DrepNews
//
//  Created by Suman Chatterjee on 27/11/2014.
//  Copyright (c) 2014 Suman Chatterjee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Event;

@interface Categories : NSManagedObject

@property (nonatomic, retain) NSString * categoryName;
@property (nonatomic, retain) NSSet *events;
@end

@interface Categories (CoreDataGeneratedAccessors)

- (void)addEventsObject:(Event *)value;
- (void)removeEventsObject:(Event *)value;
- (void)addEvents:(NSSet *)values;
- (void)removeEvents:(NSSet *)values;

@end
