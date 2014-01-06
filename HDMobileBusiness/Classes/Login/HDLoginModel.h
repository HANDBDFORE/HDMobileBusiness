//
//  HDLoginModel.h
//  HRMS
//
//  Created by Rocky Lee on 3/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

@protocol HDLoginModel <TTModel>

@property(nonatomic,retain) NSString * submitURL;

@property(nonatomic,copy) NSString * username;

@property(nonatomic,copy) NSString * password;

-(void)login;

@end

@interface HDLoginModel : HDURLRequestModel<HDLoginModel>

@property(nonatomic,retain) NSString * submitURL;

@property(nonatomic,copy) NSString * username;

@property(nonatomic,copy) NSString * password;

-(void)login;

@end
