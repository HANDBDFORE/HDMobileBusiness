//
//  HDLoginModel.h
//  HRMS
//
//  Created by Rocky Lee on 3/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import "ULANKey.h"
#import "ULANKeyDelegate.h"

@protocol HDLoginModel <TTModel>

@property(nonatomic,retain) NSString * submitURL;

@property(nonatomic,copy) NSString * username;

@property(nonatomic,copy) NSString * password;


////通过这个标志区别是 login 还是check

-(void)login;



@end

@interface HDLoginModel : HDURLRequestModel<HDLoginModel>

@property(nonatomic,retain) NSString * submitURL;

@property(nonatomic,copy) NSString * username;

@property(nonatomic,copy) NSString * password;


@property (nonatomic,retain)  HDResponseMap * map;



@property(nonatomic,retain)NSString * tag;


-(void)loginWithSingatureBase64:(NSString *)SingatureBase64;

-(void)checkWithUserName:(NSString *)username;


-(void)login;

@end
