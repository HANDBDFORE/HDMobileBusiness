//
//  HDSQLCenter.h
//  HDMobileBusiness
//
//  Created by Plato on 8/9/12.
//  Copyright (c) 2012 hand. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString * kHDStorageStatusNormal = @"HD_STORAGE_STATUS_NORMAL";
static NSString * kHDStorageStatusInsert = @"HD_STORAGE_STATUS_INSERT";
static NSString * kHDStorageStatusUpdate = @"HD_STORAGE_STATUS_UPDATE";
static NSString * kHDStorageStatusRemove = @"HD_STORAGE_STATUS_REMOVE";

static NSString * kHDRecordStatusNormal = @"HD_RECORD_STATUS_NORMAL";
static NSString * kHDRecordStatusWaiting = @"HD_RECORD_STATUS_WAITING";
static NSString * kHDRecordStatusError = @"HD_RECORD_STATUS_ERROR";
static NSString * kHDRecordStatusDifferent = @"HD_RECORD_STATUS_DIFFERENT";

static NSString * kHDQueryTodoList = @"query";
static NSString * kHDInsertTodoList = @"insert";
static NSString * kHDUpdateTodoList = @"update";
static NSString * kHDRemoveTodoList = @"remove";
static NSString * kHDSyncTodoList = @"sync";


@interface HDSQLCenter : NSObject

@end
