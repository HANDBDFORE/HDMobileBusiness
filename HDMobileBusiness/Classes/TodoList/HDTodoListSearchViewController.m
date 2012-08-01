//
//  HDWillApproveSearchViewController.m
//  hrms
//
//  Created by Rocky Lee on 7/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDTodoListSearchViewController.h"
#import "HDTodoListSearchDataSource.h"
#import "HDDetailSubmitModel.h"

@implementation HDTodoListSearchViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[TTNavigator navigator].URLMap 
         from:[NSString stringWithFormat:@"%@/(%@:)",kOpenWillApproveSearchDetailViewPath ,@"openDetailViewForKey",nil]
         toSharedViewController:self 
         selector:@selector(openDetailViewForKey:)];  
    }
    return self;
}

#pragma mark edit status
-(void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    [self setEditingToolbarItemButtons:editing animated:animated];
    [self setEnableSearchBar:!editing animated:animated];
}

-(void)setEnableSearchBar:(BOOL) enableSearchBar animated:(BOOL)animated
{
    self.superController.searchDisplayController.searchBar.userInteractionEnabled = enableSearchBar;
    [UIView animateWithDuration:animated?0.25:0 animations:^{
        self.superController.searchDisplayController.searchBar.alpha = enableSearchBar? 1:0.5; 
        [self.superController.searchDisplayController.searchBar setShowsCancelButton:enableSearchBar animated:animated];
    }];
}

-(void) setEditingToolbarItemButtons:(BOOL)editing animated:(BOOL)animated
{
    [self.superController setToolbarItems:[self createToolbarItems] animated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setEditingToolbarItemButtons:NO animated:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self revertToolbar];
}

-(void)viewDidUnload
{
    [[TTNavigator navigator].URLMap removeURL:[NSString stringWithFormat:@"%@/(%@:)",kOpenWillApproveSearchDetailViewPath ,@"openDetailViewForKey",nil]];
    [super viewDidUnload];
}

#pragma mark toolbar setting
-(void)revertToolbar
{
    [self.superController setEditing:NO animated:YES];
}

-(NSArray *)createToolbarItems
{
    if (self.editing) {
        return [NSArray arrayWithObjects:_acceptButton,_refuseButton,_space,self.editButtonItem, nil];
    }else {
        return [NSArray arrayWithObjects:_refreshButton,_space,_space,self.editButtonItem, nil];
    } 
}

-(UIViewController *)openDetailViewForKey:(NSString *) key
{
    HDTodoListModel * _approveListModel = (HDTodoListModel *) self.model;
    Approve * _approve = [_approveListModel.searchResultList objectAtIndex:[key intValue]];
    
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
//    [self setEditing:NO animated:NO];
//    //    TTDPRINT(@"%@",indexPaths);
//    [(HDWillAproveListModel*)self.model addObjectAtIndexPathsForSubmit:indexPaths comment:text searching:YES];
//    //    [self reloadIfNeeded];
//}
//#pragma mark viewController life circle

//-(void)viewDidUnload
//{

//    TT_RELEASE_SAFELY(_toolbarModel);
//    TT_RELEASE_SAFELY(_acceptButton);
//    TT_RELEASE_SAFELY(_refuseButton);
//    TT_RELEASE_SAFELY(_space);  
//    [super viewDidUnload];
//}

//-(void)loadView
//{
//    [super loadView];
//    _space = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];

//    self.tableView.height = self.tableView.height - TTToolbarHeight();
//}

//#pragma mark toolBar setting
//-(void)changeToolbar
//{
//    [self.toolbarModel setStatus:kToolbarStatusSearch];
//    [self.superController setToolbarItems:[self.toolbarModel createToolbarItems] animated:YES];
////    [self resetToolBarButtons];
////    [self.superController setToolbarItems:[NSArray arrayWithObjects:_acceptButton,_refuseButton,_space,self.editButtonItem, nil] animated:YES];
//}
//
//-(void)revertToolbar
//{
////    [self resetToolBarButtons];
////    [self.superController setToolbarItems:[NSArray arrayWithObjects:_acceptButton,_space,_refuseButton, nil] animated:YES];
//    [self.toolbarModel setStatus:kToolbarStatusDefault];
//    [self.superController setToolbarItems:[self.toolbarModel createToolbarItems] animated:YES];
//}
//
//-(void) setToolbarButtonTitleWithCount:(NSNumber *)count
//{
//    [self.toolbarModel setButtonTitleCount:count];
//}

//#pragma mark searchBar setting
///////////////////////////////////////////////////////////////////////////////////////////////////
//-(void)setEnableSearchBar:(BOOL) enableSearchBar animated:(BOOL)animated
//{
//    self.searchBar.userInteractionEnabled = enableSearchBar;
//    [UIView animateWithDuration:animated?0.25:0 animations:^{
//        self.searchBar.alpha = enableSearchBar? 1:0.5;
//        [self.searchBar setShowsCancelButton:enableSearchBar animated:animated];
//    }];
//}

///////////////////////////////////////////////////////////////////////////////////////////////////
//-(void)setEditing:(BOOL)editing animated:(BOOL)animated
//{
//    [super setEditing:editing animated:animated];
//    [self.toolbarModel setButtonTitleCount:[NSNumber numberWithInt:0]];
//    [self setEnableSearchBar:!editing animated:animated];
//}

//#pragma mark interface orientation
/////////////////////////////////////////////////////////////////////////////////////////////////////
//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//    return (interfaceOrientation !=UIInterfaceOrientationPortraitUpsideDown);
//}
//
/////////////////////////////////////////////////////////////////////////////////////////////////////
//- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
//                                         duration:(NSTimeInterval)duration {
//    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
//    [self updateToolbarWithOrientation:toInterfaceOrientation];
//}
//
/////////////////////////////////////////////////////////////////////////////////////////////////////
//- (void)updateToolbarWithOrientation:(UIInterfaceOrientation)interfaceOrientation {
////    _tableView.height = self.view.height - TTToolbarHeight();
//}
//
//#pragma mark post view controller
////toolBar button pressed
//-(void)toolBarButtonPressed: (id)sender
//{
//    if ([sender tag]==0) {
//        [(HDWillAproveListModel *)self.model setBatchAction:@"Y"];
//    }else {
//        [(HDWillAproveListModel *)self.model setBatchAction:@"N" ];
//    }
//    [self showPostView];
//}
//
//-(void)showPostView
//{
//    //准备默认审批内容
//    NSString *defaultText = [[NSUserDefaults standardUserDefaults] stringForKey:@"default_approve_preference"];
//    //点击后打开模态视图
//    //    controller.originView = [query objectForKey:@"__target__"];
//    NSDictionary * query = [NSDictionary dictionaryWithObjectsAndKeys:defaultText, @"text",self,@"delegate",nil];
//    
//    [[TTNavigator navigator]openURLAction:[[TTURLAction actionWithURLPath:@"init://postController"]applyQuery:query]]; 
//}
//
//-(void)postController:(TTPostController *)postController didPostText:(NSString *)text withResult:(id)result
//{
//    NSArray * indexPaths = [self.tableView indexPathsForSelectedRows];
//    [(HDWillAproveListModel*)self.model addObjectAtIndexPathsForSubmit:indexPaths comment:text];
//    [self setEditing:NO animated:YES];
//    [self reloadIfNeeded];
//}
//
//-(UIViewController *)openDetailViewForKey:(NSString *) key
//{
//    HDWillAproveListModel * _approveListModel = (HDWillAproveListModel *) self.model;
//    Approve * _approve = [_approveListModel.resultList objectAtIndex:[key intValue]];
//    
//    UIViewController * viewController = [[TTNavigator navigator]viewControllerForURL:@"init://willApproveDetail"];
//    
//    viewController.hidesBottomBarWhenPushed = YES;
//    HDDetailSubmitModel * submitModel = [[HDDetailSubmitModel alloc]init];
//    submitModel.submitData = _approve;
//    
//    
//    [viewController setValue:submitModel forKey:@"submitModel"];
//    //    //get webpage url
//    NSDictionary * urlQuery = [_approve dictionaryWithValuesForKeys:[NSArray arrayWithObjects:@"docPageUrl",@"instanceId", nil]];
//    
//    NSString * webPageUrl = [HDURLCenter requestURLWithKey:kDidApprovedDetailWebPagePath query:urlQuery];
//    
//    NSString * employeeURLPath = [HDURLCenter requestURLWithKey:kDidApprovedEmployeeInfoWebPagePath query:[NSDictionary dictionaryWithObject:_approve.employeeId forKey:@"employeeID"]];
//    
//    [viewController setValue:_approve.rowID forKeyPath:@"rowID"];
//    [viewController setValue:_approve.recordID forKeyPath:@"recordID"];
//    [viewController setValue:_approve.instanceId forKeyPath:@"instanceID"];
//    
//    [viewController setValue:_approve.localStatus forKeyPath:@"localStatus"];
//    [viewController setValue:webPageUrl forKeyPath:@"webPageURLPath"];
//    
//    [viewController setValue:_approve.employeeName forKeyPath:@"employeeName"];
//    [viewController setValue:employeeURLPath forKeyPath:@"employeeURLPath"];
//    return viewController;
//}
//
//-(id<UITableViewDelegate>)createDelegate
//{
//    return  [[[HDWillApproveListDelegate alloc] initWithController:self] autorelease];
//}

@end
