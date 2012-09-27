//
//  HDGuider.m
//  Three20GitCoreDataLab
//
//  Created by Rocky Lee on 6/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDGuider.h"
#import "HDXMLParser.h"

static NSString * kGuideModalPath = @"guide://modalViewControler/";
static NSString * kGuideCreatePath = @"guide://createViewControler/";
static NSString * kGuideSharePath = @"guide://shareViewControler/";

static NSString * kRedirectSelector = @"(controllerWithKeyPath:)";

typedef UIViewController * (^openControllerPathBlock)(NSString *);

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
    }
    return self;
}

-(UIViewController*) guideToKeyPath:(NSString *) keyPath
                              query:(NSDictionary *)query
                           animated:(BOOL)animated;
{
   return [self configControllerWithKeyPath:keyPath
                                      block: ^UIViewController *(NSString * urlPath)
    {
        //TODO:这里转发到controllerWithKeyPath
        return [[TTNavigator navigator] openURLAction:
                [[[TTURLAction actionWithURLPath:urlPath] applyQuery:query] applyAnimated:animated]];
    }
                                       query:query];
}

-(UIViewController *)controllerWithKeyPath:(NSString *) keyPath
                                     query:(NSDictionary *)query
{
    TTDPRINT(@"keyPath :%@",keyPath);
    //TODO:这里创建改成直接create
    return [self configControllerWithKeyPath:keyPath
                                       block: ^UIViewController *(NSString * urlPath)
    {
        return [[TTNavigator navigator]viewControllerForURL:urlPath
                                                      query:query];
    }
                                        query:query];
}

/*
 *根据block,打开或创建一个controller,根据配置设置这个controller
 */
-(UIViewController *)configControllerWithKeyPath:(NSString *) keyPath
                                           block:(openControllerPathBlock) block
                                           query:query
{
    HDGuiderMap * guiderMap = nil;
    if ((guiderMap = [self guiderMapForKeyPath:keyPath])) {
        //open contoller with path
        UIViewController * controller = block(guiderMap.urlPath);
        //如果配置中要求从query配置属性，query为前一个视图控制器传递出啊来的参数
        if(guiderMap.shouldConfigWithQuery)
        {
            //TODO:这里配置方式有问题，应该在配置文件中指定需要从query中获取什么参数，而不是让query中的参数顺序set，可能造成set了被配置vc不需要的参数而导致程序崩溃（undefinedKey exception）
            [self configViewController:controller dictionary:query];
        }
        return [self configViewController:controller dictionary:guiderMap.propertyDictionary];
        }
    return nil;
}

#pragma -mark 配置控制器，之后从配置加载
//配置从query传递的参数
-(UIViewController *)configViewController:(UIViewController *) controller
                               dictionary:(NSDictionary *)dictionary
{
    for (NSString * keyPath in [dictionary allKeys]){
        [controller setValue:[dictionary valueForKey:keyPath] forKeyPath:keyPath];
    }
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
    
    //TODO:考虑添加一个dic，配置从前一个视图控制器传递过来的参数映射
    return map;
}

@end
