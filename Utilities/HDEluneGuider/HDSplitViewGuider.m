//
//  HDSplitViewGuider.m
//  HDMobileBusiness
//
//  Created by Plato on 11/26/12.
//  Copyright (c) 2012 hand. All rights reserved.
//

#import "HDSplitViewGuider.h"
#import "HDSplitViewController.h"

@implementation HDSplitViewGuider
- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

-(void)perform
{
    [self prepareForGuider];
    for (NSString * key in _configureParameters) {
        [self.destinationController setValue:[_configureParameters valueForKey:key] forKeyPath:key];
    }   
    [self.destinationController viewWillAppear:NO];
}
@end
