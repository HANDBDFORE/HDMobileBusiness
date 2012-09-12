//
//  HDWillAproveListModel.h
//  hrms
//
//  Created by Rocky Lee on 7/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDURLRequestModel.h"
#import "../HDListModel.h"
/*
 *记录状态,不同的状态cell样式不同
 */
static NSString * kRecordNormal = @"NORMAL";
static NSString * kRecordWaiting = @"WAITING";
static NSString * kRecordError = @"ERROR";
static NSString * kRecordDifferent = @"DIFFERENT";

static NSString * kRecordStatus = @"kLocalStatus";
static NSString * kRecordServerMessage = @"kServerMessage";
/*
 *使用同步方法从本地存储刷新数据使用状态,当前不启用
 */
static NSString * kStorageNormal = @"NORMAL";
static NSString * kStorageInsert = @"INSERT";
static NSString * kStorageUpdate = @"UPDATE";
static NSString * kStorageRemove = @"REMOVE";

@interface HDTodoListModel : HDURLRequestModel<HDListModel>
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

//结果列表，和界面显示对应，datasource从该列表获取数据
//@property(nonatomic,readonly) NSArray * resultList;

//查询字段
@property(nonatomic,retain) NSArray * serachFields;

//主键字段
@property(nonatomic,copy) NSString * primaryFiled;

//查询的Url
@property(nonatomic,copy) NSString * queryURL;

//提交的Url
@property(nonatomic,copy) NSString * submitURL;

//清除无效的数据
-(void)clear;

@end



