//
//  HDTodoListViewController.m
//  HandMobile
//
//  Created by Rocky Lee on 7/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDTodoListViewController.h"
#import "HDTodoListSearchViewController.h"

@implementation HDTodoListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = TTLocalizedString(@"Todo List", @"");
    }
    return self;
}

#pragma mark viewController life circle

-(void)loadView
{
    [super loadView];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    //tab图标
    self.tabBarItem.image = [UIImage imageNamed:@"mailclosed.png"];
    
    //初始化导航条右侧按钮
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    //tool bar
    [self setEditingToolbarItemButtons:NO animated:YES];
    
    _searchController.searchBar.tintColor = TTSTYLEVAR(searchBarTintColor);
    self.tableView.tableHeaderView = _searchController.searchBar;
//    self.tableView.contentOffset = CGPointMake(0, TTToolbarHeight());
}
//-(void)viewDidLoad
//{
//    [super viewDidLoad];
//    [self.navigationController setToolbarHidden:NO animated:NO];
//}
//-(void)viewWillAppear:(BOOL)animated
//{
//    if ([_searchController isActive]) {
//        [self.searchViewController viewWillAppear:animated];
//    }else{
//        [super viewWillAppear:animated];
//        [self.navigationController setToolbarHidden:NO animated:NO];
//    }
//}
-(void)viewDidAppear:(BOOL)animated
{
//    NSLog(@"todolistDidAppear");
    [super viewDidAppear:animated];
    [self.navigationController setToolbarHidden:NO animated:YES];
    
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
        return [NSArray arrayWithObjects:_acceptButtonItem,self.spaceItem,_refuseButtonItem, nil];
    }else {
        return [NSArray arrayWithObjects:self.spaceItem,self.timeStampItem,self.spaceItem,nil];
    }
}

@end
