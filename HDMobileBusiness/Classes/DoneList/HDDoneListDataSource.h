//
//  HDDoneListDataSource.h
//  HandMobile
//
//  Created by Rocky Lee on 5/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "../HDVector.h"

@interface HDDoneListDataSource : TTListDataSource

@property(nonatomic,assign) id<HDVector> listModel;

@property(nonatomic,retain) NSDictionary * cellItemMap;

@end
