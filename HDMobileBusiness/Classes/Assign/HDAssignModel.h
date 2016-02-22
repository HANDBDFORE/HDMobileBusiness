//
//  HDDeleverModel.h
//  HDMobileBusiness
//
//  Created by jiangtiteng on 14-9-29.
//  Copyright (c) 2014年 hand. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HDAssignModel :  HDURLRequestModel <TTModel>


@property (nonatomic,strong) NSString * queryUrl;
@property (nonatomic,strong) NSArray * list;

-(void)loadRecord:(NSString *)data
          localId:(NSString *)localId;
@end
