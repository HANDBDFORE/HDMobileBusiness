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
@synthesize urlCenter = _urlCenter;

- (void)dealloc
{
    TT_RELEASE_CF_SAFELY(_urlCenter);
    [super dealloc];
}

+(id)shareHTTPRequestCenter
{
    return [self shareObject];
}

-(id)init
{
    self = [super init];
    if (self) {
        _urlCenter = [[HDURLCenter alloc]init];
        [[TTURLRequestQueue mainQueue]setMaxContentLength:0];
    }
    return self;
}

+(id) sharedURLCenter
{
    return [[HDHTTPRequestCenter shareHTTPRequestCenter] urlCenter];
}

#pragma -mark create request use ttRequest
-(TTURLRequest *)requestWithRequestMap:(HDRequestMap *) map
                                 error:(NSError **) error
{
    //setting url
    if (!map.urlPath) {
        return nil;
    }
    
    //setting post data
    id<HDDataConvertor> convertor =
    [[[HDAuroraRequestConvertor alloc]initWithNextConvertor:
      [[[HDJSONToDataConvertor alloc]initWithNextConvertor:
        [[[HDDataToStringConvertor alloc]init]autorelease]
        ]autorelease]
      ]autorelease];
    
    id postParameter = [convertor doConvertor:map.postData error:error];
    
    if (nil == *(error)) {
        //create request
        TTURLRequest * request = [TTURLRequest request];
        request.urlPath = map.urlPath;
        [request.parameters setObject:postParameter forKey:@"_request_data"];
        request.cachePolicy = map.cachePolicy;
        request.httpMethod = map.httpMethod;
        request.multiPartForm = map.multiPartForm;
        request.response = map.response;
        request.userInfo = map.userInfo;
        for (id delegate in map.delegates) {
            [request.delegates addObject:delegate];
        }
        return request;
    }
    return nil;
}

-(HDResponseMap *)responseMapWithRequest:(TTURLRequest *)request
                                   error:(NSError **) error
{
    TTURLDataResponse * response = request.response;
    
    // get convertor
    id<HDDataConvertor> convertor =
    [[[HDDataToJSONConvertor alloc]initWithNextConvertor:
      [[[HDAuroraResponseConvertor alloc]init]autorelease]
      ]autorelease];
    
    id result = [convertor doConvertor:response.data error:error];
    
    HDResponseMap * responseMap = [HDResponseMap map];
    responseMap.userInfo = request.userInfo;
    responseMap.urlPath = request.urlPath;
    responseMap.error = *(error);
    responseMap.result = result;
    
    return responseMap;
}

@end
