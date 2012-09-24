//
//  HDSingltonObject.m
//  HDMobileBusiness
//
//  Created by Plato on 8/24/12.
//  Copyright (c) 2012 hand. All rights reserved.
//

#import "HDSingletonObject.h"

static NSMutableDictionary * _gSingletonMap;

@implementation HDSingletonObject

+(id)shareObject
{
    if (_gSingletonMap == nil) {
        _gSingletonMap =[[NSMutableDictionary alloc]init];
    }
    
    NSString * className = [NSString stringWithUTF8String:object_getClassName(self)];
    @synchronized(self){
        if ([_gSingletonMap valueForKey:className] == nil)
        {
            //
            id object = [[NSAllocateObject([super class], 0, NULL) init] autorelease];
            [_gSingletonMap setObject:object forKey:className];
        }
    }
    return  [_gSingletonMap valueForKey:className];
}

+(id) allocWithZone:(NSZone *)zone{
    @synchronized(self){
        NSString * className = [NSString stringWithUTF8String:object_getClassName(self)];
        if ([_gSingletonMap valueForKey:className] == nil) {
            id object = [super allocWithZone:zone];
            [_gSingletonMap setValue:object forKey:className];
            return  object;
        }
    }
    
    return nil;
}

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
