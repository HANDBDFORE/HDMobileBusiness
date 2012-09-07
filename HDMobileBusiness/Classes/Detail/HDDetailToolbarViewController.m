//
//  ;
//  Three20GitCoreDataLab
//
//  Created by Rocky Lee on 6/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDDetailToolbarViewController.h"

@implementation HDDetailToolbarViewController

#pragma mark - life cycle
#pragma mark -

- (void)viewDidUnload
{
    TT_RELEASE_SAFELY(_toolBarModel);
    [super viewDidUnload];
}

-(id)initWithSignature:(NSString *) signature
                 query:(NSDictionary *) query
{ return nil;
}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        //创建toolBarmodel
        _toolBarModel = [[HDDetailToolbarModel alloc]init];
        self.model = _toolBarModel;
    }
    return self;
}

#pragma mark - submit record
#pragma mark -
-(void)toolbarButtonPressed: (id)sender
{
    //设置当前审批动作
     _toolBarModel.selectedAction = [NSString stringWithFormat:@"%i",[sender tag]];
    //准备默认审批内容
    NSString *defaultText = [[NSUserDefaults standardUserDefaults] stringForKey:@"default_approve_preference"];
    //block
    //点击后打开模态视图
    //    controller.originView = [query objectForKey:@"__target__"];
    NSDictionary * query = [NSDictionary dictionaryWithObjectsAndKeys:defaultText, @"text",self,@"delegate",nil];
    [[TTNavigator navigator]openURLAction:[[TTURLAction actionWithURLPath:@"init://postController"]applyQuery:query]];
    //    [self showOpinionView:0];
}

-(void)postController:(TTPostController *)postController didPostText:(NSString *)text withResult:(id)result
{
    [self.listModel submitObjectAtIndexPaths:@[self.listModel.currentIndexPath] comment:text action: _toolBarModel.selectedAction];
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
#pragma mark - overWrite -
-(void)reloadAll{
    _toolBarModel.detailRecord = [self.listModel current];
    _toolBarModel.queryURL = [self matchURL:self.queryActionURLTemplate];
    [_toolBarModel load:TTURLRequestCachePolicyDefault more:NO];
    [super reloadAll];
    
}
#pragma mark - TTModel delegate functions -

-(void)modelDidFinishLoad:(id <TTModel>)model
{
    _toolBarModel = (HDDetailToolbarModel *)model;
    if ([self toolbarItemButtons:_toolBarModel.toolbarItems] >0) {
        self.navigationController.toolbarHidden = NO;
        self.toolbarItems = [self toolbarItemButtons:_toolBarModel.toolbarItems];
    }
}

//-(void)model:(id<TTModel>)model didFailLoadWithError:(NSError *)error
//{
//    TTAlert([error localizedDescription]);
//}

@end
