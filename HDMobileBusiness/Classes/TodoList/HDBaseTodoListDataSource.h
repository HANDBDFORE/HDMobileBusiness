//
//  HDWillApproveListBaseDataSource.h
//  hrms
//
//  Created by Rocky Lee on 7/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDTodoListModel.h"
#import "HDTableStatusMessageItemCell.h"

static NSString * kTodoListDetailWebPagePath = @"APPROVE_DETIAL_WEB_PAGE_PATH";

static NSString * kUserInfoWebPagePath = @"EMPLOYEE_INFO_WEB_URL";

static NSString * kOpenWillApproveDetailViewPath = @"open://willApproveDetailViewController";

@interface HDBaseTodoListDataSource : TTListDataSource

@property(nonatomic,retain) HDTodoListModel * todoListModel;

-(TTTableItem *) createItemWithObject:(id) object;

//-(id)initWithModel:(id<TTModel>) model;

@end
