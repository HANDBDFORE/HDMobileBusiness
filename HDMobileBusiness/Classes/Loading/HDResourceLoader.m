//
//  SFResourceLoader.m
//  Three20GitCoreDataLab
//
//  Created by Rocky Lee on 6/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDResourceLoader.h"

static HDResourceLoader * _globalLoader = nil;

@interface HDResourceLoader()

@property(nonatomic,readonly) TTURLRequestQueue * queue;

@end

@implementation HDResourceLoader
@synthesize resourceList = _resourceList;
@synthesize queue = _queue;

-(void)dealloc
{
    TT_RELEASE_SAFELY(_resourceList);
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

#pragma -mark sigleton functions

+(id)shareLoader
{
    @synchronized(self){
        if (_globalLoader == nil) {
            _globalLoader = [[self alloc] init];
        }
    }
    return  _globalLoader;
}

+(id)allocWithZone:(NSZone *)zone{
    @synchronized(self){
        if (_globalLoader == nil) {
            _globalLoader = [super allocWithZone:zone];
            return  _globalLoader;
        }
    }
    return nil;
}

-(unsigned)retainCount
{
    return UINT_MAX;  //denotes an object that cannot be released
}

- (id)autorelease
{
    return self;
}

#pragma -mark load resource
//scan local resouces,setlastUpdateDate,or load resources

-(void)startLoad
{
    for (HDResourceMap * map in _resourceList) {
        TTURLRequest * request = [TTURLRequest requestWithURL:map.resourceURL delegate:self];
        request.response = [[[TTURLDataResponse alloc]init] autorelease];
        request.cachePolicy = TTURLRequestCachePolicyDefault;
        request.userInfo = map;
        request.httpMethod = @"GET";
        [_queue sendRequest:request];
    }
}

-(void)stopLoad
{
    [_queue cancelAllRequests];
}

-(void)removeResourceWithResourceList:(NSArray *)list
{
    for (HDResourceMap * map in list) {
        NSString * path = TTPathForDocumentsResource(map.resourceName);
        NSError * error = nil;
        [[NSFileManager defaultManager]removeItemAtPath:path error:&error];  
        if (error) {
            TTDPRINT(@"%@",[error description]);
        }
    }
}

#pragma -mark request delegate
-(void)requestDidFinishLoad:(TTURLRequest *)request
{
    if(!request.respondedFromCache){
        TTURLDataResponse * response =  request.response;
        HDResourceMap * map = request.userInfo;
        [response.data writeToFile:TTPathForDocumentsResource(map.resourceName) atomically:YES];
    }
}

#pragma -mark get Resource functions

//get file path
//-(NSString *)filePathWithFileName:(NSString *)fileName
//{
//    NSArray * paths = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) autorelease];
//    NSString * documentsDicrectory = [paths objectAtIndex:0];
//    return [documentsDicrectory stringByAppendingPathComponent:fileName];
//}
//
////get file data
//-(NSData *)resourceDataWithName:(NSString *) name
//{
//    NSString * filePath = [self filePathWithFileName:name];
//    return [NSData dataWithContentsOfFile:filePath];;
//}
//
////return the specified type of resource,the resources is transformed by block
//-(id)resourceWithName:(NSString *) name withBlock:(resoucesTransformerBlock) block
//{
//    return block([self resourceDataWithName:name]);
//}

@end
