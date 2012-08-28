//
//  HDWillApproveBaseListViewController.h
//  hrms
//
//  Created by Rocky Lee on 7/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

@interface HDBaseTodoListViewController : TTTableViewController<TTPostControllerDelegate>
{
    @protected
    UIBarButtonItem *  _acceptButton;
    UIBarButtonItem *  _refuseButton;
    UIBarButtonItem *  _refreshButton;
    UIBarButtonItem *  _composeButton;
    UIBarButtonItem *  _clearButton;
    UIBarButtonItem *  _space;
    UILabel         *  _refreshTimeLable;
    
    NSString        *  _submitAction;
}
@property(nonatomic,retain) UILabel *refreshTimeLable;

-(void)setToolbarButtonTitleWithCount:(NSNumber *)count;

@end
