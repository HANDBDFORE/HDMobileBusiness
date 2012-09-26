//
//  HDApproveListDataSource.h
//  hrms
//
//  Created by Rocky Lee on 7/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDTodoListModel.h"
#import "HDTableDataSource.h"

@interface HDTodoListDataSource : TTListDataSource <HDTableDataSource>

@property(nonatomic,assign) id<HDListModelVector,HDListModelSubmit> listModel;

@end
