//
//  HDWillAproveListModel.m
//  hrms
//
//  Created by Rocky Lee on 7/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDTodoListModel.h"
#import "ApproveDatabaseHelper.h"

@interface HDTodoListModel()

@property(nonatomic,retain)ApproveDatabaseHelper * dbHelper;
@property(nonatomic,retain)NSString * searchText;

@end

@implementation HDTodoListModel
@synthesize resultList = _resultList,submitList = _submitList;
//,searchResultList = _searchResultList;

@synthesize searchText = _searchText;
@synthesize submitAction = _submitAction;
@synthesize dbHelper = _dbHelper;

- (void)dealloc
{
    TT_RELEASE_SAFELY(_resultList);
    TT_RELEASE_SAFELY(_submitList);
    TT_RELEASE_SAFELY(_submitAction);
    TT_RELEASE_SAFELY(_dbHelper);
//    TT_RELEASE_SAFELY(_searchResultList);
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"submitNotification" object:nil];
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        _submitList = [[NSMutableArray alloc] init];
        _resultList = [[NSMutableArray alloc] init];
//        _searchResultList = [[NSMutableArray alloc]init];
        _flags.isFirstLoad = YES;
        _dbHelper = [[ApproveDatabaseHelper alloc]init];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receiveNotification:) name:@"submitNotification" object:nil];
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
        //        [self performSelector:@selector(submit) withObject:self afterDelay:0.5];
    }
    if ([self shouldQuery]) {
        _flags.isQueryingData = YES;
        [self loadRemoteRecords];
        //        [self performSelector:@selector(loadRemoteRecords) withObject:self afterDelay:0.5];
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
        //TODO:这里考虑不转化为对象
        _flags.isQueryingData = NO;
        [self updateResultList:resultMap.result];
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

-(void)didSubmitRecord:(HDResponseMap*) resultMap
{
    TT_RELEASE_SAFELY(_loadingRequest);
    Approve * submitObject = (Approve *) [resultMap.userInfo objectForKey:@"postObject"];
    NSUInteger index;
//    if ([self isSearching]) {
//        index = [self.searchResultList indexOfObject:submitObject];
//    }else {
        index = [self.resultList indexOfObject:submitObject];
//    }
    [_submitList removeObject:submitObject];
    _flags.isSubmitingData = (_submitList.count > 0);
    //////////////////////////////////////////
    ///////////////
    if (!resultMap.result) {
        submitObject.localStatus = @"ERROR";
        submitObject.serverMessage = resultMap.error.localizedDescription;
        [self didUpdateObject:submitObject
                  atIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
        [self updateSubmitRecord:submitObject];
    }else {
        [self removeSubmitedRecord:submitObject];
        [_resultList removeObject:submitObject];
//        [_searchResultList removeObject:submitObject];
        [self setIconBageNumber];
        [self didDeleteObject:submitObject
                  atIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    }
}

#pragma -mark Submit offline data
-(void)submit
{
    Approve * _approve = [_submitList objectAtIndex:0];
    id _postData =[NSDictionary dictionaryWithObjectsAndKeys:[_approve.recordID stringValue],@"record_id", _approve.action,@"action_id",_approve.comment,@"comment",nil];
    
    HDRequestMap * map = [HDRequestMap mapWithDelegate:self];
    map.postData = _postData;
    [map.userInfo setObject:_approve forKey:@"postObject"];
    map.requestPath = _approve.submitUrl;
    //    map.urlName = kApproveListBatchSubmitPath;
    map.cachePolicy = TTURLRequestCachePolicyNoCache;
    [self requestWithMap:map];
}

-(void)addObjectAtIndexPathsForSubmit:(NSArray *) indexPaths comment:(NSString *) comment
{
    for (NSIndexPath * indexPath in indexPaths) {
        //TODO:这里需要判断是search的table还是待办列表的table,一个从result中取对象,一个从search中取
        
        Approve * submitObject = nil;
        
//        if ([self isSearching]) {
//            submitObject = [self.searchResultList objectAtIndex:indexPath.row];
//        }else {
            submitObject = [self.resultList objectAtIndex:indexPath.row];
//        }
        
        submitObject.comment = comment;
        submitObject.action = self.submitAction;
        submitObject.submitUrl = [[HDHTTPRequestCenter sharedURLCenter] requestURLWithKey:kApproveListBatchSubmitPath query:nil];
        [self setObjectForSubmit:submitObject];
    }
    //设置超时状态,进入shouldload状态
    self.cacheKey = nil;
    [self didFinishLoad];
}

-(void)receiveNotification:(NSNotification *)notification
{
    [self setObjectForSubmit:[notification object]];
    self.cacheKey = nil;
    [self didFinishLoad];
}

//这个调用只刷新界面而不应该出发model的load,需要表示model不需要load
-(void)setObjectForSubmit:(id)submitObject
{
    [submitObject setValue:@"WAITING" forKeyPath:@"localStatus"];
    [self.submitList addObject:submitObject];
    [self updateSubmitRecord:submitObject];
}

#pragma -mark Load remote records
-(void)loadRemoteRecords
{
    _flags.isQueryingData = YES;
    HDRequestMap * map = [HDRequestMap mapWithDelegate:self];
    map.urlName = kApproveListQueryPath;
    [self requestWithMap:map];
}

#pragma mark Load local records
-(void)loadLocalRecords
{
    //从数据库读取数据(应该放到一个业务逻辑类中)
    //    ApproveDatabaseHelper * _dbHelper = [[ApproveDatabaseHelper alloc]init];
    [self.dbHelper.db open];
    
    NSString *sql = [NSString stringWithFormat:@"select rowid, %@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@ from %@ order by %@ desc",APPROVE_PROPERTY_WORKFLOW_ID,APPROVE_PROPERTY_RECORD_ID,APPROVE_PROPERTY_ORDER_TYPE,APPROVE_PROPERTY_INSTANCE_DESC,APPROVE_PROPERTY_NODE_NAME,APPROVE_PROPERTY_EMPLOYEE_NAME,APPROVE_PROPERTY_CREATION_DATE,APPROVE_PROPERTY_DATE_LIMIT,APPROVE_PROPERTY_IS_LATE,APPROVE_PROPERTY_LOCAL_STATUS,APPROVE_PROPERTY_COMMENT,APPROVE_PROPERTY_APPROVE_ACTION,APPROVE_PROPERTY_SCREEN_NAME,APPROVE_PROPERTY_SERVER_MESSAGE, APPROVE_PROPERTY_SUBMIT_URL,APPROVE_PROPERTY_NODE_ID,APPROVE_PROPERTY_INSTANCE_ID,APPROVE_PROPERTY_INSTANCE_PARAM,APPROVE_PROPERTY_EMPLOYEE_ID,TABLE_NAME_APPROVE_LIST,APPROVE_PROPERTY_CREATION_DATE];
    FMResultSet *resultSet = [self.dbHelper.db executeQuery:sql];
    
    NSMutableArray * _localList = [NSMutableArray array];
    
    while ([resultSet next]) {
        Approve *_record = [[Approve alloc]initWithDictionary:resultSet.resultDictionary];
        [_localList addObject:_record];
        //如果是等待状态,插入提交列表
        if ([_record.localStatus isEqualToString:@"WAITING"]) {
            [_submitList addObject:_record];
        }
        TT_RELEASE_SAFELY(_record);
    }
    [resultSet close];
    [self.dbHelper.db close];
    [_resultList addObjectsFromArray:[self orderList:_localList]];
    [self setIconBageNumber];
    //    TT_RELEASE_SAFELY(_dbHelper);
}

//提交成功,删除本地记录
-(void)removeSubmitedRecord:(Approve *) submitRecord
{
    //删除提交成功的数据
    //    ApproveDatabaseHelper * _dbHelper = [[ApproveDatabaseHelper alloc]init];
    //TODO:做成单例...
    NSString *sql = [NSString stringWithFormat:@"delete from %@ where %@='%@';",TABLE_NAME_APPROVE_LIST,@"rowid",submitRecord.rowID];
    
    if ([_dbHelper.db open]) {
        [_dbHelper.db executeUpdate:sql];
        [_dbHelper.db close];
    }
    //    TT_RELEASE_SAFELY(_dbHelper);
}

-(void)updateSubmitRecord:(Approve *) submitRecord
{
    //修改数据
    //    ApproveDatabaseHelper * dbHelper = [[ApproveDatabaseHelper alloc]init];
    NSString *sql = [NSString stringWithFormat:@"update %@ set %@='%@',%@ ='%@',%@='%@',%@='%@',%@='%@'where %@ ='%@';",TABLE_NAME_APPROVE_LIST,APPROVE_PROPERTY_LOCAL_STATUS,submitRecord.localStatus,APPROVE_PROPERTY_COMMENT,submitRecord.comment,APPROVE_PROPERTY_SUBMIT_URL,submitRecord.submitUrl,APPROVE_PROPERTY_APPROVE_ACTION,submitRecord.action,APPROVE_PROPERTY_SERVER_MESSAGE,submitRecord.serverMessage,@"rowid",submitRecord.rowID];
    
    [_dbHelper.db open];
    [_dbHelper.db executeUpdate:sql];
    [_dbHelper.db close];
    //    TT_RELEASE_SAFELY(dbHelper);
}

-(void) updateResultList:(NSArray *) result
{
    //对比数据生成新的结果列表
    //TODO:不要转化数据
    if(0 < [[[result lastObject] allKeys]count]){
        NSArray * _responseList = [[HDGodXMLFactory shareBeanFactory] beansWithArray:result path:@"/backend-config/field-mappings/field-mapping[@url_name='APPROVE_LIST_QUERY_URL']"] ;
        
        NSArray * _newResult = [self combineRecordsWithlocalRecords:_resultList remoteRecords:_responseList];
        
        [_resultList removeAllObjects];
        [_resultList addObjectsFromArray:_newResult];
        if ([self isSearching]) {
            [self search:self.searchText];
        }
        
        [self setIconBageNumber];
    }
}

-(NSArray *)combineRecordsWithlocalRecords:(NSArray *) localRecords remoteRecords:(NSArray *) remoteRecords
{
    //
    NSMutableArray * _diffArray = [NSMutableArray arrayWithArray:localRecords];
    NSMutableArray * _newArray = [NSMutableArray arrayWithArray:remoteRecords] ;
    NSMutableArray * _localSameArray = [NSMutableArray array];
    NSMutableArray * _remoteSameArray = [NSMutableArray array];
    
    //比较数据
    //find same records
    for (Approve * localApprove in (NSArray *)localRecords) {
        for (Approve * remoteRecord in remoteRecords) {
            if ([localApprove.recordID isEqualToValue:remoteRecord.recordID]) {
                [_localSameArray addObject:localApprove];
                [_remoteSameArray addObject:remoteRecord];
            }
        }
    }
    
    [_diffArray removeObjectsInArray:_localSameArray];
    [_newArray removeObjectsInArray:_remoteSameArray];
    
    [self updateDifferentRecords:(NSArray *) _diffArray];
    [self insertNewRecords:(NSArray *) _newArray];
    
    //合并数据
    NSArray * resultArray = [[_localSameArray
                              arrayByAddingObjectsFromArray:_diffArray]
                             arrayByAddingObjectsFromArray:_newArray];
    
    return [self orderList:resultArray];
}

-(NSArray *)orderList:(NSArray *) list
{
    return [list sortedArrayWithOptions:NSSortStable usingComparator:^NSComparisonResult (Approve* obj1,Approve * obj2){
        return [obj1.creationDate compare:obj2.creationDate];
    }];
}

-(void)updateDifferentRecords:(NSArray *) records
{
    //更新数据
    //    ApproveDatabaseHelper * _dbHelper = [[ApproveDatabaseHelper alloc]init];
    
    //设置diff状态
    [_dbHelper.db open];
    [_dbHelper.db beginTransaction];
    
    BOOL successFlg = YES;
    for (Approve * diffApprve in records) {
        diffApprve.localStatus = @"DIFFERENT";
        diffApprve.serverMessage = @"已在其他地方处理";
        
        NSString * sql = [NSString stringWithFormat:@"update %@ set %@ = '%@',%@ = '%@' where %@ = '%@';",TABLE_NAME_APPROVE_LIST,APPROVE_PROPERTY_LOCAL_STATUS,diffApprve.localStatus,APPROVE_PROPERTY_SERVER_MESSAGE,diffApprve.serverMessage,@"rowid",diffApprve.rowID];
        successFlg = successFlg && [_dbHelper.db executeUpdate:sql];
    }
    if (successFlg) {
        [_dbHelper.db commit];
    }
    [_dbHelper.db close];
    //    TT_RELEASE_SAFELY(_dbHelper);
}

-(void)insertNewRecords:(NSArray *)records
{
    //    ApproveDatabaseHelper * _dbHelper = [[ApproveDatabaseHelper alloc]init];
    [_dbHelper.db open];
    
    //设置normal状态
    for (Approve * newApprove in records) {
        newApprove.localStatus = @"NORMAL";
        
        NSString * insertSQL = [NSString stringWithFormat:@"insert into %@ (%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@) values ('%@','%@','%@',%@,'%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@');",TABLE_NAME_APPROVE_LIST,APPROVE_PROPERTY_WORKFLOW_ID,APPROVE_PROPERTY_RECORD_ID,APPROVE_PROPERTY_ORDER_TYPE,APPROVE_PROPERTY_INSTANCE_DESC,APPROVE_PROPERTY_NODE_NAME,APPROVE_PROPERTY_EMPLOYEE_NAME,APPROVE_PROPERTY_CREATION_DATE,APPROVE_PROPERTY_DATE_LIMIT,APPROVE_PROPERTY_IS_LATE,APPROVE_PROPERTY_LOCAL_STATUS,APPROVE_PROPERTY_SCREEN_NAME,APPROVE_PROPERTY_NODE_ID,APPROVE_PROPERTY_INSTANCE_ID,APPROVE_PROPERTY_INSTANCE_PARAM,APPROVE_PROPERTY_EMPLOYEE_ID,newApprove.workflowID,newApprove.recordID,newApprove.orderType,(newApprove.instanceDesc == nil ? NULL : [NSString stringWithFormat:@"'%@'",newApprove.instanceDesc]),newApprove.nodeName,newApprove.employeeName,newApprove.creationDate,newApprove.dateLimit,newApprove.isLate,newApprove.localStatus,newApprove.docPageUrl,newApprove.nodeId,newApprove.instanceId,newApprove.instanceParam,newApprove.employeeId];
        
        [_dbHelper.db executeUpdate:insertSQL];
        
        newApprove.rowID = [NSNumber numberWithInt:sqlite3_last_insert_rowid([_dbHelper.db sqliteHandle])] ;
    }
    [_dbHelper.db close];
    //    TT_RELEASE_SAFELY(_dbHelper);
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
    //    TTDPRINT(@"search");
    self.searchText = text;
//    [_searchResultList removeAllObjects];
    [_resultList removeAllObjects];
    [self loadLocalRecords];
    if (self.searchText.length) {
        //        [self fakeSearch];
        [_resultList addObjectsFromArray:[self createSearchResult]];
        [self didFinishLoad];
    } else {
        [self didChange];
    }
}

-(NSArray *)createSearchResult
{
    NSMutableArray * searchResultList = [NSMutableArray array];
    for (id record in self.resultList) {
        BOOL matchFlg = NO;
        //TODO:有字段是nil啊..结果集没显示出来为什么呢
        matchFlg = matchFlg || [[record valueForKey:@"orderType"] rangeOfString:self.searchText options:NSLiteralSearch|NSCaseInsensitiveSearch|NSNumericSearch].length;
        matchFlg = matchFlg || [[record valueForKey:@"nodeName"] rangeOfString:self.searchText options:NSLiteralSearch|NSCaseInsensitiveSearch|NSNumericSearch].length;
        matchFlg = matchFlg || [[record valueForKey:@"employeeName"] rangeOfString:self.searchText options:NSLiteralSearch|NSCaseInsensitiveSearch|NSNumericSearch].length;
        if (matchFlg) {
            [searchResultList addObject:record];
        }
    }
    return [self orderList:searchResultList];
}

#pragma mark Others
-(void)setIconBageNumber
{
    [UIApplication sharedApplication].applicationIconBadgeNumber = self.resultList.count;
}

//-(void)setIsSearching:(BOOL)isSearching
//{
//    _flags.isSearching = isSearching;
//}

-(BOOL)isSearching
{
//    return _flags.isSearching;
    return !!self.searchText;
}
@end
