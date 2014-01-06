//
//  HDWillAproveListModel.h
//  hrms
//
//  Created by Rocky Lee on 7/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDURLRequestModel.h"
#import "HDListModel.h"
#import "HDBaseService.h"

@interface HDTodoListService : HDBaseService <HDPageTurning>
{
    NSRange _vectorRange;    
}

@property(nonatomic,retain) id<HDURLRequestModel,HDListModelSubmit,HDListModelQuery> model;

//获取结果列表
@property(nonatomic,readonly) NSArray * resultList;

#pragma -mark service

-(void)removeRecordAtIndex:(NSUInteger) index;

//提交IndexPath指定的记录，提交参数通过query传递

-(void)submitRecordsAtIndexPaths:(NSArray *)indexPaths
                      dictionary:(NSDictionary *)dictionary;

-(void)submitCurrentRecordWithDictionary:(NSDictionary *)dictionary;


@property(nonatomic,assign) NSUInteger currentIndex;

@property(nonatomic,readonly) NSIndexPath * currentIndexPath;

//清除无效的数据,未使用
//-(void)clear;

@end



