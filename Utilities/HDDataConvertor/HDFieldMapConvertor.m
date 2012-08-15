//
//  HDDataFieldMapConvertor.m
//  HDMobileBusiness
//
//  Created by Rocky Lee on 5/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDFieldMapConvertor.h"

@implementation HDFieldMapConvertor
@synthesize fieldMap = _fieldMap;

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
    //solution 1:要求强制输入所有mapping字段,没有mapping的字段将被遗弃
//    NSArray * keys =  [_fieldMap allKeys];
//    NSArray * objects = [mappingData objectsForKeys:keys notFoundMarker:@""];
//    NSDictionary * result = [NSDictionary dictionaryWithObjects:objects forKeys:[_fieldMap allValues]];
//    return result;
    
    //solution 2:允许只配置部分字段,没有mapping的字段将不进行map,仍然保留原有的key
    NSMutableDictionary * mapDictionary = [NSMutableDictionary dictionary];
    NSArray * keys = [mappingData allKeys];
    for (NSString * key in keys) {
        if ([_fieldMap valueForKey:key]) {
            [mapDictionary setValue:[mappingData valueForKey:key] forKey:[_fieldMap valueForKey:key]];
        }else{
            [mapDictionary setValue:[mappingData valueForKey:key] forKey:key];
        }
    }
    return mapDictionary;
}

@end
