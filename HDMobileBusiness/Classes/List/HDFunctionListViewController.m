//
//  HDTableImageViewController.m
//  hrms
//
//  Created by Rocky Lee on 6/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDFunctionListViewController.h"
#import "HDFunctionListDataSource.h"

@implementation HDFunctionListViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.title = @"功能列表";
        self.variableHeightRows = YES;
        self.dataSource = [[[HDFunctionListDataSource alloc]init] autorelease];
    }
    return self;
}

-(void)loadView
{
    [super loadView];
    
//    _settingButton = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:@selector(settingButtonPressed:)];
//    _settingButton.tintColor = RGBCOLOR(0, 152, 0);
//    self.navigationItem.rightBarButtonItem = _settingButton;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.model load:TTURLRequestCachePolicyDefault more:NO];
    [self.navigationController setToolbarHidden:YES animated:YES];
}

-(void)viewDidUnload
{
    TT_RELEASE_SAFELY(_settingButton);
    [super viewDidUnload];
}

//-(void)settingButtonPressed:(id) sender
//{
//    TTDPRINT(@"setting");
//    [[TTNavigator navigator]openURLAction:[[[TTURLAction actionWithURLPath:@"guide://modalViewControler/SETTINGS_VC_PATH"]applyAnimated:YES]applyTransition:UIViewAnimationTransitionFlipFromLeft]];
//}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
}

-(id<UITableViewDelegate>)createDelegate
{
    return [[[TTTableViewGroupedVarHeightDelegate alloc]initWithController:self]autorelease];
}

-(void)model:(id<TTModel>)model didFailLoadWithError:(NSError *)error
{
    TTAlert(error.localizedDescription);
}

@end
