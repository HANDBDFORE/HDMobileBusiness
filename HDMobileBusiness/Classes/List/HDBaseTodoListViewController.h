//
//  HDBaseTodoListViewController.h
//  HandMobile
//
//  Created by Rocky Lee on 7/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDListViewController.h"
#import "TTTableViewController+Select.h"
#import "HDDetailToolbarViewController.h"

static NSString * kEventTodoListSearchViewWillDissappear = @"TodoListSearchViewWillDissappear";

@interface HDBaseTodoListViewController : HDListViewController<TTPostControllerDelegate>
{
    @protected
    UIBarButtonItem *  _acceptButtonItem;
    UIBarButtonItem *  _refuseButtonItem;
    UIBarButtonItem *  _clearButtonItem;
    NSString        *  _submitAction;
}

@property(nonatomic,assign) id <HDTodoListService,HDPageTurning> model;

@property(nonatomic,retain) HDDetailToolbarViewController * detailViewController;

//-(void)setToolbarButtonWithCount:(NSNumber *)count;

#pragma -override
-(void)refreshButtonPressed:(id) sender;

-(void)setEditing:(BOOL)editing animated:(BOOL)animated;

-(void)modelDidFinishLoad:(id<TTModel>)model;

-(id<UITableViewDelegate>)createDelegate;

#pragma -implement TTPostControllerDelegate
-(void)postController:(TTPostController *)postController didPostText:(NSString *)text withResult:(id)result;

@end
