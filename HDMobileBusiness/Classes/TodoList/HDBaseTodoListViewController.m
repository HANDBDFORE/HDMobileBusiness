//
//  HDWillApproveBaseListViewController.m
//  hrms
//
//  Created by Rocky Lee on 7/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDBaseTodoListViewController.h"
#import "HDTodoListDelegate.h"

@implementation HDBaseTodoListViewController
@synthesize refreshTimeLable=_refreshTimeLable;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.variableHeightRows = YES;
        _clearsSelectionOnViewWillAppear = NO; 
    }
    return self;
}

#pragma mark viewController life circle
-(void)loadView
{
    [super loadView];
    _acceptButton = [[UIBarButtonItem alloc]initWithTitle:@"同意" style:UIBarButtonItemStyleBordered target:self action:@selector(toolBarButtonPressed:)]; 
    _acceptButton.width = 100;
    _acceptButton.tintColor = RGBCOLOR(0, 152, 0);
    _acceptButton.tag = 1;
    
    _refuseButton = [[UIBarButtonItem alloc]initWithTitle:@"拒绝" style:UIBarButtonItemStyleBordered target:self action:@selector(toolBarButtonPressed:)];         
    _refuseButton.width = 100;
    _refuseButton.tag = 0;
    
    _space = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    _refreshButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshButtonPressed:)];
    _composeButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:nil action:nil];
    _states = [[UIBarButtonItem alloc]initWithTitle:@"loading" style:UIBarButtonItemStylePlain target:nil action:nil];

    [self resetButtonTitle];
}

-(void)resetButtonTitle
{
    _acceptButton.title = @"同意";
    _acceptButton.enabled = NO;
    
    _refuseButton.title = @"拒绝";
    _refuseButton.enabled = NO;
}


- (void)viewDidUnload
{
    [_refreshTimeLable removeFromSuperview];
    TT_RELEASE_SAFELY(_refuseButton);
    TT_RELEASE_SAFELY(_acceptButton);
    TT_RELEASE_SAFELY(_refreshButton);
    TT_RELEASE_SAFELY(_composeButton);
    TT_RELEASE_SAFELY(_states);
    TT_RELEASE_SAFELY(_space);
    TT_RELEASE_SAFELY(_refreshTimeLable);
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(void)setToolbarButtonTitleWithCount:(NSNumber *)count
{
    if (count.intValue >0) {
        _refuseButton.title = [NSString stringWithFormat:@"拒绝(%@)",count];
        _refuseButton.enabled = YES;
        _acceptButton.title = [NSString stringWithFormat:@"同意(%@)",count];
        _acceptButton.enabled = YES;
    }
    else {
        [self resetButtonTitle]; 
    }
}
///////////////////////////////////////////////////////////////////////////////////////////////////
-(void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    [self resetButtonTitle];
    if(editing){
        self.editButtonItem.title = @"取消";
         _refreshTimeLable.hidden = YES;
    }else {
        self.editButtonItem.title = @"批量";
         _refreshTimeLable.hidden = NO;
    }
}


#pragma mark interface orientation
///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation!=UIInterfaceOrientationPortraitUpsideDown);
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self.tableView reloadData];
}

#pragma refresh
-(void)refreshButtonPressed:(id)sender
{
    [self.model load:TTURLRequestCachePolicyNetwork more:NO];
}

#pragma mark post view controller
//toolBar button pressed
-(void)toolBarButtonPressed: (id)sender
{    
    if ([self.model respondsToSelector:@selector(setSubmitAction:)]) {
        [self.model performSelector:@selector(setSubmitAction:)
                         withObject:[self createBatchAction:[sender tag]]];
    }
    [self showPostView];
}

-(NSString *)createBatchAction:(NSUInteger) tag
{
    if (tag== 1) {
        return @"Y";
    }else {
        return @"N";
    }
}

-(void)showPostView
{
    //准备默认审批内容
    NSString *defaultText = [[NSUserDefaults standardUserDefaults] stringForKey:@"default_approve_preference"];
    //点击后打开模态视图
    //    controller.originView = [query objectForKey:@"__target__"];
    NSDictionary * query = [NSDictionary dictionaryWithObjectsAndKeys:defaultText, @"text",self,@"delegate",@"审批意见",@"title",nil];
    
    [[TTNavigator navigator]openURLAction:[[TTURLAction actionWithURLPath:@"init://postController"]applyQuery:query]]; 
}

-(void)postController:(TTPostController *)postController didPostText:(NSString *)text withResult:(id)result
{
    NSArray * indexPaths = [self.tableView indexPathsForSelectedRows];
    if ([self.model respondsToSelector:@selector(addObjectAtIndexPathsForSubmit:comment:)]) {
        [self.model performSelector:@selector(addObjectAtIndexPathsForSubmit:comment:)  withObject:indexPaths withObject:text];
    }
    [self setEditing:NO animated:YES];
}

-(UIViewController *)openDetailViewForKey:(NSString *) key
{
    return nil;
}

-(id<UITableViewDelegate>)createDelegate
{
    return  [[[HDTodoListDelegate alloc] initWithController:self] autorelease];
}

@end
