//
//  HDArrayConfigObject.m
//  HDMobileBusiness
//
//  Created by Plato on 9/27/12.
//  Copyright (c) 2012 hand. All rights reserved.
//

#import "HDArrayConfigObject.h"

@implementation HDArrayConfigObject

-(NSDictionary *)configPropertyDictionaryWithChildren:(NSArray *)children
{
    NSMutableArray * propertyArray = [NSMutableArray array];
    for (id<HDConfig> childConfig in children) {
        [propertyArray addObjectsFromArray:[[childConfig createPropertyDictionary] allValues]];
    }
    return @{self.propertyKey : propertyArray};
}
@end
