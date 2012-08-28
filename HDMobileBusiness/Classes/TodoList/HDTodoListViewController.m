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

@implementation HDTodoListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"待办事项";
        self.dataSource = [[[HDTodoListDataSource alloc]init]autorelease];
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
    self.searchViewController.dataSource = self.dataSource;
    self.tableView.contentOffset = CGPointMake(0, TTToolbarHeight());
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self.navigationController setToolbarHidden:NO animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [self.navigationController setToolbarHidden:YES animated:YES];
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
        return [NSArray arrayWithObjects:_refreshButton,_space,_clearButton,nil];
    } 
}

@end
