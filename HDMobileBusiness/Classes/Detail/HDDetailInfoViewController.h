//
//  HDDidApprovedDetailViewController.h
//  hrms
//
//  Created by Rocky Lee on 7/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDUserInfoView.h"
#import "HDTodoListModel.h"

@interface HDDetailInfoViewController : TTModelViewController<UIWebViewDelegate,UIActionSheetDelegate>
{
@protected
    HDUserInfoView *_userInfoView;
    UIWebView *_webView;
    NSInteger index;
}
//单据明细页面URL模板
@property (nonatomic,copy) NSString * webPageURLTemplate;
//用户信息页面URL模板
@property (nonatomic,copy) NSString * userInfoPageURLTemplate;
//用户信息按钮显示字段
@property (nonatomic,copy) NSString * userInfoItemTitle;
//model
@property (nonatomic,retain) HDTodoListModel * todoListModel;
//
@end
