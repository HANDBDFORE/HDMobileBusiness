//
//  HDResponseMap.m
//  HDMobileBusiness
//
//  Created by Plato on 8/15/12.
//  Copyright (c) 2012 hand. All rights reserved.
//

#import "HDResponseMap.h"

@implementation HDResponseMap

@synthesize result = _result;
@synthesize urlPath = _urlPath;
@synthesize userInfo = _userInfo;
@synthesize error = _error;

-(void)dealloc
{
    TT_RELEASE_SAFELY(_result);
    TT_RELEASE_SAFELY(_urlPath);
    TT_RELEASE_SAFELY(_userInfo);
    TT_RELEASE_SAFELY(_error);
    [super dealloc];
}

+(id)map
{
    return [[[HDResponseMap alloc]init]autorelease];
}

@end
