//
//  HDDataFieldMapConvertor.m
//  HDMobileBusiness
//
//  Created by Rocky Lee on 5/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDFieldMapConvertor.h"

@implementation HDFieldMapConvertor
@synthesize fieldMapData = _fieldMapData;

-(id)convert:(id)data error:(NSError **)error
{
    if ([data isKindOfClass:[NSArray class]]) {
        NSMutableArray * resultArray = [NSMutableArray array];
        for (id record in data) {
            [resultArray addObject:[self mapping:record]];
        }
        return resultArray;
    }
    if ([data isKindOfClass:[NSDictionary class]]) {
        return [self mapping:data];
    }
    return data;
}

-(NSDictionary *)mapping:(NSDictionary *)mappingData
{
    NSMutableDictionary * mapDictionary = [NSMutableDictionary dictionary];
    
    NSArray * keys = [mappingData allKeys];
    for (NSString * key in keys) {
        if (nil != [self findKeyForMapTo:key]) {
            [mapDictionary setValue:[mappingData valueForKey:key]
                             forKey:[self findKeyForMapTo:key]];
        }else{
            [mapDictionary setValue:[mappingData valueForKey:key]
                             forKey:key];
        }
    }
//        if ([_fieldMapData valueForKey:key]) {
//            [mapDictionary setValue:[mappingData valueForKey:key] forKey:[_fieldMapData valueForKey:key]];
//        }else{
//            [mapDictionary setValue:[mappingData valueForKey:key] forKey:key];
//        }
//    }
    return mapDictionary;
}

-(NSString *) findKeyForMapTo:(NSString *) mapFromKey
{
    for (NSDictionary * mapRecord in _fieldMapData) {
        if ([[mapRecord valueForKey:kMapFrom] isEqualToString:mapFromKey]) {
            return [mapRecord valueForKey:kMapTo];
        }
    }
    return nil;
}

@end
