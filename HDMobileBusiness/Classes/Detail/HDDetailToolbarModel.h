//
//  HDDetailToolbarDataSource.h
//  Three20GitCoreDataLab
//
//  Created by Rocky Lee on 6/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HDToolbarItem.h"
//#import "HDToolbarModel.h"
static NSString * kToobarActionQueryPath = @"TOOLBAR_ACTION_QUERY_PATH";

@interface HDDetailToolbarModel : HDURLRequestModel

@property(nonatomic,retain)NSNumber * recordID;
@property(nonatomic,retain) id resultList;

/*
 *确认提交后把本地动作数据删除,确保没有垃圾数据
 *保存之前尝试删除相关数据,防止切换地址遗留数据导致唯一索引错误
 */
-(void)removeTheActions;

-(id)initWithKey:(id)key query:(id) query;

-(NSArray *)toolbarItems;

@end

