//
//  HDGuider.m
//  Three20GitCoreDataLab
//
//  Created by Rocky Lee on 6/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDGuider.h"

static NSString * kGuideModalPath = @"guide://modalViewControler/";
static NSString * kGuideCreatePath = @"guide://createViewControler/";
static NSString * kGuideSharePath = @"guide://shareViewControler/";

static NSString * kRedirectSelector = @"(controllerWithKeyPath:)";

typedef UIViewController * (^openControllerPathBlock)(NSString *);

@interface HDGuider()
{
    //将配置缓存
    NSMutableDictionary * _guiderMapDictionary;
    HDGuiderMap * _guiderMap;
}

@end

@implementation HDGuider

+(id)guider
{
    return [self shareObject];
}

- (void)dealloc
{
    [[TTNavigator navigator].URLMap removeURL:[NSString stringWithFormat:@"%@%@",kGuideCreatePath,kRedirectSelector]];
    [[TTNavigator navigator].URLMap removeURL:[NSString stringWithFormat:@"%@%@",kGuideSharePath,kRedirectSelector]];
    [[TTNavigator navigator].URLMap removeURL:[NSString stringWithFormat:@"%@%@",kGuideModalPath,kRedirectSelector]];
    TT_RELEASE_SAFELY(_guiderMapDictionary);
    TT_RELEASE_SAFELY(_guiderMap);
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        [[TTNavigator navigator].URLMap from:[NSString stringWithFormat:@"%@%@",kGuideCreatePath,kRedirectSelector]
                      toSharedViewController:self];
        [[TTNavigator navigator].URLMap from:[NSString stringWithFormat:@"%@%@",kGuideSharePath,kRedirectSelector]
                      toSharedViewController:self];
        [[TTNavigator navigator].URLMap from:[NSString stringWithFormat:@"%@%@",kGuideModalPath,kRedirectSelector]
                      toModalViewController:self];
        
        [TTNavigator navigator].delegate = self;
        _guiderMapDictionary = [[NSMutableDictionary alloc]init];
    }
    return self;
}

-(UIViewController*) guideToKeyPath:(NSString *) keyPath
                              query:(NSDictionary *)query
                           animated:(BOOL)animated;
{
    //使用全局变量，在视图控制器显示之前设置配置
    _guiderMap = [[self guiderMapForKeyPath:keyPath] retain];
    HDGuiderMap * guiderMap = [self guiderMapForKeyPath:keyPath];
    
    UIViewController * controller = [[TTNavigator navigator] openURLAction:
            [[[TTURLAction actionWithURLPath:_guiderMap.urlPath] applyQuery:query] applyAnimated:animated]];
    
    //设置需要在视图load之后设置的属性
    return [self configViewController:controller
                           dictionary:guiderMap.propertyDictionary];
}

-(UIViewController *)controllerWithKeyPath:(NSString *) keyPath
                                     query:(NSDictionary *)query
{
    HDGuiderMap * guiderMap = [self guiderMapForKeyPath:keyPath];
    UIViewController * controller =
    [[TTNavigator navigator]viewControllerForURL:guiderMap.urlPath
                                           query:query];
    
    if (guiderMap.shouldConfigWithQuery) {
        [self configViewController:controller
                        dictionary:query];
    }
    
    return [self configViewController:controller
                           dictionary:guiderMap.propertyDictionary];
}

#pragma -mark 配置控制器，之后从配置加载
//配置从query传递的参数
-(UIViewController *)configViewController:(UIViewController *) controller
                               dictionary:(NSDictionary *)dictionary
{
    for (NSString * keyPath in [dictionary allKeys]){
        [controller setValue:[dictionary valueForKey:keyPath] forKeyPath:keyPath];
    }
    //debug:使用完map之后需要置空，否则使用正常tt方式打开如loading页面时会导致配置错误的设置到别的控制器上
    TT_RELEASE_SAFELY(_guiderMap);
    return controller;
}

/*
 *根据path,获取控制器跳转配置对象
 */
-(HDGuiderMap *) guiderMapForKeyPath:(NSString *) keyPath
{
    if (!keyPath) {
        return nil;
    }
    
//    if ([_guiderMapDictionary objectForKey:keyPath]) {
//        return [_guiderMapDictionary objectForKey:keyPath];
//    }
    
    HDGuiderMap * map = [[[HDGuiderMap alloc]init] autorelease];
    
    NSDictionary * urlPathDic =
    @{@"HD_MAIN_VC_PATH":@"init://todoListViewController",
    @"TODO_LIST_SEARCH":@"init://todoListSearchViewController",
    @"HD_LOGIN_VC_PATH":@"init://modalNib/HDLoginViewController/HDLoginViewController",
    @"DONE_LIST_VC_PATH":@"init://doneListViewController",
    @"TODO_LIST_VC_PATH":@"init://todoListViewController",
    @"FUNCTION_LIST_VC_PATH":@"init://functionListViewController",
    @"SETTINGS_VC_PATH":@"init://settingsViewController",
    @"TOOLBAR_DETIAL_VC_PATH":@"init://toolbarDetailViewController",
    @"DETIAL_VC_PATH":@"init://detailViewController",
    @"POST_VC_PATH":@"init://postController",
    @"DELIVER_VC_PATH":@"init://deliverViewController"};
    
    map.urlPath = [urlPathDic valueForKey:keyPath];
    
    map.propertyDictionary = [HDXMLParser createPropertyDictionaryForKeyPath:keyPath];
    if ([keyPath isEqualToString:@"TOOLBAR_DETIAL_VC_PATH"] ||
        [keyPath isEqualToString:@"DETIAL_VC_PATH"] ||
        [keyPath isEqualToString:@"DELIVER_VC_PATH"]) {
        map.shouldConfigWithQuery = YES;
    }
    
//    [_guiderMapDictionary setValue:map forKey:keyPath];
    return map;
}

#pragma -mark TTNavigatorDelegate
-(void)navigator:(TTBaseNavigator *)navigator willOpenURL:(NSURL *)URL inViewController:(UIViewController *)controller
{
    [self configViewController:controller
                    dictionary:_guiderMap.propertyDictionary];
}

@end
