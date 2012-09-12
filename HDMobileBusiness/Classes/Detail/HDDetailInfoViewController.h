//
//  HDDidApprovedDetailViewController.h
//  hrms
//
//  Created by Rocky Lee on 7/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDUserInfoView.h"
#import "../List/HDListModel.h"

@interface HDDetailInfoViewController : TTModelViewController<UIWebViewDelegate,UIActionSheetDelegate>
{
    UIBarButtonItem * _nextButtonItem;
    UIBarButtonItem * _prevButtonItem;
    UIBarButtonItem * _refreshButtonItem;
    
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

@property (nonatomic,retain) id<HDListModelVector> listModel;
//
-(NSString *)matchURL:(NSString *)Template;
-(void)expend;
-(void)reloadAll;
@end
