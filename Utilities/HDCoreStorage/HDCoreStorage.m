//
//  HDCoreStorage.m
//  HDMobileBusiness
//
//  Created by Plato on 8/7/12.
//  Copyright (c) 2012 hand. All rights reserved.
//

#import "HDCoreStorage.h"
#import "FMDatabase.h"

@implementation HDCoreStorage{
    FMDatabasePool *DatabasePool;
    HDSQLCenter *sqlCenter;
}
#pragma mark -
#pragma mark 单例
+(id)shareStorage
{
    return [self shareObject];
}

-(id)init
{
    self = [super init];
    if (self) {
        //使用tt函数直接获取document路径
        DatabasePool = [[FMDatabasePool alloc] initWithPath:TTPathForDocumentsResource(@"HDMobileBusiness.db")];
        DatabasePool.maximumNumberOfDatabasesToCreate = 3;
        sqlCenter = [[HDSQLCenter alloc]init];
    }
    return self;
}

-(void)dealloc
{
    [DatabasePool releaseAllDatabases];
    //使用宏释放内存，防止野指针造成crash
    TT_RELEASE_SAFELY(DatabasePool);
    TT_RELEASE_SAFELY(sqlCenter);
    [super dealloc];
}
#pragma mark-
#pragma mark 方法
-(NSArray*)query:(SEL) handler conditions:(NSDictionary *) conditions{
    if ([sqlCenter respondsToSelector:handler]) {
        __block  NSMutableArray  *_DATA = [[[NSMutableArray alloc]init]autorelease];
        void (^doDabase)(FMDatabase *db)=^(FMDatabase *db){
            FMResultSet *rs=[sqlCenter performSelector:handler withObject:db withObject:conditions];
            while ([rs next]){
                [_DATA addObject:[rs resultDictionary]];
            }
        };
        [DatabasePool inDatabase:doDabase];
        return _DATA;
    }
    NSLog(@"无效的selector:%@",NSStringFromSelector(handler));
    return nil;
}

-(BOOL)excute:(SEL) handler recordList:(NSArray *) recordList{
    if ([sqlCenter respondsToSelector:handler]) {
        __block  BOOL state = FALSE;
        void (^doDabase)(FMDatabase *db)=^(FMDatabase *db){
            state=(BOOL)[sqlCenter performSelector:handler withObject:db withObject:recordList];
        };
        [DatabasePool inDatabase:doDabase];
        return state;
    }
    NSLog(@"无效的selector:%@",NSStringFromSelector(handler));
    return NO;
}
//同步方法
//-(void)sync:(id)data
//{}

@end