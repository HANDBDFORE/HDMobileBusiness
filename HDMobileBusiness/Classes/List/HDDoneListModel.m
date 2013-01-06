//
//  HDDoneListModel.m
//  HandMobile
//
//  Created by Rocky Lee on 7/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDDoneListModel.h"

@implementation HDDoneListModel
@synthesize resultList = _resultList;
@synthesize pageNum = _pageNum;
@synthesize queryURL = _queryURL;
@synthesize currentIndex = _currentIndex;

- (void)dealloc
{
    TT_RELEASE_SAFELY(_resultList);
    TT_RELEASE_SAFELY(_queryURL);
    [super dealloc];
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(id)init
{
    if (self = [super init]) {
        _pageNum = 1;
        _resultList = [[NSMutableArray alloc] init];
    }
    return self;
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(void)load:(TTURLRequestCachePolicy)cachePolicy more:(BOOL)more
{
    if (more) {
        _pageNum ++;
    }else {
        _pageNum = 1;
//        [_resultList removeAllObjects];
    }
    //debug:添加对_queryURL的nil校验，否则对nil appendding导致crash R
    if (_queryURL.length) {
        HDRequestMap * map = [HDRequestMap mapWithDelegate:self];
        map.urlPath = [_queryURL stringByAppendingFormat:@"?pagesize=10&pagenum=%i&_fetchall=false_autocount=false",_pageNum];
        [self requestWithMap:map];
    }
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(void)requestResultMap:(HDResponseMap *)map
{
    if(_pageNum==1){
        [_resultList removeAllObjects];
    }
    [_resultList addObjectsFromArray:map.result];
    
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(void)emptyResponse:(TTURLRequest *)request
{
    _pageNum --;
    [super emptyResponse:request];
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark Page turning
-(id)current
{
    if (self.resultList.count > _currentIndex) {
        return [self.resultList objectAtIndex:_currentIndex];
    }
    return nil;
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(id)next
{
    if ([self hasNext]) {
        _currentIndex ++;
    }
    return [self current];
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(BOOL)hasNext
{
    return  (_currentIndex + 1< [self effectiveRecordCount]);
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(id)prev
{
    if ([self hasPrev]) {
        _currentIndex --;
    }
    return [self current];
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(BOOL)hasPrev
{
    return  (_currentIndex > 0);
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(NSUInteger)effectiveRecordCount
{
    return self.resultList.count;
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(NSIndexPath *) currentIndexPath
{
    return [NSIndexPath indexPathForRow:_currentIndex inSection:0];
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@end
