//
//  HDURLRequestModel.m
//  Three20Lab-2
//
//  Created by Rocky Lee on 5/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDURLRequestModel.h"
#import "HDHTTPRequestCenter.h"

@implementation HDURLRequestModel

-(void)requestWithMap:(HDRequestMap *) map
{
    NSError * error = [[HDHTTPRequestCenter shareHTTPRequestCenter] requestWithRequestMap:map];

    if (nil != error) {
        [self didFailLoadWithError:error];
    }
}

-(void)requestDidFinishLoad:(TTURLRequest *)request
{
    HDRequestResultMap * resultMap = [HDHTTPRequestCenter resultMapWithRequest:request];
    if (!resultMap.result) {
        [super request:request didFailLoadWithError:resultMap.error];
    }else {
        [self requestResultMap:resultMap];
        [super requestDidFinishLoad:request];          
    }
}

-(void)requestResultMap:(HDRequestResultMap *)map
{
}

@end
