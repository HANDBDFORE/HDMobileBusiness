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
@property(nonatomic,readonly) NSArray * resultList;

@property(nonatomic,assign) NSUInteger pageNum;

//查询的Url
@property(nonatomic,copy) NSString * queryURL;

//当前指针位置，表识被点击纪录的行号
//@property(nonatomic,assign) NSUInteger currentIndex;

////获取当前selectedIndex对应resultList中的纪录
//-(id)currentRecord;
//
////跳转到下一条有效记录
//-(void)nextRecord;
//
////是否有下一条记录
//-(BOOL)hasNextRecord;
//
////跳转到上一条有效记录
//-(void)prevRecord;
//
////是否有上一条记录
//-(BOOL)hasPrevRecord;
//
////获取当前有效记录数
//-(NSUInteger)effectiveRecordCount;
//
////获取当前记录的indexPah
//-(NSIndexPath *) currentIndexPath;

@end
