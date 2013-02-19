//
//  HDDetaiViewController.h
//  Three20GitCoreDataLab
//
//  Created by Rocky Lee on 6/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HDDetailInfoViewController.h"

@interface HDDetailToolbarViewController : HDDetailInfoViewController <TTMessageControllerDelegate,TTPostControllerDelegate>
{
}

@property(nonatomic,readonly) UIBarButtonItem * spaceItem;

-(void)setEditing:(BOOL)editing animated:(BOOL)animated;

-(NSMutableArray *)createRightNavigationItems;

-(NSMutableArray *)createLeftNavigationItems;

-(void)updateNavigationItems;

-(void)resetEditViewAnimated:(BOOL) animated;

-(void)selectedObject:(id)object atIndex:(NSInteger)index;

-(void)deselectedObject:(id)object atIndex:(NSInteger)index;

@end
