//
//  HDListModel.h
//  HDMobileBusiness
//
//  Created by Plato on 9/12/12.
//  Copyright (c) 2012 hand. All rights reserved.
//


//submit field
static NSString * kAction = @"action_id";
static NSString * kComments = @"comments";
static NSString * kEmployeeID = @"employee_id";
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/*
 * 多数ListModel会实现这个接口，统一查询的路径属性和查询结果列表
 */
@protocol HDListModelQuery <TTModel>

//查询结果
@property(nonatomic,copy) NSString * queryURL;

//查询结果
@property(nonatomic,readonly) NSArray * resultList;

@optional
//查询
- (void)search:(NSString*)text;

@end
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/*
 *todoListModel实现这个接口，用于提交，删除数据。
 */
@protocol HDListModelSubmit <NSObject>

@property(nonatomic,copy) NSString * submitURL;

-(void)submitRecords:(NSArray *)records;

-(void)removeRecord:(id)record;

@end
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/*
 *翻页相关,todoListService 和 DoneListModel实现这个接口，HDTodoListService delegate 扩展了这个delegate，所以todoListService类仅声明实现了todoListService delegate
 */
@protocol HDPageTurning <NSObject>

//当前指针位置，表识被点击纪录的行号
@property(nonatomic,assign) NSUInteger currentIndex;

//获取当前selectedIndex对应resultList中的纪录
-(id)current;

//跳转到下一条有效记录
-(void)next;

//是否有下一条记录
-(BOOL)hasNext;

//跳转到上一条有效记录
-(void)prev;

//是否有上一条记录
-(BOOL)hasPrev;

//获取当前有效记录数
-(NSUInteger)effectiveRecordCount;

@optional

-(void)submitCurrentRecordWithDictionary:(NSDictionary *)dictionary;

@end
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@protocol HDURLRequestModel <NSObject>

/**
 * Valid upon completion of the URL request. Represents the timestamp of the completed request.
 */
-(NSDate *)loadedTime;

/**
 * Valid upon completion of the URL request. Represents the request's cache key.
 */
-(NSString *)cacheKey;

/**
 * Not used internally, but intended for book-keeping purposes when making requests.
 */
-(BOOL)hasNoMore;

/**
 * Resets the model to its original state before any data was loaded.
 */
- (void)reset;

/**
 * Valid while loading. Returns download progress as between 0 and 1.
 */

- (float)downloadProgress;

@end

///////////////////////////////////////////////////////////////////////////////////////////////////

/*
 *TodoListService
 */
@protocol HDTodoListService <TTModelDelegate,TTModel>

@optional

//删除指定位置的记录
-(void)removeRecordAtIndex:(NSUInteger) index;

//提交IndexPath指定的记录，提交参数通过query传递
-(void)submitRecordsAtIndexPaths:(NSArray *)indexPaths
                      dictionary:(NSDictionary *)dictionary;

//分组
@property(nonatomic,readonly) NSArray * groupResultList;

@property(nonatomic,copy) NSString * groupedCode;

@property(nonatomic,copy) NSString * groupedCodeField;

@property(nonatomic,copy) NSString * groupedValueField;

////////////////////
@property(nonatomic,readonly) NSArray * resultList;

//查询
- (void)search:(NSString*)text;

@end
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


