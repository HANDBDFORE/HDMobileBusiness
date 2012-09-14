//
//  HDPersonPickDataSource.h
//  HDMobileBusiness
//
//  Created by Plato on 9/11/12.
//  Copyright (c) 2012 hand. All rights reserved.
//

#import "HDPersonListModel.h"

@interface HDPersonListDataSource : TTListDataSource

@property(nonatomic,assign) id<HDListModelQuery> listModel;

//item字典，描述如何从record中获取数据设置到item中 
@property(nonatomic,retain) NSDictionary * itemDictionary;

@end
