//
//  HDBaseTodoListViewController.m
//  hrms
//
//  Created by Rocky Lee on 7/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDBaseTodoListViewController.h"
#import "HDTodoListDelegate.h"

@implementation HDBaseTodoListViewController
@synthesize listModel = _listModel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.variableHeightRows = YES;
        self.clearsSelectionOnViewWillAppear = NO;
        
        HDTodoListDataSource * listDataSource = [[[HDTodoListDataSource alloc]init]autorelease];
        self.dataSource = listDataSource;
        self.listModel = listDataSource.listModel;
    }
    return self;
}

#pragma mark viewController life circle
- (void)viewDidUnload
{
    TT_RELEASE_SAFELY(_refuseButtonItem);
    TT_RELEASE_SAFELY(_acceptButtonItem);
    TT_RELEASE_SAFELY(_refreshButtonItem);
    TT_RELEASE_SAFELY(_composeButtonItem);
    TT_RELEASE_SAFELY(_clearButtonItem);
    TT_RELEASE_SAFELY(_stateLabelItem);
    TT_RELEASE_SAFELY(_timeStampLabel);
    TT_RELEASE_SAFELY(_space);
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(void)loadView
{
    [super loadView];
    _acceptButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"同意" style:UIBarButtonItemStyleBordered target:self action:@selector(toolBarButtonPressed:)]; 
    _acceptButtonItem.width = 120;
    _acceptButtonItem.tintColor = RGBCOLOR(0, 153, 0);
    _acceptButtonItem.tag = 1;
    ////////////////////////////////////////////////////////////////////////////////
/////////////////////
    
    _refuseButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"拒绝" style:UIBarButtonItemStyleBordered target:self action:@selector(toolBarButtonPressed:)];
    _refuseButtonItem.width = 120;
    _refuseButtonItem.tintColor = RGBCOLOR(153, 0, 0);
    _refuseButtonItem.tag = 0;
    ////////////////////////////////////////////////////////////////////////////////
/////////////////////
    
    _clearButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"清理" style:UIBarButtonItemStyleBordered target:self.model action:@selector(clear)];
    ////////////////////////////////////////////////////////////////////////////////
/////////////////////
    
    _space = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    ////////////////////////////////////////////////////////////////////////////////
/////////////////////
    
    _refreshButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshButtonPressed:)];
    ////////////////////////////////////////////////////////////////////////////////
/////////////////////
    
    _composeButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:nil action:nil];
    ////////////////////////////////////////////////////////////////////////////////
/////////////////////
    _timeStampLabel = [[TTLabel alloc]init];
    _timeStampLabel.style = TTSTYLE(timeStampLabel);
    _timeStampLabel.frame = CGRectMake(0, 0, self.view.width, TTToolbarHeight());
    _timeStampLabel.backgroundColor = [UIColor clearColor];
    _timeStampLabel.text = @"...";
    
    _stateLabelItem =[[UIBarButtonItem alloc]initWithCustomView:_timeStampLabel];
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
}

#pragma  -mark toolbar Buttons
-(void)resetButtonTitle
{
    _acceptButtonItem.title = @"同意";
    _acceptButtonItem.enabled = NO;
    
    _refuseButtonItem.title = @"拒绝";
    _refuseButtonItem.enabled = NO;
}

-(void)setToolbarButtonTitleWithCount:(NSNumber *)count
{
    if (count.intValue >0) {
        _refuseButtonItem.title = [NSString stringWithFormat:@"拒绝(%@)",count];
        _refuseButtonItem.enabled = YES;
        _acceptButtonItem.title = [NSString stringWithFormat:@"同意(%@)",count];
        _acceptButtonItem.enabled = YES;
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
        self.editButtonItem.title = @"取消";
    }else {
        self.editButtonItem.title = @"批量";
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
    [self showPostView];
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(void)showPostView
{
    //TODO:获取默认审批内容使用常量，常量定义位置未定,考虑使用一个全局常量头文件
    NSString *defaultComments = [[NSUserDefaults standardUserDefaults] stringForKey:@"default_approve_preference"];
    //    controller.originView = [query objectForKey:@"__target__"];
    [[TTNavigator navigator] openURLAction:[[TTURLAction actionWithURLPath:@"init://postController"] applyQuery: @{@"text":defaultComments, @"delegate":self, @"title":@"审批意见"}]];
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(void)postController:(TTPostController *)postController didPostText:(NSString *)text withResult:(id)result
{
    NSArray * indexPaths = [self.tableView indexPathsForSelectedRows];
    [self.listModel submitRecordsAtIndexPaths:indexPaths
                                        query:@{kComments:text,kAction:_submitAction}];

    [self setEditing:NO animated:YES];
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma -mark TTModel Functions
-(void)modelDidFinishLoad:(id<TTModel>)model
{
    [super modelDidFinishLoad:model];
    NSDate * lastUpdatedDate =  [(TTURLRequestModel *)model loadedTime];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    _timeStampLabel.text = [NSString stringWithFormat:
                              TTLocalizedString(@"Last updated: %@",
                                                @"The last time the table view was updated."),
                              [formatter stringFromDate:lastUpdatedDate]];
    [formatter release];
}

-(id<UITableViewDelegate>)createDelegate
{
    return  [[[HDTodoListDelegate alloc] initWithController:self] autorelease];
}

#pragma -mark swipe
-(void)didSwiped:(UISwipeGestureRecognizer *)recognizer{
    CGPoint swipeLocation = [recognizer locationInView:self.tableView];
    NSIndexPath *swipedIndexPath = [self.tableView indexPathForRowAtPoint:swipeLocation];
    [self.listModel removeRecordAtIndex:swipedIndexPath.row];
}
@end
