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

- (void)dealloc
{
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
        [[TTURLRequestQueue mainQueue]setMaxContentLength:0];
    }
    return self;
}

+(NSString*)baseURLPath
{
    NSString * basePath = [[NSUserDefaults standardUserDefaults]stringForKey:@"base_url_preference"];
    
    basePath = [basePath stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([basePath isEqualToString:@""]) {
        return basePath;
    }
    if (![basePath hasSuffix:@"/"]) {
        basePath = [basePath stringByAppendingString:@"/"];
    }
    if (![basePath hasPrefix:@"http://"]) {
        basePath = [@"http://" stringByAppendingString:basePath];
    }
    basePath = [basePath stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    [[NSUserDefaults standardUserDefaults]setValue:basePath
                                            forKey:@"base_url_preference"];
    return basePath;
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
        request.shouldHandleCookies=YES;
        request.urlPath = [map.urlPath stringByReplacingSpaceHodlerWithDictionary:@{@"base_url" : [HDHTTPRequestCenter baseURLPath]}];
        [request.parameters setObject:postParameter forKey:@"_request_data"];
        request.cachePolicy = map.cachePolicy;
        request.httpMethod = map.httpMethod;
        request.multiPartForm = map.multiPartForm;
        request.response = map.response;
        request.userInfo = map.userInfo;
        for (id delegate in map.delegates) {
            [request.delegates addObject:delegate];
        }
        NSLog(@"=============request=============");
        NSLog(@"URL:%@",[request urlPath]);
        NSLog(@"DATA:%@",[[NSString alloc] initWithData:[request httpBody] encoding:NSUTF8StringEncoding]);
        NSLog(@"=============-------=============");
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
      [[[HDMBSResponseConvertor alloc]init]autorelease]
      ]autorelease];
    NSLog(@"=============response=============");
    NSLog(@"DATA:%@",[[NSString alloc] initWithData:response.data encoding:NSUTF8StringEncoding]);
    NSLog(@"=============-------=============");
    NSDictionary * result = [convertor doConvertor:response.data error:error];
    
    HDResponseMap * responseMap = [HDResponseMap map];
    responseMap.userInfo = request.userInfo;
    responseMap.urlPath = request.urlPath;
    responseMap.error = *(error);
    responseMap.result = result;
    
    return responseMap;
}

@end
