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
                              query:(NSDictionary *)query;
{
   return [self configControllerWithKeyPath:keyPath
                                       block: ^UIViewController *(HDGuiderMap * guiderMap)
    {
        return [[TTNavigator navigator] openURLAction:
                [[TTURLAction actionWithURLPath:guiderMap.urlPath] applyQuery:query]];
    }
                                       query:query];
}

-(UIViewController *)controllerWithKeyPath:(NSString *) keyPath
                                     query:(NSDictionary *)query
{
    id vc = [self configControllerWithKeyPath:keyPath
                                        block: ^UIViewController *(HDGuiderMap * guiderMap) {
        return [[TTNavigator navigator]viewControllerForURL:guiderMap.urlPath
                                                      query:query];
     }
                                        query:query];
    //TODO:区分第二次从功能列表进入加载
    if ([keyPath isEqualToString:@"TODO_LIST_VC_PATH"]) {
        [vc setValue:@1 forKeyPath:@"tableViewStyle"];
    }
    
    return vc;
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
//        NSEnumerator * e = [guiderMap.propertyMap keyEnumerator];
//        for (NSString* key ; key = [e nextObject];) {
//            [controller setValue:[guiderMap.propertyMap valueForKeyPath:key] forKeyPath:key];
//        }
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
            return [self configTodoListDetialViewController:controller query:query];
        }
        if ([keyPath isEqualToString:@"DETIAL_VC_PATH"]) {
            return [self configDoneListDetialViewController:controller query:query];
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
    [controller setValue: @{@"title":@"${workflow_name}:${employee_name}",
     @"caption":@"当前节点: ${node_name}",
     @"text":@"${workflow_desc}",
     @"timestamp":@"${creation_date}",
     @"isLate":@"${is_late}"}
              forKeyPath:@"dataSource.cellItemMap"];
    [controller setValue:@"creation_date" forKeyPath:@"dataSource.model.orderField"];
    [controller setValue:@"record_id" forKeyPath:@"dataSource.model.primaryFiled"];
    [controller setValue:@[@"order_type",@"node_name",@"employee_name"] forKeyPath:@"dataSource.model.serachFields"];
    [controller setValue:[NSString stringWithFormat:@"%@autocrud/ios.ios_todo_list.ios_todo_list_query/query?_fetchall=true&amp;_autocount=false",[[HDHTTPRequestCenter sharedURLCenter]baseURLPath]] forKeyPath:@"dataSource.model.queryURL"];
    [controller setValue:[NSString stringWithFormat:@"%@%@",[[HDHTTPRequestCenter sharedURLCenter]baseURLPath],@"modules/ios/ios_approve_new/ios_todo_list_commit.svc"] forKeyPath:@"dataSource.model.submitURL"];
    return controller;
}

-(UIViewController *) configDoneListViewController:(UIViewController *) controller
{
    [controller setValue:@"DoneList[配置]" forKeyPath:@"title"];
    //            [controller setValue:RGBCOLOR(234, 234, 234) forKeyPath:@"tableView.backgroundColor"];
    [controller setValue:@1 forKeyPath:@"tableView.separatorStyle"];
    [controller setValue:RGBCOLOR(53, 53, 53) forKeyPath:@"tableView.separatorColor"];
    [controller setValue:@{@"title":@"${workflow_name}:${created_by_name}",
     @"caption":@"当前节点: ${created_by_name}",
     @"text":@"${workflow_desc}",
     @"timestamp":@"${creation_date}"}
              forKeyPath:@"dataSource.cellItemMap"];
    [controller setValue:[NSString stringWithFormat:@"%@autocrud/ios.ios_done_list.ios_done_list_query/query",[[HDHTTPRequestCenter sharedURLCenter]baseURLPath]] forKeyPath:@"dataSource.model.queryURL"];
    return controller;
}

-(UIViewController *) configFunctionListViewController:(UIViewController *) controller
{
    [controller setValue:@"功能[配置]" forKeyPath:@"title"];
    [controller setValue:[NSString stringWithFormat:@"%@modules/ios/ios_function_center/ios_function_query.svc", [[HDHTTPRequestCenter sharedURLCenter]baseURLPath]]forKeyPath:@"model.queryURL"];
    return controller;
}
//todolist明细页面配置
-(UIViewController *) configTodoListDetialViewController:(UIViewController *) controller
                                                       query:(NSDictionary *)query
{
//    [controller setValue:@"功能[配置]" forKeyPath:@"title"];
    [controller setValue:@"record_id" forKeyPath:@"userInfoItemTitle"];
    [controller setValue:[NSString stringWithFormat:@"%@autocrud/ios.iso_my_test.ios_workflow_approve_action_query/query?record_id={record_id}",[[HDHTTPRequestCenter sharedURLCenter]baseURLPath]]forKeyPath:@"queryActionURLTemplate"];
    [controller setValue:[NSString stringWithFormat:@"%@modules/mobile/hr_lbr_employee.screen?employee_id={user_id}",[[HDHTTPRequestCenter sharedURLCenter]baseURLPath]]forKeyPath:@"userInfoPageURLTemplate"];
    [controller setValue:[NSString stringWithFormat:@"%@{screen_name}",[[HDHTTPRequestCenter sharedURLCenter]baseURLPath]]forKeyPath:@"webPageURLTemplate"];
    //设置listModel
    [controller setValue:[query valueForKeyPath:@"listModel"] forKey:@"listModel"];
    return controller;
}

//done detail
-(UIViewController *) configDoneListDetialViewController:(UIViewController *) controller
                                                   query:(NSDictionary *)query
{
    [controller setValue:@"record_id" forKeyPath:@"userInfoItemTitle"];
    [controller setValue:[NSString stringWithFormat:@"%@modules/mobile/hr_lbr_employee.screen?employee_id={user_id}",[[HDHTTPRequestCenter sharedURLCenter]baseURLPath]]forKeyPath:@"userInfoPageURLTemplate"];
    [controller setValue:[NSString stringWithFormat:@"%@{screen_name}",[[HDHTTPRequestCenter sharedURLCenter]baseURLPath]]forKeyPath:@"webPageURLTemplate"];
    [controller setValue:[query valueForKeyPath:@"listModel"] forKey:@"listModel"];
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
    @"DETIAL_VC_PATH":@"init://detailViewController"};
    //realase
//    @{@"HD_MAIN_VC_PATH":@"init://todoListViewController",
//    @"TODO_LIST_SEARCH":@"init://todoListSearchViewController",
//    @"HD_LOGIN_VC_PATH":@"init://modalNib/HDLoginViewController/HDLoginViewController",
//    @"DONE_LIST_VC_PATH":@"init://doneListViewController"};
    
    
//    map.urlPath = [[HDGodXMLFactory shareBeanFactory] actionURLPathWithKey:path];
    map.urlPath = [urlPathDic valueForKey:path];
    return map;
}

+(id)guider
{
    return [self shareObject];
}

@end
