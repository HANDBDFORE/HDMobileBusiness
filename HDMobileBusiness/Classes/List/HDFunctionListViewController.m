//
//  HDTableImageViewController.m
//  hrms
//
//  Created by Rocky Lee on 6/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDFunctionListViewController.h"

@implementation HDFunctionListViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.title = @"功能列表";
        self.variableHeightRows = YES;
    }
    return self;
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(void)loadView
{
    [super loadView];
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//-(void)viewDidLoad
//{
//    [super viewDidLoad];
//    [self.navigationController setToolbarHidden:YES animated:NO];
//}
//-(void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    [self.navigationController setToolbarHidden:YES animated:NO];
//}
-(void)viewDidAppear:(BOOL)animated
{
//    NSLog(@"functionlistDidAppear");
    [super viewDidAppear:animated];
    [self.navigationController setToolbarHidden:YES animated:YES];
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(void)viewDidUnload
{
    TT_RELEASE_SAFELY(_settingButton);
    [super viewDidUnload];
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//-(void)settingButtonPressed:(id) sender
//{
//    TTDPRINT(@"setting");
//    [[TTNavigator navigator]openURLAction:[[[TTURLAction actionWithURLPath:@"guide://modalViewControler/SETTINGS_VC_PATH"]applyAnimated:YES]applyTransition:UIViewAnimationTransitionFlipFromLeft]];
//}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(id<UITableViewDelegate>)createDelegate
{
    return [[[TTTableViewGroupedVarHeightDelegate alloc]initWithController:self]autorelease];
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

-(void)model:(id<TTModel>)model didFailLoadWithError:(NSError *)error
{
    TTAlert(error.localizedDescription);
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@end
