//
//  RCLoginViewController.m
//  HRMS
//
//  Created by Rocky Lee on 3/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDLoginViewController.h"

@implementation HDLoginViewController

@synthesize username = _username;
@synthesize password = _password;
@synthesize loginBtn = _loginBtn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setAutoresizesForKeyboard:YES];
    }
    return self;
}

-(void)setLoginModel:(id<HDLoginModel>)loginModel
{
    _loginModel = [loginModel retain];
    self.model = loginModel;
    
    //注册模型键值观察
    [self addObserver:_loginModel forKeyPath:@"username.text" options:NSKeyValueObservingOptionNew context:@"username"];
    [self addObserver:_loginModel forKeyPath:@"password.text" options:NSKeyValueObservingOptionNew context:@"password"];
}

-(void)viewDidUnload
{
    [self removeObserver:self.loginModel forKeyPath:@"username.text"];
    [self removeObserver:self.loginModel forKeyPath:@"password.text"];
    
    TT_RELEASE_SAFELY(_loginModel);
    
    TT_RELEASE_SAFELY(_username);
    TT_RELEASE_SAFELY(_password);
    TT_RELEASE_SAFELY(_loginBtn);
    
    TT_RELEASE_SAFELY(_backgroundImageLoader);
    TT_RELEASE_SAFELY(_loginButtonNormalImageLoader);
    TT_RELEASE_SAFELY(_loginButonHighlightedImageLoader);
    
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
    
    if (self.backgroundImageLoader) {
        [(UIImageView *)[self.view viewWithTag:9] setImage:[self.backgroundImageLoader image]];
    }
    
    if (self.loginButtonNormalImageLoader) {
        [_loginBtn setBackgroundImage:[self.loginButtonNormalImageLoader image]
                             forState:UIControlStateNormal];
    }

    if (self.loginButonHighlightedImageLoader) {
        [_loginBtn setBackgroundImage:[self.loginButonHighlightedImageLoader image]
                             forState:UIControlStateHighlighted];
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
        [self.loginModel login];
        [self.loginBtn setTitle:@"取消" forState:UIControlStateNormal];
        [self.loginBtn setTag:21];
    }else{
        [self.loginModel cancel];
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

@end
