//
//  HDConfigLoader.m
//  Three20Lab
//
//  Created by Rocky Lee on 5/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDClassLoader.h"
//user help
#import "HDUserGuideViewController.h"
//loading
#import "HDLoadingViewController.h"
//login
#import "HDLoginViewController.h"
//function list
#import "HDFunctionListViewController.h"
#import "HDFunctionListDataSource.h"
//todo list
#import "HDTodoListViewController.h"
#import "HDTodoListDataSource.h"
#import "HDTodoListModel.h"
//done list
#import "HDDoneListViewController.h"
#import "HDDoneListDataSource.h"
#import "HDDoneListModel.h"
//done detail
#import "HDDetailInfoViewController.h"
//todo detail
#import "HDDetailToolbarViewController.h"
//navigation
#import "HDNavigationController.h"
//web view
#import "HDWebViewController.h"
//deliver
#import "HDDeliverViewController.h"
//person choice for deliver
#import "HDPersonListDataSource.h"

#import "HDTodoListService.h"
#import "HDTodoListSearchService.h"
//pad
#import "HDSplitViewController.h"

#import "HDDoneListViewController_Pad.h"
//gloable
#import "HDResourceLoader.h"

@implementation HDClassLoader

+(void)loadURLMap:(TTURLMap *) map
{
    //通过资源加载器获取资源对象，资源会通过load对象下载到本地然后通过url获取资源对象，资源通过identifirer标识
    [map from:@"tt://image/(imageWithIdentifier:)" toObject:[HDResourceLoader shareLoader] selector:@selector(imageWithIdentifier:)];
    
    //
    [map from:@"*" toViewController:[HDWebViewController class]];
    
    //guiders
    [map from:@"tt://rootGuider/(initWithKeyIdentifier:)" toViewController:[HDRootViewGuider class]];
    
    [map from:@"tt://navigatorGuider/(initWithKeyIdentifier:)" toViewController:[HDNavigatorViewGuider class]];
    
    [map from:@"tt://modalGuider/(initWithKeyIdentifier:)" toViewController:[HDModalViewGuider class]];
    
    [map from:@"tt://showInViewGuider/(initWithKeyIdentifier:)" toViewController:[HDShowInViewGuider class]];   
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////    
    //view Controllers
    [map from:@"tt://LoadingViewController" toViewController:[HDLoadingViewController class]];
        
    [map from:@"tt://UserGuideViewController" toViewController:[HDUserGuideViewController class]];
    
    //login
    [map from:@"tt://loginModel" toViewController:[HDLoginModel class]];
    //autologin
    [map from:@"tt://autologinModel" toViewController:[HDAutologinModel class]];
    //navigationcontroller
    [map from:@"tt://navigator" toViewController:[HDNavigationController class]];
    
    [map from:@"tt://navigator/(initWithNavigationBarClassName:)/(toolbarClassName:)" toViewController:[HDNavigationController class]];
    
    //function list classes
    [map from:@"tt://functionListViewController" toViewController:[HDFunctionListViewController class]];
    
    [map from:@"tt://functionDataSource" toViewController:[HDFunctionListDataSource class]];
    
    [map from:@"tt://functionModel" toViewController:[HDFunctionListModel class]];
    
    //todo list classes
    [map from:@"tt://todoListViewController" toViewController:[HDTodoListViewController class]];
    
    [map from:@"tt://todoListDataSource" toViewController:[HDTodoListDataSource class]];
    
    [map from:@"tt://todoListModel" toViewController:[HDTodoListModel class]];
    
    [map from:@"tt://todoListSearchViewController" toViewController:[HDTodoListSearchViewController class]];
    
    [map from:@"tt://todoListService" toViewController:[HDTodoListService class]];
    
    [map from:@"tt://todoListSearchService" toViewController:[HDTodoListSearchService class]];
    //todo action
    [map from:@"tt://actionModel" toViewController:[HDActionModel class]];
    //done list classes
    [map from:@"tt://doneListViewController" toViewController:[HDDoneListViewController class]];
    
    [map from:@"tt://doneListDataSource" toViewController:[HDDoneListDataSource class]];
    
    [map from:@"tt://doneListModel" toViewController:[HDDoneListModel class]];
    
    //done detail
    [map from:@"tt://doneDetailViewController" toViewController:[HDDetailInfoViewController class]];
    
    [map from:@"tt://todoDetailViewController" toViewController:[HDDetailToolbarViewController class]];
    
    //post controller
    [map from:@"tt://postController" toViewController:[TTPostController class]];
    
    //deliver controller
    [map from:@"tt://deliverController" toViewController:[HDDeliverViewController class]];
    
    //personListDataSource
    [map from:@"tt://personListDataSource" toViewController:[HDPersonListDataSource class]];
    
    //person list model
    [map from:@"tt://personListModel" toViewController:[HDPersonListModel class]];
    
    [map from:@"tt://resourceLoader" toObject:[HDResourceLoader class] selector:@selector(shareLoader)];

    [map from:@"tt://imageLoader" toViewController:[HDImageLoader class]];
    
    if (TTIsPad()) {
        [map from:@"tt://splitViewGuider/(initWithKeyIdentifier:)" toViewController:[HDSplitViewGuider class]];
        
        [map from:@"tt://doneListViewController" toViewController:[HDDoneListViewController_Pad class]];
        
        [map from:@"tt://splitViewController" toViewController:[HDSplitViewController class]];
    }
}

@end
