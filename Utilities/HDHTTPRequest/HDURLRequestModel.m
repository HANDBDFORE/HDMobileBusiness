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
    NSError * error = nil;
    TTURLRequest * request =
    [[HDHTTPRequestCenter shareHTTPRequestCenter] requestWithRequestMap:map
                                                                  error:&error];
    if (!error && nil != request) {
        [request send];
    }else{
        [self didFailLoadWithError:error];
    }
}

-(void)requestDidFinishLoad:(TTURLRequest *)request
{

    
    NSError * error = nil;
    HDResponseMap * responseMap =
    [[HDHTTPRequestCenter shareHTTPRequestCenter] responseMapWithRequest:request
                                                                   error:&error];
    if (nil != error) {
        //根据错误状态判断是否走错误流程
//        if ([error.localizedFailureReason isEqualToString:@""]) {
//            
//        }
        [super request:request didFailLoadWithError:error];
    }
    
    if (!error && 0 <  [[responseMap.result allKeys]count]) {
        //只有成功返回才重置时间
        //每次网络请求 刷新timer开始计时
        [[HDApplicationContext shareContext] refreshTimer];
        
        [self requestResultMap:responseMap];
        [super requestDidFinishLoad:request];
    }
    if (!error && 0 == [[responseMap.result allKeys]count]) {
        [self emptyResponse:request];
    }
}

-(void)requestResultMap:(HDResponseMap *)map{}

-(void)emptyResponse:(TTURLRequest *)request
{
    [super requestDidFinishLoad:request];
}

@end
