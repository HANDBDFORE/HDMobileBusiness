//
//  HDDetailToolbarDataSource.m
//  Three20GitCoreDataLab
//
//  Created by Rocky Lee on 6/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDDetailToolbarModel.h"
#import "HDCoreStorage.h"

@implementation HDDetailToolbarModel

@synthesize resultList = _resultList;
@synthesize queryURL = _queryURL;
@synthesize detailRecord = _detailRecord;
@synthesize selectedAction = _selectedAction;

- (void)dealloc
{
    TT_RELEASE_SAFELY(_queryURL);
    TT_RELEASE_SAFELY(_resultList);
    [super dealloc];
}

-(void)load:(TTURLRequestCachePolicy)cachePolicy more:(BOOL)more
{
    id actionList  = [self loadTheLocalDataBaseActions];
    if ([actionList count]!=0) {
        self.resultList = actionList;
        self.loadedTime = [NSDate dateWithTimeIntervalSinceNow:0];
        self.cacheKey = @"local action";
        [self didFinishLoad];
    }else {
        HDRequestMap * requestMap = [HDRequestMap mapWithDelegate:self];
        requestMap.requestPath = self.queryURL;
        [self requestWithMap:requestMap];
    }
}

-(void)requestResultMap:(HDResponseMap *)map
{
    self.resultList = map.result;
    [self saveTheActions];
}

#pragma mark - SQL -
//查询本地动作
-(NSArray*)loadTheLocalDataBaseActions
{
    return [[HDCoreStorage shareStorage] query:@selector(SQLqueryAction:conditions:) conditions:self.detailRecord];
}

//保存审批动作
-(void)saveTheActions
{
    [self removeTheActions];
    [[HDCoreStorage shareStorage]excute:@selector(SQLinsertActions:recordList:) recordList:self.resultList];
}

//删除本地动作
-(void)removeTheActions
{
    [[HDCoreStorage shareStorage]excute:@selector(SQLremoveActions:recordList:) recordList:self.resultList];
}
#pragma mark - -
-(NSArray *)toolbarItems
{
    if(!self.resultList)return nil;
    NSMutableArray * actionItems = [NSMutableArray array];
    for (NSDictionary * actionRecord in self.resultList) {
        HDToolbarItem * actionItem = [[[HDToolbarItem alloc]init]autorelease];
        actionItem.tag = [[actionRecord objectForKey:@"action_id"] intValue];
        actionItem.title = [actionRecord objectForKey:@"action_id"];
        [actionItems addObject:actionItem];
    }
    return actionItems;
}

@end

