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

@protocol HDResourceLoader <NSObject>

-(void)loadResource:(NSDictionary *) resourceDictionary;

-(void)stopLoad;//Unimplemented

@end

@interface HDResourceLoader : HDSingletonObject <TTURLRequestDelegate,HDResourceLoader>

+(id)shareLoader;

//根据指定dictionary下载资源到本地，kResourceName为存储到本地的文件名称，kResourceURL为资源的访问路径
-(void)loadResource:(NSDictionary *) resourceDictionary;

-(void)stopLoad;//Unimplemented

@end