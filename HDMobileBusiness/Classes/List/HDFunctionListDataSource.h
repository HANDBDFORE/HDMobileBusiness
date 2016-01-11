//
//  HDTableImageSectionDataSource.h
//  hrms
//
//  Created by Rocky Lee on 6/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDListModel.h"
#import "HDTableDataSource.h"

@interface HDFunctionListModel : HDURLRequestModel<HDListModelQuery>
{
    NSMutableArray * _resultList;
}

@property(nonatomic,copy) NSString * queryURL;

@property(nonatomic,readonly) NSArray * resultList;

@end


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface HDFunctionListDataSource : TTSectionedDataSource <HDTableDataSource,UIAlertViewDelegate>

@property(nonatomic,retain) id<HDListModelQuery> model;

@property(nonatomic,assign) BOOL shouldLoadBasicItems;

#pragma -override
@property(nonatomic,retain) NSDictionary * itemDictionary;

@end
