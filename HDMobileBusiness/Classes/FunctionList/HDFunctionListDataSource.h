//
//  HDTableImageSectionDataSource.h
//  hrms
//
//  Created by Rocky Lee on 6/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "../HDVector.h"

@interface HDFunctionListModel : HDURLRequestModel<HDListModelQuery>
{
    NSMutableArray * _resultList;
}

@property(nonatomic,copy) NSString * queryURL;

@end

@interface HDFunctionListDataSource : TTSectionedDataSource

@property(nonatomic,assign) id<HDListModelQuery> listModel;
@property(nonatomic,retain) NSDictionary * cellItemMap;

@end
