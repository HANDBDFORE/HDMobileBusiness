//
//  HDWillApproveListBaseDataSource.h
//  hrms
//
//  Created by Rocky Lee on 7/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDTodoListModel.h"
#import "HDTableStatusMessageItemCell.h"

static NSString * kDidApprovedDetailWebPagePath = @"APPROVE_DETIAL_WEB_PAGE_PATH";

static NSString * kDidApprovedEmployeeInfoWebPagePath = @"EMPLOYEE_INFO_WEB_URL";

@interface HDBaseTodoListDataSource : TTListDataSource

@property(nonatomic,retain) HDTodoListModel * approveListModel;

-(TTTableItem *) createItemWithObject:(id) object;

-(id)initWithModel:(id<TTModel>) model;

@end