//
//  LoginModel.m
//  HRMS
//
//  Created by Rocky Lee on 3/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDLoginModel.h"
#import "ApproveDatabaseHelper.h"

static NSString * kLoginSubmitURLPath = @"LOGIN_PATH";

@implementation HDLoginModel

//登陆post数据
@synthesize loginBean = _loginBean;

-(id)init
{
    if (self = [super init]) {
        _loginBean = [[HDLoginBean alloc]init];
    }
    return self;
}

-(void)initUsers
{
    //不同用户登录,清除数据库
    if (_loginBean.username != [[NSUserDefaults standardUserDefaults] valueForKey:@"username"]) {
        //
        ApproveDatabaseHelper * dbHelper = [[ApproveDatabaseHelper alloc]init];
        [dbHelper.db open];
        [dbHelper dropAllTables];
        [dbHelper.db close];
    }   
    [[NSUserDefaults standardUserDefaults] setValue:_loginBean.username forKey:@"username"];
    [[NSUserDefaults standardUserDefaults] setValue:_loginBean.password forKey:@"password"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

-(void)login
{
    //如果是不同用户登陆的,清空数据库
    [self initUsers];

    id postdata = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                   _loginBean.username,@"user_name",
                   _loginBean.password,@"user_password",
                   @"简体中文",@"langugae",
                   @"ZHS",@"user_language",
                   @"N",@"is_ipad", 
                   @"PHONE",@"device_type",
                   @"1",@"company_id",
                   @"41",@"role_id",
                   [[NSUserDefaults standardUserDefaults] valueForKey:@"deviceToken"],@"device_token",
                   nil];

    HDRequestMap * map = [HDRequestMap mapWithDelegate:self];
    map.urlName = kLoginSubmitURLPath;
    map.postData = postdata;
    
    [self requestWithMap:map]; 
}

-(void)dealloc
{
    TT_RELEASE_SAFELY(_loginBean);
    [super dealloc];
}

@end
