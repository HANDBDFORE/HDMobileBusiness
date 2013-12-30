//
//  HDActionModel.m
//  HDMobileBusiness
//
//  Created by 马豪杰 on 13-7-3.
//  Copyright (c) 2013年 hand. All rights reserved.
//

#import "HDActionModel.h"
#import "HDCoreStorage.h"
@implementation HDActionModel
@synthesize queryURL = _queryURL;
@synthesize actionList = _actionList;
@synthesize record = _record;
-(void)dealloc
{
    TT_RELEASE_SAFELY(_record);
    TT_RELEASE_SAFELY(_queryURL);
    TT_RELEASE_SAFELY(_actionList);
    [super dealloc];
}
-(id)init
{
    if (self = [super init]) {
    }
    return self;
}
-(void)query
{
    _actionList = [self queryActions];
    if ([_actionList count] < 1) {
        HDRequestMap * map = [HDRequestMap mapWithDelegate:self];
        map.urlPath = self.queryURL;
        //传回localId及sourceSystemName
        NSDictionary * postdata = [NSDictionary dictionaryWithObjectsAndKeys:[[_record objectForKey:@"localId"] stringValue],@"localId",[_record objectForKey:@"sourceSystemName"],@"sourceSystemName", nil];
        map.postData = postdata;
        [self requestWithMap:map];

    }else{
        [self didFinishLoad];
    }
}

#pragma -mark  overwrite HDURLRequestModel  functions
-(void)requestResultMap:(HDResponseMap *)map{
    NSArray * actions = [map.result objectForKey:@"list"];
    [self insertActions:actions];
    _actionList = actions;
}
#pragma -mark DataBase
-(NSArray *)queryActions
{
    return [[HDCoreStorage shareStorage] query:@selector(SQLQueryAction:conditions:)
                                    conditions:[NSDictionary dictionaryWithObject:[_record objectForKey:@"localId"] forKey:@"localId"]];
}
-(void)insertActions:(NSArray *) recordList
{
    [[HDCoreStorage shareStorage] excute:@selector(SQLActionInsertRecords:recordList:) recordList:recordList];
}
@end
