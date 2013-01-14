//
//  HDTodoListSearchViewController.m
//  HandMobile
//
//  Created by Rocky Lee on 7/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDTodoListSearchViewController.h"

@implementation HDTodoListSearchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark edit status
-(void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    [self setEditingToolbarItemButtons:editing animated:animated];
    [self setEnableSearchBar:!editing animated:animated];
}

-(void)setEnableSearchBar:(BOOL) enableSearchBar animated:(BOOL)animated
{
    self.superController.searchDisplayController.searchBar.userInteractionEnabled = enableSearchBar;
    [UIView animateWithDuration:animated?0.25:0 animations:^{
        self.superController.searchDisplayController.searchBar.alpha = enableSearchBar? 1:0.5; 
        [self.superController.searchDisplayController.searchBar setShowsCancelButton:enableSearchBar animated:animated];
    }];
}

-(void) setEditingToolbarItemButtons:(BOOL)editing animated:(BOOL)animated
{
    [self.superController setToolbarItems:[self createToolbarItems] animated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setEditingToolbarItemButtons:NO animated:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self revertToolbar];
//    [[NSNotificationCenter defaultCenter] postNotificationName:kEventTodoListSearchViewWillDissappear object:nil];
}

#pragma mark toolbar setting
-(void)revertToolbar
{
    [self.superController setEditing:NO animated:YES];
}

-(NSArray *)createToolbarItems
{
    if (self.editing) {
        return [NSArray arrayWithObjects:_acceptButtonItem,_refuseButtonItem,self.spaceItem,self.editButtonItem, nil];
    }else {
        return [NSArray arrayWithObjects:self.spaceItem,self.editButtonItem, nil];
    } 
}

@end
