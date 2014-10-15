//
//  HDDeleverModel.m
//  HDMobileBusiness
//
//  Created by jiangtiteng on 14-9-29.
//  Copyright (c) 2014年 hand. All rights reserved.
//

#import "HDDeleverModel.h"

@interface HDDeleverModel ()

@end

@implementation HDDeleverModel

@synthesize list  = _list;

-(id)init
{
    self = [super init];
    if(self){
        
        self.queryUrl  = @"${base_url}modules/mobile_um/client/commons/todo/mobile_employee_synch.svc";
    }
    
    
    return  self;
}

-(void)loadRecord:(NSString *)data
{
    
    HDRequestMap * map = [HDRequestMap mapWithDelegate:self];
    map.urlPath = self.queryUrl;
    map.postData = @{@"mobile_employee_keyword": data};
    [self requestWithMap:map];
    
}

-(void)requestResultMap:(HDResponseMap *)map{
    self.list = [[map result] objectForKey:@"list"];
    NSLog(@"%d",self.list.count);
}


@end
