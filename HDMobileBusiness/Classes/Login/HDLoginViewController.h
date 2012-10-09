//
//  RCLoginViewController.h
//  HRMS
//
//  Created by Rocky Lee on 3/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDLoginModel.h"

@interface HDLoginViewController : TTModelViewController
{
    HDLoginModel * _loginModel;
}    
//界面上的用户名和密码
@property (nonatomic,retain) IBOutlet UITextField * username;
@property (nonatomic,retain) IBOutlet UITextField * password;
@property (nonatomic,retain) IBOutlet UIButton * loginBtn;

@property (nonatomic,retain) UIImage * backgroundImage;

-(IBAction)loginBtnPressed:(id)sender;

@end
