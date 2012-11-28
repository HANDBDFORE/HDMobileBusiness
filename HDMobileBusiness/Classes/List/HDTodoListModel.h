//
//  HDWillAproveListModel.h
//  hrms
//
//  Created by Rocky Lee on 7/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDURLRequestModel.h"
#import "HDListModel.h"

/*
 *使用同步方法从本地存储刷新数据使用状态,当前不启用
 */
//static NSString * kStorageNormal = @"NORMAL";
//static NSString * kStorageInsert = @"INSERT";
//static NSString * kStorageUpdate = @"UPDATE";
//static NSString * kStorageRemove = @"REMOVE";

@interface HDTodoListModel : HDURLRequestModel<HDListModelVector,HDListModelSubmit>
{
    @private
    struct {
        unsigned int shouldLoadingLocalData:1;
        unsigned int isSubmitingData:1;
        unsigned int isQueryingData:1;
    } _flags;
    
    NSMutableArray * _resultList;
    NSMutableArray * _submitList;
    NSString * _searchText;
    
    NSRange _vectorRange;
}

#pragma override ModelQuery 
@property(nonatomic,copy) NSString * queryURL;

//获取结果列表
@property(nonatomic,readonly) NSArray * resultList;

//查询
- (void)search:(NSString*)text;

#pragma override ModelSubmit
//提交的Url
@property(nonatomic,copy) NSString * submitURL;

-(void)removeRecordAtIndex:(NSUInteger) index;

//提交IndexPath指定的记录，提交参数通过query传递
-(void)submitRecordsAtIndexPaths:(NSArray *)indexPaths
                      dictionary:(NSDictionary *)dictionary;

-(void)submitCurrentRecordWithDictionary:(NSDictionary *)dictionary;


//查询字段
@property(nonatomic,retain) NSArray * searchFields;

//主键字段
@property(nonatomic,copy) NSString * primaryField;

//清除无效的数据,未使用
//-(void)clear;

@end



