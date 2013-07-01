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

@interface HDSQLCenter : NSObject
//查询ToDoList操作
-(FMResultSet *)SQLQueryToDoList:(FMDatabase *)db;
//建表
-(BOOL)SQLCreatTable:(FMDatabase *)db;
//切换用户清理表数据
-(BOOL)SQLCleanTable:(FMDatabase *)db;
//提交成功,删除本地记录
-(BOOL)SQLRemoveRecords:(FMDatabase *)db recordList:(NSArray *) recordList;
-(BOOL)SQLUpdateRecords:(FMDatabase *)db recordList:(NSArray *) recordList;
-(BOOL)SQLDataPoolInsert:(FMDatabase *)db recordList:(NSArray *) recordList;

@end
