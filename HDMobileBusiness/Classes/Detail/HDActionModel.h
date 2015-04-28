//
//  HDActionModel.h
//  HDMobileBusiness
//
//  Created by 马豪杰 on 13-7-3.
//  Copyright (c) 2013年 hand. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HDActionModel : HDURLRequestModel{
    
}
//查询路径
@property(nonatomic,copy) NSString * queryURL;
//要查询的单据
@property(nonatomic,copy) NSDictionary * record;
//获取结果列表
@property(nonatomic,retain) NSArray * actionList;


@property(nonatomic,copy)NSString * record_id;

@property(nonatomic,retain)NSString * signature;


@property (nonatomic) BOOL ca_verification_necessity;

-(void)query;
@end
