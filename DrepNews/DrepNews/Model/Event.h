//
//  Event.h
//  DrepNews
//
//  Created by Suman Chatterjee on 27/11/2014.
//  Copyright (c) 2014 Suman Chatterjee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Categories, Coordinates, EventImages;

@interface Event : NSManagedObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * event_Id;
@property (nonatomic, retain) NSString * eventDesc;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * postalCode;
@property (nonatomic, retain) NSData * thambnail;
@property (nonatomic, retain) NSDate * timeStamp;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSSet *category;
@property (nonatomic, retain) Coordinates *coordinate;
@property (nonatomic, retain) NSSet *eventimages;
@end

@interface Event (CoreDataGeneratedAccessors)

- (void)addCategoryObject:(Categories *)value;
- (void)removeCategoryObject:(Categories *)value;
- (void)addCategory:(NSSet *)values;
- (void)removeCategory:(NSSet *)values;

- (void)addEventimagesObject:(EventImages *)value;
- (void)removeEventimagesObject:(EventImages *)value;
- (void)addEventimages:(NSSet *)values;
- (void)removeEventimages:(NSSet *)values;

@end
