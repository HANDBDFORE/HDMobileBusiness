//
//  HDDoneListDataSource.h
//  HandMobile
//
//  Created by Rocky Lee on 5/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDListModel.h"
#import "HDTableDataSource.h"

@interface HDDoneListDataSource : TTListDataSource <HDTableDataSource>

@property(nonatomic,assign) id<HDListModelVector> listModel;

@end
