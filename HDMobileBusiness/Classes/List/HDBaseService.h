//
//  HDBaseService.h
//  HDMobileBusiness
//
//  Created by Plato on 12/18/12.
//  Copyright (c) 2012 hand. All rights reserved.
//

#import <Three20Network/Three20Network.h>
#import "HDListModel.h"

@interface HDBaseService : TTModel <HDURLRequestModel,HDTodoListService>

@property(nonatomic,retain) id <TTModel,HDURLRequestModel> model;

#pragma override TTModel

- (BOOL)isLoaded;

- (BOOL)isLoading;

- (BOOL)isLoadingMore;

- (BOOL)isOutdated;

@end
