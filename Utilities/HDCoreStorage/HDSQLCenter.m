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
    NSArray *sqlAry= [NSArray arrayWithObjects:@"create table if not exists DataPool( column0 TEXT primary key,column1 TEXT,column2 TEXT,column3 TEXT,column4 TEXT ,column5 TEXT,column6 TEXT,column7 TEXT ,column8 TEXT,column9 TEXT,column10 TEXT ,column11 TEXT,column12 TEXT,column13 TEXT ,column14 TEXT,column15 TEXT,column16 TEXT ,column17 TEXT,column18 TEXT,column19 TEXT ,column20 TEXT,column21 TEXT,column22 TEXT ,column23 TEXT ,column24 TEXT,column25 TEXT,column26 TEXT ,column27 TEXT,column28 TEXT,column29 TEXT );", @"create table if not exists ColumnMap( column0 TEXT primary key,column1 TEXT,column2 TEXT,column3 TEXT,column4 TEXT );",@"create table if not exists Action( id INTEGER primary key ,recordkey TEXT,actionid TEXT,actiontitle TEXT );",nil];
    BOOL state = YES;
    state = [self execBatchInTransaction:db sqlArray:sqlAry];
    return state;
}
//清除数据库
-(BOOL)SQLCleanTable:(FMDatabase *)db{
    NSArray *sqlAry= [NSArray arrayWithObjects:@"delete from DataPool;",@"delete from ColumnMap;",@"delete from ColumnMap;",nil];
    BOOL state = YES;
    state = [self execBatchInTransaction:db sqlArray:sqlAry];
    return state;
}
//ColumnMap插入
-(BOOL)SQLColumnMapInsert:(FMDatabase *)db recordList:(NSArray *) recordList{
    //不传参会挂掉
    if (!recordList) return NO;
    NSString *currentSql =@"insert into ColumnMap(column0,column1) values(:column0,:column1);";
    BOOL state = YES;
    state = [self execLineInTransaction:db recordList:recordList currentSql:currentSql];
    return state;
}
//DataPool表插入
-(BOOL)SQLDataPoolInsert:(FMDatabase *)db recordList:(NSArray *) recordList{
    //不传参会挂掉
    if (!recordList) return NO;
    NSString *strTempColumns =@"";
    NSString *strTempValues =@"";
    NSDictionary *mapDic = [self mapDicL2R:db];
    for (NSString* key in mapDic) {
        strTempColumns = [NSString stringWithFormat:@"%@,%@",key,strTempColumns];
        strTempValues = [NSString stringWithFormat:@":%@,%@",[mapDic objectForKey:key],strTempValues];
    }
    strTempColumns = [strTempColumns substringToIndex:[strTempColumns length]-1];
    strTempValues = [strTempValues substringToIndex:[strTempValues length]-1];
    NSString *currentSql = [NSString stringWithFormat:@"insert into DataPool (%@) values (%@)",strTempColumns,strTempValues];
    BOOL state = YES;
    state = [self execLineInTransaction:db recordList:recordList currentSql:currentSql];
    return state;
}
//ColumnMap查询
-(FMResultSet *)SQLqueryColumnMap:(FMDatabase *)db{
    FMResultSet *rs=[self mapRs:db];
    return rs;
}
//查询ToDoList操作
-(FMResultSet *)SQLqueryToDoList:(FMDatabase *)db{
    NSString *strTemp =@"";
    NSDictionary *mapDic = [self mapDicL2R:db];
    for (NSString* key in mapDic) {
        strTemp = [NSString stringWithFormat:@"%@ %@,%@",key,[mapDic objectForKey:key],strTemp];
    }
    if(![strTemp length]){
        return nil;
    }
    strTemp = [strTemp substringToIndex:strTemp.length -1];
    NSString *currentSql = [NSString stringWithFormat:@"select %@ from DataPool",strTemp];
    return [db executeQuery:currentSql];
}

//删除记录
-(BOOL)SQLremoveRecords:(FMDatabase *)db recordList:(NSArray *) recordList{
    //不传参会挂掉
    if (!recordList) return NO;
    NSDictionary *mapDic = [self mapDicL2R:db];
    NSString *PK = [mapDic objectForKey:@"column0"];
    NSMutableArray *newrecordList = [[[NSMutableArray alloc]init] autorelease];
    for (NSDictionary *record in recordList) {
        [newrecordList addObject:[NSDictionary dictionaryWithObject:[record objectForKey:PK] forKey:PK]];
    }
    NSString *currentSql = [NSString stringWithFormat:@"delete from datapool where column0 =:%@",PK];
    BOOL state = YES;
    state = [self execLineInTransaction:db recordList:newrecordList currentSql:currentSql];
    return state;
}
//插入操作
-(BOOL)SQLinsertNewRecords:(FMDatabase *)db recordList:(NSArray *) recordList{
    //不传参会挂掉
    if (!recordList) return NO;
    NSString *currentSql = [NSString stringWithFormat:@"insert into persons (name) values(:name)"];
    BOOL state = YES;
    state = [self execLineInTransaction:db recordList:recordList currentSql:currentSql];
    return state;
}
//更新操作
-(BOOL)SQLupdateRecords:(FMDatabase *)db recordList:(NSArray *) recordList{
    //不传参会挂掉
    if (!recordList) return NO;
    NSDictionary *mapDic = [self mapDicR2L:db];
    NSString *TEMPSet = @"";
    NSString *TEMPWhere = @"";
    for (id key in [mapDic allKeys]) {
        if ([[mapDic valueForKey:key] isEqualToString:@"column0"]) {
            TEMPWhere = [NSString stringWithFormat:@"%@= :%@",[mapDic valueForKey:key],key];
        }else{
            TEMPSet = [NSString stringWithFormat:@"%@=:%@,%@",[mapDic valueForKey:key],key,TEMPSet];
        }
    }
    TEMPSet = [TEMPSet substringToIndex:[TEMPSet length]-1];
    NSString *currentSql = [NSString stringWithFormat:@"update  DataPool set %@ where %@",TEMPSet,TEMPWhere];
    BOOL state = YES;
    state = [self execLineInTransaction:db recordList:recordList currentSql:currentSql];
    return state;
}
//查询Action操作
-(FMResultSet *)SQLqueryAction:(FMDatabase *)db conditions:(NSDictionary *) conditions{
    //不传参会挂掉
    if (!conditions) return nil;
    NSDictionary *mapDic = [self mapDicL2R:db];
    NSString *PK = [mapDic objectForKey:@"column0"];
    NSString *currentSql = [NSString stringWithFormat:@"select recordkey %@,actionid action_id ,actiontitle action_title from Action where recordkey = :%@ order by actionid",PK,PK];
    NSDictionary *PKDic = [NSDictionary dictionaryWithObject:[conditions objectForKey:PK] forKey:PK];
    FMResultSet * rs=[db executeQuery:currentSql withParameterDictionary:PKDic];
    return  rs;
}
//插入Action操作
-(BOOL)SQLinsertActions:(FMDatabase *)db recordList:(NSArray *) recordList{
    //不传参会挂掉
    if (!recordList) return NO;
    NSDictionary *mapDic = [self mapDicL2R:db];
    NSString *PK = [mapDic objectForKey:@"column0"];
    NSString *currentSql = [NSString stringWithFormat:@"insert into Action (recordkey,actionid,actiontitle) values(:%@,:action_id,:action_title)",PK];
    BOOL state = YES;
    state = [self execLineInTransaction:db recordList:recordList currentSql:currentSql];
    return state;
}
//删除Action记录操作
-(BOOL)SQLremoveActions:(FMDatabase *)db recordList:(NSArray *) recordList{
    //不传参会挂掉
    if (!recordList) return NO;
    //组装新List
    NSDictionary *mapDic = [self mapDicL2R:db];
    NSString *PK = [mapDic objectForKey:@"column0"];
    NSArray *newrecordList = [NSArray arrayWithObject:[NSDictionary dictionaryWithObject:[[recordList objectAtIndex:0] objectForKey:PK] forKey:PK]];
    NSString *currentSql = [NSString stringWithFormat:@"delete from Action where recordkey =:%@",PK];
    BOOL state = YES;
    state = [self execLineInTransaction:db recordList:newrecordList currentSql:currentSql];
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
//映射表rs 不推荐使用这个
-(FMResultSet *)mapRs:(FMDatabase *)db{
    NSString *currentSql = [NSString stringWithFormat:@"select column0,column1 from ColumnMap"];
    FMResultSet *rs=[db executeQuery:currentSql];
    return rs;
}
//映射表L2R
-(NSDictionary *)mapDicL2R:(FMDatabase *)db{
    FMResultSet *rs=[self mapRs:db];
    NSMutableDictionary * DIC = [[[NSMutableDictionary alloc]init]autorelease];
    while ([rs next]){
        NSDictionary *TempDic = [rs resultDictionary];
        [DIC setValue:[TempDic  valueForKey:@"column1"] forKey:[TempDic  valueForKey:@"column0"]];
    }
    return DIC;
}
//映射表R2L
-(NSDictionary *)mapDicR2L:(FMDatabase *)db{
    FMResultSet *rs=[self mapRs:db];
    NSMutableDictionary * DIC = [[[NSMutableDictionary alloc]init]autorelease];
    while ([rs next]){
        NSDictionary *TempDic = [rs resultDictionary];
        [DIC setValue:[TempDic  valueForKey:@"column0"] forKey:[TempDic  valueForKey:@"column1"]];
    }
    return DIC;
}
@end
