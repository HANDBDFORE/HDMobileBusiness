//
//  ApprovedListDataSource.h
//  hrms
//
//  Created by Rocky Lee on 5/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDDoneListModel.h"

@interface HDDoneListDataSource : TTListDataSource

@property(nonatomic,readonly) HDDoneListModel * doneListModel;

@property(nonatomic,retain) NSDictionary * cellItemMap;

@end
