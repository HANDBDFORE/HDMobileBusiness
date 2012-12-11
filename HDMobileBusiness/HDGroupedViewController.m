//
//  HDGroupedViewController.m
//  HDMobileBusiness
//
//  Created by Plato on 12/6/12.
//  Copyright (c) 2012 hand. All rights reserved.
//

#import "HDGroupedViewController.h"

@implementation HDGroupedViewController

-(void)loadView
{
    [super loadView];
    [self.navigationController setToolbarHidden:NO];
    [self.navigationController.toolbar setTintColor:TTSTYLEVAR(toolbarTintColor)];
    [self setToolbarItems:@[self.spaceItem,self.timeStampItem,self.spaceItem]];
}

#pragma -mark TTModel Functions
-(void)modelDidFinishLoad:(id<TTModel>)model
{
    [super modelDidFinishLoad:model];
    self.timeStampLabel.timeStamp =  [(TTURLRequestModel *)model loadedTime];
}

-(id<UITableViewDelegate>)createDelegate
{
    return [[[TTTableViewDragRefreshDelegate alloc]initWithController:self]autorelease];
}

@end
