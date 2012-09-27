//
//  HDContainerConfigObject.m
//  HDMobileBusiness
//
//  Created by Plato on 9/27/12.
//  Copyright (c) 2012 hand. All rights reserved.
//

#import "HDContainerConfigObject.h"

@implementation HDContainerConfigObject

-(NSDictionary *)configPropertyDictionaryWithChildren:(NSArray *)children
{
    NSMutableDictionary * propertyDictionary = [NSMutableDictionary dictionary];
    for (id<HDConfig> childConfig in children) {
        NSDictionary * childProperties = [childConfig createPropertyDictionary];
        if ([self shouldAddKey]) {
            for (NSString * childPropertyKey in [childProperties allKeys]) {
                id value = [childProperties valueForKey:childPropertyKey];
                [propertyDictionary setValue:value
                                      forKey:[self.propertyKey stringByAppendingFormat:@".%@",childPropertyKey]];
            }
        }else{
            [propertyDictionary addEntriesFromDictionary:childProperties];
        }
    }
    return propertyDictionary;
}

-(BOOL)shouldAddKey
{
    return !!self.propertyKey;
}

@end
