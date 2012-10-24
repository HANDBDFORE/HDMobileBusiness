//
//  HDResourceLoader.h
//  Three20GitCoreDataLab
//
//  Created by Rocky Lee on 6/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString * kResourceURL = @"remoteURL";
static NSString * kResourceName = @"saveFileName";

@interface HDResourceLoader : HDSingletonObject <TTURLRequestDelegate>
{
    NSMutableArray * _resourceList;
}

+(id)shareLoader;

-(void)removeResourceWithResourceList:(NSArray *) list;

//资源字典,应该包含资源名称,网络路径,存放地址,刷新间隔,是否需要立即刷新
-(void)addResource:(NSDictionary *) resourceDictionary;

-(void)stopLoad;

-(void)startLoad;

@end
