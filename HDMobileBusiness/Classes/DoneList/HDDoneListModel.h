//
//  HDDoneListModel.h
//  HandMobile
//
//  Created by Rocky Lee on 7/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDURLRequestModel.h"

@interface HDDoneListModel : HDURLRequestModel
{
    @private
    NSMutableArray * _resultList;
}
@property(nonatomic,readonly) NSArray * resultList;

@property(nonatomic,assign) NSUInteger pageNum;

//查询的Url
@property(nonatomic,copy) NSString * queryUrl;

//当前指针位置，表识被点击纪录的行号
@property(nonatomic,assign) NSUInteger selectedIndex;

//获取当前selectedIndex对应resultList中的纪录
-(id)currentRecord;

//跳转到下一条有效记录
-(BOOL)nextRecord;

//跳转到上一条有效记录
-(BOOL)prevRecord;

//获取当前有效记录数
-(NSUInteger)effectiveRecordCount;


@end
