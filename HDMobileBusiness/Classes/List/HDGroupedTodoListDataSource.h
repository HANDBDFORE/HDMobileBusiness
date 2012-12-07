//
//  HDGroupedTodoListDataSource.h
//  HDMobileBusiness
//
//  Created by Plato on 12/5/12.
//  Copyright (c) 2012 hand. All rights reserved.
//

#import <Three20UI/Three20UI.h>
#import "HDTableDataSource.h"
#import "HDListModel.h"

@interface HDGroupedTodoListDataSource : TTListDataSource

@property(nonatomic,retain) id<HDListModelQuery,HDListModelGroupe> listModel;

@property(nonatomic,copy) NSString * groupedCodeField;

@property(nonatomic,copy) NSString * groupedValueField;

@end
