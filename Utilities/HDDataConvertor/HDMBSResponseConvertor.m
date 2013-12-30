//
//  HDMBSResponseConvertor.m
//  HDMobileBusiness
//
//  Created by 马豪杰 on 13-6-28.
//  Copyright (c) 2013年 hand. All rights reserved.
//

#import "HDMBSResponseConvertor.h"

@implementation HDMBSResponseConvertor

-(BOOL)validateData:(id)data
{
    if ([data isKindOfClass:[NSDictionary class]]) {
        if ([data valueForKeyPath:@"success"] != nil) {
            return NO;
        }
        return YES;
    }
    return  NO;
}

-(id)convert:(id)data error:(NSError **)error
{
    NSString * responseCode = [data valueForKeyPath:@"head.code"];
    if ([[responseCode lowercaseString] isEqualToString:@"ok"]) {
        if ([[data valueForKeyPath:@"body"] isKindOfClass:[NSDictionary class]]) {
            if([(NSDictionary *)[data valueForKeyPath:@"body"] count] >0){
                return[NSDictionary dictionaryWithDictionary:[data valueForKeyPath:@"body"]];
            }else{
                return nil;
            }
        }
    }
    *error = [NSError errorWithDomain:kHDConvertErrorDomain
                               code:kHDConvertErrorCode
                           userInfo:[NSDictionary dictionaryWithObject:[data valueForKeyPath:@"head.message"] forKey:NSLocalizedDescriptionKey]];
    return nil;
}

@end
