//
//  HDDidApprovedDetailViewController.m
//  hrms
//
//  Created by Rocky Lee on 7/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDDetailInfoViewController.h"

#import "HDUserInfoView.h"
//#import "Approve.h"

@implementation HDDetailInfoViewController

@synthesize employeeName = _employeeName;
@synthesize employeeURLPath = _employeeURLPath;
@synthesize webPageURLPath = _webPageURLPath;

-(void)dealloc
{
    TT_RELEASE_SAFELY(_employeeName);
    TT_RELEASE_SAFELY(_employeeURLPath);
    TT_RELEASE_SAFELY(_webPageURLPath);
    [super dealloc];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _employeeView = [[HDUserInfoView alloc] initWithFrame:HDNavigationLandscapeFrame()];
    _employeeView.employeeUrlPath = self.employeeURLPath;
    [self.view addSubview: _employeeView];
    
    //添加员工信息页面按钮
    UIBarButtonItem *employeeInfoItem = [[UIBarButtonItem alloc]initWithTitle:self.employeeName style:UIBarButtonItemStyleBordered target:_employeeView action:@selector(show)];    
    self.navigationItem.rightBarButtonItem = employeeInfoItem;
    [employeeInfoItem release];
}

-(void)setWebPageURLPath:(NSString *)webPageURLPath
{
    if (nil != _webPageURLPath) {
        TT_RELEASE_SAFELY(_webPageURLPath);
    }
    _webPageURLPath = [webPageURLPath retain];
    [self openURL:[NSURL URLWithString:self.webPageURLPath]];
}

CGRect HDNavigationLandscapeFrame() {
    
    CGRect frame = TTScreenBounds();
    return  CGRectMake(0, 0, frame.size.width, frame.size.height - TTToolbarHeight());
}

@end
