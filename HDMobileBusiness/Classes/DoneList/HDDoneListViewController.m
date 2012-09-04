//
//  HDDoneListViewController.m
//  HandMobile
//
//  Created by Rocky Lee on 5/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDDoneListViewController.h"
#import "HDDoneListDataSource.h"

@implementation HDDoneListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"审批完成";
        self.variableHeightRows = YES;
        self.dataSource = [[[HDDoneListDataSource alloc]init]autorelease];
    }
    return self;
}

- (void)viewDidUnload
{
    TT_RELEASE_SAFELY(_refreshButton);
    [super viewDidUnload];
}

-(void)loadView
{
    [super loadView];
     _refreshButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshButtonPressed:)];
    
    self.navigationItem.rightBarButtonItem = _refreshButton;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setToolbarHidden:YES];
    [self.model load:TTURLRequestCachePolicyDefault more:NO];
    [self.navigationController setToolbarHidden:YES animated:YES];
}

-(void)refreshButtonPressed:(id)sender
{
    [self.model load:TTURLRequestCachePolicyDefault more:NO];
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return (toInterfaceOrientation != UIDeviceOrientationPortraitUpsideDown);
}
@end
