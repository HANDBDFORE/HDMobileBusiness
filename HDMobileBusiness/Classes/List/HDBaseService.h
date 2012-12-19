//
//  HDBaseService.h
//  HDMobileBusiness
//
//  Created by Plato on 12/18/12.
//  Copyright (c) 2012 hand. All rights reserved.
//

#import <Three20Network/Three20Network.h>
#import "HDListModel.h"

@protocol HDURLRequestModel <NSObject>

/**
 * Valid upon completion of the URL request. Represents the timestamp of the completed request.
 */
-(NSDate *)loadedTime;

/**
 * Valid upon completion of the URL request. Represents the request's cache key.
 */
-(NSString *)cacheKey;

/**
 * Not used internally, but intended for book-keeping purposes when making requests.
 */
-(BOOL)hasNoMore;

/**
 * Resets the model to its original state before any data was loaded.
 */
- (void)reset;

/**
 * Valid while loading. Returns download progress as between 0 and 1.
 */

- (float)downloadProgress;

@end

///////////////////////////////////////////////////////////////////////////////////////////////////

@interface HDBaseService : TTModel <HDURLRequestModel,HDTodoListService>

@property(nonatomic,retain) id <TTModel,HDURLRequestModel> model;

#pragma override TTModel

- (BOOL)isLoaded;

- (BOOL)isLoading;

- (BOOL)isLoadingMore;

- (BOOL)isOutdated;

@end
