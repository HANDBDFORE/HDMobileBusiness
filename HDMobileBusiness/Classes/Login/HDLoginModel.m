//
//  HDLoginModel.m
//  HRMS
//
//  Created by Rocky Lee on 3/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDLoginModel.h"

@implementation HDLoginModel

@synthesize submitURL = _submitURL;
@synthesize username = _username;
@synthesize password = _password;

-(void)dealloc
{
    TT_RELEASE_SAFELY(_submitURL);
    TT_RELEASE_SAFELY(_username);
    TT_RELEASE_SAFELY(_password);
    [super dealloc];
}

-(id)init
{
    if (self = [super init]) {
        self.username = [[NSUserDefaults standardUserDefaults] valueForKey:@"username"];
    }
    return self;
}

-(void)initUsers
{
    //不同用户登录,清除数据库
    if (self.username != [[NSUserDefaults standardUserDefaults] valueForKey:@"username"]) {
        //
        HDCoreStorage * CoreStorage = [HDCoreStorage shareStorage];
        [CoreStorage excute:@selector(SQLCleanTable:) recordList:nil];
    }   
    [[NSUserDefaults standardUserDefaults] setValue:self.username forKey:@"username"];
    [[NSUserDefaults standardUserDefaults] setValue:self.password forKey:@"password"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)login
{
    //如果是不同用户登陆的,清空数据库
    [self initUsers];

    id postdata = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                   self.username,@"username",
                   self.password,@"password",
                   [self deviceType],@"device_type",
                   [[NSUserDefaults standardUserDefaults] valueForKey:@"deviceToken"],@"push_token",
                   [[NSUserDefaults standardUserDefaults] valueForKey:@"deviceToken"],@"device_Id",
                   nil];

    HDRequestMap * map = [HDRequestMap mapWithDelegate:self];
    map.urlPath = self.submitURL;
    map.postData = postdata;
    
    [self requestWithMap:map]; 
}

-(NSString *) deviceType
{
    if (TTIsPad()) {
        return @"iPad";
    }
    if (HDIsInch4()) {
        return @"iPhone5";
    }
    return @"iPhone";
}

//binding
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (![[self valueForKeyPath:context] isEqual:[change valueForKey:@"new"]]) {
        [self setValue:[change valueForKey:@"new"] forKeyPath:context];
    }
}
-(void)requestResultMap:(HDResponseMap *)map{
    NSString * SID = [[map result] objectForKey:@"token"];
    [[NSUserDefaults standardUserDefaults]setValue:SID forKey:@"Token"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}
@end
