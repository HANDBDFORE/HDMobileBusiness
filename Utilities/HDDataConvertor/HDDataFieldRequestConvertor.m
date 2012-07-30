//
//  HDDataFieldMapConvertor.m
//  Three20Lab-2
//
//  Created by Rocky Lee on 5/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDDataFieldRequestConvertor.h"

@implementation HDDataFieldRequestConvertor
@synthesize filedDictionary = _filedDictionary;

-(id)doConvertor:(id)data error:(NSError **)error
{
    //遵循键值编码协议的对象才转换
    if ([data isKindOfClass:[NSArray class]]) {
        NSMutableArray * resultArray = [NSMutableArray array];
        for (id record in data) {
            if ([data conformsToProtocol:@protocol(NSCoding)]) {
                id resultDictionary = [self convertToDictionary:record];
                if (nil != resultDictionary) {
                    [resultArray addObject:resultDictionary];
                }
            }
        }
        if ([data count] == [resultArray count]) {
            return [self doNextConvertor:resultArray error:error];
        }
    }
    if ([data conformsToProtocol:@protocol(NSCoding)]){
        id resultDictionary = [self convertToDictionary:data];
        if (nil != resultDictionary) {
            return [self doNextConvertor:resultDictionary error:error];
        }
    }
    
    ////
    return [self errorWithData:data error:error];
}

-(NSDictionary *)convertToDictionary:(id)record
{
   
    NSArray * keyArray =  [_filedDictionary allKeys];
    NSMutableDictionary * newDictionary = [NSMutableDictionary dictionary];
    for (NSString * key  in keyArray) {
        //从map中获取映射的key
        NSString * mapKey = [_filedDictionary valueForKey:key];
        //设置key为映射后的key
        if (nil != mapKey) {
            [newDictionary setValue:[record valueForKeyPath:key] forKey:mapKey];
        }else {
            TTDPRINT(@"can't convert key for %@,make sure you set the mapping correct",key);
        }
    }
    return newDictionary;
}

-(id)errorWithData:(id)data error:(NSError **)error
{
    if (error && !*error) {
        NSString * description = @"Data Filed Convertor 未知错误";
        if (![data conformsToProtocol:@protocol(NSCoding)]) {
            description = @"对象不遵循键值编程协议";
        }
        if ([data isKindOfClass:[NSArray class]]) {
            if (![[data lastObject] conformsToProtocol:@protocol(NSCoding)]){
                description = @"对象不遵循键值编程协议";
            }
        }
        *error = [NSError errorWithDomain:kHDConvertErrorDomain
                                     code:kHDConvertErrorCode
                                 userInfo:[NSDictionary dictionaryWithObject:description forKey:@"NSLocalizedDescription"]];
    } 
    return nil; 
}
@end
