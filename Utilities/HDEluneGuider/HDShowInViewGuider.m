//
//  HDShowInViewGuider.m
//  HDMobileBusiness
//
//  Created by Plato on 11/21/12.
//  Copyright (c) 2012 hand. All rights reserved.
//

#import "HDShowInViewGuider.h"

@implementation HDShowInViewGuider

-(void)perform{
    if ([self.destinationController respondsToSelector:@selector(showInView:animated:)]) {
        [self.destinationController showInView:[(UIViewController *)self.sourceController view]
                                      animated:self.animated];
    }
}
@end
