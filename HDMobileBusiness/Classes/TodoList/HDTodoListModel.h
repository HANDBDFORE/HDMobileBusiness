//
//  HDWillAproveListModel.h
//  hrms
//
//  Created by Rocky Lee on 7/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDURLRequestModel.h"

#import "Approve.h"
//TODO:考虑不要path了,直接通过viewController来取
static NSString * kApproveListBatchSubmitPath = @"APPROVE_LIST_BATCH_SUBMIT_PATH";

static NSString * kApproveListQueryPath = @"APPROVE_LIST_QUERY_PATH";

/*
 *记录状态,不同的状态cell样式不同
 */
static NSString * kRecordNormal = @"NORMAL";
static NSString * kRecordWaiting = @"WAITING";
static NSString * kRecordError = @"ERROR";
static NSString * kRecordDifferent = @"DIFFERENT";

/*
 *使用同步方法从本地存储刷新数据使用状态,当前不启用
 */
static NSString * kStorageNormal = @"NORMAL";
static NSString * kStorageInsert = @"INSERT";
static NSString * kStorageUpdate = @"UPDATE";
static NSString * kStorageRemove = @"REMOVE";

@interface HDTodoListModel : HDURLRequestModel
{
    struct {
        unsigned int isFirstLoad:1;
        unsigned int isSubmitingData:1;
        unsigned int isQueryingData:1;
    } _flags;
    
    NSMutableArray * _resultList;
    NSMutableArray * _submitList;
    
    NSString * _searchText;
}

@property(nonatomic,readonly) NSMutableArray * resultList;
@property(nonatomic,readonly) NSMutableArray * submitList;
//@property(nonatomic,readonly) NSMutableArray * searchResultList;

@property(nonatomic,copy) NSString * submitAction;

//提交成功,删除记录
//-(void)removeSubmitedRecord:(Approve *) submitedRecord;

//提交失败,修改记录
//-(void)updateErrorRecord:(Approve *) errorRecord;

-(void)addObjectAtIndexPathsForSubmit:(NSArray *) indexPaths comment:(NSString *) comment;

//-(void) setIsSearching:(BOOL) isSearching;

- (void)search:(NSString*)text;

@end



