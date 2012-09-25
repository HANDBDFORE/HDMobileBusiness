//
//  HDListModel.h
//  HDMobileBusiness
//
//  Created by Plato on 9/12/12.
//  Copyright (c) 2012 hand. All rights reserved.
//

//submit filed
static NSString * kAction = @"action_id";
static NSString * kComments = @"comments";
static NSString * kEmployeeID = @"employee_id";
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@protocol HDListModelQuery <NSObject>

@required

//获取结果列表
@property(nonatomic,readonly) NSArray * resultList;

@optional
//查询
- (void)search:(NSString*)text;

@end
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@protocol HDListModelSubmit <NSObject,HDListModelQuery>

@required

//删除指定位置的记录
-(void)removeRecordAtIndex:(NSUInteger) index;

//提交IndexPath指定的记录，提交参数通过query传递
-(void)submitRecordsAtIndexPaths:(NSArray *)indexPaths
                      dictionary:(NSDictionary *)dictionary;

-(void)submitCurrentRecordWithDictionary:(NSDictionary *)dictionary;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@protocol HDListModelVector <NSObject,HDListModelQuery>

//当前指针位置，表识被点击纪录的行号
@property(nonatomic,assign) NSUInteger currentIndex;

@required

//获取当前记录的indexPah
//-(NSIndexPath *) currentIndexPath;

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

@end