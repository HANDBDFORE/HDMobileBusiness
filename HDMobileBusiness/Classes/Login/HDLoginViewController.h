//
//  RCLoginViewController.h
//  HRMS
//
//  Created by Rocky Lee on 3/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDLoginModel.h"
#import "HDTextFieldDelegate.h"
#import "HDImageLoader.h"
#import "HDMathCheckModel.h"
#import "SignViewUlan.h"


@interface HDLoginViewController : TTModelViewController<SignViewUlanDelegate>
{
    HDTextFieldDelegate * _usernameDelegate;
    HDTextFieldDelegate * _passwordDelegate;
}

@property(nonatomic,retain) id<HDLoginModel> loginModel;


@property (nonatomic,retain) HDMathCheckModel * hdMathCheckModel;

//界面上的用户名和密码
@property (nonatomic,retain) IBOutlet UITextField * username;
@property (nonatomic,retain) IBOutlet UITextField * password;
@property (nonatomic,retain) IBOutlet UIButton * loginBtn;

@property (retain, nonatomic) IBOutlet UILabel *loginLbl;

@property (retain, nonatomic) IBOutlet UILabel *passwordLbl;

//配置项
@property (nonatomic,retain) id<HDImageLoader>  backgroundImageLoader;
@property (nonatomic,retain) id<HDImageLoader>  loginButtonNormalImageLoader;
@property (nonatomic,retain) id<HDImageLoader>  loginButonHighlightedImageLoader;


@property (nonatomic,retain) SignViewUlan       * key;

-(IBAction)loginBtnPressed:(id)sender;

@end
