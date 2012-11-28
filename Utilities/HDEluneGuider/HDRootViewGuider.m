//
//  HDRootViewGuider.m
//  HDMobileBusiness
//
//  Created by Plato on 11/19/12.
//  Copyright (c) 2012 hand. All rights reserved.
//

#import "HDRootViewGuider.h"

@implementation HDRootViewGuider

-(void)perform
{    
    [(UIWindow *)self.sourceController setRootViewController:self.destinationController];
}

@end
