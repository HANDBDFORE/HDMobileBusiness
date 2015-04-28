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
#import "SignViewUlan.h"

static NSString * kActionTypeDeliver = @"deliver";

@interface HDDetailToolbarViewController ()
{
    @private
    NSString * _selectedAction;
    NSArray * _submitActionItems;
    
    
}
@property(nonatomic,retain) NSString * selectedAction;

@property(nonatomic,retain) NSArray * submitActionItems;

@property (nonatomic,copy)NSString * currentComment;

@property (nonatomic,retain) SignViewUlan       * key;

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
    
    
    if (self.key == nil) {
        NSString *nibName = nil;
        if (UIUserInterfaceIdiomPad == [[UIDevice currentDevice] userInterfaceIdiom]) {
            nibName = @"SignViewUlan_iPad";
        } else {
            nibName = @"SignViewUlan";
        }
        self.key = [[SignViewUlan alloc]initWithNibName:nibName bundle:nil];
        
    }
    
    
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
    TT_RELEASE_SAFELY(_key);
    
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
    

    [self  presentModalViewController:[[UINavigationController alloc] initWithRootViewController:dataSetting]  animated:YES];
    
    
}
///////////
-(void) afterDone:(ULANKeyError*)err type:(int)type result:(NSObject *)result;
{
    
    if (type == kFetchCertSuccess) {
        
        
        
        
    } else if (type == kSignSucess) {
        NSString * singatureBase64 = (NSString *)result;
        
        
        NSLog(@"singatureBase64 IS %@",singatureBase64);
        
        [self doPostController:singatureBase64];
        
        
    } else if (type == kCancel) {
        
    } else if (type == kDisconnected) {
        NSString *errorMessage = [NSString stringWithFormat:@"BLE已断开连接:%@", [err toString]];
        NSLog(@"%@",errorMessage);
        
        
        
    } else {//kFailure
        NSString *resultString = [NSString stringWithFormat:@"Error:%@, result:%@", [err toString], result];
        
        NSLog(@"%@",resultString);
        
        
        
    }
    
    
    
    
    
    
    
}


///////////////////////////////////////////////////////////////////////////////////////////////////
-(void)doPostController:(NSString * )signtCode
{
    
    [self submitWithDictionary:@{@"comment":self.currentComment,@"submitAction":self.selectedAction,@"signature" : signtCode,@"ca_verification_necessity" : @"1" , @"p_record_id" : _actionModel.record_id,@"submitActionType" :[self getActionTypeWithId:self.selectedAction]}];

}

-(NSString * )getActionTypeWithId:(NSString *)actionId
{
    NSArray * array = self.actionModel.actionList;
    
    for(NSDictionary * record in array){
        
        NSNumber * actionid = [record valueForKey:@"action"];
        NSString * actionIdStr = [NSString stringWithFormat:@"%@",actionid];
        
        if([actionIdStr isEqualToString:actionId]){
            
            
            return [record valueForKey:@"actionType"];
            
        }
        
    }
    
    
    return @"";
    
    
}

-(NSString * )getActionTitleWithId:(NSString * )actionId
{

    NSArray * array = self.actionModel.actionList;
    
    for(NSDictionary * record in array){
        
        NSNumber * actionid = [record valueForKey:@"action"];
        NSString * actionIdStr = [NSString stringWithFormat:@"%@",actionid];
        
        if([actionIdStr isEqualToString:actionId]){
            
            
            return [record valueForKey:@"actionTitle"];
            
        }
        
    }
    
    
    return @"";
}

-(void)postController:(TTPostController *)postController didPostText:(NSString *)text withResult:(id)result
{
    if(self.ca_verification_necessity){
    
            self.currentComment = text;
       

        
        
        NSString * signatureActionTitle =[_actionModel.signature stringByAppendingString:[self getActionTitleWithId:self.selectedAction]];
        
        NSString * key_id  =             [[NSUserDefaults standardUserDefaults]valueForKey:@"keyId"];

        
            [self.key sign:[signatureActionTitle dataUsingEncoding:NSUTF8StringEncoding]
                parentView:self.view
      parentViewController:self
                 delegator:self
                  signType:@"PKCS7_ATTACHED"
                  certType:nil
                      hash:@"SM3"
                     keyID:key_id
               useCachePin:YES
                    ];
        
        
//        self.navigationController.toolbar.userInteractionEnabled = NO;
        
//        
//        for( UIBarButtonItem * item  in self.toolbarItems){
//            item.enabled = NO;
//            
//            
//        }
        
    
    }else {
        
            [self submitWithDictionary:@{@"comment":self.currentComment,@"submitAction":self.selectedAction,@"ca_verification_necessity" : @"0",@"submitActionType" :[self getActionTypeWithId:self.selectedAction]}];
        
    }
    
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
    
    self.actionModel.ca_verification_necessity = self.ca_verification_necessity;
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
    }
    
    return actionButton;
}@end
