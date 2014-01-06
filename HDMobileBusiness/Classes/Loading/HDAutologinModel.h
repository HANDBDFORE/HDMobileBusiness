//
//  HDAutologinModel.h
//  HDMobileBusiness
//
//  Created by 马 豪杰 on 13-5-28.
//  Copyright (c) 2013年 hand. All rights reserved.
//

@protocol HDAutologinModel <TTModel>

@property(nonatomic,retain) NSString * submitURL;

@property(nonatomic,copy) NSString * token;

-(void)autologin;

@end

@interface HDAutologinModel : HDURLRequestModel<HDAutologinModel>

@property(nonatomic,retain) NSString * submitURL;

@property(nonatomic,copy) NSString * token;

-(void)autologin;

@end
