//
//  HDWillAproveListModel.h
//  hrms
//
//  Created by Rocky Lee on 7/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDURLRequestModel.h"
#import "HDListModel.h"

@interface HDTodoListModel : TTURLRequestModel<HDListModelVector,HDListModelSubmit>
{
    NSMutableArray * _resultList;
    NSString * _searchText;
    
    NSRange _vectorRange;
}

#pragma override ModelQuery 

//获取结果列表
@property(nonatomic,readonly) NSArray * resultList;

//查询
- (void)search:(NSString*)text;

#pragma override ModelSubmit

-(void)removeRecordAtIndex:(NSUInteger) index;

//提交IndexPath指定的记录，提交参数通过query传递
-(void)submitRecordsAtIndexPaths:(NSArray *)indexPaths
                      dictionary:(NSDictionary *)dictionary;

-(void)submitCurrentRecordWithDictionary:(NSDictionary *)dictionary;


//查询字段
@property(nonatomic,retain) NSArray * searchFields;

//清除无效的数据,未使用
//-(void)clear;

#pragma override ModelGroup
@property(nonatomic,readonly) NSArray * groupResultList;

@property(nonatomic,copy) NSString * groupedCode;

@property(nonatomic,copy) NSString * groupedCodeField;

@property(nonatomic,copy) NSString * groupedValueField;


#pragma override TTModel
///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)isLoaded;

- (BOOL)isLoading;

- (BOOL)isLoadingMore;

- (BOOL)isOutdated;

-(NSDate *)loadedTime;
///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma Trash
//主键字段
@property(nonatomic,copy) NSString * primaryField;

//提交的Url
@property(nonatomic,copy) NSString * submitURL;

@property(nonatomic,copy) NSString * queryURL;

@end



