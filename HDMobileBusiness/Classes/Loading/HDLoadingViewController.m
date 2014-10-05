//
//  HDViewController.m
//  ERROR
//
//  Created by mas apple on 7/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDLoadingViewController.h"
#import "HDResourceLoader.h"
#import "HDLoginViewController.h"

static  NSString* configFileName = @"ios-backend-config";

@interface HDLoadingViewController ()

@end

@implementation HDLoadingViewController

#pragma mark -
#pragma mark  方法

-(void)loadGodConfig{
    //首先检查是否配置地址
    BOOL hasAddress = [self hasServerAddress];
    if (!hasAddress) {
        _errorSummury.text = @"Server address not found in configuration";
        _errorDetail.text = @"You've not set the server address,back to the main screen and step into the 'Hand Mobile Bussiness' in 'Settings'，then enter the server address of your company.";
        _retryButton.hidden = NO;
        [_retryButton setUserInteractionEnabled:YES];
    }else {
        //开始发请求
        NSString *fileURL = [NSString stringWithFormat:@"%@?t=%i",[self configFileURL],(int)[[NSDate date] timeIntervalSince1970]];
        NSURL *url = [NSURL URLWithString:fileURL];
        NSMutableURLRequest *postRequest = [[[NSMutableURLRequest alloc]initWithURL:url]autorelease];
        [postRequest setHTTPMethod:@"GET"];
        [postRequest setTimeoutInterval:30];
        NSOperationQueue *queue = [[[NSOperationQueue alloc] init]autorelease];
        
        //构造block
        void(^completionHandler)(NSURLResponse *response,
                                 NSData *data,
                                 NSError *error) = ^(NSURLResponse *response,
                                                     NSData *data,
                                                     NSError *error){
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            //count
            if (error) {
                NSInteger errorCode = [error code];
                if (errorCode == -1001||errorCode == -1003) {
                    //超时
                    //神一般的ping
                    BOOL ping1Success = [self pingStage1];
                    if (ping1Success) {
                        //百度ping通
                        dispatch_async(dispatch_get_main_queue(), ^{
                            _errorSummury.text = @"Unexpected network";
                            _errorDetail.text = @"Your cell phone can current access while the server is not reachable.Please check the server address is entered correctly.There may be a server in shutdown status if you have ever used before.In addition,checking the VPN if your company uses it.";
                            _retryButton.hidden = NO;
                            _alertView.hidden = NO;
                            _retryButton.userInteractionEnabled = YES;
                        });
                    }else {
                        //百度ping不通
                        dispatch_async(dispatch_get_main_queue(), ^{
                            _errorSummury.text =  @"None available network connection";
                            _errorDetail.text = @"Please check your network connection.";
                            _retryButton.hidden = NO;
                            _alertView.hidden = NO;
                            _retryButton.userInteractionEnabled = YES;
                        });
                        
                    }
                }else if (errorCode == -1004) {
                    //没有网
                    dispatch_async(dispatch_get_main_queue(), ^{
                        _errorSummury.text = @"None available network connection";
                        _errorDetail.text = @"Please check your network connection.";
                        _retryButton.hidden = NO;
                        _alertView.hidden = NO;
                        _retryButton.userInteractionEnabled = YES;
                    });
                }else {
                    //未知错误，抛出原始错误信息
                    dispatch_async(dispatch_get_main_queue(), ^{
                        _errorSummury.text = @"Network connection failure";
                        _errorDetail.text =[NSString  stringWithFormat:@"Unknow error cause\n error description：\n%@",[error description]] ;
                        _retryButton.hidden = NO;
                        _alertView.hidden = NO;
                        _retryButton.userInteractionEnabled = YES;
                    });
                }
                
            }else{
                NSInteger responseCode = [httpResponse statusCode];
                if (responseCode!=200) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        _errorSummury.text =@"Abnormal state of server";
                        _errorDetail.text =[NSString  stringWithFormat:@"Please contact the technical support.\n the server returns status code：%i",responseCode] ;
                        _retryButton.hidden = NO;
                        _alertView.hidden = NO;
                        _retryButton.userInteractionEnabled = YES;
                    });
                }else {
                    BOOL writeSuccess = [data writeToFile:TTPathForDocumentsResource(@"ios-backend-config.xml") atomically:YES];
                    if (writeSuccess) {
                        
                        //在这里解析
                        if (![HDApplicationContext configApplicationContextForXmlPath:@"ios-backend-config.xml"]) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                _errorSummury.text = @"Abnormal file from server";
                                _errorDetail.text = @"Files returned from server are unsuccessfully parsed，please contact the technical support.";
                                _retryButton.hidden = NO;
                                _alertView.hidden = NO;
                                _retryButton.userInteractionEnabled = YES;
                            });
                        }else {
                            //最终状态
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self dismissViewControllerAnimated:NO completion:^{}];
                                [self autologin];
                            });
                        }
                    }
                }
            }
        };
        [NSURLConnection sendAsynchronousRequest:postRequest
                                           queue:queue
                               completionHandler:completionHandler];
    }
}

-(NSString *)configFileURL
{
        return [NSString stringWithFormat:@"%@%@.xml",[HDHTTPRequestCenter baseURLPath],configFileName];
}

-(BOOL)pingStage1{
    BOOL success = false;
    
    NSURL *url = [NSURL URLWithString:@"http://www.baidu.com"];
    NSMutableURLRequest *postRequest = [[[NSMutableURLRequest alloc]initWithURL:url]autorelease];
    [postRequest setHTTPMethod:@"HEAD"];
    [postRequest setTimeoutInterval:10];
    NSHTTPURLResponse* response = nil;
    NSData *resData = nil;
    
    resData= [NSURLConnection sendSynchronousRequest:postRequest returningResponse:&response error:nil];
    
    if (resData) {
        success = true;
    }
    
    return success;
}

-(void)retry{
    [self loadGodConfig];
}


-(BOOL)hasServerAddress{
    NSString *address = [[NSUserDefaults standardUserDefaults] objectForKey:@"base_url_preference"];
    if (address.length==0||[address isEqualToString:@"http://"]) {
        return NO;
    }else {
        return YES;
    }
}

//设置用户选项
- (void)setupByPreferences
{
    NSString *baseURL = [[NSUserDefaults standardUserDefaults] stringForKey:@"base_url_preference"];
    NSString *defaultApprove = [[NSUserDefaults standardUserDefaults] stringForKey:@"default_approve_preference"];
	if (!baseURL||!defaultApprove)
	{
        //从root文件读取配置
        NSString *settingsBundlePath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"Settings.bundle"];
        
        NSString *finalPath = [settingsBundlePath stringByAppendingPathComponent:@"Root.plist"];
        NSDictionary *settingsDict = [NSDictionary dictionaryWithContentsOfFile:finalPath];
        
        NSArray *prefSpecifierArray = [settingsDict objectForKey:@"PreferenceSpecifiers"];
        
        NSMutableDictionary *appDefaults = [NSMutableDictionary dictionary];
        for (NSDictionary *prefItem in prefSpecifierArray)
        {
            if ([prefItem objectForKey:@"DefaultValue"] != nil) {
                [appDefaults setValue:[prefItem objectForKey:@"DefaultValue"]
                               forKey:[prefItem objectForKey:@"Key"]];
            }
        }
        
        [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
        [[NSUserDefaults standardUserDefaults] synchronize];
	}
}
-(void)setAutologinModel:(id<HDAutologinModel>)autologinModel
{
    _autologinModel = [autologinModel retain];
    self.model = autologinModel;
}
-(void)autologin
{
    NSString *token = [[NSUserDefaults standardUserDefaults]stringForKey:@"Token"];
    if (token) {
        self.autologinModel = [[HDApplicationContext shareContext]objectForIdentifier:@"autologinModel"];
        self.autologinModel.token = token;
        [self.autologinModel autologin];
    }else{
//        HDLoginViewController * loginVCTL = [[[HDLoginViewController alloc]initWithNibName:@"HDLoginViewController" bundle:nil]autorelease];
//        [UIApplication sharedApplication].delegate.window.rootViewController = loginVCTL;
        [self showLoginView];
    };
}
-(void)showLoginView
{
    HDViewGuider * guider = [[HDApplicationContext shareContext]objectForIdentifier:@"loadingGuider"] ;
    [guider perform];
}
-(void)showNavView
{
    //登录成功跳转前 刷新timer开始计时
    [[HDApplicationContext shareContext] refreshTimer];
    
    
    HDViewGuider * guider = [[HDApplicationContext shareContext]objectForIdentifier:@"loginGuider"] ;
    [guider perform];
}
//模型delegate方法
- (void)modelDidFinishLoad:(HDAutologinModel *)model
{
    

    
    [self showNavView];
}

- (void)model:(id<TTModel>)model didFailLoadWithError:(NSError*)error
{
    [self showLoginView];
}
#pragma mark - life cycle
-(void)loadView{
    self.navigationController.navigationBarHidden = YES;
    UIView *view = [[[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds]autorelease];
    self.view = view;
    self.view.backgroundColor = RGBCOLOR(235, 240, 243);
//    _customBackground = [[[UIView alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width*0.98, (self.view.frame.size.height-20)*0.98)]autorelease];
//    _customBackground.backgroundColor = RGBCOLOR(229, 232, 237);
//    _customBackground.center = CGPointMake(self.view.frame.size.width/2, (self.view.frame.size.height-20)/2);
//    _customBackground.layer.cornerRadius = 8;
//    _customBackground.layer.shadowOffset = CGSizeMake(0,0);
//    _customBackground.layer.shadowColor =[UIColor blackColor].CGColor;
//    _customBackground.layer.shadowOpacity = 1;
//    [self.view insertSubview:_customBackground atIndex:0];
    _alertView = [[[UIImageView alloc]initWithImage:TTIMAGE(@"bundle://loadingAlert.png")]autorelease];
    _alertView.center = CGPointMake(self.view.frame.size.width/2,(self.view.frame.size.height-20)*0.2);
    //    _alertView.hidden = YES;
    [self.view addSubview:_alertView];
    _errorSummury = [[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width*0.8, 50)]autorelease];
    //样式
    _errorSummury.center = CGPointMake(self.view.frame.size.width/2,(self.view.frame.size.height-20)*0.4);
    _errorSummury.numberOfLines = 2;
    _errorSummury.backgroundColor = [UIColor clearColor];
    //_errorSummury.backgroundColor = [UIColor  redColor];
    _errorSummury.textAlignment = NSTextAlignmentCenter;
    _errorSummury.adjustsFontSizeToFitWidth = NO;
    _errorSummury.font = [UIFont fontWithName:@"Helvetica" size:18];
    _errorSummury.textColor = RGBCOLOR(133, 141, 155);
    _errorSummury.text =@"Loading the configuration file, please wait";
    [self.view addSubview:_errorSummury];
    
    _errorDetail = [[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width*0.8, 200)]autorelease];
    //样式
    _errorDetail.center = CGPointMake(self.view.frame.size.width/2,(self.view.frame.size.height-20)*0.6);
    _errorDetail.numberOfLines = 20;
    _errorDetail.font = [UIFont fontWithName:@"Helvetica" size:14];
    _errorDetail.textAlignment = NSTextAlignmentCenter;
    _errorDetail.backgroundColor = [UIColor clearColor];
    //_errorDetail.backgroundColor = [UIColor  redColor];
    _errorDetail.textColor = RGBCOLOR(100,103,108);
    [self.view addSubview:_errorDetail];
    
    _retryButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_retryButton setImage:[UIImage imageNamed:@"reloadButton"] forState:UIControlStateNormal];
    [_retryButton setImage:[UIImage imageNamed:@"reloadButtonActive"] forState:UIControlStateHighlighted];
    [_retryButton addTarget:self action:@selector(retry) forControlEvents:UIControlEventTouchUpInside];
    _retryButton.center = CGPointMake(self.view.frame.size.width/2,(self.view.frame.size.height-20)*0.8);
    _retryButton.bounds = CGRectMake(0, 0, 100, 100);
    _retryButton.hidden = YES;
    [_retryButton setUserInteractionEnabled:NO];
    [self.view addSubview:_retryButton];
    if (TTIsPad()) {
        //        _alertView.center = CGPointMake(self.view.frame.size.width/2,self.view.frame.size.height*0.2);
        //        _errorSummury.center = CGPointMake(self.view.frame.size.width/2,self.view.frame.size.height*0.4);
        //        _errorDetail.center = CGPointMake(self.view.frame.size.width/2,self.view.frame.size.height*0.6);
        //        _retryButton.center = CGPointMake(self.view.frame.size.width/2,self.view.frame.size.height*0.8);
        _errorSummury.font = [UIFont fontWithName:@"Helvetica" size:32];
        _errorDetail.font = [UIFont fontWithName:@"Helvetica" size:24];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupByPreferences];
    [self loadGodConfig];
	// Do any additional setup after loading the view, typically from a nib.
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    TT_RELEASE_SAFELY(_autologinModel);
    // Release any retained subviews of the main view.
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationPortrait == interfaceOrientation;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}
@end
