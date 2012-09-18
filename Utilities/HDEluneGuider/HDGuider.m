//
//  HDGuider.m
//  Three20GitCoreDataLab
//
//  Created by Rocky Lee on 6/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDGuider.h"

#import "HDGodXMLFactory.h"

#import "HDTodoListViewController.h"
#import "HDMessageSingleRecipientField.h"
static NSString * kGuideModalPath = @"guide://modalViewControler/";
static NSString * kGuideCreatePath = @"guide://createViewControler/";
static NSString * kGuideSharePath = @"guide://shareViewControler/";

static NSString * kRedirectSelector = @"(controllerWithKeyPath:)";

typedef UIViewController * (^openControllerPathBlock)(HDGuiderMap *);

@implementation HDGuider

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
                                       block: ^UIViewController *(HDGuiderMap * guiderMap)
    {
        return [[TTNavigator navigator] openURLAction:
                [[[TTURLAction actionWithURLPath:guiderMap.urlPath] applyQuery:query]applyAnimated:animated]];
    }
                                       query:query];
}

-(UIViewController *)controllerWithKeyPath:(NSString *) keyPath
                                     query:(NSDictionary *)query
{
    return [self configControllerWithKeyPath:keyPath
                                       block: ^UIViewController *(HDGuiderMap * guiderMap)
    {
        return [[TTNavigator navigator]viewControllerForURL:guiderMap.urlPath
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
        UIViewController * controller = block(guiderMap);

        if ([keyPath isEqualToString:@"HD_LOGIN_VC_PATH"]) {
            return [self configLoginViewController:controller];
        }
        if ([keyPath isEqualToString:@"HD_MAIN_VC_PATH"] ||
            [keyPath isEqualToString:@"TODO_LIST_SEARCH"]||
            [keyPath isEqualToString:@"TODO_LIST_VC_PATH"]) {
            return [self configTodoListViewController:controller];
        }
        if ([keyPath isEqualToString:@"DONE_LIST_VC_PATH"]) {
            return [self configDoneListViewController:controller];
        }
        if ([keyPath isEqualToString:@"FUNCTION_LIST_VC_PATH"]) {
            return [self configFunctionListViewController:controller];
        }
        if ([keyPath isEqualToString:@"TOOLBAR_DETIAL_VC_PATH"]) {
            return [self configTodoListDetialViewController:
                    [self configViewController:controller query:query]];
        }
        if ([keyPath isEqualToString:@"DETIAL_VC_PATH"]) {
            return [self configDoneListDetialViewController:
                    [self configViewController:controller query:query]];
        }
        if ([keyPath isEqualToString:@"DELIVER_VC_PATH"]) {
            return [self configDeliverViewController:
                    [self configViewController:controller
                                         query:query]];
        }
        return controller;
    }
    return nil;
}

#pragma -mark 配置控制器，之后从配置加载
//TODO:配置控制器，之后从配置加载
-(UIViewController *) configLoginViewController:(UIViewController *) controller
{
    [controller setValue:[NSString stringWithFormat:@"%@modules/ios/public/login_iphone.svc",[[HDHTTPRequestCenter sharedURLCenter]baseURLPath]] forKeyPath:@"model.submitURLPath"];
    return controller;
}

-(UIViewController *) configTodoListViewController:(UIViewController *) controller
{
    [controller setValue:@"TodoList[配置]" forKeyPath:@"title"];
    [controller setValue:RGBCOLOR(204, 255, 255) forKeyPath:@"tableView.backgroundColor"];
    [controller setValue: @{@"title":@"${workflow_name}:${employee_name}",
     @"caption":@"当前节点: ${node_name}",
     @"text":@"${workflow_desc}",
     @"timestamp":@"${creation_date}",
     @"isLate":@"${is_late}"}
              forKeyPath:@"dataSource.cellItemMap"];
    [controller setValue:@"record_id" forKeyPath:@"dataSource.model.primaryFiled"];
    [controller setValue:@[@"order_type",@"node_name",@"employee_name"] forKeyPath:@"dataSource.model.serachFields"];
    [controller setValue:[NSString stringWithFormat:@"%@autocrud/ios.ios_test.ios_todo_list_test/query?_fetchall=true&amp;_autocount=false",[[HDHTTPRequestCenter sharedURLCenter]baseURLPath]] forKeyPath:@"dataSource.model.queryURL"];
    [controller setValue:[NSString stringWithFormat:@"%@%@",[[HDHTTPRequestCenter sharedURLCenter]baseURLPath],@"modules/ios/ios_test/ios_todo_list_commit.svc"] forKeyPath:@"dataSource.model.submitURL"];
    return controller;
}

-(UIViewController *) configDoneListViewController:(UIViewController *) controller
{
    [controller setValue:@"DoneList[配置]" forKeyPath:@"title"];
    [controller setValue:@1 forKeyPath:@"tableView.separatorStyle"];
    [controller setValue:RGBCOLOR(53, 53, 53) forKeyPath:@"tableView.separatorColor"];
    [controller setValue:@{@"title":@"${workflow_name}:${created_by_name}",
     @"caption":@"当前节点: ${created_by_name}",
     @"text":@"${workflow_desc}",
     @"timestamp":@"${creation_date}"}
              forKeyPath:@"dataSource.cellItemMap"];
    [controller setValue:[NSString stringWithFormat:@"%@autocrud/ios.ios_test.ios_done_list_test/query",[[HDHTTPRequestCenter sharedURLCenter]baseURLPath]] forKeyPath:@"dataSource.model.queryURL"];
    return controller;
}

-(UIViewController *) configFunctionListViewController:(UIViewController *) controller
{
    [controller setValue:@"功能[配置]" forKeyPath:@"title"];
    [controller setValue:[NSString stringWithFormat:@"%@autocrud/ios.ios_function_center.ios_function_center_list/query", [[HDHTTPRequestCenter sharedURLCenter]baseURLPath]]forKeyPath:@"model.queryURL"];
    return controller;
}
//todolist明细页面配置
-(UIViewController *) configTodoListDetialViewController:(UIViewController *) controller
{
    [controller setValue:@"record_id" forKeyPath:@"userInfoItemTitle"];
    [controller setValue:[NSString stringWithFormat:@"%@autocrud/ios.ios_test.ios_detail_action_query/query?record_id={record_id}",[[HDHTTPRequestCenter sharedURLCenter]baseURLPath]]forKeyPath:@"queryActionURLTemplate"];
    [controller setValue:[NSString stringWithFormat:@"%@modules/mobile/hr_lbr_employee.screen?employee_id={user_id}",[[HDHTTPRequestCenter sharedURLCenter]baseURLPath]]forKeyPath:@"userInfoPageURLTemplate"];
    [controller setValue:[NSString stringWithFormat:@"%@{screen_name}",[[HDHTTPRequestCenter sharedURLCenter]baseURLPath]]forKeyPath:@"webPageURLTemplate"];
    return controller;
}

//done detail
-(UIViewController *) configDoneListDetialViewController:(UIViewController *) controller
{
    [controller setValue:@"record_id" forKeyPath:@"userInfoItemTitle"];
    [controller setValue:[NSString stringWithFormat:@"%@modules/mobile/hr_lbr_employee.screen?employee_id={user_id}",[[HDHTTPRequestCenter sharedURLCenter]baseURLPath]]forKeyPath:@"userInfoPageURLTemplate"];
    [controller setValue:[NSString stringWithFormat:@"%@{screen_name}",[[HDHTTPRequestCenter sharedURLCenter]baseURLPath]]forKeyPath:@"webPageURLTemplate"];
    return controller;
}

//选人界面
-(UIViewController *)configDeliverViewController:(UIViewController *) controller
{
    [controller setValue:@"转交[配置]" forKeyPath:@"title"];
    //是否显示+号，可以点加号通过列表选人
    [controller setValue:@0 forKeyPath:@"showsRecipientPicker"];
    [controller setValue:[NSString stringWithFormat:@"%@autocrud/ios.ios_deliver.ios_wprkflow_deliver_query/query",[[HDHTTPRequestCenter sharedURLCenter]baseURLPath]] forKeyPath:@"dataSource.model.queryURL"];
    [controller setValue:@{ @"text" : @"${name}",@"subtitle":@"${position_name}",@"userInfo":@"${employee_id}"} forKeyPath: @"dataSource.itemDictionary"];
    return controller;
}

//配置从query传递的参数
-(UIViewController *)configViewController:(UIViewController *) controller
                                    query:(NSDictionary *)query
{
    for (NSString * key in [query allKeys]){
        [controller setValue:[query valueForKey:key] forKeyPath:key];
    }
    return controller;
}
/*
 *根据path,获取控制器跳转配置对象
 */
-(HDGuiderMap *) guiderMapForKeyPath:(NSString *) path
{
    if (!path) {
        return nil;
    }
    HDGuiderMap * map = [[[HDGuiderMap alloc]init] autorelease];
    
    //    if ([path isEqualToString:@"HD_LOGIN_VC_PATH"]) {
    //        map.redirectPath = [NSString stringWithFormat:@"%@%@",kGuideModalPath,path];
    //    }
    //    if ([path isEqualToString:@"HD_MAIN_VC_PATH"]) {
    //        map.redirectPath = [NSString stringWithFormat:@"%@%@",kGuideSharePath,path];
    //    }
    
    //TODO:这里考虑从god生成map,想配什么就在map里加吧...
    NSDictionary * urlPathDic =
    //test
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
    //realase
//    @{@"HD_MAIN_VC_PATH":@"init://todoListViewController",
//    @"TODO_LIST_SEARCH":@"init://todoListSearchViewController",
//    @"HD_LOGIN_VC_PATH":@"init://modalNib/HDLoginViewController/HDLoginViewController",
//    @"DONE_LIST_VC_PATH":@"init://doneListViewController"};
    
    map.urlPath = [urlPathDic valueForKey:path];
    return map;
}

+(id)guider
{
    return [self shareObject];
}

@end
