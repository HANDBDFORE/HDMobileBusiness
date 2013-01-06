//
//  HDDoneListViewController.h
//  HandMobile
//
//  Created by Rocky Lee on 5/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import "HDListModel.h"
#import "HDListViewController.h"

@interface HDDoneListViewController : HDListViewController

@property(nonatomic,retain) id <HDPageTurning> model;

@end
