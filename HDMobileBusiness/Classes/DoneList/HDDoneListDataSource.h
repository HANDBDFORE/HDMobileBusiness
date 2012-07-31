//
//  ApprovedListDataSource.h
//  hrms
//
//  Created by Rocky Lee on 5/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDDoneListModel.h"

static NSString * kOpenDidApprovedDetailViewPath = @"open://didApprovedDetailViewController";

static NSString * kDidApprovedDetailWebPagePath = @"APPROVE_DETIAL_WEB_PAGE_PATH";

static NSString * kDidApprovedEmployeeInfoWebPagePath = @"EMPLOYEE_INFO_WEB_URL";

@interface HDDoneListDataSource : TTListDataSource

@property(nonatomic,readonly) HDDoneListModel * approvedListModel;

@end
