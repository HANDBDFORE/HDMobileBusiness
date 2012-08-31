//
//  HDDidApprovedListModel.m
//  hrms
//
//  Created by Rocky Lee on 7/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDDoneListModel.h"

@implementation HDDoneListModel
@synthesize resultList = _resultList;
@synthesize pageNum = _pageNum;

@synthesize queryUrl = _queryUrl;
@synthesize selectedIndex = _selectedIndex;

- (void)dealloc
{
    TT_RELEASE_SAFELY(_resultList);
    TT_RELEASE_SAFELY(_queryUrl);
    [super dealloc];
}

-(id)init
{
    if (self = [super init]) {
        _pageNum = 1;
        _resultList = [[NSMutableArray alloc] init];
        //test data
//        self.queryUrl = [NSString stringWithFormat:@"%@autocrud/ios.ios_approve.ios_workflow_has_approved_query/query",[[HDHTTPRequestCenter sharedURLCenter]baseURLPath]];
    }
    return self;
}

-(void)load:(TTURLRequestCachePolicy)cachePolicy more:(BOOL)more
{
    if (more) {
        _pageNum ++;
        _isLoadingMore = more;
    }
    //debug:添加对_queryUrl的nil校验，否则对nil appendding导致crash R
    if (_queryUrl) {
        HDRequestMap * map = [HDRequestMap mapWithDelegate:self];
        map.requestPath = [_queryUrl stringByAppendingFormat:@"?pagesize=10&amp;pagenum=%i&amp;_fetchall=false&amp;_autocount=false",_pageNum];
        [self requestWithMap:map];
    }
}

-(void)requestResultMap:(HDResponseMap *)map
{
    if (0 < [[[map.result lastObject] allKeys]count]) {
        if ([self isLoadingMore]) {
            [_resultList addObjectsFromArray:map.result];
            _isLoadingMore = NO;
        }else {
            [_resultList removeAllObjects];
            [_resultList addObjectsFromArray:map.result];
        }
    }
}

-(id)currentRecord
{
    return [self.resultList objectAtIndex:_selectedIndex];
}

//跳转到下一条有效记录
-(BOOL)nextRecord
{
    if (_selectedIndex == [self effectiveRecordCount]) {
        return NO;
    }
    _selectedIndex ++;
    return YES;
}

//跳转到上一条有效记录
-(BOOL)prevRecord
{
    if (_selectedIndex == 0) {
        return 0;
    }
    _selectedIndex--;
    return YES;
}

//获取当前有效记录数
-(NSUInteger)effectiveRecordCount
{
    return self.resultList.count;
}
@end
