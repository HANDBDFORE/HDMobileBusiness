//
//  HDSplitViewGuider.h
//  HDMobileBusiness
//
//  Created by Plato on 11/26/12.
//  Copyright (c) 2012 hand. All rights reserved.
//

#import "HDViewGuider.h"

@interface HDSplitViewGuider : HDViewGuider

@property (nonatomic,retain) NSDictionary * configureParameters;

@property (nonatomic,assign) BOOL shouldLoadAction;

@property (nonatomic,retain) id pageTurningService;

@end
