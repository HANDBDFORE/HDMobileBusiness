//
//  HDApproveListDataSource.h
//  hrms
//
//  Created by Rocky Lee on 7/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDTodoListModel.h"

@interface HDTodoListDataSource : TTListDataSource

@property(nonatomic,retain) HDTodoListModel * todoListModel;

@property(nonatomic,retain) NSDictionary * cellItemMap;

@end
