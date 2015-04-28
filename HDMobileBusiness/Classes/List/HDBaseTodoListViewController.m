//
//  HDBaseTodoListViewController.m
//  hrms
//
//  Created by Rocky Lee on 7/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDBaseTodoListViewController.h"
#import "HDTodoListDelegate.h"
#import "HDTodoListModelStatus.h"
#import "HDTableStatusMessageItem.h"
#import "HDTodoListDataSource.h"
#import "HDTodoListModel.h"
#import "HDDetailToolbarViewController.h"

@implementation HDBaseTodoListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.variableHeightRows = YES;
        self.clearsSelectionOnViewWillAppear = !TTIsPad();
    }
    return self;
}

#pragma mark viewController life circle
- (void)viewDidUnload
{
    TT_RELEASE_SAFELY(_refuseButtonItem);
    TT_RELEASE_SAFELY(_acceptButtonItem);
    TT_RELEASE_SAFELY(_clearButtonItem);
    TT_RELEASE_SAFELY(_detailViewController);
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(void)loadView
{
    [super loadView];
    self.editButtonItem.title = TTLocalizedString(@"Batch", @"批量");
    self.editButtonItem.width = 60;
    //////////////////////
    
    _acceptButtonItem = [[UIBarButtonItem alloc]initWithTitle:TTLocalizedString(@"Accept", @"同意") style:UIBarButtonItemStyleBordered target:self action:@selector(toolBarButtonPressed:)];
    _acceptButtonItem.width = 110;
    _acceptButtonItem.tintColor = RGBCOLOR(0, 153, 0);
    _acceptButtonItem.tag = 1;
    ////////////////////////////////////////////////////////////////////////////////
    /////////////////////
    
    _refuseButtonItem = [[UIBarButtonItem alloc]initWithTitle:TTLocalizedString(@"Refuse", @"拒绝") style:UIBarButtonItemStyleBordered target:self action:@selector(toolBarButtonPressed:)];
    _refuseButtonItem.width = 110;
    _refuseButtonItem.tintColor = RGBCOLOR(153, 0, 0);
    _refuseButtonItem.tag = 0;
    ////////////////////////////////////////////////////////////////////////////////
    /////////////////////
    
    _clearButtonItem = [[UIBarButtonItem alloc]initWithTitle:TTLocalizedString(@"Clear", @"清理") style:UIBarButtonItemStyleBordered target:self.model action:@selector(clear)];
    ////////////////////////////////////////////////////////////////////////////////
    /////////////////////
    [self resetToolBarButton];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //swipe
    UISwipeGestureRecognizer *removeRecordRecognizer = [[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(didSwiped:)]autorelease];
    removeRecordRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.tableView addGestureRecognizer:removeRecordRecognizer];
}

#pragma  -mark toolbar Buttons
-(void)resetToolBarButton
{
    _acceptButtonItem.title = TTLocalizedString(@"Accept", @"同意");
    _acceptButtonItem.enabled = NO;
    
    _refuseButtonItem.title = TTLocalizedString(@"Refuse", @"拒绝");
    _refuseButtonItem.enabled = NO;
}

-(void)setToolbarButtonWithCount
{
    NSNumber * count =  [NSNumber numberWithInt:self.tableView.indexPathsForSelectedRows.count];
    if (count.intValue >0) {
        _acceptButtonItem.title = [NSString stringWithFormat:@"%@(%@)",TTLocalizedString(@"Accept", @"同意"),count];
        _acceptButtonItem.enabled = YES;
        _refuseButtonItem.title = [NSString stringWithFormat:@"%@(%@)",TTLocalizedString(@"Refuse", @"拒绝"),count];
        _refuseButtonItem.enabled = YES;
    }
    else {
        [self resetToolBarButton];
    }
}
///////////////////////////////////////////////////////////////////////////////////////////////////
-(void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    [self.detailViewController setEditing:editing animated:animated];
    [self resetToolBarButton];
    if(editing){
        self.editButtonItem.title = TTLocalizedString(@"Cancel", @"取消");
    }else {
        if (TTIsPad()) {
            [self selectedTableCellForCurrentRecord];
        }
        self.editButtonItem.title = TTLocalizedString(@"Batch", @"批量");
    }
}

#pragma mark interface orientation
///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return TTIsSupportedOrientation(interfaceOrientation);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma refresh
-(void)refreshButtonPressed:(id)sender
{
    [self.model load:TTURLRequestCachePolicyNetwork more:NO];
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark post view controller
//toolBar button pressed
-(void)toolBarButtonPressed: (id)sender
{
    _submitActionType = ([sender tag] == 1)?@"approve":@"reject";
    [self showPostView:sender];
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(void)showPostView:(id)sender
{
    HDViewGuider * guider = [[HDApplicationContext shareContext]objectForIdentifier:@"todoListPostGuider"];
    
    NSString *defaultComments = [[NSUserDefaults standardUserDefaults] stringForKey:@"default_approve_preference"];
    
    guider.destinationQuery = @{@"text":defaultComments, @"delegate":self, @"title":TTLocalizedString(@"Comments", @"意见")};
    
    [guider setSourceController:self];
    [guider perform];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(void)postController:(TTPostController *)postController didPostText:(NSString *)text withResult:(id)result
{
    [self.detailViewController resetEditViewAnimated:YES];
    NSArray * indexPaths = [self.tableView indexPathsForSelectedRows];
    [self.model submitRecordsAtIndexPaths:indexPaths
                               dictionary:@{@"comment":text,@"submitActionType":_submitActionType}];
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma -mark TTModel Functions
-(void)modelDidFinishLoad:(id<TTModel>)model
{
    [super modelDidFinishLoad:model];
    self.timeStampLabel.timeStamp = [(TTURLRequestModel *)model loadedTime];
    [self resetToolBarButton];
    if (self.editing) {
        [self.detailViewController resetEditViewAnimated:YES];
    }else if (TTIsPad()) {
        [self selectedTableCellForCurrentRecord];
    }
}

-(id<UITableViewDelegate>)createDelegate
{
    return  [[[HDTodoListDelegate alloc] initWithController:self] autorelease];
}

#pragma -mark private
////判断是否需要蓝牙key
-(BOOL)isNeedUlanKey:(NSUInteger )row
{
    
  HDTodoListModel * toDoModel =   (HDTodoListModel *)self.model ;
  NSDictionary * record  =  [toDoModel.resultList objectAtIndex:row];
    
    NSString *VERIFICATION_ID = [record valueForKey:@"serverMessage"];
    
    if([VERIFICATION_ID isEqualToString:@"0"]){
        
        return NO;
        
    }else {
        
        
        return  YES;
    }
    
    
    
}

-(void)didSwiped:(UISwipeGestureRecognizer *)recognizer{
    CGPoint swipeLocation = [recognizer locationInView:self.tableView];
    NSIndexPath *swipedIndexPath = [self.tableView indexPathForRowAtPoint:swipeLocation];
    if (swipedIndexPath) {
        [self.model removeRecordAtIndex:swipedIndexPath.row];
    }
}

-(void)didSelectObject:(id)object atIndexPath:(NSIndexPath *)indexPath
{
    HDTableStatusMessageItem * item = object;
    if (self.editing) {
        
        if([self isNeedUlanKey:indexPath.row]){
            
            
            [_tableView deselectRowAtIndexPath:indexPath animated:YES];
            TTAlert(@"该单据需要蓝牙签名无法批量审批");
            
        }else{
            [self setToolbarButtonWithCount];
            [self.detailViewController selectedObject:object atIndex:indexPath.row];
        }
    }else{
        if ([item.state isEqualToString:kRecordNew] || [item.state isEqualToString:kRecordError]) {
            self.model.currentIndex = indexPath.row;
            [self selectedTableCellForCurrentRecord];
        }
    }
}

-(void)didDeselectObject:(id)object atIndexPath:(NSIndexPath *)indexPath
{
    if (self.editing) {
        [self setToolbarButtonWithCount];
        [self.detailViewController deselectedObject:object atIndex:indexPath.row];
    }
}
///////////////modify by jiangtiteng 15-4-22
-(void)goToDetail
{
    
    HDViewGuider * guider =  [[HDApplicationContext shareContext] objectForIdentifier:@"todolistTableGuider"];
    //TODO:Pad版本考虑直接向目标视图控制器设置model而不是通过guider间接设置
    if ([guider respondsToSelector:@selector(setPageTurningService:)]) {
        [guider performSelector:@selector(setPageTurningService:) withObject:self.model];
    }
    if ([guider.destinationController respondsToSelector:@selector(setPageTurningService:)]) {
        [guider.destinationController performSelector:@selector(setPageTurningService:) withObject:self.model];
    }
    
   HDDetailToolbarViewController *  tmp=  (HDDetailToolbarViewController *)guider.destinationController;
    
    tmp.ca_verification_necessity = [self isNeedUlanKey:self.model.currentIndex] ;
    
    
    
    
    [guider perform];
}


-(void)selectedTableCellForCurrentRecord
{
    [super selectedTableCellForCurrentRecord];
    
    [self goToDetail];
}
@end
