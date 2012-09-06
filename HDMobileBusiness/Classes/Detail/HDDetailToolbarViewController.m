//
//  ;
//  Three20GitCoreDataLab
//
//  Created by Rocky Lee on 6/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDDetailToolbarViewController.h"

@implementation HDDetailToolbarViewController

- (void)dealloc
{
    TT_RELEASE_SAFELY(_toolBarModel);
    [super dealloc];
}
#pragma mark - life cycle
#pragma mark -
-(id)initWithSignature:(NSString *) signature
                 query:(NSDictionary *) query
{ return nil;
}

-(id)init
{
    if (self = [self init]) {
        //创建toolBarmodel
        _toolBarModel = [[HDDetailToolbarModel alloc]init];
        self.model = _toolBarModel;
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    self.navigationController.toolbarHidden = NO;
    self.navigationController.toolbarItems = [self toolbarItemButtons:[_toolBarModel toolbarItems]];
    
}
#pragma mark - toolbarmodel
#pragma mark -
-(BOOL)shouldLoadAction
{
    return YES;
    //!([self.localStatus isEqualToString:@"WAITING"]||[self.localStatus isEqualToString:@"DIFFERENT"]);
}

-(void)createModel
{
    if ([self shouldLoadAction]) {
        //        _toolbarModel.recordID = self.recordID;
        
    }
    //    _submitModel = [[HDDetailSubmitModel alloc]init];
    //    _submitModel.rowID = self.rowID;
    //    _submitModel.recordID = self.recordID;
}

#pragma mark - submit record
#pragma mark -
-(void)toolbarButtonPressed: (id)sender
{
    //设置审批动作
    //_submitModel.actionID = [NSNumber numberWithInt:[sender tag]];
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
    //_submitModel.comment = text;
    //准备提交对象,传递到通知中心
    //[_submitModel submit];
    //删除动作
    [_toolBarModel removeTheActions];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - set toolbar
#pragma mark -
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

#pragma mark - TTModel delegate functions

-(void)modelDidFinishLoad:(id <TTModel>)model
{
    HDDetailToolbarModel * toolbarModel = (HDDetailToolbarModel *)model;
    if ([self toolbarItemButtons:toolbarModel.toolbarItems] >0) {
        self.navigationController.toolbarHidden = NO;
        self.toolbarItems = [self toolbarItemButtons:toolbarModel.toolbarItems];
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
//- (void)webViewDidStartLoad:(UIWebView*)webView {
//    if ([_delegate respondsToSelector:@selector(webController:webViewDidStartLoad:)]) {
//        [_delegate webController:self webViewDidStartLoad:webView];
//    }
//
//    self.title = TTLocalizedString(@"Loading...", @"");
//    if (!self.navigationItem.rightBarButtonItem) {
//        [self.navigationItem setRightBarButtonItem:_activityItem animated:YES];
//    }
//    if ([_toolbar itemWithTag:3] == _refreshButton) {
//        [_toolbar replaceItemWithTag:3 withItem:_stopButton];
//        _backButton.enabled = [_webView canGoBack];
//        _forwardButton.enabled = [_webView canGoForward];
//    }
//}


///////////////////////////////////////////////////////////////////////////////////////////////////
//- (void)webViewDidFinishLoad:(UIWebView*)webView {
//    if ([_delegate respondsToSelector:@selector(webController:webViewDidFinishLoad:)]) {
//        [_delegate webController:self webViewDidFinishLoad:webView];
//    }
//
//    TT_RELEASE_SAFELY(_loadingURL);
//    self.title = [_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
//    if (self.navigationItem.rightBarButtonItem == _activityItem) {
//        [self.navigationItem setRightBarButtonItem:nil animated:YES];
//    }
//
//    if ([_toolbar itemWithTag:3] == _stopButton) {
//        [_toolbar replaceItemWithTag:3 withItem:_refreshButton];
//        _backButton.enabled = [_webView canGoBack];
//        _forwardButton.enabled = [_webView canGoForward];
//    }
//}

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
