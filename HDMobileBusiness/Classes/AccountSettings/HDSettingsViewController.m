//
//  HDSettingViewController.m
//  HDMobileBusiness
//
//  Created by Plato on 8/31/12.
//  Copyright (c) 2012 hand. All rights reserved.
//

#import "HDSettingsViewController.h"

@interface HDSettingsViewController ()

@end

@implementation HDSettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"设置";
        //        self.tableViewStyle = UITableViewStyleGrouped;
        self.variableHeightRows = YES;
    }
    return self;
}

-(void)loadView
{
    [super loadView];
    
    //    self.tableView.backgroundColor = RGBCOLOR(224, 224, 224);
    
    _cancelButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
    
    _saveButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save:)];
    
    self.navigationItem.leftBarButtonItem = _cancelButton;
    self.navigationItem.rightBarButtonItem = _saveButton;
}

- (void)viewDidUnload
{
    TT_RELEASE_SAFELY(_cancelButton);
    TT_RELEASE_SAFELY(_saveButton);
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

#pragma -mark custom
-(void) cancel:(id) sender
{
    TTDPRINT(@"cancel");
    [self dismissModalViewControllerAnimated:YES];
}

-(void) save:(id) sender
{
    TTDPRINT(@"save");
    [self dismissModalViewControllerAnimated:YES];
}

-(void) logout:(id) sender
{
    TTDPRINT(@"logout");
}

-(void)createModel
{
    HDTableViewLogoutCell * logoutCell = [[HDTableViewLogoutCell alloc]initWithLogoutButtonTarget:self selector:@selector(logout:)];
    
    self.dataSource =[TTListDataSource dataSourceWithObjects:logoutCell,nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}
@end

@implementation HDTableViewLogoutCell

-(id)initWithLogoutButtonTarget:(id) target selector:(SEL)selector
{
    self = [self init];
    if (self) {
        self.frame = HDNavigationStatusbarFrame();
        
        
        TTLabel * textLabel = [[TTLabel alloc]initWithText:@"退出系统后，将删除该账号在本地的所有缓存数据，包括登录记录，同时将无法接收到推送消息。"];
        
        NSUInteger labelWidth = 300;
        textLabel.frame = CGRectMake((self.width - labelWidth)/2, 10, labelWidth, 60);
        [self addSubview:textLabel];
        
        NSUInteger buttonWidth = 80;
        NSUInteger buttonHeight = 44;
        TTButton * logoutButton = [TTButton buttonWithStyle:@"blackToolbarRoundButton:" title:@"注销"];
        logoutButton.frame = CGRectMake((self.width - buttonWidth)/2, buttonHeight *2, buttonWidth, buttonHeight);
        logoutButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
        [logoutButton addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:logoutButton];
    }
    return self;
}

@end