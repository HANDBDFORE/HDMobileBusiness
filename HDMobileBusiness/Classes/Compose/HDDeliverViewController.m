//
//  HDDeliverViewController.m
//  HDMobileBusiness
//
//  Created by Plato on 9/18/12.
//  Copyright (c) 2012 hand. All rights reserved.
//

#import "HDDeliverViewController.h"

@interface HDDeliverViewController ()

@end

@implementation HDDeliverViewController
@synthesize personPickerTextField = _personPickerTextField;

-(void)viewDidUnload
{
    TT_RELEASE_SAFELY(_personPickerTextField);
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.personPickerTextField = [[[HDMessageSingleRecipientField alloc] initWithTitle: TTLocalizedString(@"To:", @"") required: YES]autorelease];
       
        //默认站位字符，可配置
        self.personPickerTextField.placeholder = TTLocalizedString(@"Enter Conditions For Search", @"请输入查询条件");

        self.fields = @[self.personPickerTextField];
    }
    return self;
}

-(void)loadView
{
    [super loadView];
    //body初始为空，设置默认值时会使焦点跳转到text上。
    NSString * defaultApprove = [[NSUserDefaults standardUserDefaults] stringForKey:@"default_approve_preference"];
    
    self.body = (nil != defaultApprove)? defaultApprove :@" ";
}

@end
