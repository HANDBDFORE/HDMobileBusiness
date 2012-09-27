//
//  HDDictionaryConfigObject.m
//  HDMobileBusiness
//
//  Created by Plato on 9/27/12.
//  Copyright (c) 2012 hand. All rights reserved.
//

#import "HDDictionaryConfigObject.h"

@implementation HDDictionaryConfigObject

-(NSDictionary *)configPropertyDictionaryWithChildren:(NSArray *)children
{
    NSMutableDictionary * propertyDictionary = [NSMutableDictionary dictionary];
    for (id<HDConfig> childConfig in children) {
        [propertyDictionary addEntriesFromDictionary:[childConfig createPropertyDictionary]];
    }
    return @{self.propertyKey : propertyDictionary};
}

@end
