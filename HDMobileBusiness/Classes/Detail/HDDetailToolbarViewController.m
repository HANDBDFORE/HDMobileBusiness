//
//  ;
//  Three20GitCoreDataLab
//
//  Created by Rocky Lee on 6/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDDetailToolbarViewController.h"
#import "HDTableStatusMessageItemCell.h"
#import "HDActionModel.h"
static NSString * kActionTypeDeliver = @"deliver";

@interface HDDetailToolbarViewController ()

@property(nonatomic,retain) NSString * selectedAction;

@property(nonatomic,retain) NSArray * submitActionItems;

@property(nonatomic,retain) UIView * editBackgroundView;

@property(nonatomic,retain) UIView * editRecordsView;

@property(nonatomic,assign) NSInteger factor;

@end

@implementation HDDetailToolbarViewController

@synthesize spaceItem = _spaceItem;
@synthesize actionModel = _actionModel;


///////////////////////////////////////////////////////////////////////////////////////////////////

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.actionModel = [[HDApplicationContext shareContext]objectForIdentifier:@"actionModel"];
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////
-(void)setActionModel:(HDActionModel *)actionModel
{
    _actionModel = [actionModel retain];
    self.model = actionModel;
}
#pragma mark - life cycle
#pragma mark -

- (void)viewDidUnload
{
    [[TTNavigator navigator].URLMap removeURL:@"jscall://post/(postWithTag:)"];
    [[TTNavigator navigator].URLMap removeURL:@"jscall://deliver"];
    TT_RELEASE_SAFELY(_selectedAction)
    TT_RELEASE_SAFELY(_submitActionItems);
    TT_RELEASE_SAFELY(_editBackgroundView);
    TT_RELEASE_SAFELY(_editRecordsView);
    TT_RELEASE_SAFELY(_spaceItem);
    [super viewDidUnload];
}

-(void)loadView
{
    [super loadView];
    _editBackgroundView = [[UIControl alloc]initWithFrame:self.view.frame];
    _editBackgroundView.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
    _editBackgroundView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    
    TTURLMap *map = [TTNavigator navigator].URLMap;
    [map from:@"jscall://post/(postWithTag:)" toObject:self selector:@selector(postWithTag:)];
    [map from:@"jscall://deliver" toObject:self selector:@selector(deliver)];
    
}
///////////////////////////////////////////////////////////////////////////////////////////////////

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    [self.navigationController setToolbarHidden:NO animated:NO];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - iphone
-(UIBarButtonItem *)spaceItem
{
    if (!_spaceItem) {
        _spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    }
    return _spaceItem;
}

-(void)updateToolbarItems
{
        NSMutableArray * items = [NSMutableArray arrayWithCapacity:5];
        for (id item in self.submitActionItems) {
            [items addObject:item];
            [items addObject:self.spaceItem];
        }
        [items removeLastObject];
        self.toolbarItems = items;
}

#pragma mark - submit record
-(void)postWithTag:(NSString *)tag
{
    [self toolbarButtonPressed:@{@"tag":tag}];
}

-(void)toolbarButtonPressed: (id)sender
{
    //设置当前审批动作
    self.selectedAction = [sender valueForKey:@"tag"];
    //准备默认审批内容
    NSString *defaultComments = [[NSUserDefaults standardUserDefaults] stringForKey:@"default_approve_preference"];
    
    HDViewGuider * guider = [[HDApplicationContext shareContext]objectForIdentifier:@"todoDetailPostGuider"];
    
    guider.destinationQuery = @{@"text":defaultComments, @"delegate":self, @"title":TTLocalizedString(@"Comments", @"意见")};
    [guider perform];
}
///////////////////////////////////////////////////////////////////////////////////////////////////

-(void)postController:(TTPostController *)postController didPostText:(NSString *)text withResult:(id)result
{
    [self submitWithDictionary:@{@"comment":text,@"submitAction":_selectedAction}];
}
///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma -mark deliver
-(void)deliver:(id)sender
{
    //设置当前审批动作
    self.selectedAction = [sender valueForKey:@"tag"];
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
                [dictionary setValue:item.userInfo forKeyPath:@"deliveree"];
            }
            //获取第二个单元格的内容
        } else if ([field isKindOfClass:[TTMessageTextField class]]) {
            [dictionary  setValue:[(TTMessageTextField *)field text] forKeyPath:@"comment"];
        }
    }
    [dictionary setValue:kActionTypeDeliver forKeyPath:@"submitActionType"];
    [dictionary setValue:_selectedAction forKeyPath:@"submitAction"];
    [controller dismissViewControllerAnimated:YES completion:^{}];
    [self submitWithDictionary:dictionary];
}
///////////////////////////////////////////////////////////////////////////////////////////////////

-(void)submitWithDictionary:(NSDictionary *) dictionary
{
    if ([self.pageTurningService respondsToSelector:@selector(submitRecordsAtIndexPaths:dictionary:)]) {
        [self.pageTurningService submitCurrentRecordWithDictionary:dictionary];
    }
    //TODO:这里需要确认交互设计，直接弹出需要反复进入明细不方便，如果直接在明细页面自动翻页，记录过多的情况下会有较长时间的列表提交动画。目前暂时使用原来的直接弹出到列表的方式
//    if ([self.pageTurningService next]) {
//        [self loadCurrentRecord];
//    }else{
    [self.navigationController performSelector:@selector(popViewControllerAnimated:)
                                    withObject:@"YES"
                                    afterDelay:0.5];
//  }
}

///////////////////////////////////////////////////////////////////////////////////////////////////

- (void)composeControllerShowRecipientPicker:(TTMessageController*)controller {
    TTDPRINT(@"show picker");
}
///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma -mark TTModel delegate functions
-(void)modelDidFinishLoad:(id<TTModel>)model{
    
    NSMutableArray * itemButtons = [NSMutableArray array];
    for (NSDictionary * actionRecord in [[self actionModel] actionList]) {
        [itemButtons addObject:[self createToolbarButtonWithRecord:actionRecord]];
    }
    self.submitActionItems = itemButtons;
    [self updateNavigationItems];
    [self updateToolbarItems];
}
-(void)showEmpty:(BOOL)show
{
    self.submitActionItems = nil;
    [super showEmpty:show];
}
///////////////////////////////////////////////////////////////////////////////////////////////////

-(void)loadRecord:(NSDictionary *) record{
    if (self.editing) {
        return;
    }else if (nil == self.pageTurningService) {
        [self updateNavigationItems];
        [self openURL:[NSURL URLWithString:self.webPageURLTemplate]];
    }else{
        [super loadRecord:record];
        [self loadActions:record];
    }
}
///////////////////////////////////////////////////////////////////////////////////////////////////

-(void)loadActions:(NSDictionary *) record
{
    self.toolbarItems = nil;
    self.actionModel.record = record;
    [self.actionModel query];
}
///////////////////////////////////////////////////////////////////////////////////////////////////

-(UIBarButtonItem *)createToolbarButtonWithRecord:(NSDictionary *)record
{
    UIBarButtonItem * actionButton =
    [[[UIBarButtonItem alloc]initWithTitle:[record valueForKey:@"actionTitle"]
                                     style:UIBarButtonItemStyleBordered
                                    target:self
                                    action:@selector(toolbarButtonPressed:)] autorelease];
    actionButton.tag = [[record valueForKey:@"action"] intValue];
//    actionButton.image = TTIMAGE([record valueForKey:@"action_image"]);
    
    if (actionButton.image) {
        actionButton.title = nil;
        actionButton.style = UIBarButtonItemStylePlain;
    }
    
    if ([[record valueForKey:@"actionType"] isEqualToString:kActionTypeDeliver]) {
        actionButton.action = @selector(deliver:);
    }
    
    return actionButton;
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
    if(self.submitActionItems&&TTIsPad()){
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
