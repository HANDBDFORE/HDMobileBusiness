//
//  HDTableImageSectionDataSource.h
//  hrms
//
//  Created by Rocky Lee on 6/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

@interface HDFunctionListModel : HDURLRequestModel

@property(nonatomic,retain) NSArray * resultList;

@end

@interface HDFunctionListDataSource : TTSectionedDataSource
-(void)addBasicItems;
//@property(nonatomic,readonly) HDTableImageModel * tableImageModel;

@end
