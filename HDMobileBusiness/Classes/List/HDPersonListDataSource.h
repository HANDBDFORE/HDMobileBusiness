//
//  HDPersonPickDataSource.h
//  HDMobileBusiness
//
//  Created by Plato on 9/11/12.
//  Copyright (c) 2012 hand. All rights reserved.
//

#import "HDPersonListModel.h"
#import "HDTableDataSource.h"

@interface HDPersonListDataSource : TTListDataSource <HDTableDataSource>

@property(nonatomic,assign) id<HDListModelQuery> listModel;

@end
