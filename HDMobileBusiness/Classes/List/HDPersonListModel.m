//
//  HDPersonPickModel.m
//  HDMobileBusiness
//
//  Created by Plato on 9/11/12.
//  Copyright (c) 2012 hand. All rights reserved.
//

#import "HDPersonListModel.h"

@implementation HDPersonListModel

@synthesize resultList = _resultList;
@synthesize queryURL = _queryURL;

- (void)dealloc
{
    TT_RELEASE_SAFELY(_resultList);
    TT_RELEASE_SAFELY(_queryURL);
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        _resultList = [[NSMutableArray alloc]init];
//        self.queryURL = [NSString stringWithFormat:@"%@autocrud/ios.ios_deliver.ios_wprkflow_deliver_query/query",[[HDHTTPRequestCenter sharedURLCenter]baseURLPath]];
    }
    return self;
}

-(void)requestResultMap:(HDResponseMap *)map
{
    [_resultList addObjectsFromArray:map.result];
}

-(void)search:(NSString *)text
{
    [self cancel];
    [_resultList removeAllObjects];
    if (text.length) {
        HDRequestMap * map = [HDRequestMap mapWithDelegate:self];
        map.urlPath = self.queryURL;
        map.postData = @{ @"parameter" : text};
        [self requestWithMap:map];
    } else {
        [_delegates perform:@selector(modelDidChange:) withObject:self];
    }
}

@end