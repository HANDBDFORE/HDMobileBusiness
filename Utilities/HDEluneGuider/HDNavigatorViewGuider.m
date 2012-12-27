//
//  HDNavigatorViewGuider.m
//  HDMobileBusiness
//
//  Created by Plato on 11/19/12.
//  Copyright (c) 2012 hand. All rights reserved.
//

#import "HDNavigatorViewGuider.h"

@implementation HDNavigatorViewGuider

- (void)dealloc
{
    [super dealloc];
}

-(void)perform
{    
    if ([self.sourceController respondsToSelector:@selector(prepareForGuider:targetViewController:)]) {
        [self.sourceController performSelector:@selector(prepareForGuider:targetViewController:) withObject:self withObject:self.destinationController];
    }
    
    TTDASSERT([self.destinationController isKindOfClass:[UIViewController class]]);
    
    UINavigationController * navigator = [(UIViewController *)self.sourceController navigationController];
       
    if ([self.destinationController isKindOfClass:[UIViewController class]]) {
        [navigator pushViewController:self.destinationController animated:self.animated];
    }
}

@end
