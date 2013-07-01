//
//  HDSQLCenter.m
//  HDMobileBusiness
//
//  Created by Plato on 8/9/12.
//  Copyright (c) 2012 hand. All rights reserved.
//

#import "HDSQLCenter.h"
#import "FMDatabase.h"
#import "FMResultSet.h"

@implementation HDSQLCenter
//数据库初始化
-(BOOL)SQLCreatTable:(FMDatabase *)db{
    NSArray *sqlAry= [NSArray arrayWithObjects:@"CREATE TABLE IF NOT EXISTS DataPool ( id INTEGER PRIMARY KEY AUTOINCREMENT, localId INTEGER, sourceSystemName TEXT, item1 TEXT, item2 TEXT, item3 TEXT, item4 TEXT,	status TEXT, comment TEXT, submitAction TEXT);",@"create table if not exists Action( id INTEGER primary key ,recordkey TEXT,actionid TEXT,actiontitle TEXT,actiontype TEXT );",nil];
    BOOL state = YES;
    state = [self execBatchInTransaction:db sqlArray:sqlAry];
    return state;
}
//清除数据库
-(BOOL)SQLCleanTable:(FMDatabase *)db{
    NSArray *sqlAry= [NSArray arrayWithObjects:@"delete from DataPool;",@"delete from Action;",nil];
    BOOL state = YES;
    state = [self execBatchInTransaction:db sqlArray:sqlAry];
    return state;
}
//查询ToDoList操作
-(FMResultSet *)SQLQueryToDoList:(FMDatabase *)db{
    NSString *currentSql = @"SELECT  DataPool.id, DataPool.localId, DataPool.sourceSystemName, DataPool.item1, DataPool.item2, DataPool.item3, DataPool.item4, DataPool.status, DataPool.comment, DataPool.submitAction FROM DataPool";
    return [db executeQuery:currentSql];
}

//删除记录
-(BOOL)SQLRemoveRecords:(FMDatabase *)db recordList:(NSArray *) recordList{
    NSString *currentSql = @"DELETE FROM Datapool WHERE localId =:localId";
    BOOL state = YES;
    state = [self execLineInTransaction:db recordList:recordList currentSql:currentSql];
    return state;
}

//更新操作
-(BOOL)SQLUpdateRecords:(FMDatabase *)db recordList:(NSArray *) recordList{
    if (!recordList) return NO;
    NSString *currentSql = @"UPDATE DataPool SET %@ WHERE localId =:localId";
    BOOL state = YES;
    state = [self execLineInTransaction:db recordList:recordList currentSql:currentSql];
    return state;
}
//DataPool表插入
-(BOOL)SQLInsertRecords:(FMDatabase *)db recordList:(NSArray *) recordList{
    if (!recordList) return NO;
    NSString *currentSql = @"INSERT INTO DataPool ( localId, sourceSystemName, item1, item2, item3, item4, status ) VALUES (:localId, :sourceSystemName, :item1, :item2, :item3, :item4, \"NEW\" )";
    BOOL state = YES;
    state = [self execLineInTransaction:db recordList:recordList currentSql:currentSql];
    return state;
}

#pragma mark- 私有方法 -

//当行SQL执行，传入 数据库，记录集参数，SQL语句
-(BOOL)execLineInTransaction:(FMDatabase *)db recordList:(NSArray *) recordList currentSql:(NSString *)currentSql{
    BOOL state = YES;
    if ([db beginTransaction]) {
        int rCount  = [recordList count];
        for (int n = 0; n<rCount; n++) {
            state =  [db executeUpdate:currentSql withParameterDictionary:[recordList objectAtIndex:n]];
            if (!state) {
                if (![db rollback]) {
                    NSLog(@"数据库rollback失败");
                }
                return state;
            }
        }
        if (![db commit]) {
            NSLog(@"数据库commit失败");
        };
    }else {
        state=NO;
    }
    return state;
}
//批量SQL执行，传入 数据库，SQL语句数组
-(BOOL)execBatchInTransaction:(FMDatabase *)db sqlArray:(NSArray *)sqlArray{
    BOOL state = YES;
    int sqlCount = [sqlArray count];
    if ([db beginTransaction]) {
        for (int i = 0; i<sqlCount; i++) {
            NSString * currentSql =[sqlArray objectAtIndex:i];
            if (![db executeUpdate:currentSql]) {
                state =NO;
            }
        }
        if (!state) {
            [db rollback];
            return state;
        }
        [db commit];
    }else {
        state=NO;
    }
    return state;
}
@end
