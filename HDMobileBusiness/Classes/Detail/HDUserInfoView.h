//
//  HDEmployeeView.h
//  hrms
//
//  Created by Rocky Lee on 7/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HDUserInfoView : UIControl
{
    @protected
    
    UIWebView * _empWebView;
    
    BOOL _isPullDown;
    BOOL _isFirstLoad;
}

@property(nonatomic,copy) NSString * employeeUrlPath;

-(void)show;

@end
