//
//  HDBaseTodoListViewController.h
//  HandMobile
//
//  Created by Rocky Lee on 7/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import "HDTodoListDataSource.h"

static NSString * kEventTodoListSearchViewWillDissappear = @"TodoListSearchViewWillDissappear";

@interface HDBaseTodoListViewController : TTTableViewController<TTPostControllerDelegate>
{
    @protected
    UIBarButtonItem *  _acceptButtonItem;
    UIBarButtonItem *  _refuseButtonItem;
    UIBarButtonItem *  _refreshButtonItem;
    UIBarButtonItem *  _composeButtonItem;
    UIBarButtonItem *  _clearButtonItem;
    UIBarButtonItem *  _stateLabelItem;
    TTLabel         *  _timeStampLabel;
    UIBarButtonItem *  _space;
    
    NSString        *  _submitAction;
}

@property(nonatomic,assign) id <HDListModelSubmit> listModel;

-(void)setToolbarButtonTitleWithCount:(NSNumber *)count;

@end
