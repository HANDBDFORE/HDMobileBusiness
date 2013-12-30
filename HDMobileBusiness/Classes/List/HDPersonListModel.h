//
//  HDPersonPickModel.h
//  HDMobileBusiness
//
//  Created by Plato on 9/11/12.
//  Copyright (c) 2012 hand. All rights reserved.
//

#import "HDURLRequestModel.h"
#import "HDListModel.h"

@interface HDPersonListModel : HDURLRequestModel<HDListModelQuery>
{
    NSMutableArray * _resultList;
}

@property(nonatomic,copy) NSString * queryURL;
@property(nonatomic,retain) id<HDPageTurning>  todoModel;

@end
