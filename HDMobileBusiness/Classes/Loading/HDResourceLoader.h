//
//  SFResourceLoader.h
//  Three20GitCoreDataLab
//
//  Created by Rocky Lee on 6/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HDResourceMap.h"

//typedef id (^resoucesTransformerBlock)(NSData *);

@interface HDResourceLoader : NSObject <TTURLRequestDelegate>

//资源列表,应该包含资源名称,网络路径,存放地址,刷新间隔,是否需要立即刷新
@property(nonatomic,retain) NSArray * resourceList;

+(id)shareLoader;

-(void)removeResourceWithResourceList:(NSArray *) list;

-(void)stopLoad;

-(void)startLoad;

@end
