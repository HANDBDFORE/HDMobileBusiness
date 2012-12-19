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

@interface HDTodoListService : HDBaseService <HDTodoListService>
{
    NSMutableArray * _resultList;
    NSString * _searchText;
    
    NSRange _vectorRange;
}

@property(nonatomic,retain) id<TTModel,HDURLRequestModel,HDListModelSubmit,HDListModelQuery> model;

//获取结果列表
@property(nonatomic,readonly) NSArray * resultList;

//查询字段
@property(nonatomic,retain) NSArray * searchFields;

#pragma -mark service
//查询
- (void)search:(NSString*)text;

-(void)removeRecordAtIndex:(NSUInteger) index;

//提交IndexPath指定的记录，提交参数通过query传递

-(void)submitRecordsAtIndexPaths:(NSArray *)indexPaths
                      dictionary:(NSDictionary *)dictionary;

-(void)submitCurrentRecordWithDictionary:(NSDictionary *)dictionary;


@property(nonatomic,assign) NSUInteger currentIndex;


#pragma -mark override ModelGroup
@property(nonatomic,readonly) NSArray * groupResultList;

@property(nonatomic,copy) NSString * groupedCode;

@property(nonatomic,copy) NSString * groupedCodeField;

@property(nonatomic,copy) NSString * groupedValueField;

//清除无效的数据,未使用
//-(void)clear;

@end



