//
//  HDListViewController.h
//  HDMobileBusiness
//
//  Created by Plato on 12/11/12.
//  Copyright (c) 2012 hand. All rights reserved.
//

#import <Three20UI/Three20UI.h>
#import "HDTimeStampLabel.h"
#import "HDListModel.h"

@interface HDListViewController : TTTableViewController

@property(nonatomic,readonly) UIBarButtonItem * spaceItem;
@property(nonatomic,readonly) UIBarButtonItem * timeStampItem;
@property(nonatomic,readonly) HDTimeStampLabel * timeStampLabel;
@property(nonatomic,readonly) UIBarButtonItem * refreshItem;

@property(nonatomic,assign) id <HDPageTurning> model;

@property(nonatomic,retain) TTModelViewController * detailController;

-(void)refreshButtonPressed:(id) sender;

-(void)selectedTableCellForCurrentRecord;

@end
