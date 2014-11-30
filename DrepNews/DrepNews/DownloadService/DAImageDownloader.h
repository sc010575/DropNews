//
//  DAImageDownloader.h
//  EventPilot
//
//  Created by Suman Chatterjee on 21/07/2014.
//  Copyright (c) 2014 Suman Chatterjee. All rights reserved.
//


typedef void(^ImageCompletionBlock)(UIImage * image);

@interface DAImageDownloader : NSObject

+(void) downLoadThumbNailImage:(NSString*) Url withCompletionBlock:(ImageCompletionBlock) completionBlock;


@end
