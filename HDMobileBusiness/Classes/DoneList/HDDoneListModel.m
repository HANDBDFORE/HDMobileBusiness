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

- (void)dealloc
{
    TT_RELEASE_SAFELY(_resultList);
    [super dealloc];
}

-(id)init
{
    if (self = [super init]) {
        _pageNum = 1;
    }
    return self;
}

-(void)load:(TTURLRequestCachePolicy)cachePolicy more:(BOOL)more
{
    if (more) {
        _pageNum ++;
        _isLoadingMore = more;
    }
    HDRequestMap * map = [HDRequestMap mapWithDelegate:self];
    map.urlName = kDoneListQueryPath;
    map.urlParameters = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%i",_pageNum],@"pageNum", nil];
    
    [self requestWithMap:map];
}

-(void)requestResultMap:(HDRequestResultMap *)map
{
    if (0 < [[[map.result lastObject] allKeys]count]) { 
        //TODO:这里考虑不转化为对象
        NSArray * tempApproveList = [[[HDGodXMLFactory shareBeanFactory] beansWithArray:map.result path:@"/backend-config/field-mappings/field-mapping[@url_name='APPROVED_LIST_QUERY_URL']"]retain] ;
        
        if ([self isLoadingMore]) {
            NSMutableArray * moreArray = [_resultList mutableCopy];
            [moreArray addObjectsFromArray:tempApproveList];
            [tempApproveList release];
            TT_RELEASE_SAFELY(_resultList);
            _resultList = moreArray;
            _isLoadingMore = NO;
        }else {
            TT_RELEASE_SAFELY(_resultList);
            _resultList = tempApproveList;
        }
    }
}
@end
