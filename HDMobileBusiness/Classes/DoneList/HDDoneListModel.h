//
//  HDDidApprovedListModel.h
//  hrms
//
//  Created by Rocky Lee on 7/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDURLRequestModel.h"

static NSString * kDoneListQueryPath = @"APPROVED_LIST_QUERY_PATH";

@interface HDDoneListModel : HDURLRequestModel

@property(nonatomic,readonly) NSArray * resultList;
@property(nonatomic) NSUInteger pageNum;

@end
