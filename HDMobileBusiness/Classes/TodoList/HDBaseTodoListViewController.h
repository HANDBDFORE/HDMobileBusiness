//
//  HDWillApproveBaseListViewController.h
//  hrms
//
//  Created by Rocky Lee on 7/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

//#import "HDWillApproveToolBarModel.h"
//#import "HDDetailSubmitModel.h"

@interface HDBaseTodoListViewController : TTTableViewController<TTPostControllerDelegate>
{
    UIBarButtonItem *  _acceptButton;
    UIBarButtonItem *  _refuseButton;
    UIBarButtonItem *  _refreshButton;
    UIBarButtonItem *  _composeButton;
    UIBarButtonItem *  _states;
    UIBarButtonItem *  _space;
}

@end
