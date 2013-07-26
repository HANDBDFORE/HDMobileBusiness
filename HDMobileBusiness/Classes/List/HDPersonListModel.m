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
@synthesize todoModel = _todoModel;

- (void)dealloc
{
    TT_RELEASE_SAFELY(_resultList);
    TT_RELEASE_SAFELY(_queryURL);
    TT_RELEASE_SAFELY(_todoModel);
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        _resultList = [[NSMutableArray alloc]init];
    }
    return self;
}

-(void)requestResultMap:(HDResponseMap *)map
{
    [_resultList addObjectsFromArray:[map.result valueForKey:@"list"]];
}

-(void)search:(NSString *)text
{
    [self cancel];
    [_resultList removeAllObjects];
    if (text.length) {
        HDRequestMap * map = [HDRequestMap mapWithDelegate:self];
        map.urlPath = self.queryURL;
        map.postData = @{ @"keyword" : text,@"sourceSystemName":[[_todoModel current]objectForKey:@"sourceSystemName"]};
        [self requestWithMap:map];
    } else {
        [_delegates perform:@selector(modelDidChange:) withObject:self];
    }
}

@end