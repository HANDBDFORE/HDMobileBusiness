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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
