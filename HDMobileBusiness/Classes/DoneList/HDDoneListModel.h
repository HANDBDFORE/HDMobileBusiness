//
//  HDDoneListModel.h
//  HandMobile
//
//  Created by Rocky Lee on 7/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDURLRequestModel.h"
#import "../HDVector.h"

@interface HDDoneListModel : HDURLRequestModel<HDVector>
{
    @private
    NSMutableArray * _resultList;
}

@property(nonatomic,assign) NSUInteger pageNum;

//查询的Url
@property(nonatomic,copy) NSString * queryURL;

@end
