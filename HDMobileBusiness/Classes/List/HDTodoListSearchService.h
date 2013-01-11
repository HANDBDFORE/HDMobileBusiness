//
//  HDTodoListSearchService.h
//  HDMobileBusiness
//
//  Created by Plato on 1/10/13.
//  Copyright (c) 2013 hand. All rights reserved.
//

#import "HDTodoListService.h"

@interface HDTodoListSearchService : HDTodoListService
{
    NSString * _searchText;
}
//查询字段
@property(nonatomic,retain) NSArray * searchFields;

#pragma -mark service
//查询
- (void)search:(NSString*)text;
@end
