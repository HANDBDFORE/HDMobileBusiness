//
//  HDNavigationController.m
//  HDMobileBusiness
//
//  Created by Plato on 11/19/12.
//  Copyright (c) 2012 hand. All rights reserved.
//

#import "HDNavigationController.h"

@interface HDNavigationController ()

@end

@implementation HDNavigationController
@synthesize pushedViewControllers = _pushedViewControllers;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

-(instancetype)initWithNavigationBarClassName:(NSString *)navigationBarClassName
                             toolbarClassName:(NSString *)toolbarClassName
{
    //    self = [self initWithNavigationBarClass:NSClassFromString(navigationBarClassName)
    //                               toolbarClass:NSClassFromString(toolbarClassName)];
    self = [self initWithNavigationBarClass:NSClassFromString(@"UINavigationBar")
                               toolbarClass:NSClassFromString(@"UIToolbar")];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    for (id controller in _pushedViewControllers) {
        if ([controller isKindOfClass:[NSString class]]) {
            UIViewController * viewController = [[HDApplicationContext shareContext]objectForIdentifier:controller];
            [self pushViewController:viewController animated:NO];
        }
        if ([controller isKindOfClass:[UIViewController class]]) {
            [self pushViewController:controller animated:NO];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
