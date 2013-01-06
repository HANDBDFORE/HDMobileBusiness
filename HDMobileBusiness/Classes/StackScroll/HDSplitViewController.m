//
//  HDSplitViewController.m
//  StackScrollView
//
//  Created by Plato on 11/7/12.
//
//

#import "HDSplitViewController.h"

@implementation HDSplitViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)setViewControllerKeys:(NSArray *)viewControllerKeys
{
    NSMutableArray * controllers = [NSMutableArray arrayWithCapacity:2];
    for (NSString * key in viewControllerKeys) {
       [controllers addObject:[[HDApplicationContext shareContext]objectForIdentifier:key]];
    }
    self.viewControllers = controllers;
}

@end
