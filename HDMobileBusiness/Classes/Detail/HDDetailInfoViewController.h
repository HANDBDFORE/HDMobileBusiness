//
//  HDDidApprovedDetailViewController.h
//  hrms
//
//  Created by Rocky Lee on 7/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDWebViewController.h"
#import "HDUserInfoView.h"
#import "HDListModel.h"

@interface HDDetailInfoViewController : HDWebViewController<UISplitViewControllerDelegate>
{
    UIBarButtonItem * _nextButtonItem;
    UIBarButtonItem * _prevButtonItem;
    UIBarButtonItem * _refreshButtonItem;
    UIBarButtonItem * _employeeInfoItem;

    HDUserInfoView *_userInfoView;
    NSInteger index;
}

//单据明细页面URL模板
@property (nonatomic,copy) NSString * webPageURLTemplate;
//用户信息页面URL模板
@property (nonatomic,copy) NSString * userInfoPageURLTemplate;
//用户信息按钮显示字段
@property (nonatomic,copy) NSString * userInfoField;

@property (nonatomic,retain) id<HDPageTurning> pageTurningService;

-(void)setPropertiesWithRecord:(NSDictionary *) record;

-(void)loadCurrentRecord;

-(void)nextRecord;

-(void)prevRecord;

-(NSArray *)createRightNavigationItems:(NSArray *) others;

-(NSArray *)createLeftNavigationItems:(NSArray *) others;

@end
