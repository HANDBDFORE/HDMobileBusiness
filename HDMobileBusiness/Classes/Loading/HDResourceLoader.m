//
//  HDResourceLoader.m
//  Three20GitCoreDataLab
//
//  Created by Rocky Lee on 6/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDResourceLoader.h"

@interface HDResourceLoader()

@property(nonatomic,readonly) TTURLRequestQueue * queue;

@end

@implementation HDResourceLoader
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
        _resourceList = [[NSMutableArray alloc]initWithCapacity:3];
    }
    return self;
}

+(id)shareLoader
{
    return [self shareObject];
}

#pragma -mark load resource
//scan local resouces,setlastUpdateDate,or load resources

-(void)startLoad
{
    for (NSDictionary * map in _resourceList) {
        TTURLRequest * request = [TTURLRequest requestWithURL:[map valueForKey:kResourceURL] delegate:self];
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

-(void)addResource:(NSDictionary *) resourceDictionary
{
    [_resourceList addObject:resourceDictionary];
}

-(void)removeResourceWithResourceList:(NSArray *)list
{
    for (NSDictionary * map in list) {
        NSString * path = TTPathForDocumentsResource([map valueForKey:kResourceName]);
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
        NSDictionary * map = request.userInfo;
        [response.data writeToFile:TTPathForDocumentsResource([map valueForKey:kResourceName]) atomically:YES];
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
