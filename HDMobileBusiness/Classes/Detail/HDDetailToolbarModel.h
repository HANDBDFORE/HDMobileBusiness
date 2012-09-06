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
@interface HDDetailToolbarModel : HDURLRequestModel

@property(nonatomic,retain)NSDictionary * detailRecord;
@property(nonatomic,retain)NSArray * resultList;
@property(nonatomic,retain)NSString * actionURL;

/*
 *确认提交后把本地动作数据删除,确保没有垃圾数据
 *保存之前尝试删除相关数据,防止切换地址遗留数据导致唯一索引错误
 */
-(void)removeTheActions;
-(NSArray *)toolbarItems;

@end
