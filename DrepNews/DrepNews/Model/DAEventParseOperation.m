//
//  DAEventParser.m
//  EventPilot
//
//  Created by Suman Chatterjee on 19/07/2014.
//  Copyright (c) 2014 Suman Chatterjee. All rights reserved.
//

#import "DAEventParseOperation.h"
#import "DAResourceLoader.h"
#import "Event.h"
#import "Categories.h"
#import "Coordinates.h"
#import "EventImages.h"
#import "DAImageDownloader.h"
#import "NSManagedObject+CoreDataHandler.h"
#import "NSManagedObjectContext+Helper.h"

@interface DAEventParseOperation()

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSPersistentStoreCoordinator *sharedPSC;
@property (nonatomic, strong) NSData *downloadData;
@end

@implementation DAEventParseOperation


- (instancetype)initWithData:(NSData *)data sharedPSC:(NSPersistentStoreCoordinator *)psc {
    
    self = [super init];
    if (self) {
        
        // keep the shared psc for creating context later in main
        _downloadData = data;
        _sharedPSC = psc;
        
    }
    return self;
}

//main
// The main function for this NSOperation, to start the parsing.
- (void)main {
    
    self.managedObjectContext = [NSManagedObjectContext managedObjectContextWithStoreCoordinator:self.sharedPSC];
    [self parseEventWithContext:self.managedObjectContext];
}


-(void) parseEventWithContext:(NSManagedObjectContext*)context
{
    NSDictionary * parseJSON = [DAResourceLoader readJSONFromDocumentFromUrl:self.downloadData];
    
    NSArray *eventArray = parseJSON[@"items"];
    
    [self.managedObjectContext updateOnBackgroundThread:^(NSManagedObjectContext *updateContext) {
        for (NSDictionary * individualEvent in eventArray)
        {
            [self processIndividualEvent:individualEvent withContext:updateContext];
        }
        
    } completion:^{
        //complete
    }];

    
    
}

-(BOOL) isThisEventIsNew:(NSString*) eventName inContext:(NSManagedObjectContext*) context
{
    NSPredicate *purchasePredicate = [NSPredicate predicateWithFormat:@"name == %@", eventName];
    Event * event = [[Event findAllWithPredicate:purchasePredicate inContext:context]  firstObject];
    return  (!event) ? YES:NO;
    
}

-(void) processIndividualEvent:(NSDictionary*)eventData withContext:(NSManagedObjectContext*) context
{
    if([self isThisEventIsNew:eventData[@"name"] inContext:context]){
        
        //OK new event add it to the database
        __block Event *event = [Event createInContext:context];
        event.event_Id = eventData[@"id"];
        event.name = eventData[@"name"];
        event.postalCode = eventData[@"postcode"];
        event.address = eventData[@"location"];
        event.eventDesc = eventData[@"description"];
        
        NSString *dateString = eventData[@"date"];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
        [dateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"];

        
        NSDate *dateFromString = [dateFormatter dateFromString:dateString];
        event.timeStamp = dateFromString;
        
        //     event.timeStamp = dateFromString;
        event.type = eventData[@"event-type"];
        
        //Add Category
        NSArray * categoryArray = eventData[@"categories"];
        for (NSString * categoryName in categoryArray)
        {
            Categories * categories = [Categories createInContext:context];
            categories.categoryName = categoryName;
            [event addCategoryObject:categories];
        }
        
        //Add Coordinate
        NSDictionary * cordDict = eventData[@"coordinate"];
        Coordinates * coordinates = [Coordinates createInContext:context];
        coordinates.longitude = cordDict[@"longitude"];
        coordinates.latitude  = cordDict[@"latitude"];
        event.coordinate = coordinates;
        
        
        //store event Images
        NSArray *eventImageArray = eventData[@"images"];

        for(NSString *imageUrl in eventImageArray)
        {
            EventImages * images = [EventImages createInContext:context];
            images.imageUrl = imageUrl;
            [event addEventimagesObject:images];
        }
        
        //DownLoad ThumbNail
        event.thambnailImageSave = NO;
        event.thambnailUrl = eventData[@"thumbnail"];
    
    }
}


- (void)saveThumbNail:(UIImage*)image forEvent:(Event*)event
{
    //First Find the event from the database
    
    [self.managedObjectContext updateOnBackgroundThread:^(NSManagedObjectContext *updateContext) {
        NSPredicate * Predicate = [NSPredicate predicateWithFormat:@"(name == %@) AND (event_Id == %@)", event.name ,event.event_Id];
        
        Event *recentEvent = [[Event findAllWithPredicate:Predicate inContext:updateContext] firstObject];
        if (!recentEvent) {
            //no record found
        }
        else
        {
            recentEvent.thambnail = UIImagePNGRepresentation(image);
        }
        
    } completion:^{
        
    }];

    
}


@end
