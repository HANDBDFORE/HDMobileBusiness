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
    NSArray *sqlAry= [NSArray arrayWithObjects:@"create table if not exists DataPool( column0 TEXT primary key,column1 TEXT,column2 TEXT,column3 TEXT,column4 TEXT ,column5 TEXT,column6 TEXT,column7 TEXT ,column8 TEXT,column9 TEXT,column10 TEXT ,column11 TEXT,column12 TEXT,column13 TEXT ,column14 TEXT,column15 TEXT,column16 TEXT ,column17 TEXT,column18 TEXT,column19 TEXT ,column20 TEXT,column21 TEXT,column22 TEXT ,column23 TEXT ,column24 TEXT,column25 TEXT,column26 TEXT ,column27 TEXT,column28 TEXT,column29 TEXT );", @"create table if not exists ColumnMap( column0 TEXT primary key,column1 TEXT,column2 TEXT,column3 TEXT,column4 TEXT );",nil];
    BOOL state = YES;
    state = [self execBatchInTransaction:db sqlArray:sqlAry];
    return state;
}
//清除数据库
-(BOOL)SQLCleanTable:(FMDatabase *)db{
    NSArray *sqlAry= [NSArray arrayWithObjects:@"delete from DataPool;",@"delete from ColumnMap;",nil];
    BOOL state = YES;
    state = [self execBatchInTransaction:db sqlArray:sqlAry];
    return state;
}
//ColumnMap插入
-(BOOL)SQLColumnMapInsert:(FMDatabase *)db recordSet:(id) recordSet{
    NSString *currentSql =@"insert into ColumnMap(Column0,Column1) values(:Column0,:Column1);";
    BOOL state = YES;
    state = [self execLineInTransaction:db recordSet:recordSet currentSql:currentSql];
    return state;
}
//DataPool表插入
-(BOOL)SQLDataPoolInsert:(FMDatabase *)db recordSet:(id) recordSet{
    NSString *str1 =@""; 
    NSString *str2 =@""; 
    FMResultSet *rs=[self map:db];
    while ([rs next]){
        str1 = [NSString stringWithFormat:@"%@,%@",[[rs resultDictionary] objectForKey:@"column0"],str1];
        str2 = [NSString stringWithFormat:@":%@,%@",[[rs resultDictionary] objectForKey:@"column1"],str2];
    } 
    str1 = [str1 substringToIndex:[str1 length]-1];
    str2 = [str2 substringToIndex:[str2 length]-1];
    NSString *currentSql = [NSString stringWithFormat:@"insert into DataPool (%@) values (%@)",str1,str2];
    BOOL state = YES;
    state = [self execLineInTransaction:db recordSet:recordSet currentSql:currentSql];
    return state;
}
//查询数据表操作
-(FMResultSet *)SQLqueryColumnMap:(FMDatabase *)db{
    NSString *str1 =@""; 
    FMResultSet *rs=[self map:db];
    while ([rs next]){
        str1 = [NSString stringWithFormat:@"%@ %@,%@",[[rs resultDictionary] objectForKey:@"column0"],[[rs resultDictionary] objectForKey:@"column1"],str1];
    } 
    str1 = [str1 substringToIndex:[str1 length]-1];
    NSString *currentSql = [NSString stringWithFormat:@"select %@ from datapool",str1];
    rs=[db executeQuery:currentSql];
    return rs;
}
//查询ToDoList操作
-(FMResultSet *)SQLqueryToDoList:(FMDatabase *)db{
    NSString *str1 =@""; 
    FMResultSet *rs=[self map:db];
    while ([rs next]){
        str1 = [NSString stringWithFormat:@"%@ %@,%@",[[rs resultDictionary] objectForKey:@"column0"],[[rs resultDictionary] objectForKey:@"column1"],str1];
    } 
    if([str1 length]){
        return nil;
        }
    NSString *currentSql = [NSString stringWithFormat:@"select %@ from datapool",str1];
    rs=[db executeQuery:currentSql];
    return rs;
}

//删除记录
-(BOOL)SQLremoveRecord:(FMDatabase *)db recordSet:(id) recordSet{
    NSString *currentSql = [NSString stringWithFormat:@"delete from datapool where column0 =':recordid'"];
    BOOL state = YES;
    state = [self execLineInTransaction:db recordSet:recordSet currentSql:currentSql];
    return state;
}
//插入操作
-(BOOL)SQLinsertNewRecords:(FMDatabase *)db recordSet:(id) recordSet{
    NSString *currentSql = [NSString stringWithFormat:@"insert into persons (name) values(:name)"];
    BOOL state = YES;
    state = [self execLineInTransaction:db recordSet:recordSet currentSql:currentSql];
    return state;
}
-(BOOL)SQLupdateRecords:(FMDatabase *)db recordSet:(id) recordSet{
    return NO;
}
#pragma mark-
#pragma mark 私有方法
//当行SQL执行，传入 数据库，记录集参数，SQL语句
-(BOOL)execLineInTransaction:(FMDatabase *)db recordSet:(id) recordSet currentSql:(NSString *)currentSql{
    BOOL state = YES;
    if ([db beginTransaction]) {
        int rCount  = [recordSet count];
        for (int n = 0; n<rCount; n++) {
            state =  [db executeUpdate:currentSql withParameterDictionary:[recordSet objectAtIndex:n]];
            if (!state) {
                if (![db rollback]) {
                    NSLog(@"回滚失败");
                }
                return state;
            }
        }
        if (![db commit]) {
            NSLog(@"提交失败");
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
//映射表rs
-(FMResultSet *)map:(FMDatabase *)db{
    NSString *currentSql = [NSString stringWithFormat:@"select column0,column1 from ColumnMap"];
    FMResultSet *rs=[db executeQuery:currentSql];
    return rs;
}
@end
