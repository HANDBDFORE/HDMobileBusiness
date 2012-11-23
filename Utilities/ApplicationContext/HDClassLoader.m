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

@implementation HDClassLoader

+(void)loadURLMap:(TTURLMap *) map
{
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
    
    //navigationcontroller
    [map from:@"tt://navigator" toViewController:[HDNavigationController class]];
    
    //function list classes
    [map from:@"tt://functionListViewController" toViewController:[HDFunctionListViewController class]];
    
    [map from:@"tt://functionDataSource" toViewController:[HDFunctionListDataSource class]];
    
    [map from:@"tt://functionModel" toViewController:[HDFunctionListModel class]];
    
    //todo list classes
    [map from:@"tt://todoListViewController" toViewController:[HDTodoListViewController class]];
    
    [map from:@"tt://todoListDataSource" toViewController:[HDTodoListDataSource class]];
    
    [map from:@"tt://todoListModel" toViewController:[HDTodoListModel class]];
    [map from:@"tt://todoListSearchViewController" toViewController:[HDTodoListSearchViewController class]];
    
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
}

@end
