//
//  HDMathCheckModel.m
//  HDMobileBusiness
//
//  Created by titengjiang on 15/4/20.
//  Copyright (c) 2015年 hand. All rights reserved.
//

#import "HDMathCheckModel.h"

@implementation HDMathCheckModel

-(void)dealloc
{

    [super dealloc];
}

-(id)init
{
    if (self = [super init]) {
    }
    return self;
}


-(void)checkWithUserName:(NSString *)username
{

    
    HDRequestMap * map = [HDRequestMap mapWithDelegate:self];
    map.urlPath = @"modules/mobile/client/commons/login/check_number.svc";
    map.postData = @{ @"username" : username};
    
    [self requestWithMap:map];
    
    
}



-(void)requestResultMap:(HDResponseMap *)map
{
  
}

@end
