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

- (void)dealloc
{
    TT_RELEASE_SAFELY(_resultList);
    TT_RELEASE_SAFELY(_queryURL);
    TT_RELEASE_SAFELY(_detailRecord);
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
    }else if (self.detailRecord && self.queryURL) {
        HDRequestMap * requestMap = [HDRequestMap mapWithDelegate:self];
        requestMap.urlPath = [self.queryURL stringByReplacingSpaceHodlerWithDictionary:self.detailRecord];
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


@end

