//
//  HDDidApprovedDetailViewController.h
//  hrms
//
//  Created by Rocky Lee on 7/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDUserInfoView.h"

@interface HDDetailInfoViewController : TTWebController
{
    HDUserInfoView *_employeeView;
}

@property (nonatomic,copy) NSString * employeeURLPath;
@property (nonatomic,copy) NSString * employeeName;

/*
 *设置该属性会打开指定路径的页面
 */
@property (nonatomic,copy) NSString * webPageURLPath;

@end
