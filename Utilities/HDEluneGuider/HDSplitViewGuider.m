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

- (void)dealloc
{
    TT_RELEASE_SAFELY(_configureParameters);
    TT_RELEASE_SAFELY(_pageTurningService);
    [super dealloc];
}

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
    [self.destinationController setValue:[NSNumber numberWithBool:self.shouldLoadAction] forKeyPath:@"shouldLoadAction"];
    [self.destinationController setValue:self.pageTurningService forKeyPath:@"pageTurningService"];

    //tt在willAppear时挂起网络访问，防止卡界面，需要同时调用didAppear恢复网络访问
    [self.destinationController viewWillAppear:NO];
    [self.destinationController viewDidAppear:NO];
}
@end
