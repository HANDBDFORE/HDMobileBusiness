//
//  LoginModel.h
//  HRMS
//
//  Created by Rocky Lee on 3/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDLoginBean.h"

@interface HDLoginModel : HDURLRequestModel

@property(nonatomic,readonly) HDLoginBean * loginBean;

-(void)login;

@end
