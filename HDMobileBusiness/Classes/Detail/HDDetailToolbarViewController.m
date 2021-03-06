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
#import "HDDeleverViewController.h"
#import "HDDeleverCommentViewController.h"
#import "HDAssignCommentViewController.h"

static NSString * kActionTypeDeliver = @"deliver";
static NSString * kActionTypeAssign = @"assign";

@interface HDDetailToolbarViewController ()
{
    @private
    NSString * _selectedAction;
    NSArray * _submitActionItems;
}
@property(nonatomic,retain) NSString * selectedAction;

@property(nonatomic,retain) NSArray * submitActionItems;
@end

@implementation HDDetailToolbarViewController

@synthesize selectedAction = _selectedAction;
@synthesize submitActionItems = _submitActionItems;
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
-(void)loadView
{
    [super loadView];
    TTURLMap *map = [TTNavigator navigator].URLMap;
    [map from:@"jscall://returnback" toObject:self selector:@selector(returnback)];

    [map from:@"jscall://post/(postWithTag:)" toObject:self selector:@selector(postWithTag:)];
    [map from:@"jscall://deliver" toObject:self selector:@selector(deliver)];
    
}
//-(void)viewDidLoad
//{
//    [super viewDidLoad];
//    [self.navigationController setToolbarHidden:NO animated:NO];
//}
//-(void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    [self.navigationController setToolbarHidden:NO animated:NO];
//}
-(void)viewDidAppear:(BOOL)animated
{
//    NSLog(@"detaillistDidAppear");
    [super viewDidAppear:animated];
    [self.navigationController setToolbarHidden:NO animated:NO];
}
- (void)viewDidUnload
{
    [[TTNavigator navigator].URLMap removeURL:@"jscall://post/(postWithTag:)"];
    [[TTNavigator navigator].URLMap removeURL:@"jscall://deliver"];
    [[TTNavigator navigator].URLMap removeURL:@"jscall://returnback"]; 

    TT_RELEASE_SAFELY(_spaceItem);
    TT_RELEASE_SAFELY(_selectedAction)
    TT_RELEASE_SAFELY(_submitActionItems);
    [super viewDidUnload];
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
    self.selectedAction = [[sender valueForKey:@"tag"] stringValue];
   NSLog(@"%@",self.selectedAction);
   
    
    //准备默认审批内容
    NSString *defaultComments = [[NSUserDefaults standardUserDefaults] stringForKey:@"default_approve_preference"];
    
    HDViewGuider * guider = [[HDApplicationContext shareContext]objectForIdentifier:@"todoDetailPostGuider"];
    
    guider.destinationQuery = @{@"text":defaultComments, @"delegate":self, @"title":TTLocalizedString(@"Comments", @"意见")};
    [guider perform];
}

-(void)deliver:(id)sender
{
     //设置当前审批动作
       self.selectedAction = [[sender valueForKey:@"tag"] stringValue];
    
    UIStoryboard *StoryBoard = [UIStoryboard storyboardWithName:@"DeleverStoryboard" bundle:nil];
    HDDeleverCommentViewController * dataSetting = [StoryBoard instantiateViewControllerWithIdentifier:@"HDDeleverCommentViewController"];

    dataSetting.delegate = self;
    dataSetting.localId = [NSString stringWithFormat:@"%@",[self.params valueForKey:@"localId"]];
    
    
    [self  presentModalViewController:[[UINavigationController alloc] initWithRootViewController:dataSetting]  animated:YES];
}

-(void)assign:(id)sender
{
    //设置当前审批动作
    self.selectedAction = [[sender valueForKey:@"tag"] stringValue];
    
    UIStoryboard *StoryBoard = [UIStoryboard storyboardWithName:@"AssignStoryboard" bundle:nil];
    HDAssignCommentViewController * dataSetting = [StoryBoard instantiateViewControllerWithIdentifier:@"HDAssignCommentViewController"];
    NSLog(@"%@,",self.params);
    dataSetting.localId = [NSString stringWithFormat:@"%@",[self.params valueForKey:@"localId"]];
    
    dataSetting.delegate = self;
    
    
    [self  presentModalViewController:[[UINavigationController alloc] initWithRootViewController:dataSetting]  animated:YES];
    
}
///////////////////////////////////////////////////////////////////////////////////////////////////

-(void)postController:(TTPostController *)postController didPostText:(NSString *)text withResult:(id)result
{
    [self submitWithDictionary:@{@"comment":text,@"submitAction":self.selectedAction}];

    
    
}

//转交调用程序
-(void)postDeliverController:(NSString *)comment
                 delivereeid:(NSString *)delivereeid
{

  


    
    [self submitWithDictionary:@{@"comment" : comment,@"submitAction":self.selectedAction
                                 ,@"deliveree" :delivereeid
                                 }];

    
    
}

///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma -mark return back
-(void)returnback
{
    
    [self.navigationController popViewControllerAnimated:YES];
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
    [dictionary setValue:self.selectedAction forKeyPath:@"submitAction"];
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
    if (nil == self.pageTurningService) {
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
    
    
    //对于actiontype为转交的进行单独处理 modify jtt 2014-10-09
    if ([[record valueForKey:@"actionType"] isEqualToString:kActionTypeDeliver]) {
        actionButton.action = @selector(deliver:);
    }else if([[record valueForKey:@"actionType"] isEqualToString:kActionTypeAssign]){
        actionButton.action = @selector(assign:);

    }
    
    
    
    return actionButton;
}@end
