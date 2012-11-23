//
//  ;
//  Three20GitCoreDataLab
//
//  Created by Rocky Lee on 6/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDDetailToolbarViewController.h"
//#import "../List/HDPersonListDataSource.h"
//#import "../Compose/HDMessageSingleRecipientField.h"
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

//-(id)initWithSignature:(NSString *) signature
//                 query:(NSDictionary *) query
//{ return nil;
//}

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
    NSString *defaultComments = [[NSUserDefaults standardUserDefaults] stringForKey:@"default_approve_preference"];
    
    HDViewGuider * guider = [[HDApplicationContext shareContext]objectForIdentifier:@"todoDetailPostGuider"];
    
    guider.destinationQuery = @{@"text":defaultComments, @"delegate":self, @"title":TTLocalizedString(@"Comments", @"意见")};
    [guider perform];
}

-(void)postController:(TTPostController *)postController didPostText:(NSString *)text withResult:(id)result
{
    if ([self.listModel respondsToSelector:@selector(submitRecordsAtIndexPaths:dictionary:)]) {
        [self.listModel submitCurrentRecordWithDictionary:@{kComments:text,kAction:_toolBarModel.selectedAction}];
        //删除动作
        [_toolBarModel removeTheActions];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - overWrite -
-(void)reloadAll{
    _toolBarModel.detailRecord = [self.listModel current];
    _toolBarModel.queryURL = [self.queryActionURLTemplate stringByReplacingSpaceHodlerWithDictionary:[self.listModel current]];

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
            [[[UIBarButtonItem alloc]initWithTitle:[actionRecord valueForKey:@"action_title"]
                                             style:UIBarButtonItemStyleBordered
                                            target:self
                                            action:@selector(toolbarButtonPressed:)] autorelease];
            actionButton.tag = [[actionRecord valueForKey:@"action_id"] intValue];
            //button color
            if ([[actionRecord valueForKey:@"action_type"] isEqualToString:kActionTypeApprove]) {
                actionButton.tintColor = RGBCOLOR(0, 153, 0);
            }
            if ([[actionRecord valueForKey:@"action_type"] isEqualToString:kActionTypeReject]) {
                actionButton.tintColor = RGBCOLOR(153, 0, 0);
            }
            if ([[actionRecord valueForKey:@"action_type"] isEqualToString:kActionTypeDeliver]) {
                actionButton.tintColor = RGBCOLOR(0, 0, 153);
                actionButton.action = @selector(deliver:);
            }
            
            [itemButtons addObject:actionButton];
            [itemButtons addObject:_spaceItem];
        }
        
        [itemButtons removeLastObject];
        self.toolbarItems = itemButtons;
    }
}

#pragma -mark deliver
-(void)deliver:(id)sender
{
    HDViewGuider * guider = [[HDApplicationContext shareContext] objectForIdentifier:@"todoDetailDeliverGuider"];
    [guider perform];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// TTMessageControllerDelegate

- (void)composeController:(TTMessageController*)controller didSendFields:(NSArray*)fields {
    NSMutableDictionary * dictionary = [NSMutableDictionary dictionary];
    
    for (id field in fields) {
        //获取第一个单元格的第一个cell
        if ([field isKindOfClass:[TTMessageRecipientField class]]) {
            for (TTTableTextItem * item in [field recipients]) {
                [dictionary setValue:item.userInfo forKeyPath:kEmployeeID];
            }
            //获取第二个单元格的内容
        } else if ([field isKindOfClass:[TTMessageTextField class]]) {
            [dictionary  setValue:[(TTMessageTextField *)field text] forKeyPath:kComments];
        }
    }
    [dictionary setValue:@"D" forKeyPath:kAction];
    [self.listModel submitCurrentRecordWithDictionary:dictionary];
    
    [controller dismissModalViewControllerAnimated:YES];
    //如何pop出去不会crash
    [self.navigationController performSelector:@selector(popViewControllerAnimated:) withObject:@"YES" afterDelay:0.5];
}

//- (void)composeControllerDidCancel:(TTMessageController*)controller {
//    TTDPRINT(@"did cancel");
//}

- (void)composeControllerShowRecipientPicker:(TTMessageController*)controller {
    TTDPRINT(@"show picker");
}

///////////////////////////////////////////////////////////////////////////////////////////////////

//-(void)model:(id<TTModel>)model didFailLoadWithError:(NSError *)error
//{
//    TTAlert([error localizedDescription]);
//}

@end
