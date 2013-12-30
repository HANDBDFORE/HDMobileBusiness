//
//  HDTodoListService.m
//  HDMobileBusiness
//
//  Created by Plato on 12/13/12.
//  Copyright (c) 2012 hand. All rights reserved.
//

#import "HDTodoListModel.h"
#import "HDCoreStorage.h"

@implementation HDTodoListModel

- (void)dealloc
{
    TT_RELEASE_SAFELY(_resultList);
    TT_RELEASE_SAFELY(_primaryField);
    TT_RELEASE_SAFELY(_queryURL);
    TT_RELEASE_SAFELY(_submitURL);
    TT_RELEASE_SAFELY(_submitList);
    [super dealloc];
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (id)init
{
    self = [super init];
    if (self) {
        _submitList = [[NSMutableArray alloc] init];
        _resultList = [[NSMutableArray alloc] init];
        _flags.shouldLoadingLocalData = YES;
    }
    return self;
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark TTModel protocol
-(void)load:(TTURLRequestCachePolicy)cachePolicy more:(BOOL)more
{
    //读取本地数据库数据,把待提交的数据单条循环提交.等待前一条返回才发送下一条
    //第一次加载从本地加载
    if ([self shouldLoadLocalData]) {
        _flags.shouldLoadingLocalData = NO;
        [self loadLocalRecords];
        //这里只设置loadedTime表示超时,modelViewController会调用reload方法,之后可以考虑overwrite viewController的shuldreload方法或者model的isOutdated方法
        self.loadedTime = [NSDate dateWithTimeIntervalSinceNow:0];
        self.cacheKey = nil;
        [self load:TTURLRequestCachePolicyDefault more:NO];
        return;
    }
    if([self shouldSubmit]){
        _flags.isSubmitingData = YES;
        [self submit];
    }
    if ([self shouldQuery]) {
        _flags.isQueryingData = YES;
        [self loadRemoteRecords];
    }
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(void)cancel
{
    [super cancel];
    _flags.isQueryingData = NO;
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////


#pragma mark TTURLRequestDelegate
//因为服务端返回错误状态状态时,需要额外的流程,不能使用 requestResultMap
-(void)requestDidFinishLoad:(TTURLRequest *)request
{
    NSError * error = nil;
    HDResponseMap * resultMap = [[HDHTTPRequestCenter shareHTTPRequestCenter] responseMapWithRequest:request error:&error];
    //提交状态
    if (_flags.isSubmitingData) {
        [self performSelector:@selector(submitResponse:) withObject:resultMap afterDelay:0.6];
        //debug:这里加入return,否则在执行完update或delete之后会改变当前状态,如果继续执行会导致,执行查询状态代码,而这个时候返回的请求实际上是提交的请求.
        return;
    }
    //查询状态
    if (_flags.isQueryingData) {
        _flags.isQueryingData = NO;
        _flags.shouldLoadingLocalData = YES;
        if (!self.isLoadingMore) {
            self.loadedTime = request.timestamp;
            self.cacheKey = request.cacheKey;
        }
        [self performSelector:@selector(queryResponse:) withObject:resultMap afterDelay:0.6];
        return;
    }
    [self didFinishLoad];
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(void)request:(TTURLRequest *)request didFailLoadWithError:(NSError *)error
{
    [super request:request didFailLoadWithError:error];
    _flags.isQueryingData = NO;
    _flags.isSubmitingData = NO;
    _flags.shouldLoadingLocalData = YES;
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark HDListModelSubmit Submit 
-(void)submitRecords:(NSArray *)records
{
    [records setValue:kRecordWaiting forKey:kRecordStatus];
    //debug:调用了错误的方法,不应该使用 addObject
    [_submitList addObjectsFromArray:records];
    [self updateRecords:records];
    self.cacheKey = nil;
    [self didFinishLoad];
}

#pragma mark HDListModelSubmit Submit
-(void)submitDeliverRecords:(NSArray *)records
{
    [records setValue:kRecordWaiting forKey:kRecordStatus];
    //debug:调用了错误的方法,不应该使用 addObject
    [_submitList addObjectsFromArray:records];
    [self updateDeliverRecords:records];
    self.cacheKey = nil;
    [self didFinishLoad];
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(void)removeRecord:(id)record
{
    NSInteger index = [_resultList indexOfObject:record];
    [self removeRecords:@[record]];
    [self didDeleteObject:record atIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    [_resultList removeObject:record];
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma -mark CoreStorage
-(void)cleanTable
{
    [[HDCoreStorage shareStorage] excute:@selector(SQLCleanTable:) recordList:nil];
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-(NSArray *)queryRecords
{
    return [[HDCoreStorage shareStorage] query:@selector(SQLQueryToDoList:)
                                    conditions:nil];
}

-(NSArray *)queryRecordsDigest{
    return [[HDCoreStorage shareStorage] query:@selector(SQLQueryToDoListDigest:)
                                    conditions:nil];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(void)updateRecords:(NSArray *) recordList
{
    [[HDCoreStorage shareStorage] excute:@selector(SQLUpdateRecords:recordList:) recordList:recordList];
}

-(void)updateDeliverRecords:(NSArray *) recordList
{
    [[HDCoreStorage shareStorage] excute:@selector(SQLUpdateDeliverRecords:recordList:) recordList:recordList];
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(void)insertRecords:(NSArray *) recordList
{
    [[HDCoreStorage shareStorage] excute:@selector(SQLInsertRecords:recordList:) recordList:recordList];
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(void)removeRecords:(NSArray *) recordList
{
    [[HDCoreStorage shareStorage] excute:@selector(SQLRemoveRecords:recordList:) recordList:recordList];
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma -mark Flags
-(BOOL)isSubmiting
{
    return _flags.isSubmitingData;
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/*
 *可以加载本地数据
 */
-(BOOL)shouldLoadLocalData
{
    return _flags.shouldLoadingLocalData;
}

/*
 *可以提交的状态:
 *1 没有在查询
 *2 提交列表不为空
 */
-(BOOL) shouldSubmit
{
    return !_flags.isSubmitingData && !_flags.isQueryingData && (_submitList.count > 0);
}

/*
 *可以查询远程数据的状态
 *1 没有在提交状态
 *2 没有在查询状态
 *3 本地数据不可加载
 */
-(BOOL) shouldQuery
{
    return !_flags.isSubmitingData && !_flags.isQueryingData;
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma -mark private
-(void)loadLocalRecords
{
    [_resultList removeAllObjects];
    [_submitList removeAllObjects];
    //从数据库读取数据(应该放到一个业务逻辑类中)
    NSArray *_storageList = [self queryRecords];
    for (NSDictionary *record in _storageList) {
        [_resultList addObject:record];
        
        //如果是等待状态,插入提交列表
        if ([[record valueForKey:kRecordStatus] isEqualToString:kRecordWaiting]) {
            [_submitList addObject:record];
        }
    }
    [self setIconBadgeNumber];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(void)submit
{
    HDRequestMap * map = [HDRequestMap mapWithDelegate:self];
    NSMutableArray * postlist = [[NSMutableArray alloc]init];
    for (NSDictionary * submitrecord in _submitList) {
        NSMutableDictionary * postrecord = [NSMutableDictionary dictionaryWithObjectsAndKeys:[[submitrecord objectForKey:@"localId"] stringValue],@"localId",[submitrecord objectForKey:@"sourceSystemName"],@"sourceSystemName",[submitrecord objectForKey:@"submitAction"],@"action",[submitrecord objectForKey:@"submitActionType"],@"actionType",[submitrecord objectForKey:@"comment"],@"comments", nil];
        if ([submitrecord objectForKey:@"deliveree"]!=[NSNull null]) {
            NSDictionary * otherParams =[NSDictionary dictionaryWithObject:[submitrecord objectForKey:@"deliveree"] forKey:@"deliveree"];
            [postrecord setObject:otherParams forKey:@"otherParams"];
        }
        
        
        [postlist addObject:postrecord];
    }

    NSData *jsonData = nil;
    if ([NSJSONSerialization isValidJSONObject:postlist])
    {
        NSError *error = nil;
        jsonData  = [NSJSONSerialization dataWithJSONObject:postlist options:0 error:&error];
    }
    NSString *jsonString = [[[NSString alloc] initWithData:jsonData
                                                 encoding:NSUTF8StringEncoding]autorelease];
    TT_RELEASE_SAFELY(postlist);
    map.urlPath = self.submitURL;
    map.postData = [NSDictionary dictionaryWithObject:jsonString forKey:@"actions"];
    map.httpMethod = @"post";
    map.cachePolicy = TTURLRequestCachePolicyNoCache;
    [self requestWithMap:map];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(void)submitResponse:(HDResponseMap*) resultMap
{
    TT_RELEASE_SAFELY(_loadingRequest);
    _flags.isSubmitingData = NO;
    NSArray * reslist = [resultMap valueForKeyPath:@"result.list"];
    for(int i = [_submitList count] -1;i>=0;i--){
        NSDictionary * submitrecord =[_submitList objectAtIndex:i];
//        NSUInteger index = [self.resultList indexOfObject:submitrecord];
        for (NSDictionary * resrecord in reslist) {
            if (  [[resrecord objectForKey:@"localId"] integerValue] == [[submitrecord objectForKey:@"localId"] integerValue] &&[[resrecord objectForKey:@"sourceSystemName"] isEqualToString:[submitrecord objectForKey:@"sourceSystemName"]]) {
                if ([[resrecord objectForKey:@"status"] isEqualToString:@"F"]) {
                    [submitrecord setValue:kRecordWaiting forKey:kRecordStatus];
                    [submitrecord setValue:[resrecord objectForKey:@"message"] forKey:kRecordServerMessage];
//                    [self didUpdateObject:submitrecord
//                              atIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
                    [self updateRecords:@[submitrecord]];

                }else{
                    //debug:删除数据需要包装成数组
                    [self removeRecords:@[submitrecord]];
                    [self setIconBadgeNumber];
                    [_resultList removeObject:submitrecord];
                
                }
            }
        }
        [_submitList removeObject:[_submitList objectAtIndex:i]];
    }
    [self load:TTURLRequestCachePolicyDefault more:NO];
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(void)loadRemoteRecords
{
    NSArray * postlist =[self queryRecordsDigest];
    NSData *jsonData = nil;
    if ([NSJSONSerialization isValidJSONObject:postlist])
    {
        NSError *error = nil;
        jsonData  = [NSJSONSerialization dataWithJSONObject:postlist options:nil error:&error];
    }
    NSString *jsonString = [[[NSString alloc] initWithData:jsonData
                                                 encoding:NSUTF8StringEncoding]autorelease];
    HDRequestMap * map = [HDRequestMap mapWithDelegate:self];
    map.postData = [NSDictionary dictionaryWithObject:jsonString forKey:@"localIds"];
    map.httpMethod = @"post";
    map.urlPath =  self.queryURL;
    map.cachePolicy = TTURLRequestCachePolicyNoCache;
    [self requestWithMap:map];
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(void)queryResponse:(HDResponseMap*) resultMap
{
    [self refreshResultList:[resultMap result]];
    TT_RELEASE_SAFELY(_loadingRequest);
    [self didFinishLoad];
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//对比传入的 result 和当前的 _resultList 生成新的结果列表
-(void) refreshResultList:(NSDictionary *) responseList
{
    [self insertRecords:[responseList valueForKey:@"new"]];
    [self removeRecords:[responseList valueForKey:@"delete"]];
    [self loadLocalRecords];
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(void)setIconBadgeNumber
{
    [UIApplication sharedApplication].applicationIconBadgeNumber = [_resultList count];
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@end
