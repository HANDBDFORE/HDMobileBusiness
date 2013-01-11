//
//  HDTodoListService.m
//  HDMobileBusiness
//
//  Created by Plato on 12/13/12.
//  Copyright (c) 2012 hand. All rights reserved.
//

#import "HDTodoListModel.h"
#import "HDCoreStorage.h"

static NSString * kColumnMapKey = @"column1";
static NSString * kColumnMapColumn = @"column0";

static NSString * kSQLNull = @"null";

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
        //TODO:这里如果使用didFinish，会导致下拉刷新界面出问题，如果直接load会在分组时进入列表出现延迟现象。之后还是用load比较好，重新设计分组的交互。
        [self load:TTURLRequestCachePolicyDefault more:NO];
//        [self didFinishLoad];
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
-(NSArray *)queryRecords
{
    return [[HDCoreStorage shareStorage] query:@selector(SQLqueryToDoList:)
                                    conditions:nil];
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(void)updateRecords:(NSArray *) recordList
{
    [[HDCoreStorage shareStorage] excute:@selector(SQLupdateRecords:recordList:) recordList:recordList];
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(void)insertRecords:(NSArray *) recordList
{
    [[HDCoreStorage shareStorage] excute:@selector(SQLDataPoolInsert:recordList:) recordList:recordList];
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(void)removeRecords:(NSArray *) recordList
{
    [[HDCoreStorage shareStorage] excute:@selector(SQLremoveRecords:recordList:) recordList:recordList];
    [[HDCoreStorage shareStorage] excute:@selector(SQLremoveActions:recordList:) recordList:recordList];
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
    [self setIconBageNumber];
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(void)submit
{
    HDRequestMap * map = [HDRequestMap mapWithDelegate:self];
    map.postData = @[[_submitList objectAtIndex:0]];
    [map.userInfo setObject:[_submitList objectAtIndex:0] forKey:@"postObject"];
    map.urlPath = self.submitURL;
    map.cachePolicy = TTURLRequestCachePolicyNoCache;
    [self requestWithMap:map];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(void)submitResponse:(HDResponseMap*) resultMap
{
    TT_RELEASE_SAFELY(_loadingRequest);
    id submitObject = [resultMap.userInfo objectForKey:@"postObject"];
    NSUInteger index = [self.resultList indexOfObject:submitObject];
    [_submitList removeObject:submitObject];
    _flags.isSubmitingData = NO;
    /////////////////////////////////////////////////////////
    if (!resultMap.result) {
        [submitObject setValue:kRecordError forKey:kRecordStatus];
        [submitObject setValue:resultMap.error.localizedDescription forKey:kRecordServerMessage];
        [self didUpdateObject:submitObject
                  atIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
        [self updateRecords:@[submitObject]];
    }else {
        //debug:删除数据需要包装成数组
        [self removeRecords:@[submitObject]];
        [self setIconBageNumber];
        [self didDeleteObject:submitObject
                  atIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
        [_resultList removeObject:submitObject];
    }
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(void)loadRemoteRecords
{
    HDRequestMap * map = [HDRequestMap mapWithDelegate:self];
    map.urlPath =  self.queryURL;
    [self requestWithMap:map];
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(void)queryResponse:(HDResponseMap*) resultMap
{
    [self refreshResultList:resultMap.result];
    TT_RELEASE_SAFELY(_loadingRequest);
    [self didFinishLoad];
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//对比传入的 result 和当前的 _resultList 生成新的结果列表
-(void) refreshResultList:(NSArray *) responseList
{
    if(0 < [[[responseList lastObject] allKeys]count]){
        //TODO:需要确定action,comments字段是服务端传递还是这里强制写死
        //服务端传递:服务端可以自由使用变量名,提交参数意义明确,缺点是需要强制传递空参数,增加数据传输量.
        //客户端指定:不需要服务端传递空参数,缺点是提交参数被写死了.
        [responseList setValue:kRecordNormal forKey:kRecordStatus];
        [responseList setValue:kSQLNull forKey:kRecordServerMessage];
        [responseList setValue:kSQLNull forKey:kAction];
        [responseList setValue:kSQLNull forKey:kComments];
        [responseList setValue:kSQLNull forKey:kEmployeeID];
        
        [self refreshColumnMap:[responseList lastObject]];
        [self refreshDataBaseWithList:responseList];
        [self loadLocalRecords];
    }
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(void)refreshColumnMap:(NSDictionary *) record
{
    if (![self isMatchColumnMapWithDictionary:record]) {
        [[HDCoreStorage shareStorage]excute:@selector(SQLCleanTable:) recordList:nil];
        [self loadLocalRecords];
        
        NSMutableArray * columnKeyList = [NSMutableArray array];
        //set locked field
        [columnKeyList addObject:@{kColumnMapKey:_primaryField,kColumnMapColumn:@"column0"}];
        //set dinymic field from Column5
        int i =5;
        
        NSMutableDictionary * mutableRecord =  [[record mutableCopy] autorelease];
        [mutableRecord removeObjectForKey:_primaryField];
        NSArray * keys = [mutableRecord allKeys];
        for (NSString * key in keys) {
            [columnKeyList addObject:@{kColumnMapKey : key,kColumnMapColumn:[NSString stringWithFormat:@"column%i",i]}];
            i++;
        }
        [[HDCoreStorage shareStorage] excute:@selector(SQLColumnMapInsert:recordList:) recordList:columnKeyList];
    }
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(BOOL)isMatchColumnMapWithDictionary:(NSDictionary *) record
{
    NSArray * oldColumnKeyList = [[HDCoreStorage shareStorage]query:@selector(SQLqueryColumnMap:) conditions:nil];
    
    if ([record allKeys].count != oldColumnKeyList.count ||
        oldColumnKeyList.count == 0) {
        return NO;
    }
    
    BOOL matchFlg = YES;
    for (NSDictionary * line  in oldColumnKeyList) {
        matchFlg = matchFlg && !![record valueForKey:[line valueForKey:kColumnMapKey]];
    }
    return matchFlg;
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(void)refreshDataBaseWithList:(NSArray *) remoteRecords
{
    NSArray * localRecords = [self queryRecords];
    if (localRecords.count == 0) {
        [self insertRecords:remoteRecords];
        return;
    }
    
    NSMutableArray * diffArray = [[localRecords mutableCopy] autorelease];
    NSMutableArray * newArray = [[remoteRecords mutableCopy] autorelease];
    NSMutableArray * localSameArray = [NSMutableArray array];
    NSMutableArray * remoteSameArray = [NSMutableArray array];
    
    //比较数据
    //find same records
    for (NSMutableDictionary * localApprove in localRecords) {
        for (NSMutableDictionary * remoteRecord in remoteRecords) {
            if ([[localApprove valueForKey:_primaryField] isEqual:[remoteRecord valueForKey:_primaryField]]) {
                [localSameArray addObject:localApprove];
                [remoteSameArray addObject:remoteRecord];
            }
        }
    }
    
    [diffArray removeObjectsInArray:localSameArray];
    [diffArray setValue:kRecordDifferent forKey:kRecordStatus];
    [diffArray setValue:@"已在其他地方处理" forKey:kRecordServerMessage];
    [self updateRecords:diffArray];
    
    [newArray removeObjectsInArray:remoteSameArray];
    [self insertRecords:newArray];
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(void)setIconBageNumber
{
    [UIApplication sharedApplication].applicationIconBadgeNumber = [_resultList count];
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@end
