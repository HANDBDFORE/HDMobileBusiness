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

@interface HDTodoListService : HDURLRequestModel<HDListModelSubmit>
{
    @private
    struct {
        unsigned int shouldLoadingLocalData:1;
        unsigned int isSubmitingData:1;
        unsigned int isQueryingData:1;
    } _flags;
    
    NSMutableArray * _resultList;
    NSMutableArray * _submitList;
}

//主键字段
@property(nonatomic,copy) NSString * primaryField;

#pragma override ModelQuery
@property(nonatomic,copy) NSString * queryURL;

//获取结果列表
@property(nonatomic,readonly) NSArray * resultList;

#pragma override ModelSubmit
//提交的Url
@property(nonatomic,copy) NSString * submitURL;


//提交IndexPath指定的记录，提交参数通过query传递
-(void)submitRecordsAtIndexPaths:(NSArray *)indexPaths
                      dictionary:(NSDictionary *)dictionary;

-(void)removeRecordAtIndex:(NSUInteger) index;

#pragma new
-(void)removeRecord:(id)record;

-(void)submitRecords:(NSArray *)records dictionary:(NSDictionary *)dictionary;

@end
