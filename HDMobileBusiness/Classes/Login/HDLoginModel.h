//
//  HDLoginModel.h
//  HRMS
//
//  Created by Rocky Lee on 3/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

@interface HDLoginModel : HDURLRequestModel

@property(nonatomic,retain) NSString * submitURLPath;

@property(nonatomic,copy) NSString * username;

@property(nonatomic,copy) NSString * password;

-(void)login;

@end
