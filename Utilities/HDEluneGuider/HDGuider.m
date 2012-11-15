//
//  HDGuider.m
//  Three20GitCoreDataLab
//
//  Created by Rocky Lee on 6/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDGuider.h"
#import "HDSplitViewController.h"
#import "StackScrollViewController.h"

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

-(UIViewController *)guideWithSegment:(HDGuideSegment *)segment
{
    //使用全局变量，在视图控制器显示之前设置配置
    _guiderMap = [[self guiderMapForKeyPath:segment.keyPath] retain];
    HDGuiderMap * guiderMap = [self guiderMapForKeyPath:segment.keyPath];
    
    if (TTIsPad()) {
        if ([segment.keyPath isEqualToString:kMainControllerPath]) {
            [[TTNavigator navigator] openURLAction:
             [[[TTURLAction actionWithURLPath:_guiderMap.urlPath] applyQuery:segment.query] applyAnimated:segment.animated]];
        }
        if (![segment.keyPath isEqualToString:kMainControllerPath]) {
            //获取主控制器
            HDSplitViewController * mainController = (HDSplitViewController *)[[TTNavigator navigator]viewControllerForURL:@"init://HDSplitViewController"];
            
            //获取右边堆视图控制器
            StackScrollViewController * stackController = (StackScrollViewController *)mainController.rightViewController;
            
            //获取需要压入的视图控制器
            UIViewController * pushedController = [self controllerWithKeyPath:segment.keyPath query:segment.query];
            
            UINavigationController * navigationController = nil;
            
            if (nil == pushedController.navigationController) {
                navigationController = [[[UINavigationController alloc]initWithRootViewController:pushedController] autorelease];
            }else{
                navigationController = pushedController.navigationController;
            }
            
            navigationController.view.frame = CGRectMake(0, 0, 440, CGRectGetHeight(pushedController.view.frame));
            
            
            if ([segment.invoker isKindOfClass:NSClassFromString(@"HDFunctionListViewController")]) {
                [stackController addViewInSlider:navigationController
                              invokeByController:mainController.leftViewController
                                isStackStartView:YES];
            }
            else{
                [stackController addViewInSlider:navigationController
                              invokeByController:segment.invoker
                                isStackStartView:NO];
            }
        }
        return nil;
    }
    UIViewController * controller = [[TTNavigator navigator] openURLAction:
                                     [[[TTURLAction actionWithURLPath:_guiderMap.urlPath] applyQuery:segment.query]
                                      applyAnimated:segment.animated]];
    
    if (guiderMap.shouldConfigWithQuery) {
        [self configViewController:controller
                        dictionary:segment.query];
    }

    //设置需要在视图load之后设置的属性
    return [self configViewController:controller
                           dictionary:guiderMap.propertyDictionary];
}

-(UIViewController*) guideToKeyPath:(NSString *) keyPath
                              query:(NSDictionary *)query
                           animated:(BOOL)animated;
{
    //使用全局变量，在视图控制器显示之前设置配置
    _guiderMap = [[self guiderMapForKeyPath:keyPath] retain];
    HDGuiderMap * guiderMap = [self guiderMapForKeyPath:keyPath];
    
    if (TTIsPad()) {
        if ([keyPath isEqualToString:kMainControllerPath]) {
            [[TTNavigator navigator] openURLAction:
             [[[TTURLAction actionWithURLPath:_guiderMap.urlPath] applyQuery:query] applyAnimated:animated]];
        }
        if (![keyPath isEqualToString:kMainControllerPath]) {
            //获取主控制器
            HDSplitViewController * mainController = (HDSplitViewController *)[[TTNavigator navigator]viewControllerForURL:@"init://HDSplitViewController"];
            
            //获取右边堆视图控制器
            StackScrollViewController * stackController = (StackScrollViewController *)mainController.rightViewController;
            
            //获取需要压入的视图控制器
            UIViewController * pushedController = [self controllerWithKeyPath:keyPath query:nil];
//            pushedController.view.frame = CGRectMake(0, 0, 800, CGRectGetHeight(pushedController.view.frame));
            
            [stackController addViewInSlider:pushedController
                          invokeByController:mainController.leftViewController
                            isStackStartView:YES];
        }
        return nil;
    }
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

-(UIViewController *)controllerWithKeyPath:(NSString *) keyPath
                                 className:(Class) className
                                   nibName:(NSString *) nibName
{
    HDGuiderMap * guiderMap = [self guiderMapForKeyPath:keyPath];
    UIViewController * viewController = nil;
    if (nibName) {
        viewController = [[className alloc]initWithNibName:nibName bundle:nil];
    }else
    {
        viewController = [[[className alloc]init]autorelease];
    }
    return [self configViewController:viewController dictionary:guiderMap.propertyDictionary];
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
    [controller viewWillAppear:NO];
    [controller viewDidAppear:NO];
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
    
    NSMutableDictionary * urlPathDic = [NSMutableDictionary dictionaryWithDictionary:
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
                                        @"DELIVER_VC_PATH":@"init://deliverViewController"}];
    
    //在这里对pad的key做不同的解释
    if (TTIsPad()) {
        [urlPathDic setValue:@"init://shareNib/HDPadLoginViewController/HDLoginViewController" forKey:@"HD_LOGIN_VC_PATH"];
        [urlPathDic setValue:@"init://HDSplitViewController" forKey:@"HD_MAIN_VC_PATH"];
    }
    
    map.urlPath = [urlPathDic valueForKey:keyPath]? [urlPathDic valueForKey:keyPath]: keyPath;
    
    map.propertyDictionary = [HDXMLParser createPropertyDictionaryForKeyPath:keyPath];
    if ([keyPath isEqualToString:@"TOOLBAR_DETIAL_VC_PATH"] ||
        [keyPath isEqualToString:@"DETIAL_VC_PATH"] ||
        [keyPath isEqualToString:@"DELIVER_VC_PATH"]) {
        map.shouldConfigWithQuery = YES;
    }
    return map;
}

#pragma -mark TTNavigatorDelegate
-(void)navigator:(TTBaseNavigator *)navigator willOpenURL:(NSURL *)URL inViewController:(UIViewController *)controller
{
    [self configViewController:controller
                    dictionary:_guiderMap.propertyDictionary];
}

@end
