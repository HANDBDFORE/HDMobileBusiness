//
//  HDListViewController.m
//  HDMobileBusiness
//
//  Created by Plato on 12/11/12.
//  Copyright (c) 2012 hand. All rights reserved.
//

#import "HDListViewController.h"

@interface HDListViewController ()

@end

@implementation HDListViewController

@synthesize spaceItem = _spaceItem;
@synthesize timeStampItem = _timeStampItem;
@synthesize timeStampLabel = _timeStampLabel;
@synthesize refreshItem = _refreshItem;

- (void)dealloc
{
    TT_RELEASE_SAFELY(_spaceItem);
    TT_RELEASE_SAFELY(_timeStampItem);
    TT_RELEASE_SAFELY(_timeStampLabel);
    TT_RELEASE_SAFELY(_refreshItem);
    [super dealloc];
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////

-(UIBarButtonItem *)spaceItem
{
    if (!_spaceItem) {
        _spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    }
    return _spaceItem;
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////

-(UIBarButtonItem *)timeStampItem
{
    if (!_timeStampItem) {
        _timeStampLabel = [[HDTimeStampLabel alloc]initWithFrame:CGRectMake(0, 0, self.view.width, TTToolbarHeight())];
        _timeStampLabel.style = TTSTYLE(timeStampLabel);
        _timeStampItem =[[UIBarButtonItem alloc]initWithCustomView:_timeStampLabel];
    }
    return _timeStampItem;
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////

-(UIBarButtonItem *)refreshItem
{
    if (!_refreshItem) {
        _refreshItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshButtonPressed:)];
    }
    return _refreshItem;
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////
-(void)refreshButtonPressed:(id) sender
{}

#pragma mark viewController life circle
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////

-(void)modelDidFinishLoad:(id<TTModel>)model
{
    [super modelDidFinishLoad:model];
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////

-(void)selectedTableCellForCurrentRecord{
    [self.tableView selectRowAtIndexPath:[self.model currentIndexPath] animated:YES scrollPosition:UITableViewScrollPositionNone];
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////
@end
