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
        NSString * responseCode = [data valueForKeyPath:@"head.code"];
        if ([[responseCode lowercaseString] isEqualToString:@"ok"]) {
            return YES;
        }
    }
    return  NO;
}

-(id)convert:(id)data error:(NSError **)error
{
    
    if ([[data valueForKeyPath:@"body"] isKindOfClass:[NSDictionary class]]) {
        return[NSDictionary dictionaryWithDictionary:[data valueForKeyPath:@"body"]];
    }
    return nil;
}

@end
