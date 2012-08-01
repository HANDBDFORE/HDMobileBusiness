//
//  HDDetailToolbarDataSource.m
//  Three20GitCoreDataLab
//
//  Created by Rocky Lee on 6/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDDetailToolbarModel.h"
#import "ApproveDatabaseHelper.h"

@implementation HDDetailToolbarModel

@synthesize recordID = _recordID;
@synthesize resultList = _resultList;

- (void)dealloc
{
    TT_RELEASE_SAFELY(_recordID);
    TT_RELEASE_SAFELY(_resultList);
    [super dealloc];
}

-(id)initWithKey:(id)key query:(id) query;
{
    if (self = [self init]) {
        self.recordID = [query valueForKey:@"recordID"];
    }
    return self;
}

-(void)load:(TTURLRequestCachePolicy)cachePolicy more:(BOOL)more
{
    id actionList  = [self loadTheLocalDataBaseActions];
    if (nil != actionList) {
        self.resultList = actionList;
        self.loadedTime = [NSDate dateWithTimeIntervalSinceNow:0];
        self.cacheKey = @"local action";
        [self didFinishLoad];
    }else {
        HDRequestMap * requestMap = [HDRequestMap mapWithDelegate:self];
        requestMap.urlName = kToobarActionQueryPath;
        requestMap.postData = 
        [NSDictionary dictionaryWithObject:self.recordID
                                    forKey:@"record_id"];
        [self requestWithMap:requestMap];
    }
}

-(void)requestResultMap:(HDRequestResultMap *)map
{
    self.resultList = map.result;
    [self saveTheActions];
}

-(id)loadTheLocalDataBaseActions
{
    ApproveDatabaseHelper * dbHelper = [[ApproveDatabaseHelper alloc]init];
    [dbHelper.db open];
    
    NSString * actionSelectSql = [NSString stringWithFormat:@"select record_id,action_id,action_title from action_list where record_id = %@ order by action_id;",self.recordID];
    
    FMResultSet *resultSet = [dbHelper.db executeQuery:actionSelectSql];
    NSMutableArray * actions = [NSMutableArray array];
    
    while ([resultSet next]) {
        [actions addObject:[resultSet resultDictionary]];
    }
    [resultSet close];
    [dbHelper.db close];
    
    TT_RELEASE_SAFELY(dbHelper);
    if ([actions count] == 0) {
        return nil;
    }
    return actions;
}

//保存审批动作
-(void)saveTheActions
{
    [self removeTheActions];
    ApproveDatabaseHelper * dbHelper = [[ApproveDatabaseHelper alloc]init];
    [dbHelper.db open];
    [dbHelper.db beginTransaction]; 
    for (NSDictionary * actionRecord in self.resultList) 
    {
        NSString * insertActionsSql = [NSString stringWithFormat:@"insert into %@ (record_id,action_id,action_title) values(%@,%@,'%@');",TABLE_NAME_APPROVE_ACTION_LIST,
                                       [actionRecord valueForKey:@"record_id"],
                                       [actionRecord valueForKey:@"action_id"],
                                       [actionRecord valueForKey:@"action_title"]];
        
        [dbHelper.db executeUpdate:insertActionsSql];
    }
    [dbHelper.db commit];
    [dbHelper.db close];
    TT_RELEASE_SAFELY(dbHelper);
}

//delete actions data
-(void)removeTheActions
{
    ApproveDatabaseHelper * dbHelper = [[ApproveDatabaseHelper alloc]init];
    [dbHelper.db open];
    [dbHelper.db beginTransaction];
    NSString * deleteActionsSql = [NSString stringWithFormat:@"delete from %@ where record_id = %@;",TABLE_NAME_APPROVE_ACTION_LIST,self.recordID];
    [dbHelper.db executeUpdate:deleteActionsSql];
    [dbHelper.db commit];
    [dbHelper.db close];
    TT_RELEASE_SAFELY(dbHelper);
    
}

-(NSArray *)toolbarItems
{
    NSMutableArray * actionItems = [NSMutableArray array];
    for (id actionRecord in self.resultList) {
        HDToolbarItem * actionItem = [[[HDToolbarItem alloc]init]autorelease];
        actionItem.tag = [[actionRecord objectForKey:@"action_id"] intValue];
        actionItem.title = [actionRecord objectForKey:@"action_title"];
        [actionItems addObject:actionItem];
    }
    return actionItems;
}

@end

