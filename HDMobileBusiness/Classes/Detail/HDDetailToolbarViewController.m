//
//  ;
//  Three20GitCoreDataLab
//
//  Created by Rocky Lee on 6/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDDetailToolbarViewController.h"
#import "HDTableStatusMessageItemCell.h"

@interface HDDetailToolbarViewController ()

@property(nonatomic,retain) NSString * selectedAction;

@property(nonatomic,retain) NSArray * submitActionItems;

@property(nonatomic,retain) UIView * editBackgroundView;

@property(nonatomic,retain) UIView * editRecordsView;

@property(nonatomic,assign) NSInteger factor;

@end

@implementation HDDetailToolbarViewController

#pragma mark - life cycle
#pragma mark -

- (void)viewDidUnload
{
    TT_RELEASE_SAFELY(_selectedAction)
    TT_RELEASE_SAFELY(_submitActionItems);
    TT_RELEASE_SAFELY(_editBackgroundView);
    TT_RELEASE_SAFELY(_editRecordsView);
    [super viewDidUnload];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    _editBackgroundView = [[UIControl alloc]initWithFrame:self.view.frame];
    _editBackgroundView.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
    _editBackgroundView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
}
///////////////////////////////////////////////////////////////////////////////////////////////////

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
    }
    return self;
}
///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - submit record
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
///////////////////////////////////////////////////////////////////////////////////////////////////

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
///////////////////////////////////////////////////////////////////////////////////////////////////

-(void)submitWithDictionary:(NSDictionary *) dictionary
{
    if ([self.pageTurningService respondsToSelector:@selector(submitRecordsAtIndexPaths:dictionary:)]) {
        [self.pageTurningService submitCurrentRecordWithDictionary:dictionary];
        //删除动作
        [self.model removeTheActions];
    }
    
//    [self turnToEffectiveRecord];
    
    [self.navigationController performSelector:@selector(popViewControllerAnimated:)
                                    withObject:@"YES"
                                    afterDelay:0.5];
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void)composeControllerShowRecipientPicker:(TTMessageController*)controller {
    TTDPRINT(@"show picker");
}
///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma -mark TTModel delegate functions
-(void)modelDidFinishLoad:(id <TTModel>)model
{
    if ([self.model.resultList count] > 0) {
        NSMutableArray * itemButtons = [NSMutableArray array];
        for (NSDictionary * actionRecord in self.model.resultList) {
            
            UIBarButtonItem * actionButton =
            [[[UIBarButtonItem alloc]initWithTitle:[actionRecord valueForKey:@"action_title"]
                                             style:UIBarButtonItemStylePlain
                                            target:self
                                            action:@selector(toolbarButtonPressed:)] autorelease];
            actionButton.tag = [[actionRecord valueForKey:@"action_id"] intValue];
            actionButton.image = TTIMAGE([actionRecord valueForKey:@"action_image"]);
            if ([[actionRecord valueForKey:@"action_type"] isEqualToString:kActionTypeDeliver]) {
                actionButton.action = @selector(deliver:);
            }
            
            [itemButtons addObject:actionButton];
        }
        self.submitActionItems = itemButtons;
        [self updateNavigationItems];
    }
}
///////////////////////////////////////////////////////////////////////////////////////////////////
-(void)showEmpty:(BOOL)show
{
    self.submitActionItems = nil;
    [super showEmpty:show];
}

-(void)loadRecord:(NSDictionary *) record{
    if (self.editing) {
        return;
    }else if (nil == self.pageTurningService) {
        [self updateNavigationItems];
        [self openURL:[NSURL URLWithString:self.webPageURLTemplate]];
    }else{
        [super loadRecord:record];
        if (self.shouldLoadAction) {
            self.model.detailRecord = [self.pageTurningService current];
            [self.model load:TTURLRequestCachePolicyDefault more:NO];
        }
    }
}
///////////////////////////////////////////////////////////////////////////////////////////////////

-(void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    [self resetEditView];
    if (editing) {
        [self updateNavigationItems];
        [self.view addSubview:self.editBackgroundView];
    }else{
        [self.editBackgroundView removeFromSuperview];
        
    }
}
///////////////////////////////////////////////////////////////////////////////////////////////////

-(void)updateNavigationItems
{
    [super updateNavigationItems];
    if (!self.isEditing) {
        return;
    }
    if (_popoverItem) {
        self.title = @"                       请选择需要审批的记录";
    }else{
        self.title = @"请选择需要审批的记录";
    }
    
    
}
///////////////////////////////////////////////////////////////////////////////////////////////////

-(NSArray *)createLeftNavigationItems
{
    if(self.isEditing && _popoverItem){
        return @[_popoverItem];
    }else{
        return [super createLeftNavigationItems];
    }
    return nil;
}
///////////////////////////////////////////////////////////////////////////////////////////////////

-(NSArray *)createRightNavigationItems
{
    if (self.isEditing) {
        return nil;
    }
    if(self.shouldLoadAction){
        NSMutableArray * items = [super createRightNavigationItems];
        [items addObjectsFromArray:self.submitActionItems];
        return items;
    }
    return [super createRightNavigationItems];
}
///////////////////////////////////////////////////////////////////////////////////////////////////

-(void)resetEditViewAnimated:(BOOL) animated;
{
    if (animated) {
        [UIView animateWithDuration:1.0 animations:^{
            _editRecordsView.alpha = 0;
        } completion:^(BOOL finished) {
            [self resetEditView];
        }];
    }else{
        [self resetEditView];
    } 
}

-(void)resetEditView{
    if (self.editRecordsView) {
        [self.editRecordsView removeFromSuperview];
        self.editRecordsView = nil;
    }
    _editRecordsView = [[UIView alloc]initWithFrame:self.view.frame];
    _editRecordsView.backgroundColor = [UIColor clearColor];
    [_editBackgroundView addSubview:_editRecordsView];
}

#pragma mark mark for pad
-(void)selectedObject:(id)object atIndex:(NSInteger)objectIndex;
{
    HDTableStatusMessageItemCell * recordView = [self recordView];
    recordView.tag = objectIndex+100;
    [recordView setObject:object];
    [recordView.layer addAnimation:[self selectAnimation] forKey:@"selectAnimation"];
    [_editRecordsView addSubview:recordView];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
-(void)deselectedObject:(id)object atIndex:(NSInteger)objectIndex
{
    UIView * recordView = [self.editBackgroundView viewWithTag:(objectIndex+100)];
    [UIView animateWithDuration:0.6
                     animations:^{
                         recordView.layer.position = CGPointMake(800, 0);
                         recordView.alpha = 0.0;
                     } completion:^(BOOL finished) {
                         [recordView removeFromSuperview];
                     }];
}
///////////////////////////////////////////////////////////////////////////////////////////////////

-(CAAnimation *)selectAnimation
{
    CATransition * animation = [[[CATransition alloc]init]autorelease];
    animation.duration = 0.3;
    animation.type = kCATransitionMoveIn;
    animation.subtype = kCATransitionFromLeft;
    return animation;
}
///////////////////////////////////////////////////////////////////////////////////////////////////

-(id)recordView
{
    _factor = (_factor+1)%3;
    NSInteger tag = _factor + 100;
    CGFloat angle = (_factor -1) *0.05;
    UIView * recordView = [self createRecordView];

    if (_popoverItem) {
        recordView.frame = CGRectMake(320, 150, 420, 220);
    }else{
        recordView.frame = CGRectMake(220, 150, 420, 220);
    }
    
    recordView.backgroundColor = [UIColor whiteColor];
    recordView.tag = tag;
    recordView.layer.affineTransform = CGAffineTransformMakeRotation(angle);
    recordView.layer.shadowOffset = CGSizeMake(5, -3);
    recordView.layer.shadowOpacity = 0.3;
    recordView.layer.cornerRadius = 8.0;
    recordView.layer.borderWidth = 0.3;
    return recordView;
}
///////////////////////////////////////////////////////////////////////////////////////////////////

-(UIView *)createRecordView{
    return [[[HDTableStatusMessageItemCell alloc]init]autorelease];
}
///////////////////////////////////////////////////////////////////////////////////////////////////

@end
