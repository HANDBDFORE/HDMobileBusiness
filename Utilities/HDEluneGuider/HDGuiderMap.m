//
//  HDViewControllerMap.m
//  Three20GitCoreDataLab
//
//  Created by Rocky Lee on 6/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDGuiderMap.h"

@implementation HDGuiderMap

@synthesize urlPath = _urlPath;
@synthesize propertyMap = _query;

-(void)dealloc
{
    TT_RELEASE_SAFELY(_urlPath);
    TT_RELEASE_SAFELY(_query);
    [super dealloc];
}

@end
