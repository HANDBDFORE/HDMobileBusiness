//
//  HDGuideSegment.m
//  HDMobileBusiness
//
//  Created by Plato on 11/12/12.
//  Copyright (c) 2012 hand. All rights reserved.
//

#import "HDGuideSegment.h"

@implementation HDGuideSegment
@synthesize keyPath = _keyPath;
@synthesize invoker = _invoker;
@synthesize query = _query;
@synthesize animated = _animated;

- (void)dealloc
{
    TT_RELEASE_SAFELY(_keyPath);
    TT_RELEASE_SAFELY(_invoker);
    TT_RELEASE_SAFELY(_query);
    [super dealloc];
}

+(id)segmentWithKeyPath:(NSString *)keyPath
{
    return [[[self alloc]initWithKeyPath:keyPath]autorelease];
}

- (id)init
{
    self = [super init];
    if (self) {
        self.animated = NO;
    }
    return self;
}

-(id)initWithKeyPath:(NSString *)keyPath
{
    if(self = [self init])
    {
        self.keyPath = keyPath;
    }
    return self;
}

@end
