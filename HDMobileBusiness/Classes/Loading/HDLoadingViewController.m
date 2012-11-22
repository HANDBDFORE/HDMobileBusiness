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
@interface HDLoadingViewController ()

@end

@implementation HDLoadingViewController

#pragma mark -
#pragma mark  方法

-(void)loadGodConfig{
    //首先检查是否配置地址
    BOOL hasAddress = [self hasServerAddress];
    if (!hasAddress) {
        _errorSummury.text = @"服务地址未配置";
        _errorDetail.text = @"您还没有设置服务器地址。请回到主屏幕，打开“设置”，进入“移动商务”，在服务器地址一栏输入您公司所用的服务器地址";
        _retryButton.hidden = NO;
        [_retryButton setUserInteractionEnabled:YES];
    }else {
        //开始发请求
        NSString *fileUrl = [NSString stringWithFormat:@"%@ios-backend-config-sprite.xml",[HDHTTPRequestCenter baseURLPath]];

        NSURL *url = [NSURL URLWithString:fileUrl];
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
                            _errorSummury.text = @"网络异常";
                            _errorDetail.text = @"您的手机当前可以上网，但无法连接到设定的服务器。请检查服务器地址是否正确。如果之前使用正常，有可能是服务器处于停机状态。如果您公司启用了VPN等安全接入方式，请检查是否已经成功连接VPN。";
                            _retryButton.hidden = NO;
                            _alertView.hidden = NO;
                            _retryButton.userInteractionEnabled = YES;
                        });
                    }else {
                        //百度ping不通
                        dispatch_async(dispatch_get_main_queue(), ^{
                            _errorSummury.text = @"没有可用的网络连接";
                            _errorDetail.text = @"请检查您的设备是否有可用的网络连接。";
                            _retryButton.hidden = NO;
                            _alertView.hidden = NO;
                            _retryButton.userInteractionEnabled = YES;
                        });
                        
                    }
                }else if (errorCode == -1004) {
                    //没有网
                    dispatch_async(dispatch_get_main_queue(), ^{
                        _errorSummury.text = @"没有可用的网络连接";
                        _errorDetail.text = @"请检查您的设备是否有可用的网络连接。";
                        _retryButton.hidden = NO;
                        _alertView.hidden = NO;
                        _retryButton.userInteractionEnabled = YES;
                    });
                }else {
                    //未知错误，抛出原始错误信息
                    dispatch_async(dispatch_get_main_queue(), ^{
                        _errorSummury.text = @"网络连接失败";
                        _errorDetail.text =[NSString  stringWithFormat:@"未知的错误原因\n错误描述：\n%@",[error description]] ;
                        _retryButton.hidden = NO;
                        _alertView.hidden = NO;
                        _retryButton.userInteractionEnabled = YES;
                    });
                }
                
            }else{
                NSInteger responseCode = [httpResponse statusCode];
                if (responseCode!=200) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        _errorSummury.text = @"服务器状态异常";
                        _errorDetail.text =[NSString  stringWithFormat:@"请联系技术支持。\n服务器返回状态：%i",responseCode] ;
                        _retryButton.hidden = NO;
                        _alertView.hidden = NO;
                        _retryButton.userInteractionEnabled = YES;
                    });
                }else {
                    BOOL writeSuccess = [data writeToFile:TTPathForDocumentsResource(@"ios-backend-config.xml") atomically:YES];
                    if (writeSuccess) {
                        if (![HDXMLParser hasParsedSuccess]) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                _errorSummury.text = @"服务器返回文件异常";
                                _errorDetail.text = @"服务器返回文件未能被成功解析，请联系技术支持。";
                                _retryButton.hidden = NO;
                                _alertView.hidden = NO;
                                _retryButton.userInteractionEnabled = YES;
                            });
                        }else {
                            //最终状态
                            dispatch_async(dispatch_get_main_queue(), ^{
                                //                            [self loadClass];
                                //                            [self loadResource];
                                [self dismissModalViewControllerAnimated:NO];
                                [self showLoginView];
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
    NSUserDefaults *serverAddress = [NSUserDefaults standardUserDefaults];
    NSString *address = [serverAddress objectForKey:@"base_url_preference"];
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

-(void)showLoginView
{
    //TODO:这个应该在下载完成后就解析
    [HDApplicationContext configApplicationContextForXmlPath:@"ios-backend-config-sprite.xml"];
    [[[HDApplicationContext shareContext]objectForIdentifier:@"loadingGuider"] perform];
}

#pragma mark - life cycle
-(void)loadView{
    self.navigationController.navigationBarHidden = YES;
    UIView *view = [[[UIView alloc]initWithFrame:[UIScreen mainScreen].applicationFrame]autorelease];
    self.view = view;
    self.view.backgroundColor = RGBCOLOR(235, 240, 243);
    _customBackground = [[[UIView alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width*0.98, self.view.frame.size.height*0.98)]autorelease];
    _customBackground.backgroundColor = RGBCOLOR(229, 232, 237);
    _customBackground.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    _customBackground.layer.cornerRadius = 8;
    _customBackground.layer.shadowOffset = CGSizeMake(0,0);
    _customBackground.layer.shadowColor =[UIColor blackColor].CGColor;
    _customBackground.layer.shadowOpacity = 1;
    [self.view insertSubview:_customBackground atIndex:0];
    _alertView = [[[UIImageView alloc]initWithImage:TTIMAGE(@"bundle://loadingAlert.png")]autorelease];
    _alertView.center = CGPointMake(self.view.frame.size.width/2,self.view.frame.size.height*0.2);
    //    _alertView.hidden = YES;
    [self.view addSubview:_alertView];
    _errorSummury = [[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width*0.8, 50)]autorelease];
    //样式
    _errorSummury.center = CGPointMake(self.view.frame.size.width/2,self.view.frame.size.height*0.4);
    _errorSummury.numberOfLines = 2;
    _errorSummury.backgroundColor = [UIColor clearColor];
    //_errorSummury.backgroundColor = [UIColor  redColor];
    _errorSummury.textAlignment = UITextAlignmentCenter;
    _errorSummury.adjustsFontSizeToFitWidth = NO;
    _errorSummury.font = [UIFont fontWithName:@"Helvetica" size:18];
    _errorSummury.textColor = RGBCOLOR(133, 141, 155);
    _errorSummury.text = @"正在加载配置文件，请稍候";
    [self.view addSubview:_errorSummury];
    
    _errorDetail = [[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width*0.8, 200)]autorelease];
    //样式
    _errorDetail.center = CGPointMake(self.view.frame.size.width/2,self.view.frame.size.height*0.6);
    _errorDetail.numberOfLines = 20;
    _errorDetail.font = [UIFont fontWithName:@"Helvetica" size:14];
    _errorDetail.textAlignment = UITextAlignmentCenter;
    _errorDetail.backgroundColor = [UIColor clearColor];
    //_errorDetail.backgroundColor = [UIColor  redColor];
    _errorDetail.textColor = RGBCOLOR(100,103,108);
    [self.view addSubview:_errorDetail];
    
    _retryButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_retryButton setImage:[UIImage imageNamed:@"reloadButton"] forState:UIControlStateNormal];
    [_retryButton setImage:[UIImage imageNamed:@"reloadButtonActive"] forState:UIControlStateHighlighted];
    [_retryButton addTarget:self action:@selector(retry) forControlEvents:UIControlEventTouchUpInside];
    _retryButton.center = CGPointMake(self.view.frame.size.width/2,self.view.frame.size.height*0.8);
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
    // Release any retained subviews of the main view.
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationPortrait == interfaceOrientation;
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

@end
