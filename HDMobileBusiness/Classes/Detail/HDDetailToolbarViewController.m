//
//  ;
//  Three20GitCoreDataLab
//
//  Created by Rocky Lee on 6/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDDetailToolbarViewController.h"

@interface HDDetailToolbarViewController ()

@property(nonatomic,retain) NSString * selectedAction;

@end

@implementation HDDetailToolbarViewController

#pragma mark - life cycle
#pragma mark -

- (void)viewDidUnload
{
    TT_RELEASE_SAFELY(_queryActionURLTemplate);
    TT_RELEASE_SAFELY(_spaceItem);
    TT_RELEASE_SAFELY(_selectedAction)
    [super viewDidUnload];
}

-(void)loadView
{
    [super loadView];
    _spaceItem  = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        //创建toolBarmodel
        self.model = [[[HDDetailToolbarModel alloc]init] autorelease];
    }
    return self;
}
///////////////////////////////////////////////////////////////////////////////////////////////////

-(void)reloadAll{
    self.model.detailRecord = [self.pageTurningService current];
    self.model.queryURL = [self.queryActionURLTemplate stringByReplacingSpaceHodlerWithDictionary:[self.pageTurningService current]];
    
    [self.model load:TTURLRequestCachePolicyDefault more:NO];
    [super reloadAll];
    
}
///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - submit record
#pragma mark -
-(void)toolbarButtonPressed: (id)sender
{
    //设置当前审批动作
    self.selectedAction = [NSString stringWithFormat:@"%i",[sender tag]];
    
    //准备默认审批内容
    NSString *defaultComments = [[NSUserDefaults standardUserDefaults] stringForKey:@"default_approve_preference"];
    
    HDViewGuider * guider = [[HDApplicationContext shareContext]objectForIdentifier:@"todoDetailPostGuider"];
    
    guider.destinationQuery = @{@"text":defaultComments, @"delegate":self, @"title":TTLocalizedString(@"Comments", @"意见")};
    [guider perform];
}

-(void)postController:(TTPostController *)postController didPostText:(NSString *)text withResult:(id)result
{
    [self submitWithDictionary:@{kComments:text,kAction:_selectedAction}];
}
///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma -mark deliver
-(void)deliver:(id)sender
{
    HDViewGuider * guider = [[HDApplicationContext shareContext] objectForIdentifier:@"todoDetailDeliverGuider"];
    [guider perform];
}
///////////////////////////////////////////////////////////////////////////////////////////////////

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
    
    [controller dismissModalViewControllerAnimated:YES];
    [self submitWithDictionary:dictionary];
}

-(void)submitWithDictionary:(NSDictionary *) dictionary
{
    if ([self.pageTurningService respondsToSelector:@selector(submitRecordsAtIndexPaths:dictionary:)]) {
        [self.pageTurningService submitCurrentRecordWithDictionary:dictionary];
        //删除动作
        [self.model removeTheActions];
    }
    
    if ([self.pageTurningService hasNext]) {
        [self nextRecord];
    }else if ([self.pageTurningService hasPrev]){
        [self prevRecord];
    }else{
        [self.navigationController performSelector:@selector(popViewControllerAnimated:) withObject:@"YES" afterDelay:0.5];
    }
}

- (void)composeControllerShowRecipientPicker:(TTMessageController*)controller {
    TTDPRINT(@"show picker");
}

///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - TTModel delegate functions -
-(void)modelDidFinishLoad:(id <TTModel>)model
{
    if ([self.model.resultList count] > 0) {
        self.navigationController.toolbarHidden = NO;
        //
        NSMutableArray * itemButtons = [NSMutableArray array];
        for (NSDictionary * actionRecord in self.model.resultList) {
            
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
///////////////////////////////////////////////////////////////////////////////////////////////////

@end
