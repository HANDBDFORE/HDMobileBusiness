//
//  HDAutologinModel.m
//  HDMobileBusiness
//
//  Created by 马 豪杰 on 13-5-28.
//  Copyright (c) 2013年 hand. All rights reserved.
//

#import "HDAutologinModel.h"

@implementation HDAutologinModel
@synthesize submitURL = _submitURL;
@synthesize token = _token;

-(void)dealloc
{
    TT_RELEASE_SAFELY(_submitURL);
    TT_RELEASE_SAFELY(_token);
    [super dealloc];
}
-(id)init
{
    if (self = [super init]) {
    }
    return self;
}
-(void)autologin
{
    id postdata = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                   self.token,@"sid",nil];
    
    HDRequestMap * map = [HDRequestMap mapWithDelegate:self];
    map.urlPath = self.submitURL;
    map.postData = postdata;
    
    [self requestWithMap:map];
}
 
@end
