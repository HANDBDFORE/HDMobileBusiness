//
//  HDSingltonObject.m
//  HDMobileBusiness
//
//  Created by Plato on 8/24/12.
//  Copyright (c) 2012 hand. All rights reserved.
//

#import "HDSingltonObject.h"

@implementation HDSingltonObject

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain
{
    return self;
}

-(unsigned)retainCount
{
    return UINT_MAX;  //denotes an object that cannot be released
}

- (id)autorelease
{
    return self;
}

-(oneway void)release
{
    
}

@end
