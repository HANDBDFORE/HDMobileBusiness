//
//  HDSQLCenter.h
//  HDMobileBusiness
//
//  Created by Plato on 8/9/12.
//  Copyright (c) 2012 hand. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMResultSet.h"

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
//查询ToDoList操作
-(FMResultSet *)SQLqueryToDoList:(FMDatabase *)db;
-(FMResultSet *)SQLqueryColumnMap:(FMDatabase *)db；
//建表
-(BOOL)SQLCreatTable:(FMDatabase *)db;
//切换用户清理表数据
-(BOOL)SQLCleanTable:(FMDatabase *)db;
//提交成功,删除本地记录
-(BOOL)SQLremoveRecord:(FMDatabase *)db recordSet:(id) recordSet;
-(BOOL)SQLupdateRecords:(FMDatabase *)db recordSet:(id) recordSet;
-(BOOL)SQLinsertNewRecords:(FMDatabase *)db recordSet:(id) recordSet;
-(BOOL)SQLColumnMapInsert:(FMDatabase *)db recordSet:(id) recordSet;
-(BOOL)SQLDataPoolInsert:(FMDatabase *)db recordSet:(id) recordSet;
@end
