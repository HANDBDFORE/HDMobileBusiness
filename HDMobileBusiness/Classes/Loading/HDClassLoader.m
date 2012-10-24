//
//  HDConfigLoader.m
//  Three20Lab
//
//  Created by Rocky Lee on 5/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDClassLoader.h"

#import "HDWebViewController.h"
#import "HDLoadingViewController.h"
#import "HDUserGuideViewController.h"
#import "HDDeliverViewController.h"
#import "HDTodoListViewController.h"
#import "HDDoneListViewController.h"
#import "HDFunctionListViewController.h"
#import "HDDetailToolbarViewController.h"

@implementation HDClassLoader

+(void)startLoad
{
    //初始化guider的url注册
    [HDGuider guider];
    
    TTNavigator * navigator = [TTNavigator navigator];
    
    [navigator.URLMap from:@"*" toSharedViewController:[HDWebViewController class]];
    
    [navigator.URLMap from:@"init://LoadingViewController" toModalViewController:[HDLoadingViewController class]];
    
    [navigator.URLMap from:@"init://HDUserGuideViewController" toSharedViewController:[HDUserGuideViewController class]];
    
//    <class name="HDTodoListViewController" navigation_mode="create" parent="guide://shareViewControler/FUNCTION_LIST_VC_PATH" url="init://todoListViewController"/>
    [navigator.URLMap from:@"init://todoListViewController"
                    parent:@"guide://shareViewControler/FUNCTION_LIST_VC_PATH"
          toViewController:[HDTodoListViewController class]
                  selector:nil
                transition:0];
    
//    <class name="HDTodoListSearchViewController" navigation_mode="create" url="init://todoListSearchViewController"/>
    [navigator.URLMap from:@"init://todoListSearchViewController" toViewController:[HDTodoListSearchViewController class]];
    
//    <class name="HDDoneListViewController" navigation_mode="create" parent="guide://shareViewControler/FUNCTION_LIST_VC_PATH" url="init://doneListViewController"/>
    [navigator.URLMap from:@"init://doneListViewController"
                    parent:@"guide://shareViewControler/FUNCTION_LIST_VC_PATH"
          toViewController:[HDDoneListViewController class]
                  selector:nil
                transition:0];
    
//    <class name="HDFunctionListViewController" navigation_mode="share" url="init://functionListViewController"/>
    [navigator.URLMap from:@"init://functionListViewController" toSharedViewController:[HDFunctionListViewController class]];
    
//    <class name="HDDetailToolbarViewController"  navigation_mode="create" url="init://toolbarDetailViewController"/>
    [navigator.URLMap from:@"init://toolbarDetailViewController" toViewController:[HDDetailToolbarViewController class]];
    
//    <class name="HDDetailInfoViewController" navigation_mode="create" url="init://detailViewController"/>
    [navigator.URLMap from:@"init://detailViewController" toViewController:[HDDetailToolbarViewController class]];
    
//    <class name="TTPostController" navigation_mode="share" url="init://postController"/>
    [navigator.URLMap from:@"init://postController" toSharedViewController:[TTPostController class]];
    
    [navigator.URLMap from:@"init://deliverViewController" toModalViewController:[HDDeliverViewController class]];
    
    //nibs
    id delegate =  [UIApplication sharedApplication].delegate;

    [navigator.URLMap from:@"init://shareNib/(loadFromNib:)" toSharedViewController:delegate];
    [navigator.URLMap from:@"init://shareNib/(loadFromNib:)/(withClass:)"
    toSharedViewController:delegate];

    [navigator.URLMap from:@"init://modalNib/(loadFromNib:)" toModalViewController:delegate];
    [navigator.URLMap from:@"init://modalNib/(loadFromNib:)/(withClass:)"
     toModalViewController:delegate];
}

@end
