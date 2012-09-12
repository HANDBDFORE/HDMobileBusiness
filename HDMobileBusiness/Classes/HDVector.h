//
//  HDListPageTuning.h
//  HDMobileBusiness
//
//  Created by Plato on 9/7/12.
//  Copyright (c) 2012 hand. All rights reserved.
//

#import <Foundation/Foundation.h>

//submit filed
static NSString * kAction = @"action_id";
static NSString * kComments = @"comments";

@protocol HDListModelQuery <NSObject>

@required
//获取结果列表
@property(nonatomic,readonly) NSArray * resultList;

@end

@protocol HDVector <NSObject,HDListModelQuery>

//当前指针位置，表识被点击纪录的行号
@property(nonatomic,assign) NSUInteger currentIndex;

//获取当前记录的indexPah
-(NSIndexPath *) currentIndexPath;

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
