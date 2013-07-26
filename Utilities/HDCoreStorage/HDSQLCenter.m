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
    NSArray *sqlAry= [NSArray arrayWithObjects:@"CREATE TABLE IF NOT EXISTS DataPool ( id INTEGER PRIMARY KEY AUTOINCREMENT, localId INTEGER, sourceSystemName TEXT, item1 TEXT, item2 TEXT, item3 TEXT, item4 TEXT,	status TEXT, comment TEXT, submitAction TEXT,submitActionType TEXT,serverMessage TEXT,deliveree TEXT);",@"CREATE TABLE IF NOT EXISTS ACTION ( id INTEGER PRIMARY KEY AUTOINCREMENT,localId TEXT,sourceSystemName TEXT,action TEXT,actionTitle TEXT,actionType TEXT);",nil];
    BOOL state = YES;
    state = [self execBatchInTransaction:db sqlArray:sqlAry];
    return state;
}
//清除数据库
-(BOOL)SQLCleanTable:(FMDatabase *)db{
    NSArray *sqlAry= [NSArray arrayWithObjects:[self creatCRUDSqlWithTableName:@"DataPool" params:nil keys:nil action:@"DELETE"],[self creatCRUDSqlWithTableName:@"ACTION" params:nil keys:nil action:@"DELETE"],nil];
    BOOL state = YES;
    state = [self execBatchInTransaction:db sqlArray:sqlAry];
    return state;
}
//查询ToDoList操作
-(FMResultSet *)SQLQueryToDoList:(FMDatabase *)db{
    NSString * tableName = @"DataPool";
    NSArray * params = [NSArray arrayWithObjects:@"id",@"localId",@"sourceSystemName",@"item1",@"item2",@"item3",@"item4",@"status",@"comment",@"submitAction",@"submitActionType",@"deliveree",nil];
    
    NSString *currentSql = [self creatCRUDSqlWithTableName:tableName params:params keys:nil action:@"SELECT"];
    
    return [db executeQuery:currentSql];
}
//查询ToDoList摘要操作
-(FMResultSet *)SQLQueryToDoListDigest:(FMDatabase *)db{
    
    NSString *currentSql = @"SELECT localId, sourceSystemName FROM DataPool WHERE STATUS != 'WAITING'";
    
    return [db executeQuery:currentSql];
}

//查询动作(单条)
-(FMResultSet *)SQLQueryAction:(FMDatabase *)db conditions:(NSDictionary *) conditions{
    NSString * tableName = @"ACTION";
    NSArray * params = [NSArray arrayWithObjects:@"action",@"actionTitle",@"actionType",@"sourceSystemName",nil];
    NSArray * keys = [NSArray arrayWithObjects:@"localId",@"sourceSystemName",nil];
    
    NSString *currentSql = [self creatCRUDSqlWithTableName:tableName params:[params arrayByAddingObjectsFromArray:keys] keys:keys action:@"SELECT"];
    
    return [db executeQuery:currentSql withParameterDictionary:conditions];
}
//将动作保存到动作表
-(BOOL)SQLActionInsertRecords:(FMDatabase *)db recordList:(NSArray *) recordList{
    if (!recordList) return NO;
    NSArray * params = [NSArray arrayWithObjects:@"localId",@"sourceSystemName",@"action",@"actionTitle",@"actionType",nil];
    NSString *currentSql = @"insert into ACTION VALUES (NULL,:localId,:sourceSystemName,:action,:actionTitle,:actionType);";
    BOOL state = YES;
    state = [self execLineInTransaction:db params:params recordList:recordList currentSql:currentSql];
    return state;
}
//将动作提交到本地(单条)
-(BOOL)SQLActionSubmitLocal:(FMDatabase *)db recordList:(NSArray *) recordList{
    if (!recordList) return NO;
    NSString * tableName = @"DataPool";
    NSArray * params = [NSArray arrayWithObjects:@"submitAction",@"submitActionType",@"comment",nil];
    NSArray * keys = [NSArray arrayWithObjects:@"localId",@"sourceSystemName",nil];
    
    NSString *currentSql = [self creatCRUDSqlWithTableName:tableName params:params keys:keys action:@"UPDATE"];
    
    BOOL state = YES;
    state = [self execLineInTransaction:db params:[params arrayByAddingObjectsFromArray:keys] recordList:recordList currentSql:currentSql];
    return state;
}
//删除记录
-(BOOL)SQLRemoveRecords:(FMDatabase *)db recordList:(NSArray *) recordList{
    NSString * tableName = @"DataPool";
    NSArray * keys = [NSArray arrayWithObjects:@"localId",@"sourceSystemName",nil];
    NSString *currentSql = [self creatCRUDSqlWithTableName:tableName params:nil keys:keys action:@"DELETE"];
    BOOL state = YES;
    state = [self execLineInTransaction:db params:keys recordList:recordList currentSql:currentSql];
    return state;
}

//更新操作
-(BOOL)SQLUpdateRecords:(FMDatabase *)db recordList:(NSArray *) recordList{
    if (!recordList) return NO;
    NSString * tableName = @"DataPool";
    NSArray * params = [NSArray arrayWithObjects:@"status",@"submitAction",@"submitActionType",@"comment",nil];
    NSArray * keys = [NSArray arrayWithObjects:@"localId",@"sourceSystemName",nil];

    NSString *currentSql = [self creatCRUDSqlWithTableName:tableName params:params keys:keys action:@"UPDATE"];
       
    BOOL state = YES;
    state = [self execLineInTransaction:db params:[params arrayByAddingObjectsFromArray:keys] recordList:recordList currentSql:currentSql];
    return state;
}
//转交更新操作
-(BOOL)SQLUpdateDeliverRecords:(FMDatabase *)db recordList:(NSArray *) recordList{
    if (!recordList) return NO;
    NSString * tableName = @"DataPool";
    NSArray * params = [NSArray arrayWithObjects:@"status",@"submitAction",@"submitActionType",@"comment",@"deliveree",nil];
    NSArray * keys = [NSArray arrayWithObjects:@"localId",@"sourceSystemName",nil];
    
    NSString *currentSql = [self creatCRUDSqlWithTableName:tableName params:params keys:keys action:@"UPDATE"];
    
    BOOL state = YES;
    state = [self execLineInTransaction:db params:[params arrayByAddingObjectsFromArray:keys] recordList:recordList currentSql:currentSql];
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

-(NSString *)creatCRUDSqlWithTableName:(NSString *)tableName params:(NSArray *)params keys:(NSArray *)keys action:(NSString *)action{
    NSMutableString * values = [[NSMutableString alloc] init];
    NSMutableString * where = [[NSMutableString alloc] init];
    [values appendString:action];
    if (keys != nil) {
        [where appendString:@"WHERE "];
        NSInteger i = [keys count];
        for (NSString * key in keys) {
            [where appendFormat:@"%@ = :%@",key,key];
            if (i>1) {
                [where appendString:@" AND "];
            }
            i--;
        }
    }
    
    if ([action isEqualToString:@"SELECT"]) {
        NSInteger s = 0;
        if (params != nil) {
            for (NSString * param in params) {
                if (s>0) {
                    [values appendString:@","];
                }
                [values appendFormat:@" %@ ",param];
                
                s++;
            }
        }
        [values appendFormat:@" FROM %@ ",tableName];

    } else if([action isEqualToString:@"UPDATE"]){
        [values appendFormat:@" %@ SET ",tableName];
        NSInteger u = 0;
        if (params != nil) {
            for (NSString * param in params) {
                if (u>0) {
                    [values appendString:@","];
                }
                [values appendFormat:@"%@ = :%@ ",param,param];  
                u++;
            }
        }
        
    } else if ([action isEqualToString:@"DELETE"]){
        [values appendFormat:@" FROM %@ ",tableName];
    }
    NSString * sql = [NSString stringWithFormat:@"%@ %@",values,where];
    [values release];
    [where release];
    return sql;
}

-(BOOL)execLineInTransaction:(FMDatabase *)db recordList:(NSArray *) recordList currentSql:(NSString *)currentSql{

    return [self execLineInTransaction:db params:nil recordList:recordList currentSql:currentSql];
}
//单行SQL执行，传入 数据库，记录集参数，SQL语句
-(BOOL)execLineInTransaction:(FMDatabase *)db params:(NSArray *)params recordList:(NSArray *) recordList currentSql:(NSString *)currentSql{
    BOOL state = YES;
    if ([db beginTransaction]) {
        int rCount  = [recordList count];
        for (int n = 0; n<rCount; n++) {
            NSDictionary * record =nil;
            if (params != nil) {
                record = [[NSDictionary dictionaryWithDictionary:[recordList objectAtIndex:n]] dictionaryWithValuesForKeys:params];
            }else{
                record = [NSDictionary dictionaryWithDictionary:[recordList objectAtIndex:n]];
            }
            
            state =  [db executeUpdate:currentSql withParameterDictionary:record];
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
