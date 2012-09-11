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
@synthesize listModel = _listModel;
@synthesize currentURL = _currentURL;

#pragma mark - life cycle
#pragma mark -
-(void)viewDidUnload{
    TT_RELEASE_SAFELY(_webPageURLTemplate);
    TT_RELEASE_SAFELY(_userInfoPageURLTemplate);
    TT_RELEASE_SAFELY(_userInfoItemTitle);
    TT_RELEASE_SAFELY(_listModel);
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
    
    //employee info button
    _employeeInfoItem = [[UIBarButtonItem alloc]initWithTitle:[[self.listModel current] objectForKey:self.userInfoItemTitle] style:UIBarButtonItemStyleBordered target:_userInfoView action:@selector(show)];
    self.navigationItem.rightBarButtonItems =[NSArray arrayWithObjects:_nextButtonItem,_prevButtonItem,_refreshButtonItem,_employeeInfoItem,nil] ;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self expend];
    [self reloadAll];
}

- (void)webViewDidFinishLoad:(UIWebView*)webView {
}
#pragma mark - 方法
#pragma mark -
//-(void)setWebPageURLPath:(NSString *)webPageURLPath
//{
//    if (nil != _webPageURLTemplate) {
//        TT_RELEASE_SAFELY(_webPageURLTemplate);
//    }
//    _webPageURLTemplate = [webPageURLPath retain];
//    [self openURL:[NSURL URLWithString:_webPageURLTemplate]];
//}
-(void)refreshWebPage{
    TTDPRINT(@"refresh");
    [self reloadAll];
}

-(void)forwordWebPage{
    [self.listModel next];
    [self reloadAll];
}

-(void)backWebPage{
    [self.listModel prev];
    [self reloadAll];
}

-(void)expend{
}

-(void)reloadAll{
    _userInfoView.employeeUrlPath = [self matchURL:self.userInfoPageURLTemplate];
    _employeeInfoItem.title =[[self.listModel current] objectForKey:self.userInfoItemTitle];
    self.currentURL = [self matchURL:self.webPageURLTemplate];
    [self openURL:[NSURL URLWithString:self.currentURL]];
    _nextButtonItem.enabled = [self.listModel hasNext];
    _prevButtonItem.enabled = [self.listModel hasPrev];
}

-(NSString *)matchURL:(NSString *)Template{
    NSString * URL = Template;
    NSDictionary * currentRecord =[self.listModel current] ;
    for ( NSString* key in currentRecord) {
        NSString *temp = [NSString stringWithFormat:@"{%@}",key];
       URL = [URL stringByReplacingOccurrencesOfString:temp withString:[currentRecord objectForKey:key]];
    }
    return URL;
}

- (void)openURL:(NSURL*)URL {
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:URL];
    [self openRequest:request];
}

- (void)openRequest:(NSURLRequest*)request {
    //    [self view];
    [_webView loadRequest:request];
}
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return toInterfaceOrientation!=UIInterfaceOrientationPortraitUpsideDown;
}
@end
