//
//  HDPersonPickModel.h
//  HDMobileBusiness
//
//  Created by Plato on 9/11/12.
//  Copyright (c) 2012 hand. All rights reserved.
//

#import "HDURLRequestModel.h"

@interface HDPersonListModel : HDURLRequestModel
{
    NSMutableArray * _resultList;
}

@property(nonatomic,readonly) NSArray * resultList;

//查询
- (void)search:(NSString*)text;

@end
