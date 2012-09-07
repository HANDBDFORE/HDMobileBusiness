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
@synthesize todoListModel = _todoListModel;
@synthesize currentURL = _currentURL;

#pragma mark - life cycle
#pragma mark -
-(void)viewDidUnload{
    TT_RELEASE_SAFELY(_webPageURLTemplate);
    TT_RELEASE_SAFELY(_currentURL);
    TT_RELEASE_SAFELY(_todoListModel);
    [super viewDidUnload];
}
- (void)loadView{
    //TTWebController;
    [super loadView];
    _webView = [[UIWebView alloc] initWithFrame:HDNavigationLandscapeFrame()];
    _webView.delegate = self;
    _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    _webView.scalesPageToFit = YES;
    [self.view addSubview:_webView];
    _userInfoView = [[HDUserInfoView alloc]initWithFrame:HDNavigationLandscapeFrame()];
    [self.view addSubview:_userInfoView];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setToolbarHidden:YES animated:YES];
    //假定参数
    self.todoListModel = [[HDTodoListModel alloc]init];
    [self.todoListModel  load:TTURLRequestCachePolicyDefault more:NO];
    //
    [self expend];
    [self reloadAll];
    //添加页面按钮
    //
    UIBarButtonItem *barButtonforwordItem = [[UIBarButtonItem alloc]initWithImage:TTIMAGE(@"bundle://Three20.bundle/images/forwardIcon.png") style:UIBarButtonItemStyleBordered target:self action:@selector(forwordWebPage)];
    UIBarButtonItem *barButtonbackItem = [[UIBarButtonItem alloc]initWithImage:TTIMAGE(@"bundle://Three20.bundle/images/backIcon.png") style:UIBarButtonItemStyleBordered target:self action:@selector(backWebPage)];
    //刷新按钮
    UIBarButtonItem *RefreshItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshWebPage)];
    RefreshItem.style = UIBarButtonItemStyleBordered;
    _employeeInfoItem = [[UIBarButtonItem alloc]initWithTitle:[[self.todoListModel currentRecord] objectForKey:self.userInfoItemTitle] style:UIBarButtonItemStyleBordered target:_userInfoView action:@selector(show)];
    self.navigationItem.rightBarButtonItems =[NSArray arrayWithObjects:barButtonforwordItem,barButtonbackItem,RefreshItem,_employeeInfoItem,nil] ;
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
    [self reloadAll];
}
-(void)forwordWebPage{
    if([self.todoListModel nextRecord]){
        [self reloadAll];
    }
}
-(void)backWebPage{
    if([self.todoListModel prevRecord]){
        [self reloadAll];
    }
}
-(void)expend{
}
-(void)reloadAll{
    _userInfoView.employeeUrlPath = [self matchURL:self.userInfoPageURLTemplate];
    _employeeInfoItem.title =[[self.todoListModel currentRecord] objectForKey:self.userInfoItemTitle];
    self.currentURL = [self matchURL:self.webPageURLTemplate];
    [self openURL:[NSURL URLWithString:self.currentURL]];
}
-(NSString *)matchURL:(NSString *)Template{
    NSString * URL = Template;
    NSDictionary * currentRecord =[self.todoListModel currentRecord] ;
    for ( NSString* key in currentRecord) {
        NSString *temp = [NSString stringWithFormat:@"{%@}",key];
       URL = [URL stringByReplacingOccurrencesOfString:temp withString:[currentRecord objectForKey:key]];
    }
    return URL;
}
///内容区域
CGRect HDNavigationLandscapeFrame() {
    CGRect frame = TTScreenBounds();
    return  CGRectMake(0, 0, frame.size.width, frame.size.height-TTToolbarHeight()-TTStatusHeight());
}

- (void)openURL:(NSURL*)URL {
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:URL];
    [self openRequest:request];
}

- (void)openRequest:(NSURLRequest*)request {
    //    [self view];
    [_webView loadRequest:request];
}
@end
