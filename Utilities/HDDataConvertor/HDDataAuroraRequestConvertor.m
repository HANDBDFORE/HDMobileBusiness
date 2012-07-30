//
//  HDAuroraDataParser.m
//  Three20Lab
//
//  Created by Rocky Lee on 5/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDDataAuroraRequestConvertor.h"

//请求过滤
@implementation HDDataAuroraRequestConvertor

-(id)doConvertor:(id)data error:(NSError **)error
{
    if ([data isKindOfClass:[NSDictionary class]]||
        [data isKindOfClass:[NSArray class]]) 
    {
        //包装到parameter中
        id parameterData = 
        [NSDictionary dictionaryWithObject:(data == nil ? @"": data) 
                                    forKey:@"parameter"];
        
        return [self doNextConvertor:parameterData error:error];
    }
    
    return [self errorWithData:data error:error];   
}

-(id)afterDoNextConvertor:(id)data error:(NSError **)error
{
    if ([data isKindOfClass:[NSData class]]) {
        return [[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    }
    return [self errorWithData:nil error:error];
}

@end



