//
//  HDDidApprovedDetailViewController.m
//  hrms
//
//  Created by Rocky Lee on 7/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDDetailInfoViewController.h"

#import "HDUserInfoView.h"
@interface HDDetailInfoViewController()

@property(nonatomic,copy) NSString* currentURL;

@end

@implementation HDDetailInfoViewController{
    NSString * _currentURL;
    UIBarButtonItem *_employeeInfoItem;
}

//单据明细页面URL模板
@synthesize webPageURLTemplate = _webPageURLTemplate;
//用户信息页面URL模板
@synthesize userInfoPageURLTemplate = _userInfoPageURLTemplate;
//用户信息按钮显示字段
@synthesize userInfoItemTitle = _userInfoItemTitle;
//model
//@synthesize listModel = _listModel;
@synthesize currentURL = _currentURL;

#pragma mark - life cycle
#pragma mark -
-(void)viewDidUnload{
    TT_RELEASE_SAFELY(_webPageURLTemplate);
    TT_RELEASE_SAFELY(_userInfoPageURLTemplate);
    TT_RELEASE_SAFELY(_userInfoItemTitle);
    TT_RELEASE_SAFELY(_pageTurningService);
    TT_RELEASE_SAFELY(_currentURL);
    TT_RELEASE_SAFELY(_nextButtonItem);
    TT_RELEASE_SAFELY(_prevButtonItem);
    TT_RELEASE_SAFELY(_refreshButtonItem);
    TT_RELEASE_SAFELY(_employeeInfoItem);
    [super viewDidUnload];
}

- (void)loadView{
    [super loadView];

    _webView = [[UIWebView alloc] initWithFrame:TTNavigationFrame()];
    _webView.delegate = self;
    _webView.scalesPageToFit = YES;
    _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_webView];
    
    //user info view
    _userInfoView = [[HDUserInfoView alloc]initWithFrame:TTNavigationFrame()];
    [self.view addSubview:_userInfoView];
    
    //next button
    _nextButtonItem = [[UIBarButtonItem alloc]initWithImage:TTIMAGE(@"bundle://Three20.bundle/images/forwardIcon.png") style:UIBarButtonItemStyleBordered target:self action:@selector(forwordWebPage)];
    
    //prev button
    _prevButtonItem = [[UIBarButtonItem alloc]initWithImage:TTIMAGE(@"bundle://Three20.bundle/images/backIcon.png") style:UIBarButtonItemStyleBordered target:self action:@selector(backWebPage)];
    
    //refresh button
    _refreshButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshWebPage)];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self reloadAll];
}

#pragma mark - 方法
#pragma mark -
-(void)refreshWebPage{
    TTDPRINT(@"refresh");
    [self reloadAll];
}

-(void)forwordWebPage{
    [self.pageTurningService next];
    [self reloadAll];
}

-(void)backWebPage{
    [self.pageTurningService prev];
    [self reloadAll];
}

-(void)reloadAll{
    NSString * employeeURLPath = [self.userInfoPageURLTemplate stringByReplacingSpaceHodlerWithDictionary:[self.pageTurningService current]] ;
    _userInfoView.employeeUrlPath = [employeeURLPath stringByReplacingSpaceHodlerWithDictionary:@{@"base_url":[HDHTTPRequestCenter baseURLPath]}] ;
    NSString *currentURL = [self.webPageURLTemplate stringByReplacingSpaceHodlerWithDictionary:[self.pageTurningService current]];

    self.currentURL = [currentURL stringByReplacingSpaceHodlerWithDictionary:@{@"base_url":[HDHTTPRequestCenter baseURLPath]}];
    
    [self openURL:[NSURL URLWithString:self.currentURL]];
    //employee info button
    if(_employeeInfoItem){
        TT_RELEASE_SAFELY(_employeeInfoItem);
    }
    _employeeInfoItem = [[UIBarButtonItem alloc]initWithTitle:[[self.pageTurningService current] objectForKey:self.userInfoItemTitle] style:UIBarButtonItemStyleBordered target:_userInfoView action:@selector(show)];
    
    self.navigationItem.rightBarButtonItems =[NSArray arrayWithObjects:_nextButtonItem,_prevButtonItem,_refreshButtonItem,_employeeInfoItem,nil] ;
    _nextButtonItem.enabled = [self.pageTurningService hasNext];
    _prevButtonItem.enabled = [self.pageTurningService hasPrev];
}

- (void)openURL:(NSURL*)URL {
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:URL];
    [self openRequest:request];
}

- (void)openRequest:(NSURLRequest*)request {
    [_webView loadRequest:request];
}
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return toInterfaceOrientation!=UIInterfaceOrientationPortraitUpsideDown;
}
@end
