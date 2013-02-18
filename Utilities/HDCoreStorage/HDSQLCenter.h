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
-(FMResultSet *)SQLqueryToDoList:(FMDatabase *)db;
-(FMResultSet *)SQLqueryColumnMap:(FMDatabase *)db;
//建表
-(BOOL)SQLCreatTable:(FMDatabase *)db;
//切换用户清理表数据
-(BOOL)SQLCleanTable:(FMDatabase *)db;
//提交成功,删除本地记录
-(BOOL)SQLremoveRecords:(FMDatabase *)db recordList:(NSArray *) recordList;
-(BOOL)SQLupdateRecords:(FMDatabase *)db recordList:(NSArray *) recordList;
-(BOOL)SQLinsertNewRecords:(FMDatabase *)db recordList:(NSArray *) recordList;
-(BOOL)SQLColumnMapInsert:(FMDatabase *)db recordList:(NSArray *) recordList;
-(BOOL)SQLDataPoolInsert:(FMDatabase *)db recordList:(NSArray *) recordList;
//插入Action记录
-(BOOL)SQLinsertActions:(FMDatabase *)db recordList:(NSArray *) recordList;
//删除Action记录操作
-(BOOL)SQLremoveActions:(FMDatabase *)db recordList:(NSArray *) recordList;
//查询Action操作
-(FMResultSet *)SQLqueryAction:(FMDatabase *)db conditions:(NSDictionary *) conditions;
@end
