//
//  HDAuroraResponseConvertor.m
//  HDMobileBusiness
//
//  Created by Rocky Lee on 5/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDAuroraResponseConvertor.h"

@implementation HDAuroraResponseConvertor

-(BOOL)validateData:(id)data
{
    if ([data isKindOfClass:[NSDictionary class]]) {
        return [[data valueForKeyPath:@"success"] boolValue];
    }
    return  NO;
}

-(id)convert:(id)data error:(NSError **)error
{
    id result = [data valueForKeyPath:@"result.record"];
    
    if (nil != result && ![result isKindOfClass:[NSArray class]]) {
        return [NSArray arrayWithObject:result];
    }else{
        return result;
    }
}

-(NSError *)errorWithData:(id) data
{
    NSString *errorMessage = nil;
    if ([data isKindOfClass:[NSDictionary class]]) {
        errorMessage = [data valueForKeyPath:@"error.message"];
    }else{
        errorMessage = @"data is not dictionary";
    }
    
    return [NSError errorWithDomain:kHDConvertErrorDomain
                               code:kHDConvertErrorCode
                           userInfo:[NSDictionary dictionaryWithObject:errorMessage forKey:NSLocalizedDescriptionKey]];
    
}
@end

