//
//  HDRequestDelegateMap.m
//  hrms
//
//  Created by Rocky Lee on 4/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDRequestMap.h"

@implementation HDRequestMap

@synthesize urlPath = _urlPath;
@synthesize contentType = _contentType;
@synthesize postData = _postData;
@synthesize httpBody = _httpBody;
@synthesize delegates = _delegates;
@synthesize httpMethod = _httpMethod;
@synthesize multiPartForm = _multiPartForm;
@synthesize cachePolicy = _cachePolicy;
@synthesize response = _response;
@synthesize userInfo = _userInfo;

-(void)dealloc
{
    TT_RELEASE_SAFELY(_urlPath);
    TT_RELEASE_SAFELY(_contentType);
    TT_RELEASE_SAFELY(_postData);
    TT_RELEASE_SAFELY(_delegates);
    TT_RELEASE_SAFELY(_httpMethod);
    TT_RELEASE_SAFELY(_response);
    TT_RELEASE_SAFELY(_userInfo);
    TT_RELEASE_SAFELY(_httpBody);
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

-(void)setUrlPath:(NSString *)urlPath
{
    if (_urlPath != urlPath) {
        TT_RELEASE_SAFELY(_urlPath);
    }
    _urlPath = [urlPath retain];
    [self.userInfo setValue:urlPath forKey:@"urlPath"];
}

@end

