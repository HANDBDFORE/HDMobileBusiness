//
//  HDCoreStorage.m
//  HDMobileBusiness
//
//  Created by Plato on 8/7/12.
//  Copyright (c) 2012 hand. All rights reserved.
//

#import "HDCoreStorage.h"

static HDCoreStorage * globalStorage = nil;

@implementation HDCoreStorage

+(id)shareStorage
{
    if (nil == globalStorage) {
        globalStorage = [[self alloc]init];
    }
    return globalStorage;
}

-(id)query:(id) conditions
{
    return nil;
}

-(BOOL)insert:(id) data
{}

-(BOOL)update:(id) data
{}

-(BOOL)remove:(id) data
{}

-(void)sync:(id)data
{}

@end
