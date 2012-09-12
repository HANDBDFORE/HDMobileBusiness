//
//  HDListModel.h
//  HDMobileBusiness
//
//  Created by Plato on 9/12/12.
//  Copyright (c) 2012 hand. All rights reserved.
//

#import "HDVector.h"
@protocol HDListModel <NSObject,HDVector>

@optional
//删除指定位置的记录
-(void)removeRecordAtIndex:(NSUInteger) index;

//提交IndexPath指定的记录，提交参数通过query传递
-(void)submitRecordsAtIndexPaths:(NSArray *)indexPaths
                           query:(NSDictionary *)query;

//查询
- (void)search:(NSString*)text;

@end
