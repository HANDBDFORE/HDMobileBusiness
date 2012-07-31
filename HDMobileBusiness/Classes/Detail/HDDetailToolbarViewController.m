//
//  HDDetaiViewController.m
//  Three20GitCoreDataLab
//
//  Created by Rocky Lee on 6/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDDetailToolbarViewController.h"

//(@~~~~@)
#import "Approve.h"
//#import "ApproveOpinionView.h"

@implementation HDDetailToolbarViewController

@synthesize employeeID = _employeeID;
@synthesize rowID = _rowID;
@synthesize recordID = _recordID;
@synthesize instanceID = _instanceID;
@synthesize localStatus = _localStatus;

@synthesize submitModel = _submitModel;

- (void)dealloc
{
    TT_RELEASE_SAFELY(_employeeID);
    TT_RELEASE_SAFELY(_rowID);
    TT_RELEASE_SAFELY(_recordID);
    TT_RELEASE_SAFELY(_instanceID);
    TT_RELEASE_SAFELY(_localStatus);
    TT_RELEASE_SAFELY(_submitModel);
    TT_RELEASE_SAFELY(_toolBarModel);
    [super dealloc];
}

-(id)initWithSignature:(NSString *) signature 
                 query:(NSDictionary *) query
{
    if (self = [self init]) {
        
        Approve * _approve = [[query objectForKey:@"data"]retain];
        self.employeeID = _approve.employeeId;
        self.rowID =_approve.rowID;
        self.recordID = _approve.recordID;
        self.instanceID = _approve.instanceId;
        self.employeeName = _approve.employeeName;
//<<<<<<< HEAD
        self.localStatus = _approve.localStatus;
        
//        self.employeeURLPath = [HDURLCenter requestURLWithKey:kEmployeeInfoWebPagePath query:[NSDictionary dictionaryWithObject:self.employeeID forKey:@"employeeID"]];
        
//=======
        self.employeeURLPath = [HDURLCenter requestURLWithKey:kEmployeeInfoWebPagePath query:[NSDictionary dictionaryWithObjectsAndKeys:self.employeeID,@"employeeId",self.instanceID,@"instanceId",nil]];
        //dictionaryWithObject:self.employeeID forKey:@"employeeID"]];
//        if (![_approve.localStatus isEqualToString:@"WAITING"]&&
//                 ![_approve.localStatus isEqualToString:@"DIFFERENT"]) {
//            _shouldLoadAction = YES;
//        }
//>>>>>>> 317aa32e37232cc05bd1b6543950d54b78df234c
        NSDictionary * urlQuery = [_approve dictionaryWithValuesForKeys:[NSArray arrayWithObjects:@"docPageUrl",@"instanceId", nil]];
        
        self.webPageURLPath = [HDURLCenter requestURLWithKey:kApproveDetailWebPagePath query:urlQuery];
        TT_RELEASE_SAFELY(_approve);
    }
    return self;
}

-(BOOL)shouldLoadAction
{
    return !([self.localStatus isEqualToString:@"WAITING"]||[self.localStatus isEqualToString:@"DIFFERENT"]);
}

-(void)createModel
{
    if ([self shouldLoadAction]) {
        //        _toolbarModel.recordID = self.recordID;
        
        _toolBarModel = [[HDDetailToolbarModel alloc]initWithKey:nil query:[NSDictionary dictionaryWithObject:self.recordID forKey:@"recordID"]];
        self.model = _toolBarModel;
    }
    //    _submitModel = [[HDDetailSubmitModel alloc]init];
    //    _submitModel.rowID = self.rowID;
    //    _submitModel.recordID = self.recordID;
}

#pragma mark submit record
-(void)toolbarButtonPressed: (id)sender
{
    //设置审批动作
    _submitModel.actionID = [NSNumber numberWithInt:[sender tag]];
    //准备默认审批内容
    NSString *defaultText = [[NSUserDefaults standardUserDefaults] stringForKey:@"default_approve_preference"];
    //点击后打开模态视图
    //    controller.originView = [query objectForKey:@"__target__"];
    NSDictionary * query = [NSDictionary dictionaryWithObjectsAndKeys:defaultText, @"text",self,@"delegate",nil];
    [[TTNavigator navigator]openURLAction:[[TTURLAction actionWithURLPath:@"init://postController"]applyQuery:query]];
    //    [self showOpinionView:0];
}

-(void)postController:(TTPostController *)postController didPostText:(NSString *)text withResult:(id)result
{
    _submitModel.comment = text;    
    //准备提交对象,传递到通知中心
    [_submitModel submit];
    //删除动作
    [_toolBarModel removeTheActions];    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark set toolbar
//根据item设定toolbar的内容,每个item之间用 FlexibleSpace 隔开
-(NSArray *) toolbarItemButtons:(NSArray *)toolbarItems
{
    NSMutableArray * itemButtons = [NSMutableArray array];
    for (HDToolbarItem * item in toolbarItems) {
        if ([item isMemberOfClass:[HDToolbarItem class]]) {
            [itemButtons addObject:[self barButtonWithItem:item]];
            UIBarButtonItem * space = [[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil] autorelease];
            [itemButtons addObject:space];
        }
    }
    [itemButtons removeLastObject];
    return itemButtons;
}

-(UIBarButtonItem *)barButtonWithItem:(HDToolbarItem *) item
{
    UIBarButtonItem * actionButton = 
    [[[UIBarButtonItem alloc]initWithTitle:item.title                                      
                                     style:UIBarButtonItemStyleBordered                                   
                                    target:self 
                                    action:@selector(toolbarButtonPressed:)] autorelease];
    actionButton.tag = item.tag;
    return actionButton;
}

#pragma TTModel delegate functions
-(void)modelDidFinishLoad:(id <TTModel>)model
{
    HDDetailToolbarModel * toolbarModel = (HDDetailToolbarModel *)model;
    if ([self toolbarItemButtons:toolbarModel.toolbarItems] >0) {        
        _toolbar.items = [self toolbarItemButtons:toolbarModel.toolbarItems];
    }      
}

-(void)model:(id<TTModel>)model didFailLoadWithError:(NSError *)error
{
    TTAlert([error localizedDescription]);
}

/*
 *覆盖父类的web代理方法,添加判断tag:3是否是停止/刷新的按钮,如果不是,则不进行替换
 */
///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)webViewDidStartLoad:(UIWebView*)webView {
    if ([_delegate respondsToSelector:@selector(webController:webViewDidStartLoad:)]) {
        [_delegate webController:self webViewDidStartLoad:webView];
    }
    
    self.title = TTLocalizedString(@"Loading...", @"");
    if (!self.navigationItem.rightBarButtonItem) {
        [self.navigationItem setRightBarButtonItem:_activityItem animated:YES];
    }
    if ([_toolbar itemWithTag:3] == _refreshButton) {
        [_toolbar replaceItemWithTag:3 withItem:_stopButton];
        _backButton.enabled = [_webView canGoBack];
        _forwardButton.enabled = [_webView canGoForward];
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)webViewDidFinishLoad:(UIWebView*)webView {
    if ([_delegate respondsToSelector:@selector(webController:webViewDidFinishLoad:)]) {
        [_delegate webController:self webViewDidFinishLoad:webView];
    }
    
    TT_RELEASE_SAFELY(_loadingURL);
    self.title = [_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    if (self.navigationItem.rightBarButtonItem == _activityItem) {
        [self.navigationItem setRightBarButtonItem:nil animated:YES];
    }
    
    if ([_toolbar itemWithTag:3] == _stopButton) {
        [_toolbar replaceItemWithTag:3 withItem:_refreshButton];
        
        _backButton.enabled = [_webView canGoBack];
        _forwardButton.enabled = [_webView canGoForward];
    }    
}

//#pragma opinion view controller delegate
//-(void)showOpinionView:(int)actionType{
//    ApproveOpinionView * _opinionView = [[ApproveOpinionView alloc]initWithNibName:@"ApproveOpinionView" bundle:nil];
//    _opinionView.modalTransitionStyle =UIModalTransitionStyleCoverVertical;
//    [_opinionView setControllerDelegate:self];
//    
//    [_opinionView setApproveType:[NSString stringWithFormat:@"%i",actionType]];
//    [self presentModalViewController:_opinionView animated:YES];
//}
//
//-(void)ApproveOpinionViewDismissed:(int)resultCode messageDictionary:(NSDictionary *)dictionary{
//    [self dismissModalViewControllerAnimated:YES];
//    if(resultCode == RESULT_OK){
//        //修改本地数据
//        _submitModel.comment = [dictionary objectForKey:@"comment"];    
//        //准备提交对象,传递到通知中心
//        [_submitModel submit];
//        
//        //删除动作
//        [_toolbarModel removeTheActions];    
//        
//        [self.navigationController popViewControllerAnimated:YES];
//    }
//}

@end
