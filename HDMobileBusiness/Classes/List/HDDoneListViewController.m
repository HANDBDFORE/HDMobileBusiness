//
//  HDDoneListViewController.m
//  HandMobile
//
//  Created by Rocky Lee on 5/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDDoneListViewController.h"

@implementation HDDoneListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"审批完成";
        self.variableHeightRows = YES;
        self.clearsSelectionOnViewWillAppear = !TTIsPad();
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setToolbarHidden:YES animated:YES];
}

-(id<UITableViewDelegate>)createDelegate
{
    return [[[TTTableViewDragRefreshDelegate alloc]initWithController:self]autorelease];
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return (toInterfaceOrientation != UIDeviceOrientationPortraitUpsideDown);
}

-(void)model:(id<TTModel>)model didFailLoadWithError:(NSError *)error
{
    TTAlert(error.localizedDescription);
}

@end
