//
//  HDDataParser.m
//  Three20Lab
//
//  Created by Rocky Lee on 5/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDDataBaseConvertor.h"

@implementation HDDataBaseConvertor

@synthesize nextConvertor = _nextConvertor;

-(id)initWithNextConvertor:(id<HDDataConvertor>) next
{
    if ([self init]) {
        self.nextConvertor = next;
    }
    return self;
}

-(void)dealloc
{
    TT_RELEASE_SAFELY(_nextConvertor);
    [super dealloc];
}

-(id)doConvertor:(id)data error:(NSError **)error
{
    if (nil != data) {
        return [self doNextConvertor:data error:error];
    }
    return [self errorWithData:data error:error];
}

-(id)doNextConvertor:(id)data error:(NSError **)error
{
    //子类实现其转换过滤,然后调用父类方法
    id nextResult = nil;
    if (self.nextConvertor) {
        nextResult = [self.nextConvertor doConvertor:data error:error];
    }else {
        nextResult = data;
    }
    if (nil != nextResult) {
        nextResult = [self afterDoNextConvertor:(id)nextResult error:(NSError **)error];
    }
    if (nil != nextResult) {
        return nextResult;
    }
    [self errorWithData:data error:error];
    return nil;
}

-(id)afterDoNextConvertor:(id)data error:(NSError **)error
{
    return data;
}

-(id)errorWithData:(id) data error:(NSError **)error
{
    if (error && !*error) {
        *error = [NSError errorWithDomain:kHDConvertErrorDomain
                                     code:kHDConvertErrorCode
                                 userInfo:[NSDictionary dictionaryWithObject:@"data filter error" forKey:@"NSLocalizedDescription"]];
    } 
    return nil; 
}
@end
