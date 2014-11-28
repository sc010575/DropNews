//
//  EventImages.h
//  DrepNews
//
//  Created by Suman Chatterjee on 27/11/2014.
//  Copyright (c) 2014 Suman Chatterjee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Event;

@interface EventImages : NSManagedObject

@property (nonatomic, retain) NSData * event_image;
@property (nonatomic, retain) NSString * imageUrl;
@property (nonatomic, retain) Event *event;

@end
