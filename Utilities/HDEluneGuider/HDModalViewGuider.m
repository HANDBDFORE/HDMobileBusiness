//
//  HDNavigatorTableItemViewGuider.m
//  HDMobileBusiness
//
//  Created by Plato on 11/20/12.
//  Copyright (c) 2012 hand. All rights reserved.
//

#import "HDModalViewGuider.h"
#import "HDNavigationController.h"

@implementation HDModalViewGuider

-(void)perform{
    [self.sourceController presentModalViewController:self.destinationController
                                             animated:self.animated];
}

@end
