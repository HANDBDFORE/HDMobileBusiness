//
//  HDHTTPRequestCenter.h
//  hrms
//
//  Created by Rocky Lee on 4/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
/*
 *http 请求中心:
 *所有的http请求代理到这里请求,解决请求创建和delegate为不同对象的问题
 *
 */

#import "HDRequestMap.h"
#import "HDRequestGetMap.h"
#import "HDURLCenter.h"

@interface HDHTTPRequestCenter : NSObject

//最后一次请求时间
@property (nonatomic,readonly) NSDate * lastRequestTime;
@property (nonatomic,readonly) NSUInteger LoginTimes;
@property (nonatomic,readonly) BOOL isTimeOut;

+(id)shareHTTPRequestCenter;

-(NSError *)requestWithRequestMap:(HDRequestMap *)map;

+(HDRequestResultMap *)resultMapWithRequest:(id) request;

@end
