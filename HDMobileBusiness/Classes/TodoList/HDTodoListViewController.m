//
//  HDApproveListViewController.m
//  hrms
//
//  Created by Rocky Lee on 7/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDTodoListViewController.h"
#import "HDTodoListDataSource.h"
#import "HDTodoListSearchViewController.h"
#import "HDTodoListSearchDataSource.h"
#import "HDDetailSubmitModel.h"

@implementation HDTodoListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"待办事项";
        [[TTNavigator navigator].URLMap 
         from:[NSString stringWithFormat:@"%@/(%@:)",kOpenWillApproveDetailViewPath ,@"openDetailViewForKey",nil]
         toSharedViewController:self 
         selector:@selector(openDetailViewForKey:)];
    }
    return self;
}

#pragma mark viewController life circle

-(void)loadView
{
    [super loadView];
    //tab图标
    self.tabBarItem.image = [UIImage imageNamed:@"mailclosed.png"];
    //初始化导航条右侧按钮
    self.editButtonItem.title = @"批量";
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //tool bar
    [self.navigationController setToolbarHidden:NO animated:NO]; 
    _refreshTimeLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0,self.view.width,TTToolbarHeight())];
    _refreshTimeLable.textAlignment = UITextAlignmentCenter;
    _refreshTimeLable.textColor = [ UIColor whiteColor];
    _refreshTimeLable.shadowColor = RGBCOLOR(68, 68, 68);
    _refreshTimeLable.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    _refreshTimeLable.backgroundColor=[UIColor clearColor];
    _refreshTimeLable.font=[UIFont fontWithName:@"Helvetica-Bold" size:12];
    [self.navigationController.toolbar insertSubview:_refreshTimeLable  atIndex:1 ];
    [self setEditingToolbarItemButtons:NO animated:YES];
    [self.navigationController.toolbar setTintColor:TTSTYLEVAR(toolbarTintColor)];
    //search bar
    HDTodoListSearchViewController* searchController = [[[HDTodoListSearchViewController alloc] init] autorelease];
    searchController.refreshTimeLable  = _refreshTimeLable;
    self.searchViewController = searchController;
    _searchController.searchBar.tintColor = TTSTYLEVAR(searchBarTintColor);
    self.tableView.tableHeaderView = _searchController.searchBar;
    self.tableView.contentOffset = CGPointMake(0, TTToolbarHeight());
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setToolbarHidden:NO animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setToolbarHidden:YES animated:YES];
}

-(void)viewDidUnload
{
    [[TTNavigator navigator].URLMap removeURL:[NSString stringWithFormat:@"%@/(%@:)",kOpenWillApproveDetailViewPath ,@"openDetailViewForKey",nil]];
    [super viewDidUnload];
}

#pragma mark TTModelViewControler functions
-(void)createModel
{
    id <TTModel> model = [[HDTodoListModel alloc]init];
    self.dataSource = [[[HDTodoListDataSource alloc]initWithModel:model]autorelease];
    
    self.searchViewController.dataSource = [[[HDTodoListSearchDataSource alloc] initWithModel:model]autorelease];
    TT_RELEASE_CF_SAFELY(model);
}

//////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark edit status
-(void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    [self setEditingToolbarItemButtons:editing animated:animated];
    [self setEnableSearchBar:!editing animated:animated];
    [self.navigationItem setHidesBackButton:editing animated:animated];
    
}

//////////////////////////////////////////////////////////////////////////////////////////////////
-(void)setEnableSearchBar:(BOOL) enableSearchBar animated:(BOOL)animated
{
    self.searchDisplayController.searchBar.userInteractionEnabled = enableSearchBar;
    [UIView animateWithDuration:animated?0.25:0 animations:^{
        self.searchDisplayController.searchBar.alpha = enableSearchBar? 1:0.5;  
    }];
}

//////////////////////////////////////////////////////////////////////////////////////////////////
-(void) setEditingToolbarItemButtons:(BOOL)editing animated:(BOOL)animated
{
    [self setToolbarItems:[self createToolbarItems] animated:YES];
}

//////////////////////////////////////////////////////////////////////////////////////////////////
-(NSArray *)createToolbarItems
{
    if (self.editing) {
        return [NSArray arrayWithObjects:_acceptButton,_space,_refuseButton, nil];
    }else {
        return [NSArray arrayWithObjects:_refreshButton,_space,nil];
    } 
}

-(UIViewController *)openDetailViewForKey:(NSString *) key
{
    HDTodoListModel * _approveListModel = (HDTodoListModel *) self.model;
    Approve * _approve = [_approveListModel.resultList objectAtIndex:[key intValue]];
    
    UIViewController * viewController = [[TTNavigator navigator]viewControllerForURL:@"init://willApproveDetail"];
    
    viewController.hidesBottomBarWhenPushed = YES;
    HDDetailSubmitModel * submitModel = [[[HDDetailSubmitModel alloc]init] autorelease];
    submitModel.submitData = _approve;
    
    
    [viewController setValue:submitModel forKey:@"submitModel"];
    //    //get webpage url
    NSDictionary * urlQuery = [_approve dictionaryWithValuesForKeys:[NSArray arrayWithObjects:@"docPageUrl",@"instanceId", nil]];
    
    NSString * webPageUrl = [HDURLCenter requestURLWithKey:kTodoListDetailWebPagePath query:urlQuery];
    
    NSString * employeeURLPath = [HDURLCenter requestURLWithKey:kUserInfoWebPagePath query:[NSDictionary dictionaryWithObject:_approve.employeeId forKey:@"employeeID"]];
    
    [viewController setValue:_approve.rowID forKeyPath:@"rowID"];
    [viewController setValue:_approve.recordID forKeyPath:@"recordID"];
    [viewController setValue:_approve.instanceId forKeyPath:@"instanceID"];
    
    [viewController setValue:_approve.localStatus forKeyPath:@"localStatus"];
    [viewController setValue:webPageUrl forKeyPath:@"webPageURLPath"];
    
    [viewController setValue:_approve.employeeName forKeyPath:@"employeeName"];
    [viewController setValue:employeeURLPath forKeyPath:@"employeeURLPath"];
    return viewController;
}
//-(void)postController:(TTPostController *)postController didPostText:(NSString *)text withResult:(id)result
//{
//    NSArray * indexPaths = [self.tableView indexPathsForSelectedRows];
//    [self setEditing:NO animated:YES];
//    //    TTDPRINT(@"%@",indexPaths);
//    [(HDWillAproveListModel*)self.model addObjectAtIndexPathsForSubmit:indexPaths comment:text searching:NO];
//    //    [self reloadIfNeeded];
//}
//#pragma mark custom functions
//-(void)postController:(TTPostController *)postController didPostText:(NSString *)text withResult:(id)result
//{
//    NSArray * indexPaths = [self.tableView indexPathsForSelectedRows];
//    [(HDWillAproveListModel*)self.model addObjectAtIndexPathsForSubmit:indexPaths comment:text];
//    [self.searchViewController setEditing:NO animated:YES];
//    [self reloadIfNeeded];
//}
//set toolbar
//-(void)showToolBar
//{
//    [self resetToolBarButtons];
//    UIBarButtonItem * space = [[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil] autorelease];
////    _toolbar.hidden = NO;
////    _toolbar.items = [NSArray arrayWithObjects:space,_acceptButton,_refuseButton,space, nil];
//    [self setToolbarItems:[NSArray arrayWithObjects:space,_acceptButton,_refuseButton,space, nil] animated:YES];
////    _toolbar.top = TTScreenBounds().size.height-TTToolbarHeight();
//    self.tableView.frame = HDNavigationStatusbarFrame();
//}

//-(void)hideToolbar
//{
//    self.navigationController.toolbar.hidden =YES;
//}

//-(void)setHidesToolBar:(BOOL) hidesToolbar animated:(BOOL) animated
//{
//    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationDuration:animated?0.25:0];
//    UIToolbar * _toolbar = self.navigationController.toolbar;
//    if (hidesToolbar) {
//        self.tableView.height = self.view.height;
//        _toolbar.top = TTScreenBounds().size.height;
//        [self resetToolBarButtons];
//    }
//    else {
//        self.tableView.height = self.view.height-TTToolbarHeight();
//        _toolbar.top = TTScreenBounds().size.height-TTToolbarHeight();
//    }
//    [UIView commitAnimations];
//}



@end
