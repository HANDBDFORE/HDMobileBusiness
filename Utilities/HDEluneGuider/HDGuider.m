//
//  HDGuider.m
//  Three20GitCoreDataLab
//
//  Created by Rocky Lee on 6/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDGuider.h"

#import "HDGodXMLFactory.h"
#import "HDGuiderMap.h"

static HDGuider * _globalGuider = nil;

typedef UIViewController * (^openControllerPathBlock)(HDGuiderMap *);

@implementation HDGuider

/*
 *跳转到指定路径的视图控制器,路径以 open://vc/ 开头后接控制器配置节点的key
 */
-(void) guideToKeyPath:(NSString *) path query:(NSDictionary *)query;
{ 
    [self guideControllerWithKeyPath:path 
                               withBlock:^UIViewController *(HDGuiderMap *map){
                                   return [[TTNavigator navigator]openURLAction:[[TTURLAction actionWithURLPath:map.urlPath]applyQuery:query]];                               }];       
}

/*
 *创建到指定路径的视图控制器,路径以 open://vc/ 开头后接控制器配置节点的key,这个方法不会显示这个视图控制器的视图,只是创建
 */
-(UIViewController *)controllerWithKeyPath:(NSString *) keyPath
                                     query:(NSDictionary *)query
{
    
    return [self guideControllerWithKeyPath:keyPath 
                               withBlock:^UIViewController *(HDGuiderMap *map){
                                   return [[TTNavigator navigator]viewControllerForURL:map.urlPath query:query];
                               }];
}

/*
 *根据block,打开或创建一个controller,根据配置设置这个controller
 */
-(UIViewController *)guideControllerWithKeyPath:(NSString *) path
                                      withBlock:(openControllerPathBlock) block
{
    HDGuiderMap * guiderMap = nil;
    if ((guiderMap = [self guiderMapWithPath:path])) {
        //open contoller with path
        UIViewController * controller = block(guiderMap);
        NSEnumerator * e = [guiderMap.propertyMap keyEnumerator];
        for (NSString* key ; key = [e nextObject];) {
            [controller setValue:[guiderMap.propertyMap valueForKeyPath:key] forKeyPath:key];
        } 
        return controller;
    }
    return nil;
}

/*
 *根据path,获取控制器跳转配置对象
 */
-(HDGuiderMap *) guiderMapWithPath:(NSString *) path
{
    if (!path) {
        return nil;
    }
    //TODO:这里考虑从god生成map,想配什么就在map里加吧...
    HDGuiderMap * map = [[[HDGuiderMap alloc]init] autorelease];
    map.urlPath = [[HDGodXMLFactory shareBeanFactory] actionURLPathWithKey:path];
    return map;
}

+(id)guider
{
    @synchronized(self){
        if (_globalGuider == nil) {
            _globalGuider = [[self alloc] init];
        }
    }
    return  _globalGuider;
}

+(id) allocWithZone:(NSZone *)zone{
    @synchronized(self){
        if (_globalGuider == nil) {
            _globalGuider = [super allocWithZone:zone];
            return  _globalGuider;
        }
    }
    return nil;
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain
{
    return self;
}

-(unsigned)retainCount
{
    return UINT_MAX;  //denotes an object that cannot be released
}

- (id)autorelease
{
    return self;
}

@end
