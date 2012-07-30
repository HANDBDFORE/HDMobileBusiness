//
//  HDHTTPRequestCenter.m
//  hrms
//
//  Created by Rocky Lee on 4/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDHTTPRequestCenter.h"
#import "HDDataConvertor.h"

@implementation HDHTTPRequestCenter

static HDHTTPRequestCenter * _requestCenter = nil;

@synthesize lastRequestTime = _lastRequestTime;
@synthesize LoginTimes = _LoginTimes;

@synthesize isTimeOut = _isTimeOut;

+(id)shareHTTPRequestCenter
{
    @synchronized(self){
        if (_requestCenter == nil) {
            _requestCenter = [[self alloc] init];
        }
    }
    return  _requestCenter;
}

+(id) allocWithZone:(NSZone *)zone{
    @synchronized(self){
        if (_requestCenter == nil) {
            _requestCenter = [super allocWithZone:zone];
            return  _requestCenter;
        }
    }
    return nil;
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain
{
    return self;
}

-(id)init
{
    self = [super init];
    if (self) {
        _lastRequestTime =[[NSDate dateWithTimeIntervalSinceNow:0] retain];
        _LoginTimes = 0;
        _isTimeOut = NO;
        [[TTURLRequestQueue mainQueue]setMaxContentLength:0];
    }
    return self;
}

-(unsigned)retainCount
{
    return UINT_MAX;  //denotes an object that cannot be released
}

- (id)autorelease
{
    return self;
}

-(void)dealloc
{
    TT_RELEASE_SAFELY(_lastRequestTime);
    [super dealloc];
}

#pragma -mark create request use ttRequest

-(NSError *)requestWithRequestMap:(HDRequestMap *)map
{
    //setting url
    NSString * urlPath = nil;
    if (!map.urlName) {
        urlPath =  map.requestPath;
    }else {
        urlPath = [HDURLCenter requestURLWithKey:map.urlName 
                                           query:map.urlParameters];
    }
    //setting post data
    NSError * error = nil;
    //    id<HDDataConvertor> convertor = 
    //    [HDDataConvertorCenter convertorChainWithURLName:map.urlName 
    //                                         type:HDDataRequestConvertor];
    //    HDDataAuroraRequestConvertor 
    
    HDJSONToDataConvertor * convert = [[[HDJSONToDataConvertor alloc]init] autorelease];
    id<HDDataConvertor> convertor = [[[HDDataAuroraRequestConvertor alloc]initWithNextConvertor:convert] autorelease];
    
    id postParameter = [convertor doConvertor:map.postData error:&error];
    
    
    if (nil != error) {
        return error;
    }else {
        //ask god
        TTURLRequest * request = [TTURLRequest request];
        //
        request.urlPath = urlPath;
        [request.parameters setObject:postParameter forKey:@"_request_data"];
        request.cachePolicy = map.cachePolicy;
        request.httpMethod = map.httpMethod;
        request.multiPartForm = map.multiPartForm;
        request.response = map.response;
        request.userInfo = map.userInfo;
        for (id delegate in map.delegates) {
            [request.delegates addObject:delegate];
        }
        [request send];
    }  
    return nil;
}

+(HDRequestResultMap *)resultMapWithRequest:(id)request
{
    //根据传入的request解析数据,返回结果
    if ([request isKindOfClass:[TTURLRequest class]]) {
        TTURLRequest * theRequest = request;
        TTURLDataResponse * response = theRequest.response;
        
        // get filter 
        id<HDDataConvertor> convertor = 
        [HDDataConvertorCenter convertorChainWithURLName:[theRequest.userInfo valueForKeyPath:@"urlName"] 
                                                    type:HDDataResponseConvertor];
        NSError * convertorError = nil;
        id result = [convertor doConvertor:response.data error:&convertorError];
        
        //setting result map
        HDRequestResultMap * resultMap = [HDRequestResultMap map];
        resultMap.userInfo = theRequest.userInfo;
        resultMap.urlPath = theRequest.urlPath;
        resultMap.error = convertorError;
        resultMap.result = result;
        
        return resultMap;
    }
    return nil;
}

@end
