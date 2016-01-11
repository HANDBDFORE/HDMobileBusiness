//
//  HDTodoListService.h
//  HDMobileBusiness
//
//  Created by Plato on 12/13/12.
//  Copyright (c) 2012 hand. All rights reserved.
//

#import "HDURLRequestModel.h"
#import "HDListModel.h"
#import "HDTodoListModelStatus.h"

@interface HDTodoListModel : HDURLRequestModel<HDListModelSubmit,HDListModelQuery>
{
    @private
    struct {
        unsigned int shouldLoadingLocalData:1;
        unsigned int isSubmitingData:1;
        unsigned int isQueryingData:1;
    } _flags;
    
    NSMutableArray * _resultList;
    NSMutableArray * _submitList;
    NSMutableArray * _currentSubmitRecords;

}

//主键字段
@property(nonatomic,copy) NSString * primaryField;

//查询路径
@property(nonatomic,copy) NSString * queryURL;

//获取结果列表
@property(nonatomic,readonly) NSArray * resultList;

//提交的Url
@property(nonatomic,copy) NSString * submitURL;

-(void)removeRecord:(id)record;

-(void)submitRecords:(NSArray *)records;

@end
