//
//  HDCoreStorage.m
//  HDMobileBusiness
//
//  Created by Plato on 8/7/12.
//  Copyright (c) 2012 hand. All rights reserved.
//

#import "HDCoreStorage.h"
#import "FMDatabase.h"
#import "FMDatabasePool.h"
#import "FMResultSet.h"
#import "HDSQLCenter.h"

static HDCoreStorage * globalStorage = nil;

@implementation HDCoreStorage{
    FMDatabasePool *DatabasePool;
    HDSQLCenter *sqlCenter;
}
#pragma mark - 
#pragma mark 单例
+(id)shareStorage
{
    if (nil == globalStorage) {
        globalStorage = [[self alloc]init];
    }
    return globalStorage;
}

+(id) allocWithZone:(NSZone *)zone{
    @synchronized(self){
        if (globalStorage == nil) {
            globalStorage = [super allocWithZone:zone];
            return  globalStorage;
        }
    }
    return nil;
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain
{
    return self;
}

-(id)init
{
    self = [super init];
    if (self) {
        DatabasePool = [[FMDatabasePool databasePoolWithPath:[self dbPath]] retain];
        DatabasePool.maximumNumberOfDatabasesToCreate = 3;
        sqlCenter = [[HDSQLCenter alloc]init];
    }
    return self;
}

-(unsigned)retainCount
{
    return UINT_MAX;  //denotes an object that cannot be released
}

- (id)autorelease
{
    return self;
}

-(void)dealloc
{
    [DatabasePool releaseAllDatabases];
    [DatabasePool release];
    [sqlCenter release];
    [super dealloc];
}
#pragma mark-
#pragma mark 方法
- (NSString *) dbPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:@"mydb.db"];
}

-(id)query:(SEL) handler conditions:(id) conditions{
    if ([sqlCenter respondsToSelector:handler]) {
        __block  NSMutableArray  *_DATA = [[[NSMutableArray alloc]init]autorelease];
        void (^doDabase)(FMDatabase *db)=^(FMDatabase *db){
            FMResultSet *rs=[sqlCenter performSelector:handler withObject:db withObject:conditions]; 
            while ([rs next]){  
                [_DATA addObject:[[rs resultDictionary]  mutableCopy]];
            } 
        };
        [DatabasePool inDatabase:doDabase];
        return _DATA;
    }
    NSLog(@"无效的selector");
    return nil;
}

-(BOOL)excute:(SEL) handler recordSet:(id) recordSet{
    if ([sqlCenter respondsToSelector:handler]) {
        __block  BOOL state = FALSE;
        void (^doDabase)(FMDatabase *db)=^(FMDatabase *db){
            state=(BOOL)[sqlCenter performSelector:handler withObject:db withObject:recordSet];
        };
        [DatabasePool inDatabase:doDabase];
        return state;
    }
    NSLog(@"无效的selector");
    return NO;
}
//同步方法
//-(void)sync:(id)data
//{}

@end