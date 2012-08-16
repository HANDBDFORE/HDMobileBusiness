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
#import "HDResponseMap.h"

#import "HDURLCenter.h"

@interface HDHTTPRequestCenter : NSObject

@property(nonatomic,readonly) HDURLCenter * urlCenter;

+(id)shareHTTPRequestCenter;

+(id)sharedURLCenter;

//根据map创建request对象
-(TTURLRequest *)requestWithRequestMap:(HDRequestMap *) map
                     error:(NSError **) error;

//根据reuqest对象,创建相应map
-(HDResponseMap *)responseMapWithRequest:(TTURLRequest *)request
                     error:(NSError **) error;

@end
