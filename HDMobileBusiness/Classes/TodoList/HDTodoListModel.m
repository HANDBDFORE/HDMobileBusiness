//
//  HDWillAproveListModel.m
//  hrms
//
//  Created by Rocky Lee on 7/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDTodoListModel.h"
#import "HDCoreStorage.h"

static NSString * kColumnMapKey = @"column1";
static NSString * kColumnMapColumn = @"column0";

static NSString * kSQLNull = @"null";
//submit filed
static NSString * kAction = @"action_id";
static NSString * kComments = @"comment";

@interface HDTodoListModel()

@property(nonatomic,retain)NSString * searchText;

@end

@implementation HDTodoListModel
@synthesize resultList = _resultList,submitList = _submitList;

@synthesize searchText = _searchText;
@synthesize serachFields = _serachFields;
@synthesize orderField = _orderField;
@synthesize primaryFiled = _primaryFiled;
@synthesize queryUrl = _queryUrl;
@synthesize submitUrl = _submitUrl;
@synthesize selectedIndex = _selectedIndex;

- (void)dealloc
{
    TT_RELEASE_SAFELY(_resultList);
    TT_RELEASE_SAFELY(_submitList);
    TT_RELEASE_SAFELY(_serachFields);
    TT_RELEASE_SAFELY(_orderField);
    TT_RELEASE_SAFELY(_primaryFiled);
    TT_RELEASE_SAFELY(_queryUrl);
    TT_RELEASE_SAFELY(_submitUrl);
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        _submitList = [[NSMutableArray alloc] init];
        _resultList = [[NSMutableArray alloc] init];
        //Test Data
        //        self.orderField = @"creation_date";
        //        self.primaryFiled = @"record_id";
        //        self.serachFields = @[@"order_type",@"node_name",@"employee_name"];
        //        self.queryUrl = [NSString stringWithFormat:@"%@%@",[[HDHTTPRequestCenter sharedURLCenter]baseURLPath],@"autocrud/ios.ios_todo_list.ios_todo_list_query/query?_fetchall=true&amp;_autocount=false"];
        //        self.submitUrl = [NSString stringWithFormat:@"%@%@",[[HDHTTPRequestCenter sharedURLCenter]baseURLPath],@"modules/ios/ios_approve_new/ios_todo_list_commit.svc"];
        _selectedIndex = 0;
        _flags.isFirstLoad = YES;
    }
    return self;
}

#pragma mark TTModel protocol
-(void)load:(TTURLRequestCachePolicy)cachePolicy more:(BOOL)more
{
    //读取本地数据库数据,把待提交的数据单条循环提交.等待前一条返回才发送下一条
    //第一次加载从本地加载
    if (_flags.isFirstLoad) {
        _flags.isFirstLoad = NO;
        [self loadLocalRecords];
        //这里只设置loadedTime表示超时,modelViewController会调用reload方法,之后可以考虑overwrite viewController的shuldreload方法或者model的isOutdated方法
        self.loadedTime = [NSDate dateWithTimeIntervalSinceNow:0];
        [self didFinishLoad];
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

#pragma mark TTURLRequestDelegate
//因为服务端返回错误状态状态时,需要额外的流程,不能使用 requestResultMap
-(void)requestDidFinishLoad:(TTURLRequest *)request
{
    NSError * error = nil;
    HDResponseMap * resultMap = [[HDHTTPRequestCenter shareHTTPRequestCenter] responseMapWithRequest:request error:&error];
    //提交状态
    if (_flags.isSubmitingData) {
        [self performSelector:@selector(didSubmitRecord:) withObject:resultMap afterDelay:0.6];
        //debug:这里加入return,否则在执行完update或delete之后会改变当前状态,如果继续执行会导致,执行查询状态代码,而这个时候返回的请求实际上是提交的请求.
        return;
    }
    //查询状态
    if (_flags.isQueryingData) {
        _flags.isQueryingData = NO;
        [self refreshResultList:resultMap.result];
        if (!self.isLoadingMore) {
            self.loadedTime = request.timestamp;
            self.cacheKey = request.cacheKey;
        }
        TT_RELEASE_SAFELY(_loadingRequest);
        [self didFinishLoad];
    }
    [self didFinishLoad];
}

-(void)request:(TTURLRequest *)request didFailLoadWithError:(NSError *)error
{
    [super request:request didFailLoadWithError:error];
    _flags.isQueryingData = NO;
    _flags.isSubmitingData = NO;
}

#pragma -mark Submit data
-(void)submit
{
    HDRequestMap * map = [HDRequestMap mapWithDelegate:self];
    map.postData = @[[_submitList objectAtIndex:0]];
    [map.userInfo setObject:[_submitList objectAtIndex:0] forKey:@"postObject"];
    map.requestPath = self.submitUrl;
    map.cachePolicy = TTURLRequestCachePolicyNoCache;
    [self requestWithMap:map];
}

-(void)didSubmitRecord:(HDResponseMap*) resultMap
{
    TT_RELEASE_SAFELY(_loadingRequest);
    id submitObject = [resultMap.userInfo objectForKey:@"postObject"];
    NSUInteger index = [self.resultList indexOfObject:[resultMap.userInfo objectForKey:@"postObject"]];
    [_submitList removeObject:submitObject];
    _flags.isSubmitingData = (_submitList.count > 0);
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
        [_resultList removeObject:submitObject];
        [self setIconBageNumber];
        [self didDeleteObject:submitObject
                  atIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    }
}

-(void)submitObjectAtIndexPaths:(NSArray *) indexPaths
                        comment:(NSString *) comment
                         action:(NSString *) action
{
    for (NSIndexPath * indexPath in indexPaths) {
        id  submitRecord = [self.resultList objectAtIndex:indexPath.row];
        [submitRecord setValue:comment forKey:kComments];
        [submitRecord setValue:action forKey:kAction];
        [submitRecord setValue:kRecordWaiting forKeyPath:kRecordStatus];
        [_submitList addObject:submitRecord];
    }
    [self updateRecords:self.submitList];
    //设置超时状态,进入shouldload状态
    self.cacheKey = nil;
    [self didFinishLoad];
}

#pragma mark Load local records
-(void)loadLocalRecords
{
    [_resultList removeAllObjects];
    //从数据库读取数据(应该放到一个业务逻辑类中)
    NSArray *_storageList = [[HDCoreStorage shareStorage]  query:@selector(SQLqueryToDoList:) conditions:nil];
    for (NSDictionary *record in _storageList) {
        [_resultList addObject:record];
        
        //如果是等待状态,插入提交列表
        if ([[record valueForKey:kRecordStatus] isEqualToString:kRecordWaiting]) {
            [_submitList addObject:record];
        }
    }
    
    [_resultList sortWithOptions:NSSortConcurrent
                 usingComparator:^NSComparisonResult (id obj1,id obj2){
                     return [[obj1 valueForKey:_orderField]
                             compare:[obj2 valueForKey:_orderField]];
                 }];
    [self setIconBageNumber];
}

#pragma -mark Load remote records
-(void)loadRemoteRecords
{
    _flags.isQueryingData = YES;
    HDRequestMap * map = [HDRequestMap mapWithDelegate:self];
    map.requestPath =  self.queryUrl;
    [self requestWithMap:map];
}

//对比传入的 result 和当前的 _resultList 生成新的结果列表
-(void) refreshResultList:(NSArray *) responseList
{
    if(0 < [[[responseList lastObject] allKeys]count]){
        //TODO:这里需要确定action,comments字段是服务端传递还是这里强制写死
        //服务端传递:服务端可以自由使用变量名,提交参数意义明确,缺点是需要强制传递空参数,增加数据传输量.
        //客户端指定:不需要服务端传递空参数,缺点是提交参数被写死了.
        [responseList setValue:kRecordNormal forKey:kRecordStatus];
        [responseList setValue:kSQLNull forKey:kRecordServerMessage];
        [responseList setValue:kSQLNull forKey:kAction];
        [responseList setValue:kSQLNull forKey:kComments];
        //刷新columnMap表
        [self refreshColumnMap:[responseList lastObject]];
        
        
        NSArray * newResultList =
        [self combineRecordsWithLocalRecords:_resultList
                               remoteRecords:responseList];
        [_resultList removeAllObjects];
        [_resultList addObjectsFromArray:newResultList];
        
        
        [_resultList sortWithOptions:NSSortStable usingComparator:^NSComparisonResult(id obj1, id obj2) {
            return [[obj1 valueForKey:_orderField]
                    compare:[obj2 valueForKey:_orderField]];
        }];
        if ([self isSearching]) {
            [self search:self.searchText];
        }
        
        [self setIconBageNumber];
    }
}

-(void)refreshColumnMap:(NSDictionary *) record
{
    if (![self matchColumnMap:record]) {
        [[HDCoreStorage shareStorage]excute:@selector(SQLCleanTable:) recordSet:nil];
        [self loadLocalRecords];
        
        NSMutableArray * columnKeyList = [NSMutableArray array];
        //set locked field
        [columnKeyList addObject:@{kColumnMapKey:_primaryFiled,kColumnMapColumn:@"column0"}];
        //set dinymic field from Column5
        int i =5;
        
        NSMutableDictionary * mutableRecord =  [record mutableCopy];
        [mutableRecord removeObjectForKey:_primaryFiled];
        NSArray * keys = [mutableRecord allKeys];
        for (NSString * key in keys) {
            [columnKeyList addObject:@{kColumnMapKey : key,kColumnMapColumn:[NSString stringWithFormat:@"column%i",i]}];
            i++;
        }
        [[HDCoreStorage shareStorage] excute:@selector(SQLColumnMapInsert:recordSet:) recordSet:columnKeyList];
    }
}

-(BOOL)matchColumnMap:(NSDictionary *) newMatchRecord
{
    NSArray * oldColumnKeyList = [[HDCoreStorage shareStorage]query:@selector(SQLqueryColumnMap:) conditions:nil];
    
    if ([newMatchRecord allKeys].count != oldColumnKeyList.count ||
        oldColumnKeyList.count == 0) {
        return NO;
    }
    
    BOOL matchFlg = YES;
    for (NSDictionary * line  in oldColumnKeyList) {
        matchFlg = matchFlg && !![newMatchRecord valueForKey:[line valueForKey:kColumnMapKey]];
    }
    return matchFlg;
}

-(NSArray *)combineRecordsWithLocalRecords:(NSArray *) localRecords remoteRecords:(NSArray *) remoteRecords
{
    //debug 判断localRecord是否为空，否则copy时会crash
    if (localRecords.count == 0) {
        [self insertRecords:remoteRecords];
        return remoteRecords;
    }
    
    NSMutableArray * diffArray = [localRecords mutableCopy];
    NSMutableArray * newArray = [remoteRecords mutableCopy] ;
    NSMutableArray * localSameArray = [NSMutableArray array];
    NSMutableArray * remoteSameArray = [NSMutableArray array];
    
    //比较数据
    //find same records
    for (NSMutableDictionary * localApprove in localRecords) {
        for (NSMutableDictionary * remoteRecord in remoteRecords) {
            if ([[localApprove valueForKey:_primaryFiled] isEqual:[remoteRecord valueForKey:_primaryFiled]]) {
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
    
    //合并数据
    return [[localSameArray arrayByAddingObjectsFromArray:diffArray]
            arrayByAddingObjectsFromArray:newArray];
}

#pragma -mark CoreStorage
-(void)updateRecords:(NSArray *) recordSet
{
    [[HDCoreStorage shareStorage] excute:@selector(SQLupdateRecords:recordSet:) recordSet:recordSet];
}

-(void)insertRecords:(NSArray *) recordSet
{
    [[HDCoreStorage shareStorage] excute:@selector(SQLDataPoolInsert:recordSet:) recordSet:recordSet];
}

-(void)removeRecords:(NSArray *) recordList
{
    NSMutableArray * deleteArray = [NSMutableArray array];
    for (NSDictionary * record in recordList) {
        //TODO:这里后期处理为直接传递record
        [deleteArray addObject:@{@"record_id":[record valueForKey:@"record_id"]}];
    }
    [[HDCoreStorage shareStorage] excute:@selector(SQLremoveRecord:recordSet:) recordSet:deleteArray];
}

#pragma -mark Flags
/*
 *可以提交的状态:
 *1 没有在查询
 *2 不是第一次load
 *3 提交列表不为空
 */
-(BOOL) shouldSubmit
{
    return !_flags.isQueryingData && !_flags.isFirstLoad && (_submitList.count > 0) ;
}

/*
 *可以查询远程数据的状态
 *1 没有在提交状态
 *2 不是第一次load
 */
-(BOOL) shouldQuery
{
    return !_flags.isSubmitingData && !_flags.isFirstLoad && !_flags.isQueryingData;
}

#pragma mark Search
- (void)search:(NSString*)text
{
    [self cancel];

    self.searchText = text;
    if (self.searchText.length) {
        [self loadLocalRecords];
        
        NSArray * fetchArray = [NSArray arrayWithArray:self.resultList];
        for (id record in fetchArray) {
            BOOL matchFlg = NO;
            for (NSString * key in self.serachFields) {
                matchFlg = matchFlg || [[record valueForKey:key] rangeOfString:self.searchText options:NSLiteralSearch|NSCaseInsensitiveSearch|NSNumericSearch].length;
            }
            if (!matchFlg) {
                [_resultList removeObject:record];
            }
        }
        [self didFinishLoad];
    } else {
        //debug:结束查询状态时，需要清空结果列表，否则再次查询时，查询table和model数据不一致导致crash。
        [_resultList removeAllObjects];
        [self didChange];
    }
}

-(BOOL)isSearching
{
    return !!self.searchText;
}

#pragma mark Others
-(void)setIconBageNumber
{
    [UIApplication sharedApplication].applicationIconBadgeNumber = self.resultList.count;
}

-(BOOL)isEffectiveRecord:(NSDictionary *)record
{
    NSString * status = [record valueForKey:kRecordStatus];
    return [status isEqualToString:kRecordNormal] ||
    [status isEqualToString:kRecordError];
}

-(void)clear
{
    NSSet * resultSet = [NSSet setWithArray:self.resultList];
    NSArray * differentRecords = [[resultSet objectsWithOptions:NSEndsWithPredicateOperatorType passingTest:^BOOL(id obj, BOOL *stop) {
        return [[obj valueForKey:kRecordStatus] isEqualToString:kRecordDifferent];
    }] allObjects];
    [self removeRecords:differentRecords];
    
    _flags.isFirstLoad = YES;
    [self load:TTURLRequestCachePolicyDefault more:NO];
}

#pragma mark Detail functions
-(NSUInteger)effectiveRecordCount
{
    NSSet * resultSet = [NSSet setWithArray:self.resultList];
    return [[resultSet objectsWithOptions:NSEndsWithPredicateOperatorType
                              passingTest:^BOOL(id obj, BOOL *stop) {
                                  return [self isEffectiveRecord:obj];
                              }] count];
}

-(id)currentRecord
{
    return [_resultList objectAtIndex:_selectedIndex];
}

-(BOOL)nextRecord
{
    if (_selectedIndex == [self effectiveRecordCount]) {
        return NO;
    }
    
    NSUInteger indexPoint = _selectedIndex;
    BOOL hasNextRecord = YES;
    
    _selectedIndex++;
    
    //如果不是有效的记录，获取下一条
    if (![self isEffectiveRecord:[self currentRecord]]) {
        hasNextRecord = [self nextRecord];
    }
    if (!hasNextRecord) {
        _selectedIndex = indexPoint;
    }
    
    return hasNextRecord;
}

-(BOOL)prevRecord
{
    if (_selectedIndex == 0) {
        return NO;
    }
    
    NSUInteger indexPoint = _selectedIndex;
    BOOL hasPrevRecord = YES;
    
    _selectedIndex--;
    
    if (![self isEffectiveRecord:[self currentRecord]]) {
        hasPrevRecord = [self nextRecord];
    }
    if (!hasPrevRecord) {
        _selectedIndex = indexPoint;
    }
    
    return hasPrevRecord;
}

@end
