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
    UIBarButtonItem * _employeeInfoItem;

    HDUserInfoView *_userInfoView;
    NSInteger index;
    
    @protected
    UIBarButtonItem* _popoverItem;
}

//单据明细页面URL模板
@property (nonatomic,copy) NSString * webPageURLTemplate;
//用户信息页面URL模板
@property (nonatomic,copy) NSString * userInfoPageURLTemplate;
//用户信息按钮显示字段
@property (nonatomic,copy) NSString * userInfoField;

@property (nonatomic,retain) id<HDPageTurning> pageTurningService;

@property (nonatomic, retain) UIView* emptyView;

//调用viewWillAppear，nextRecord，prevRecord时会调用该方法刷新页面
-(void)loadRecord:(NSDictionary *)record;

-(void)loadCurrentRecord;

-(void)nextRecord;

-(void)prevRecord;

-(NSMutableArray *)createRightNavigationItems;

-(NSMutableArray *)createLeftNavigationItems;

-(void)updateNavigationItems;


@end
