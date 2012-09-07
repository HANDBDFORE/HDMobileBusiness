//
//  HDListPageTuning.h
//  HDMobileBusiness
//
//  Created by Plato on 9/7/12.
//  Copyright (c) 2012 hand. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HDVector <NSObject>

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

//TODO:如果存在更多类似函数在抽取出来
//提交制定indexPaths中的纪录，设置纪录的comment和action
@optional
-(void)submitObjectAtIndexPaths:(NSArray *) indexPaths
                        comment:(NSString *) comment
                         action:(NSString *) action;

@end
