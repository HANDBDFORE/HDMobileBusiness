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

@implementation HDBaseTodoListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.variableHeightRows = YES;
        self.clearsSelectionOnViewWillAppear = NO;
    }
    return self;
}

#pragma mark viewController life circle
- (void)viewDidUnload
{
    TT_RELEASE_SAFELY(_refuseButtonItem);
    TT_RELEASE_SAFELY(_acceptButtonItem);
    TT_RELEASE_SAFELY(_clearButtonItem);
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
    [self resetButtonTitle];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //swipe
    UISwipeGestureRecognizer *removeRecordRecognizer = [[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(didSwiped:)]autorelease];
    removeRecordRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    removeRecordRecognizer.numberOfTouchesRequired = 1;
    [self.tableView addGestureRecognizer:removeRecordRecognizer];
//    [self.tableView.delegate tableView:self.tableView didSelectRowAtIndexPath:[self.model  currentIndexPath]];
}

#pragma  -mark toolbar Buttons
-(void)resetButtonTitle
{
    _acceptButtonItem.title = TTLocalizedString(@"Accept", @"同意");
    _acceptButtonItem.enabled = NO;
    
    _refuseButtonItem.title = TTLocalizedString(@"Refuse", @"拒绝");
    _refuseButtonItem.enabled = NO;
}

-(void)setToolbarButtonTitleWithCount:(NSNumber *)count
{
    if (count.intValue >0) {
        _acceptButtonItem.title = [NSString stringWithFormat:@"%@(%@)",TTLocalizedString(@"Accept", @"同意"),count];
        _acceptButtonItem.enabled = YES;
        _refuseButtonItem.title = [NSString stringWithFormat:@"%@(%@)",TTLocalizedString(@"Refuse", @"拒绝"),count];
        _refuseButtonItem.enabled = YES;
    }
    else {
        [self resetButtonTitle];
    }
}
///////////////////////////////////////////////////////////////////////////////////////////////////
-(void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    [self resetButtonTitle];
    if(editing){
        self.editButtonItem.title = TTLocalizedString(@"Cancel", @"取消");
    }else {
        self.editButtonItem.title = TTLocalizedString(@"Batch", @"批量");
    }
}

#pragma mark interface orientation
///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation!=UIInterfaceOrientationPortraitUpsideDown);
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
    _submitAction = ([sender tag] == 1)?@"Y":@"N";
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
    NSArray * indexPaths = [self.tableView indexPathsForSelectedRows];
    [self.model submitRecordsAtIndexPaths:indexPaths
                               dictionary:@{kComments:text,kAction:_submitAction}];
    
    [self setEditing:NO animated:YES];
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma -mark TTModel Functions
-(void)modelDidFinishLoad:(id<TTModel>)model
{
    [super modelDidFinishLoad:model];
    self.timeStampLabel.timeStamp = [(TTURLRequestModel *)model loadedTime];
}

-(id<UITableViewDelegate>)createDelegate
{
    return  [[[HDTodoListDelegate alloc] initWithController:self] autorelease];
}

#pragma -mark swipe
-(void)didSwiped:(UISwipeGestureRecognizer *)recognizer{
    CGPoint swipeLocation = [recognizer locationInView:self.tableView];
    NSIndexPath *swipedIndexPath = [self.tableView indexPathForRowAtPoint:swipeLocation];
    if (swipedIndexPath) {
        [self.model removeRecordAtIndex:swipedIndexPath.row];
    }
}

@end
