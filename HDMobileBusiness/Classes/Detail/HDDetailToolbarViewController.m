//
//  ;
//  Three20GitCoreDataLab
//
//  Created by Rocky Lee on 6/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDDetailToolbarViewController.h"
#import "../PersonList/HDPersonListDataSource.h"
#import "../Compose/HDMessageSingleRecipientField.h"
@implementation HDDetailToolbarViewController

#pragma mark - life cycle
#pragma mark -

- (void)viewDidUnload
{
    TT_RELEASE_SAFELY(_toolBarModel);
    TT_RELEASE_SAFELY(_queryActionURLTemplate);
    TT_RELEASE_SAFELY(_spaceItem);
    [[TTNavigator navigator].URLMap removeURL:@"init://messageController"];
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
        
        [[TTNavigator navigator].URLMap from:@"init://messageController"
                       toModalViewController:self selector:@selector(createMessageViewController:)];
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
    [self.listModel submitRecordsAtIndexPaths:@[self.listModel.currentIndexPath] query:@{ kComments : text,kAction:_toolBarModel.selectedAction }];
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
        //TODO:deliver
        [itemButtons addObject:[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(deliver:)] autorelease]];
//        [itemButtons removeLastObject];
        self.toolbarItems = itemButtons;
    }    
}

-(void)deliver:(id)sender
{
    TTDPRINT(@"deliver");
    [[TTNavigator navigator]openURLAction:[[TTURLAction actionWithURLPath:@"init://messageController"] applyAnimated:YES]];
}

-(UIViewController *)createMessageViewController:(NSString*)recipient
{
    TTDPRINT(@"create view controller :%@",recipient);
    TTMessageController* controller = [[[TTMessageController alloc] initWithRecipients:nil] autorelease];
    controller.title = @"deliver";
    controller.showsRecipientPicker = YES;
    TTMessageRecipientField * recipientField =
    [[[HDMessageSingleRecipientField alloc] initWithTitle: TTLocalizedString(@"To:", @"")
                                           required: YES] autorelease];

    controller.fields =@[recipientField];

    
    controller.dataSource = [[[HDPersonListDataSource alloc]init] autorelease];
    controller.delegate = self;
    
    return controller;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// TTMessageControllerDelegate

- (void)composeController:(TTMessageController*)controller didSendFields:(NSArray*)fields {
    NSMutableArray * names = [NSMutableArray array];
    NSString * comments = nil;
    
    //获取第一个单元格的第一个cell
    for (id field in fields) {
        if ([field isKindOfClass:[TTMessageRecipientField class]]) {
            for (TTTableTextItem * item in [field recipients]) {
                [names addObject:item.text];
            }
//            TTPickerTextField* textField = [_fieldViews objectAtIndex:i];
//            [(TTMessageRecipientField*)field setRecipients:textField.cells];
        } else if ([field isKindOfClass:[TTMessageTextField class]]) {
            comments = [(TTMessageTextField *)field text];
//            UITextField* textField = [_fieldViews objectAtIndex:i];
//            [(TTMessageTextField*)field setText:textField.text];
        }
    }
    TTDPRINT(@"did send :%@     %@" ,names,comments);
    //获取第二个单元格的内容
    [controller dismissModalViewControllerAnimated:YES];
}

- (void)composeControllerDidCancel:(TTMessageController*)controller {
    TTDPRINT(@"did cancel");
}

- (void)composeControllerShowRecipientPicker:(TTMessageController*)controller {
    TTDPRINT(@"show picker");
}

///////////////////////////////////////////////////////////////////////////////////////////////////

//-(void)model:(id<TTModel>)model didFailLoadWithError:(NSError *)error
//{
//    TTAlert([error localizedDescription]);
//}

@end
