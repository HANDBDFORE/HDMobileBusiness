//
//  HDDataBaseConvertor.m
//  HDMobileBusiness
//
//  Created by Rocky Lee on 5/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDBaseConvertor.h"

@implementation HDBaseConvertor

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
    if ([self validateData:data]) {
        id object = [self convert:data error:error];
        return [self doNextConvertor:object error:error];
    }
    if (error && !*error) {
        *error = [self errorWithData:data];
    }
    return nil;
}

-(BOOL)validateData:(id) data
{
    return YES;
}

-(id)convert:(id)data error:(NSError **) error
{
    return data;
}

-(id)doNextConvertor:(id)data error:(NSError **)error
{
    if (self.nextConvertor) {
        return [self.nextConvertor doConvertor:data error:error];
    }else {
        return data;
    }  
}

-(NSError *)errorWithData:(id) data
{
        return [NSError errorWithDomain:kHDConvertErrorDomain
                                     code:kHDConvertErrorCode
                                 userInfo:[NSDictionary dictionaryWithObject:kHDDefaultErrorMessage forKey:NSLocalizedDescriptionKey]];
    
}
@end
