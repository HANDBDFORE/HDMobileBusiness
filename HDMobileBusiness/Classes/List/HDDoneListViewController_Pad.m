//
//  HDDoneListViewController_Pad.m
//  HDMobileBusiness
//
//  Created by Plato on 2/16/13.
//  Copyright (c) 2013 hand. All rights reserved.
//

#import "HDDoneListViewController_Pad.h"

@interface HDDoneListViewController_Pad ()

@end

@implementation HDDoneListViewController_Pad

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self selectedTableCellForCurrentRecord];
}

-(void)modelDidFinishLoad:(id<TTModel>)model
{
    [super modelDidFinishLoad:model];
    [self selectedTableCellForCurrentRecord];
}

-(void)selectedTableCellForCurrentRecord
{
    [super selectedTableCellForCurrentRecord];
    HDViewGuider * guider = [[HDApplicationContext shareContext]objectForIdentifier:@"doneListTableGuider"];
    [guider perform];
}

@end
