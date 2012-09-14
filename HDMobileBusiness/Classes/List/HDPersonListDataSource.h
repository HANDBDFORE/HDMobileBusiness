//
//  HDPersonPickDataSource.h
//  HDMobileBusiness
//
//  Created by Plato on 9/11/12.
//  Copyright (c) 2012 hand. All rights reserved.
//

#import "HDPersonListModel.h"
@interface HDPersonListDataSource : TTListDataSource

@property(nonatomic,readonly) HDPersonListModel * personListModel;

@end
