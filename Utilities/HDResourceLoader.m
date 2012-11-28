//
//  HDResourceLoader.m
//  Three20GitCoreDataLab
//
//  Created by Rocky Lee on 6/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDResourceLoader.h"
#import "HDImageLoader.h"

@interface HDResourceLoader()

@property(nonatomic,readonly) TTURLRequestQueue * queue;

@end

@implementation HDResourceLoader
@synthesize queue = _queue;

-(void)dealloc
{
    TT_RELEASE_SAFELY(_queue);
    [super dealloc];
}

-(id)init
{
    if (self = [super init]) {
        _queue = [[TTURLRequestQueue alloc]init];
        _queue.maxContentLength = 0;
    }
    return self;
}

-(UIImage *)imageWithIdentifier:(NSString *) identifier
{
    HDImageLoader * loader = [[HDApplicationContext shareContext]objectForIdentifier:identifier];
    return  [loader image];
}

+(id)shareLoader
{
    return [self shareObject];
}

#pragma -mark load resource
-(void)loadResource:(NSDictionary *) resourceDictionary
{
    NSString * resourceURL = [[resourceDictionary valueForKey:kResourceURL] stringByReplacingSpaceHodlerWithDictionary:@{@"base_url":[HDHTTPRequestCenter baseURLPath]}] ;

    TTURLRequest * request = [TTURLRequest requestWithURL:resourceURL delegate:self];
    request.response = [[[TTURLDataResponse alloc]init] autorelease];
    request.cachePolicy = TTURLRequestCachePolicyDefault;
    request.userInfo = resourceDictionary;
    request.httpMethod = @"GET";
    [_queue sendRequest:request];

}

-(void)stopLoad
{
//    [_queue cancelAllRequests];
}

#pragma -mark request delegate
-(void)requestDidFinishLoad:(TTURLRequest *)request
{
//    if(!request.respondedFromCache){
        TTURLDataResponse * response =  request.response;
        NSDictionary * map = request.userInfo;
        [response.data writeToFile:TTPathForDocumentsResource([map valueForKey:kResourceName]) atomically:YES];
//    }
}

-(void)request:(TTURLRequest *)request didFailLoadWithError:(NSError *)error
{
    NSDictionary * map = request.userInfo;
    [[NSFileManager defaultManager]removeItemAtPath:TTPathForDocumentsResource([map valueForKey:kResourceName]) error:nil];
}
@end
