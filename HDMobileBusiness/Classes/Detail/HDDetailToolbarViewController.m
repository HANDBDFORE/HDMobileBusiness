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
    TT_RELEASE_SAFELY(_queryActionURLTemplate);
    TT_RELEASE_SAFELY(_spaceItem);
    [super viewDidUnload];
}

-(void)loadView
{
    [super loadView];
    _spaceItem  = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
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
    if ([_toolBarModel.resultList count] > 0) {
        self.navigationController.toolbarHidden = NO;
        //
        NSMutableArray * itemButtons = [NSMutableArray array];
        for (NSDictionary * actionRecord in _toolBarModel.resultList) {
            UIBarButtonItem * actionButton =
            [[[UIBarButtonItem alloc]initWithTitle:[actionRecord valueForKey:@"action_id"]
                                             style:UIBarButtonItemStyleBordered
                                            target:self
                                            action:@selector(toolbarButtonPressed:)] autorelease];
            actionButton.tag = [[actionRecord valueForKey:@"action_id"] intValue];
            
            [itemButtons addObject:actionButton];
            [itemButtons addObject:_spaceItem];
        }
        [itemButtons removeLastObject];
        self.toolbarItems = itemButtons;
    }    
}

//-(void)model:(id<TTModel>)model didFailLoadWithError:(NSError *)error
//{
//    TTAlert([error localizedDescription]);
//}

@end
