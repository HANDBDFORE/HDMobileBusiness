//
//  HDTableImageSectionDataSource.h
//  hrms
//
//  Created by Rocky Lee on 6/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

@interface HDFunctionListModel : HDURLRequestModel
{
    NSMutableArray * _resultList;
}

@property(nonatomic,readonly) NSArray * resultList;
@property(nonatomic,copy) NSString * queryURL;

@end

@interface HDFunctionListDataSource : TTSectionedDataSource

@property(nonatomic,readonly) HDFunctionListModel * functionListModel;
@property(nonatomic,retain) NSDictionary * cellItemMap;

@end
