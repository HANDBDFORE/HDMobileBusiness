//
//  HDNavigationController.h
//  HDMobileBusiness
//
//  Created by Plato on 11/19/12.
//  Copyright (c) 2012 hand. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HDViewGuider.h"

@interface HDNavigationController : UINavigationController

@property(nonatomic,retain)  NSArray * pushedViewControllers;

-(instancetype)initWithNavigationBarClassName:(NSString *)navigationBarClassName
                             toolbarClassName:(NSString *)toolbarClassName;

@end
