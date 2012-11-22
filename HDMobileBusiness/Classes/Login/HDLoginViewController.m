//
//  RCLoginViewController.m
//  HRMS
//
//  Created by Rocky Lee on 3/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDLoginViewController.h"

@implementation HDLoginViewController

@synthesize titleLabel = _titleLabel;
@synthesize username = _username;
@synthesize password = _password;
@synthesize loginBtn = _loginBtn;

@dynamic loginModel;

@synthesize  backgroundImage = _backgroundImage,loginButtonNormalImage = _loginButtonNormalImage,loginButonHighlightedImage = _loginButonHighlightedImage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setAutoresizesForKeyboard:YES];
        
//        _loginModel = [[HDLoginModel alloc]init];
//        self.model = _loginModel;
        //注册_loginModel观察self的username.text。当_loginModel接收到消息时，设置context指定的自己对应的属性
        
    }
    return self;
}

-(void)setLoginModel:(id<HDLoginModel>)loginModel
{
    _loginModel = loginModel;
    self.model = loginModel;
    
    [self addObserver:_loginModel forKeyPath:@"username.text" options:NSKeyValueObservingOptionNew context:@"username"];
    [self addObserver:_loginModel forKeyPath:@"password.text" options:NSKeyValueObservingOptionNew context:@"password"];
}

-(id<HDLoginModel>)loginModel
{
    return _loginModel;
}

-(void)viewDidUnload
{
    [self removeObserver:_loginModel forKeyPath:@"username.text"];
    [self removeObserver:_loginModel forKeyPath:@"password.text"];
    TT_RELEASE_SAFELY(_titleLabel);
    TT_RELEASE_SAFELY(_username);
    TT_RELEASE_SAFELY(_password);
//    TT_RELEASE_SAFELY(_loginModel);
    TT_RELEASE_SAFELY(_loginBtn);

    TT_RELEASE_SAFELY(_backgroundImage);
    TT_RELEASE_SAFELY(_loginButtonNormalImage);
    TT_RELEASE_SAFELY(_loginButonHighlightedImage);
//    TT_RELEASE_SAFELY(_titleLabelText);
    
    TT_RELEASE_SAFELY(_usernameDelegate);
    TT_RELEASE_SAFELY(_passwordDelegate);
    [super viewDidUnload];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    _username.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"username"];
    _password.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"password"];
    
    _usernameDelegate = [[HDTextFieldDelegate alloc]initWithTarget:self selector:@selector(usernameFieldShouldReturn:)];
    _username.delegate = _usernameDelegate;
    
    _passwordDelegate = [[HDTextFieldDelegate alloc]initWithTarget:self selector:@selector(passwordFieldShouldReturn:)];
    _password.delegate = _passwordDelegate;
    
//    if (self.titleLabelText) {
//        self.titleLabel.text = self.titleLabelText;
//    }
    
    if (self.backgroundImage) {
        [(UIImageView *)[self.view viewWithTag:9] setImage:self.backgroundImage];
    }
    
    if (self.loginButtonNormalImage) {
        [_loginBtn setBackgroundImage:self.loginButtonNormalImage forState:UIControlStateNormal];
    }
    
    if (self.loginButonHighlightedImage) {
        [_loginBtn setBackgroundImage:self.loginButonHighlightedImage forState:UIControlStateHighlighted];
    }
}

-(void)usernameFieldShouldReturn:(UITextField *) textField
{
    [_password becomeFirstResponder];
}

-(void)passwordFieldShouldReturn:(UITextField *) textField
{
    [_password resignFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController.navigationBar setHidden:NO];
    [super viewWillDisappear:animated];
}

#pragma login functions
-(IBAction)loginBtnPressed:(id)sender{
     [_username resignFirstResponder];
     [_password resignFirstResponder];
    
    if (!(_username.text.length && _password.text.length)) {
        TTAlertNoTitle(@"用户名和密码不能为空");
        return;
    }
    
    if ([self.loginBtn tag] == 20) {
        [_loginModel login];
        [self.loginBtn setTitle:@"取消" forState:UIControlStateNormal];
        [self.loginBtn setTag:21];
    }else{
        [_loginModel cancel];
        [self.loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        [self.loginBtn setTag:20];
    }
}

//模型delegate方法
- (void)modelDidFinishLoad:(HDLoginModel *)model
{
    HDViewGuider * guider = [[HDApplicationContext shareContext]objectForIdentifier:@"loginGuider"];
    [guider perform];

}

- (void)model:(id<TTModel>)model didFailLoadWithError:(NSError*)error
{
    [self.loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [self.loginBtn setTag:20];
    NSString * errorDescription = nil;
    if (!errorDescription) {
        errorDescription = [[error userInfo] valueForKeyPath:@"error"];
    }
    if (!errorDescription) {
        errorDescription = [error localizedDescription];
    }
    TTAlertNoTitle(errorDescription);
}

#pragma animations for keyborad
-(void)keyboardWillAppear:(BOOL)animated withBounds:(CGRect)bounds
{
    [UIView beginAnimations:@"keyboardAnimation" context:NULL];
    for (UIView * subView in [self.view subviews]) {
        CGAffineTransform moveTransform = CGAffineTransformMakeTranslation(0, -140);
        [subView.layer setAffineTransform:moveTransform];
    }
    [UIView commitAnimations];
}

-(void)keyboardWillDisappear:(BOOL)animated withBounds:(CGRect)bounds
{
    [UIView beginAnimations:@"keyboardAnimation" context:NULL];
    for (UIView * subView in [self.view subviews]) {
        CGAffineTransform moveTransform = CGAffineTransformMakeTranslation(0, 0);
        [subView.layer setAffineTransform:moveTransform];
    }
    [UIView commitAnimations];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

//-(BOOL)shouldAutorotate
//{
//    return NO;
//}

//-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
//{
//    if (toInterfaceOrientation == UIInterfaceOrientationMaskPortrait) {
//        _username.origin = CGPointMake(75, 231);
//        _password.origin = CGPointMake(75, 271);
//    }else{
//        _username.origin = CGPointMake(100, 80);
//        _password.origin = CGPointMake(100, 105);
//    }
    
    
//}
@end
