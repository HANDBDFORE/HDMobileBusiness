//
//  HDRequestDelegateMap.m
//  hrms
//
//  Created by Rocky Lee on 4/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDRequestMap.h"

@implementation HDRequestMap

@synthesize urlName = _urlName;
@synthesize requestPath = _requestPath;
@synthesize urlParameters = _urlParameters;
@synthesize postData = _postData;
//@synthesize postBean = _postBean;
//@synthesize tag = _tag;
@synthesize delegates = _delegates;

@synthesize httpMethod = _httpMethod;
@synthesize multiPartForm = _multiPartForm;
@synthesize cachePolicy = _cachePolicy;
@synthesize response = _response;
@synthesize userInfo = _userInfo;

-(void)dealloc
{
    TT_RELEASE_SAFELY(_requestPath);
    TT_RELEASE_SAFELY(_urlName);
    TT_RELEASE_SAFELY(_urlParameters);
    TT_RELEASE_SAFELY(_postData);
//    TT_RELEASE_SAFELY(_postBean);
    TT_RELEASE_SAFELY(_delegates);
    TT_RELEASE_SAFELY(_httpMethod);
    TT_RELEASE_SAFELY(_response);
    TT_RELEASE_SAFELY(_userInfo);
    [super dealloc];
}

+(id)map
{
    return [[[HDRequestMap alloc]init] autorelease];
}

+(id)mapWithDelegate:(id) delegate
{
    return [[[HDRequestMap alloc]initWithDelegate:delegate]autorelease];
}

-(id)init
{
    if (self = [super init]) {
        _delegates = TTCreateNonRetainingArray();
        _httpMethod = @"POST";
        _multiPartForm = NO;
        _response = [[TTURLDataResponse alloc]init];
        _userInfo = [[NSMutableDictionary alloc]init];
        _postData = [[NSDictionary alloc]init];
    }
    return self;
}

-(id)initWithDelegate:(id) delegate
{
    if (self = [self init]) {
        [_delegates addObject:delegate];
    }
    return self;
}

-(void)setUrlName:(NSString *)urlName
{
    if (nil != _urlName) {
        [_urlName release];
        _urlName = nil;
    }
    _urlName = [urlName retain];
    [self.userInfo setObject:urlName forKey:@"urlName"];
}
@end

//@implementation HDRequestResultMap
//
//@synthesize result = _result;
//@synthesize urlPath = _urlPath;
////@synthesize tag = _tag;
//@synthesize userInfo = _userInfo;
//@synthesize error = _error;
//
//-(void)dealloc
//{
//    TT_RELEASE_SAFELY(_result);
//    TT_RELEASE_SAFELY(_urlPath);
//    TT_RELEASE_SAFELY(_userInfo);
//    TT_RELEASE_SAFELY(_error);
//    [super dealloc];
//}
//
//+(id)map
//{
//      return [[[HDRequestResultMap alloc]init]autorelease];
//}

//@end
