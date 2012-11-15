//
//  HDTodoListViewController.m
//  HandMobile
//
//  Created by Rocky Lee on 7/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDTodoListViewController.h"
#import "HDTodoListSearchViewController.h"

static NSString * kSearchPathName = @"TODO_LIST_SEARCH";

@implementation HDTodoListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"待办事项";
        [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(reload)
         name:kEventTodoListSearchViewWillDissappear
         object:nil];
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
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //tool bar
    [self.navigationController setToolbarHidden:NO animated:YES];
    [self setEditingToolbarItemButtons:NO animated:YES];
    
    //search bar
//    HDTodoListSearchViewController* searchViewController = [[[HDTodoListSearchViewController alloc] init] autorelease];
    HDTodoListSearchViewController * searchViewController =
    (HDTodoListSearchViewController *)[[HDGuider guider] controllerWithKeyPath:kSearchPathName query:nil];
//    searchViewController.dataSource = self.dataSource;
    self.searchViewController = searchViewController;
    
    _searchController.searchBar.tintColor = TTSTYLEVAR(searchBarTintColor);
    self.tableView.tableHeaderView = _searchController.searchBar;
    self.tableView.contentOffset = CGPointMake(0, TTToolbarHeight());
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.toolbar setTintColor:TTSTYLEVAR(toolbarTintColor)];
    [self.navigationController setToolbarHidden:NO animated:YES];
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
        return [NSArray arrayWithObjects:_acceptButtonItem,_space,_refuseButtonItem, nil];
    }else {
        return [NSArray arrayWithObjects:_space,_stateLabelItem,_space,nil];
    } 
}

@end
