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
        _shouldGuideToRight = YES;
    }
    return self;
}

-(void)perform
{
    HDSplitViewController * source = self.sourceController;
    if (nil != [(UIViewController *)self.destinationController navigationController] )
    {
        self.destinationController = [self.destinationController navigationController];
    }
    
    if(![self.destinationController isKindOfClass:[UINavigationController class]]) {
        self.destinationController = [[[UINavigationController alloc] initWithRootViewController:self.destinationController] autorelease];
    }
    
    if (self.shouldGuideToRight) {
        [source setRightViewController:self.destinationController];
    }else{
        [source setLeftViewController:self.destinationController];
    }
}
@end
