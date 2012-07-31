//
//  HDTableImageViewController.m
//  hrms
//
//  Created by Rocky Lee on 6/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDFunctionListViewController.h"
#import "HDFunctionListDataSource.h"

@implementation HDFunctionListViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.title = @"功能列表";
        self.variableHeightRows = YES;
        [self setTableViewStyle:UITableViewStyleGrouped];
    }
    return self;
}

-(void)createModel
{
    self.dataSource = [[[HDFunctionListDataSource alloc]init] autorelease];
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return YES;
}

@end
