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

@interface HDLoginViewController : TTModelViewController
{
    id<HDLoginModel,TTModel>  _loginModel;
    HDTextFieldDelegate * _usernameDelegate;
    HDTextFieldDelegate * _passwordDelegate;
}

@property(nonatomic,assign) id<HDLoginModel> loginModel;

//界面上的用户名和密码
@property (nonatomic,retain) IBOutlet UITextField * username;
@property (nonatomic,retain) IBOutlet UITextField * password;
@property (nonatomic,retain) IBOutlet UIButton * loginBtn;

//配置项
//@property (nonatomic,copy) NSString * titleLabelText;
@property (nonatomic,retain) id<HDImageLoader>  backgroundImageLoader;
@property (nonatomic,retain) id<HDImageLoader>  loginButtonNormalImageLoader;
@property (nonatomic,retain) id<HDImageLoader>  loginButonHighlightedImageLoader;

-(IBAction)loginBtnPressed:(id)sender;

@end
