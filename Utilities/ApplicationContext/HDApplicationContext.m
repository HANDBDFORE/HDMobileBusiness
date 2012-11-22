//
//  HDApplicationContext.m
//  Three20Lab
//
//  Created by Plato on 11/15/12.
//  Copyright (c) 2012 hand. All rights reserved.
//

#import "HDApplicationContext.h"
#import "HDObjectPattern.h"

#import "HDLoadingViewController.h"
#import "HDLoginViewController.h"

#import "HDFunctionListViewController.h"
#import "HDFunctionListDataSource.h"

#import "HDTodoListViewController.h"
#import "HDTodoListDataSource.h"
#import "HDTodoListModel.h"

#import "HDDoneListViewController.h"
#import "HDDoneListDataSource.h"
#import "HDDoneListModel.h"

#import "HDDetailInfoViewController.h"
#import "HDDetailToolbarViewController.h"

#import "HDNavigationController.h"

#import "HDWebViewController.h"

#import "HDDeliverViewController.h"
#import "HDPersonListDataSource.h"

@implementation HDApplicationContext

- (void)dealloc
{
    TT_RELEASE_SAFELY(_objectFactoryMap);
    TT_RELEASE_SAFELY(_objectMappings);
    TT_RELEASE_SAFELY(_objectPatterns);
    [super dealloc];
}

+(BOOL)configApplicationContextForXmlPath:(NSString *)xmlPath
{
    return [[self shareObject]configWithXmlPath:xmlPath];
}

+(HDApplicationContext *)shareContext
{
    return [self shareObject];
}

-(void)clearObjects
{
    [_objectMappings removeAllObjects];
    [self init];
}

- (id)init
{
    self = [super init];
    if (self) {
        //加载对象创建路径
        [self loadMap];
        
        //这些配置需要在获取配置文件前加载
        //配置bean
        [self setObject:[[[UIApplication sharedApplication] windows] objectAtIndex:0] forIdentifier:@"rootWindow"];

        //入口guider
        HDObjectPattern * rootGuiderPattern =
        [HDObjectPattern patternWithURL:@"tt://rootGuider/rootGuider"
                         propertyValues:nil
                       propertyRefBeans:@{@"sourceController" :@"rootWindow",
         @"destinationController":@"loadingViewCtrl"}
                             objectMode:HDObjectModeCreate];
        
        [self setPattern:rootGuiderPattern forIdentifier:@"rootGuider"];
        
        //初始化loading。。。
        HDObjectPattern * loading =
        [HDObjectPattern patternWithURL:@"tt://LoadingViewController"
                         propertyValues:nil
                       propertyRefBeans:nil
                             objectMode:HDObjectModeCreate];
        
        [self setPattern:loading forIdentifier:@"loadingViewCtrl"];
    }
    return self;
}

-(BOOL)configWithXmlPath:(NSString *) xmlPath
{
    if (![HDXMLParser hasParsedSuccess]) {
        return NO;
    }
    //guider patterns
    //loading guider
    HDObjectPattern * loadingGuiderPattern =
    [HDObjectPattern patternWithURL:@"tt://rootGuider/rootGuider"
                     propertyValues:nil
                   propertyRefBeans:@{@"sourceController" :@"rootWindow",
     @"destinationController":@"loginViewCtrl"}
                         objectMode:HDObjectModeCreate];
    [self setPattern:loadingGuiderPattern forIdentifier:@"loadingGuider"];

    //login guider
    HDObjectPattern * loginGuiderPattern =
    [HDObjectPattern patternWithURL:@"tt://rootGuider/rootGuider"
                     propertyValues:nil
                   propertyRefBeans:@{@"sourceController" :@"rootWindow",
     @"destinationController":@"navigator"}
                         objectMode:HDObjectModeCreate];
    [self setPattern:loginGuiderPattern forIdentifier:@"loginGuider"];
    
    //functionlistGuider
    HDObjectPattern * functionCellGuiderPattern =
    [HDObjectPattern patternWithURL:@"tt://navigatorGuider/functionListTableGuider"
                     propertyValues:@{@"animated" : @1}
                   propertyRefBeans:@{@"sourceController":@"functionListViewController"}
                         objectMode:HDObjectModeCreate];
    [self setPattern:functionCellGuiderPattern forIdentifier:@"functionListTableGuider"];
    
    //todo list guider
    HDObjectPattern * todolistGuiderPattern =
    [HDObjectPattern patternWithURL:@"tt://navigatorGuider/todolistTableGuider"
                     propertyValues:@{@"animated" : @1}
                   propertyRefBeans:@{@"sourceController":@"todoListViewController",
     @"destinationController":@"todoDetailController"}
                         objectMode:HDObjectModeCreate];
    [self setPattern:todolistGuiderPattern forIdentifier:@"todolistTableGuider"];
    
    //todo list post guider
    HDObjectPattern * todoListPostGuiderPattern =
    [HDObjectPattern patternWithURL:@"tt://showInViewGuider/todoListPostGuider"
                     propertyValues:@{@"animated" : @1,
     @"destinationController":@"postController"}
                   propertyRefBeans:nil
                         objectMode:HDObjectModeCreate];
    [self setPattern:todoListPostGuiderPattern forIdentifier:@"todoListPostGuider"];
    
    //todoDetailListPostGuiderPattern
    HDObjectPattern * todoDetailPostGuiderPattern =
    [HDObjectPattern patternWithURL:@"tt://showInViewGuider/todoDetailPostGuider"
                     propertyValues:@{@"animated" : @1,
     @"destinationController":@"postController"}
                   propertyRefBeans:@{@"sourceController" : @"todoDetailController"}
                         objectMode:HDObjectModeCreate];
    [self setPattern:todoDetailPostGuiderPattern forIdentifier:@"todoDetailPostGuider"];
    
    //deliver guider
    HDObjectPattern * todoDetailDeliverGuiderPattern =
    [HDObjectPattern patternWithURL:@"tt://modalGuider/todoDetailDeliverGuider"
                     propertyValues:@{@"animated" : @1,
     @"destinationController":@"deliverNavigator"}
                   propertyRefBeans:@{@"sourceController" : @"todoDetailController"}
                         objectMode:HDObjectModeCreate];
    [self setPattern:todoDetailDeliverGuiderPattern forIdentifier:@"todoDetailDeliverGuider"];
    
    //done list guider
    HDObjectPattern * donelistGuiderPattern =
    [HDObjectPattern patternWithURL:@"tt://navigatorGuider/doneListTableGuider"
                     propertyValues:@{@"animated":@1}
                   propertyRefBeans:@{@"sourceController":@"doneListViewController",
     @"destinationController":@"doneDetailController"}
                         objectMode:HDObjectModeCreate];
    [self setPattern:donelistGuiderPattern forIdentifier:@"doneListTableGuider"];
    
//    HDObjectPattern * logoutGuiderPattern =
//    [HDObjectPattern patternWithURL:@"tt://navigatorGuider/doneListTableGuider"
//                     propertyValues:@{@"animated":@1}
//                   propertyRefBeans:@{@"sourceController":@"rootView",
//     @"destinationController":@"loading"}
//                         objectMode:HDObjectModeCreate];
//    [self setPattern:logoutGuiderPattern forIdentifier:@"logoutGuider"];
    
    
    /////////////////////
    //viewControllers
    ///loginVC
    HDObjectPattern * login =
    [HDObjectPattern patternWithURL:@"tt://nib/HDLoginViewController/HDLoginViewController"
                     propertyValues:@{@"titleLabel.text" : @"hand"}
                   propertyRefBeans:@{@"loginModel":@"loginModel"}
                         objectMode:HDObjectModeCreate];
    [self setPattern:login forIdentifier:@"loginViewCtrl"];
    
    //loginM
    HDObjectPattern * loginM = [HDObjectPattern patternWithURL:@"tt://loginModel" propertyValues:@{@"submitURL":@"${base_url}modules/ios/public/login_iphone.svc"} propertyRefBeans:nil objectMode:HDObjectModeCreate];
    [self setPattern:loginM forIdentifier:@"loginModel"];
    
    //NavigatorVC
    HDObjectPattern * navigatorPattern =
    [HDObjectPattern patternWithURL:@"tt://navigator"
                     propertyValues:@{@"pushedViewControllers" : @[@"functionListViewController",@"todoListViewController"]}
                   propertyRefBeans:nil
                         objectMode:HDObjectModeShare];
    [self setPattern:navigatorPattern forIdentifier:@"navigator"];
    
    ///functionListVC 这个是share的
    HDObjectPattern * functionlistPattern =
    [HDObjectPattern patternWithURL:@"tt://functionListViewController"
                     propertyValues:@{@"title" : @"function"}
                   propertyRefBeans:@{@"dataSource":@"functionDataSource"}
                         objectMode:HDObjectModeShare];
    [self setPattern:functionlistPattern forIdentifier:@"functionListViewController"];
    
    //function dataSource
    HDObjectPattern * functionDataSource =
    [HDObjectPattern patternWithURL:@"tt://functionDataSource"
                     propertyValues:nil
                   propertyRefBeans:@{@"model":@"functionModel",@"listModel" : @"functionModel"}
                         objectMode:HDObjectModeShare];
    [self setPattern:functionDataSource forIdentifier:@"functionDataSource"];
    
    //function model
    HDObjectPattern * functionModel =
    [HDObjectPattern patternWithURL:@"tt://functionModel"
                     propertyValues:@{@"queryURL":@"${base_url}autocrud/ios.ios_function_center.ios_function_center_list/query"}
                   propertyRefBeans:nil
                         objectMode:HDObjectModeShare];
    [self setPattern:functionModel forIdentifier:@"functionModel"];
    
    //todolistVC
    HDObjectPattern * todolistPattern =
    [HDObjectPattern patternWithURL:@"tt://todoListViewController"
                     propertyValues:@{@"title" : @"todo"}
                   propertyRefBeans:@{@"dataSource":@"todoListDataSource",
     @"listModel" : @"todoListModel",
     @"searchViewController":@"todoListSearchViewController"}
                         objectMode:HDObjectModeShare];
    [self setPattern:todolistPattern forIdentifier:@"todoListViewController"];

    //todolist dataSource
    HDObjectPattern * todoListDataSource =
    [HDObjectPattern patternWithURL:@"tt://todoListDataSource"
                     propertyValues:@{@"itemDictionary" : @{@"title" : @"${workflow_name}:${employee_name}",@"caption":@"当前节点: ${node_name}",@"text":@"${workflow_desc}",@"timestamp":@"${creation_date}",@"isLate":@"${is_late}"}}
                   propertyRefBeans:@{@"listModel" : @"todoListModel",
     @"model" : @"todoListModel"}
                         objectMode:HDObjectModeShare];
    [self setPattern:todoListDataSource forIdentifier:@"todoListDataSource"];

    //todoList model
    HDObjectPattern * todoListModel =
    [HDObjectPattern patternWithURL:@"tt://todoListModel"
                     propertyValues:@{@"primaryField":@"record_id",
     @"searchFields":@[@"order_type",@"node_name",@"employee_name"],
     @"queryURL":@"${base_url}autocrud/ios.ios_test.ios_todo_list_test/query?_fetchall=true&amp;_autocount=false",
     @"submitURL":@"${base_url}modules/ios/ios_test/ios_todo_list_commit.svc"}
                   propertyRefBeans:nil
                         objectMode:HDObjectModeShare];
    [self setPattern:todoListModel forIdentifier:@"todoListModel"];
    
    //todolistVC search
    HDObjectPattern * todolistSearchPattern =
    [HDObjectPattern patternWithURL:@"tt://todoListSearchViewController"
                     propertyValues:@{@"title" : @"todoSearch"}
                   propertyRefBeans:@{@"dataSource":@"todoListSearchDataSource",
     @"listModel":@"todoListSearchModel"}
                         objectMode:HDObjectModeShare];
    [self setPattern:todolistSearchPattern forIdentifier:@"todoListSearchViewController"];
    
    //todolist dataSource search
    HDObjectPattern * todoListSearchDataSource =
    [HDObjectPattern patternWithURL:@"tt://todoListDataSource"
                     propertyValues:@{@"itemDictionary" : @{@"title" : @"${workflow_name}:${employee_name}",@"caption":@"当前节点: ${node_name}",@"text":@"${workflow_desc}",@"timestamp":@"${creation_date}",@"isLate":@"${is_late}"}}
                   propertyRefBeans:@{@"listModel" : @"todoListSearchModel",
     @"model" : @"todoListSearchModel"}
                         objectMode:HDObjectModeShare];
    [self setPattern:todoListSearchDataSource forIdentifier:@"todoListSearchDataSource"];
    
    //todoList model search
    [self setPattern:todoListModel forIdentifier:@"todoListSearchModel"];
    
    //done list view controller
    HDObjectPattern *doneListViewCtrl =
    [HDObjectPattern patternWithURL:@"tt://doneListViewController"
                     propertyValues:@{@"title" : @"done list"}
                   propertyRefBeans:@{@"dataSource" : @"doneListDataSource"}
                         objectMode:HDObjectModeShare];
    [self setPattern:doneListViewCtrl forIdentifier:@"doneListViewController"];
    
    //done list datasource
    HDObjectPattern *doneListDataSource =
    [HDObjectPattern patternWithURL:@"tt://doneListDataSource"
                     propertyValues:@{@"itemDictionary" : @{@"title" : @"${workflow_name}:${employee_name}",@"caption":@"当前节点: ${node_name}",@"text":@"${workflow_desc}",@"timestamp":@"${creation_date}"}}
                   propertyRefBeans:@{@"listModel" : @"doneListModel",
     @"model" : @"doneListModel"}
                         objectMode:HDObjectModeShare];
    [self setPattern:doneListDataSource forIdentifier:@"doneListDataSource"];
    
    //done list model
    HDObjectPattern *doneListModel =
    [HDObjectPattern patternWithURL:@"tt://doneListModel"
                     propertyValues:@{@"queryURL" : @"${base_url}autocrud/ios.ios_test.ios_done_list_test/query"}
                   propertyRefBeans:nil
                         objectMode:HDObjectModeShare];
    [self setPattern:doneListModel forIdentifier:@"doneListModel"];
    
    //done detail
    HDObjectPattern * doneDetailViewCtrlPattern =
    [HDObjectPattern patternWithURL:@"tt://doneDetailViewController"
                     propertyValues:@{@"userInfoItemTitle" : @"record_id",
     @"userInfoPageURLTemplate":@"${base_url}modules/mobile/hr_lbr_employee.screen?employee_id=${user_id}",@"webPageURLTemplate":@"${base_url}${screen_name}"}
                   propertyRefBeans:@{@"listModel" : @"doneListModel"}
                         objectMode:HDObjectModeShare];
    [self setPattern:doneDetailViewCtrlPattern forIdentifier:@"doneDetailController"];
    
    //todo detail,这个model从不同的todolistVC接收，因为有search的存在，所以不能在这里配置
    HDObjectPattern * todoDetailViewCtrlPattern =
    [HDObjectPattern patternWithURL:@"tt://todoDetailViewController"
                     propertyValues:@{@"userInfoItemTitle" : @"record_id",
     @"queryActionURLTemplate":@"${base_url}autocrud/ios.ios_test.ios_detail_action_query/query?record_id=${record_id}",
     @"userInfoPageURLTemplate":@"${base_url}modules/mobile/hr_lbr_employee.screen?employee_id=${user_id}",
     @"webPageURLTemplate":@"${base_url}${screen_name}"}
                   propertyRefBeans:nil
                         objectMode:HDObjectModeShare];
    [self setPattern:todoDetailViewCtrlPattern forIdentifier:@"todoDetailController"];
    
    //post view controller
    HDObjectPattern * postControllerPattern =
    [HDObjectPattern patternWithURL:@"tt://postController"
                     propertyValues:nil
                   propertyRefBeans:nil
                         objectMode:HDObjectModeCreate];
    [self setPattern:postControllerPattern forIdentifier:@"postController"];

    //deliver Navigator VC
    HDObjectPattern * deliverNavigatorPattern =
    [HDObjectPattern patternWithURL:@"tt://navigator"
                     propertyValues:@{@"pushedViewControllers" : @[@"deliverController"]}
                   propertyRefBeans:nil
                         objectMode:HDObjectModeCreate];
    [self setPattern:deliverNavigatorPattern forIdentifier:@"deliverNavigator"];
    
    //deliver view controller
    HDObjectPattern * deliverControllerPattern =
    [HDObjectPattern patternWithURL:@"tt://deliverController"
                     propertyValues:@{@"title":@"deliver",
     @"personPickerTextField.placeholder":@"451116"}
                   propertyRefBeans:@{@"delegate":@"todoDetailController",
     @"dataSource":@"personListDataSource"}
                         objectMode:HDObjectModeCreate];
    [self setPattern:deliverControllerPattern forIdentifier:@"deliverController"];
    
    //person list datasource
    HDObjectPattern * personListDataSourcePattern =
    [HDObjectPattern patternWithURL:@"tt://personListDataSource"
                     propertyValues:@{@"itemDictionary" :@{@"text" : @"${name}",
     @"subtitle":@"${position_name}",
     @"userInfo":@"${employee_id}"}}
                   propertyRefBeans:@{@"listModel" : @"personListModel",
     @"model":@"personListModel"}
                         objectMode:HDObjectModeShare];
    [self setPattern:personListDataSourcePattern forIdentifier:@"personListDataSource"];
    
    //person list model
    HDObjectPattern * personListModelPattern =
    [HDObjectPattern patternWithURL:@"tt://personListModel"
                     propertyValues:@{@"queryURL" : @"${base_url}autocrud/ios.ios_deliver.ios_workflow_deliver_query/query"}
                   propertyRefBeans:nil
                         objectMode:HDObjectModeShare];
    [self setPattern:personListModelPattern forIdentifier:@"personListModel"];
    
    
    return YES;
}

-(id)objectForIdentifier:(NSString *)identifier
{
    return [self objectForIdentifier:identifier query:nil];
}

-(id)objectForIdentifier:(NSString *)identifier query:(NSDictionary *)query
{
    id object = nil;
    if (_objectMappings) {
        object = [_objectMappings objectForKey:identifier];
        if (object) {
            return object;
        }
    }
    
    //如果是网页，返回一个网页视图控制器，这样后面的property就可以启用了
    if ([identifier hasPrefix:@"http://"]) {
        return [_objectFactoryMap objectForURL:identifier];
    }
    
    HDObjectPattern * objectPattern =  [self objectPatternForIdentifier:identifier];
    if (objectPattern) {
        object = [_objectFactoryMap objectForURL:objectPattern.url query:query];
        
        //set value properties
        for (NSString * keyPath in [objectPattern.values allKeys]) {
            id value = [objectPattern.values valueForKey:keyPath];
//            id objectProperty = nil;
            
//            if ([value isKindOfClass:[NSString class]]) {
//                //如果是创建路径，从urlMap中获取对象，用于设置颜色等对象值
//                objectProperty = [_objectFactoryMap objectForURL:value];
//            }
        
//            if (objectProperty) {
//                [object setValue:objectProperty forKeyPath:keyPath];
//            }else{
                [object setValue:value forKeyPath:keyPath];
//            }
        }
        
        //set ref properies
        for (NSString * keyPath in [objectPattern.beans allKeys]) {
            NSString * identifier = [objectPattern.beans valueForKey:keyPath];
            [object setValue:[self objectForIdentifier:identifier] forKeyPath:keyPath];
        }
        
        if (objectPattern.objectMode == HDObjectModeShare && object) {
            [self setObject:object forIdentifier:identifier];
        }
    }
    return object;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (HDObjectPattern*)objectPatternForIdentifier:(NSString *)identifier {
    return [_objectPatterns objectForKey:identifier];
}

-(void)setObject:(id)object forIdentifier:(NSString *)identifier
{
    if (nil == _objectMappings) {
        _objectMappings = [[NSMutableDictionary alloc]init];
    }
    [_objectMappings setObject:object forKey:identifier];
}

-(void) setPattern:(HDObjectPattern *) pattern forIdentifier:(NSString *)identifier
{
    if (nil == _objectPatterns) {
        _objectPatterns = [[NSMutableDictionary alloc]init];
    }
    [_objectPatterns setObject:pattern forKey:identifier];
}


-(void)loadMap
{
    if (nil == _objectFactoryMap) {
        _objectFactoryMap = [[TTURLMap alloc]init];
    }
    //
    [_objectFactoryMap from:@"*" toViewController:[HDWebViewController class]];
    
    //guiders
    [_objectFactoryMap from:@"tt://rootGuider/(initWithKeyIdentifier:)" toViewController:[HDRootViewGuider class]];
    
    [_objectFactoryMap from:@"tt://navigatorGuider/(initWithKeyIdentifier:)" toViewController:[HDNavigatorViewGuider class]];
    
    [_objectFactoryMap from:@"tt://modalGuider/(initWithKeyIdentifier:)" toViewController:[HDModalViewGuider class]];
    
    [_objectFactoryMap from:@"tt://showInViewGuider/(initWithKeyIdentifier:)" toViewController:[HDShowInViewGuider class]];
    //view Controllers
    [_objectFactoryMap from:@"tt://LoadingViewController" toViewController:[HDLoadingViewController class]];
    
    //view from nib
    [_objectFactoryMap from:@"tt://nib/(loadFromNib:)/(withClass:)"
    toViewController:[UIApplication sharedApplication].delegate];

    //login
    [_objectFactoryMap from:@"tt://loginModel" toViewController:[HDLoginModel class]];

    //navigationcontroller
    [_objectFactoryMap from:@"tt://navigator" toViewController:[HDNavigationController class]];
    
    //function list classes
    [_objectFactoryMap from:@"tt://functionListViewController" toViewController:[HDFunctionListViewController class]];
    
    [_objectFactoryMap from:@"tt://functionDataSource" toViewController:[HDFunctionListDataSource class]];
    
    [_objectFactoryMap from:@"tt://functionModel" toViewController:[HDFunctionListModel class]];
    
    //todo list classes
    [_objectFactoryMap from:@"tt://todoListViewController" toViewController:[HDTodoListViewController class]];
    
    [_objectFactoryMap from:@"tt://todoListDataSource" toViewController:[HDTodoListDataSource class]];
    
    [_objectFactoryMap from:@"tt://todoListModel" toViewController:[HDTodoListModel class]];
    [_objectFactoryMap from:@"tt://todoListSearchViewController" toViewController:[HDTodoListSearchViewController class]];
    
    //done list classes
    [_objectFactoryMap from:@"tt://doneListViewController" toViewController:[HDDoneListViewController class]];
    
    [_objectFactoryMap from:@"tt://doneListDataSource" toViewController:[HDDoneListDataSource class]];
    
    [_objectFactoryMap from:@"tt://doneListModel" toViewController:[HDDoneListModel class]];
    
    //done detail
    [_objectFactoryMap from:@"tt://doneDetailViewController" toViewController:[HDDetailInfoViewController class]];
    
    [_objectFactoryMap from:@"tt://todoDetailViewController" toViewController:[HDDetailToolbarViewController class]];
    
    //post controller
    [_objectFactoryMap from:@"tt://postController" toViewController:[TTPostController class]];
    
    //deliver controller
    [_objectFactoryMap from:@"tt://deliverController" toViewController:[HDDeliverViewController class]];
    
    //personListDataSource
    [_objectFactoryMap from:@"tt://personListDataSource" toViewController:[HDPersonListDataSource class]];
    
    //person list model
    [_objectFactoryMap from:@"tt://personListModel" toViewController:[HDPersonListModel class]];
}

@end
