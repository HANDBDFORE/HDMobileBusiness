//
//  RCLoginViewController.h
//  HRMS
//
//  Created by Rocky Lee on 3/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDLoginModel.h"
#import "HDTextFieldDelegate.h"

@interface HDLoginViewController : TTModelViewController
{
    id<HDLoginModel,TTModel>  _loginModel;
    HDTextFieldDelegate * _usernameDelegate;
    HDTextFieldDelegate * _passwordDelegate;
}

@property(nonatomic,assign) id<HDLoginModel> loginModel;

@property(nonatomic,retain) IBOutlet UILabel * titleLabel;

//界面上的用户名和密码
@property (nonatomic,retain) IBOutlet UITextField * username;
@property (nonatomic,retain) IBOutlet UITextField * password;
@property (nonatomic,retain) IBOutlet UIButton * loginBtn;

//配置项
//@property (nonatomic,copy) NSString * titleLabelText;
@property (nonatomic,retain) UIImage * backgroundImage;
@property (nonatomic,retain) UIImage * loginButtonNormalImage;
@property (nonatomic,retain) UIImage * loginButonHighlightedImage;

-(IBAction)loginBtnPressed:(id)sender;

@end
