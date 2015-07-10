//
//  RCLoginViewController.m
//  HRMS
//
//  Created by Rocky Lee on 3/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDLoginViewController.h"

@implementation HDLoginViewController {
    
    
}

@synthesize username = _username;
@synthesize password = _password;
@synthesize loginBtn = _loginBtn;
@synthesize hdMathCheckModel = _hdMathCheckModel;

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
    //    [self addObserver:_loginModel forKeyPath:@"username.text" options:NSKeyValueObservingOptionNew context:@"username"];
    //    [self addObserver:_loginModel forKeyPath:@"password.text" options:NSKeyValueObservingOptionNew context:@"password"];
}

-(void)viewDidUnload
{
    //    [self removeObserver:self.loginModel forKeyPath:@"username.text"];
    //    [self removeObserver:self.loginModel forKeyPath:@"password.text"];


    TT_RELEASE_SAFELY(_key);
    
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
    
    
    if (self.key == nil) {
        NSString *nibName = nil;
        if (UIUserInterfaceIdiomPad == [[UIDevice currentDevice] userInterfaceIdiom]) {
            nibName = @"SignViewUlan_iPad";
        } else {
            nibName = @"SignViewUlan";
        }
        self.key = [[SignViewUlan alloc]initWithNibName:nibName bundle:nil];

        self.key.fromLogin = YES;
    }
    
    
    
    //国家化
    
    [self.loginBtn setTitle:TTLocalizedString(@"Login", @"") forState:UIControlStateNormal];
    //    [self.passwordLbl setText:TTLocalizedString(@"Password", @"")];
    //    [self.loginLbl setText:TTLocalizedString(@"UserName", @"")];
    
    _username.layer.cornerRadius = 1.0f;
    _password.layer.cornerRadius = 1.0f;
    
    [_username setHeight:40.0f];
    [_password setHeight:40.0f];
    
    [_username setPlaceholder:TTLocalizedString(@"Please enter the username", @"")];
    [_password setPlaceholder:TTLocalizedString(@"Please enter the password", @"")];
    
    
    
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
        TTAlertNoTitle(TTLocalizedString(@"Your user name and password cannot be empty!", @""));
        return;
    }
    
    if ([self.loginBtn tag] == 20) {
        self.loginModel.username = _username.text;
        self.loginModel.password = _password.text;
        //        [self.loginModel login];
        
        [self.loginModel checkWithUserName:_username.text];
        
        [self.loginBtn setTitle:TTLocalizedString(@"Cancel", @"") forState:UIControlStateNormal];
        [self.loginBtn setTag:21];
    }else{
        [self.loginModel cancel];
        
        
        [self.loginBtn setTitle:TTLocalizedString(@"Login", @"") forState:UIControlStateNormal];
        [self.loginBtn setTag:20];
    }
}


-(void)goToLoginGuider
{
    
    HDViewGuider * guider = [[HDApplicationContext shareContext]objectForIdentifier:@"loginGuider"];
    [guider perform];
}

//模型delegate方法
- (void)modelDidFinishLoad:(HDLoginModel *)model

{
    
    
    
    if([model.tag isEqualToString:@"login"]){
        
        //登录成功跳转前 刷新timer开始计时
        [[HDApplicationContext shareContext] refreshTimer];
        
        
        HDViewGuider * guider = [[HDApplicationContext shareContext]objectForIdentifier:@"loginGuider"];
        [guider perform];
        
        
    }else if([model.tag isEqualToString:@"checkWithUserName"]) {
        //检查成功
        
       NSString * pRes =  [[model.map result] valueForKey:@"p_res"];
    
       NSString * keyId = [[model.map result] valueForKey:@"key_id"];
        
        
        
        
//
//        [_loginModel login];
        
        if([pRes isEqualToString:@"1"]){
            
            //储存keyid;
            [[NSUserDefaults standardUserDefaults]setValue:keyId forKey:@"keyId"];
            [[NSUserDefaults standardUserDefaults]synchronize];
        
        [self.key sign:[@"abc" dataUsingEncoding:NSUTF8StringEncoding]
            parentView:self.view
  parentViewController:nil
             delegator:self
              signType:@"PKCS7_ATTACHED"
              certType:nil
                  hash:@"SHA1"
                 keyID:keyId
           useCachePin:NO
                ];
        }else if([pRes isEqual:@"0"]){
            

            
            [self.loginModel login];

            
            
        }else if([pRes isEqualToString:@"-1"]){
            [self.loginBtn setTitle:TTLocalizedString(@"Login", @"") forState:UIControlStateNormal];
            [self.loginBtn setTag:20];
            TTAlertNoTitle(TTLocalizedString(@"Invalid User Account",@"Invalid User Account"));

        }
    }
    
}





- (void)model:(id<TTModel>)model didFailLoadWithError:(NSError*)error
{
    [self.key disConnectKey];
    
    [self.loginBtn setTitle:TTLocalizedString(@"Login", @"") forState:UIControlStateNormal];
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

-(void) afterDone:(ULANKeyError*)err type:(int)type result:(NSObject *)result;
{
    
    if (type == kFetchCertSuccess) {
        
        NSString * singatureBase64 = (NSString *)result;
        
        
        NSLog(@"singatureBase64 IS %@",singatureBase64);
        
        
    } else if (type == kSignSucess) {
        NSString * singatureBase64 = (NSString *)result;
        
        
        NSLog(@"singatureBase64 IS %@",singatureBase64);
        
//        [self.loginBtn setTitle:TTLocalizedString(@"Cancel", @"") forState:UIControlStateNormal];
//        [self.loginBtn setTag:21];
        
        
        
        HDLoginModel * mode =(HDLoginModel *)self.loginModel;
        
        [mode loginWithSingatureBase64:singatureBase64 ];
        
        
        
        
        
    } else if (type == kCancel) {
        
        [self.loginBtn setTitle:TTLocalizedString(@"Login", @"") forState:UIControlStateNormal];
        [self.loginBtn setTag:20];

        
    } else if (type == kDisconnected) {
        NSString *errorMessage = [NSString stringWithFormat:@"BLE已断开连接:%@", [err toString]];
        NSLog(@"%@",errorMessage);
        
//        [self.loginBtn setTitle:TTLocalizedString(@"Login", @"") forState:UIControlStateNormal];
//        [self.loginBtn setTag:20];
        
        
    }else {//kFailure
        NSString *resultString = [NSString stringWithFormat:@"Error:%@, result:%@", [err toString], result];

        NSLog(@"%@",resultString);
        
        [self.loginBtn setTitle:TTLocalizedString(@"Login", @"") forState:UIControlStateNormal];
        [self.loginBtn setTag:20];
        
        
    }


    
    
    
    
    
}



- (void)dealloc {

    
    [_loginLbl release];
    [_passwordLbl release];
    [super dealloc];
}
@end
