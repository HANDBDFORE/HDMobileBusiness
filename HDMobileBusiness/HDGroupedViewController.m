//
//  HDGroupedViewController.m
//  HDMobileBusiness
//
//  Created by Plato on 12/6/12.
//  Copyright (c) 2012 hand. All rights reserved.
//

#import "HDGroupedViewController.h"

@interface HDGroupedViewController ()

@end

@implementation HDGroupedViewController

-(id<UITableViewDelegate>)createDelegate
{
    return [[[TTTableViewDragRefreshDelegate alloc]initWithController:self]autorelease];
}

- (void)dealloc
{
    TT_RELEASE_SAFELY(_timeStampLabel);
    TT_RELEASE_SAFELY(_stateLabelItem);
    TT_RELEASE_SAFELY(_space);
    [super dealloc];
}

-(void)loadView
{
    [super loadView];
    [self.navigationController setToolbarHidden:NO];
    [self.navigationController.toolbar setTintColor:TTSTYLEVAR(toolbarTintColor)];

    _space = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
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
    [self setToolbarItems:@[_space,_stateLabelItem,_space]];
}

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
@end
