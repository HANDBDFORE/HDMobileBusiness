//
//  HDLoginModel.m
//  HRMS
//
//  Created by Rocky Lee on 3/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDLoginModel.h"

@implementation HDLoginModel

@synthesize submitURLPath = _submitURLPath;
@synthesize username = _username;
@synthesize password = _password;

-(void)dealloc
{
    TT_RELEASE_SAFELY(_submitURLPath);
    TT_RELEASE_SAFELY(_username);
    TT_RELEASE_SAFELY(_password);
    [super dealloc];
}

-(id)init
{
    if (self = [super init]) {
//        self.submitURLPath = [NSString stringWithFormat:@"%@%@",[[HDHTTPRequestCenter sharedURLCenter]baseURLPath],@"modules/ios/public/login_iphone.svc"];
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
                   self.username,@"user_name",
                   self.password,@"user_password",
                   @"简体中文",@"langugae",
                   @"ZHS",@"user_language",
                   @"N",@"is_ipad", 
                   [self deviceType],@"device_type",
                   @"1",@"company_id",
                   @"41",@"role_id",
                   [[NSUserDefaults standardUserDefaults] valueForKey:@"deviceToken"],@"device_token",
                   nil];

    HDRequestMap * map = [HDRequestMap mapWithDelegate:self];
    map.requestPath = self.submitURLPath;
    map.postData = postdata;
    
    [self requestWithMap:map]; 
}

-(NSString *) deviceType
{
    return TTIsPad()? @"PAD":@"PHONE";
}

//binding
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (![[self valueForKeyPath:context] isEqual:[change valueForKey:@"new"]]) {
        [self setValue:[change valueForKey:@"new"] forKeyPath:context];
    }
}
@end
