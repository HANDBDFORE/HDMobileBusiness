//
//  HDWillAproveListModel.h
//  hrms
//
//  Created by Rocky Lee on 7/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDURLRequestModel.h"

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

@interface HDTodoListModel : HDURLRequestModel
{
    @private
    struct {
        unsigned int isFirstLoad:1;
        unsigned int isSubmitingData:1;
        unsigned int isQueryingData:1;
    } _flags;
    
    NSMutableArray * _resultList;
    NSMutableArray * _submitList;
    
    NSString * _searchText;
}

//结果列表，和界面显示对应，datasource从该列表获取数据
@property(nonatomic,readonly) NSMutableArray * resultList;

//提交队列
@property(nonatomic,readonly) NSMutableArray * submitList;

//查询字段
@property(nonatomic,retain) NSArray * serachFields;

//排序字段
@property(nonatomic,copy) NSString * orderField;

//主键字段
@property(nonatomic,copy) NSString * primaryFiled;

//查询的Url
@property(nonatomic,copy) NSString * queryUrl;

//提交的Url
@property(nonatomic,copy) NSString * submitUrl;

//当前指针位置，表识被点击纪录的行号
@property(nonatomic,assign) NSUInteger selectedIndex;

//提交成功,删除记录
//-(void)removeSubmitedRecord:(Approve *) submitedRecord;

//提交失败,修改记录
//-(void)updateErrorRecord:(Approve *) errorRecord;

//提交制定indexPaths中的纪录，设置纪录的comment和action
-(void)submitObjectAtIndexPaths:(NSArray *) indexPaths
                        comment:(NSString *) comment
                         action:(NSString *) action;

//查询
- (void)search:(NSString*)text;

//获取当前selectedIndex对应resultList中的纪录
-(id)currentRecord;

//跳转到下一条有效记录
-(BOOL)nextRecord;

//跳转到上一条有效记录
-(BOOL)prevRecord;

//获取当前有效记录数
-(NSUInteger)effectiveRecordCount;

//清除无效的数据
-(void)clear;

@end



