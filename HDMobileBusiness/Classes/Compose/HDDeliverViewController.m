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
        //TODO:为personPickerTextField添加placeholder,由于vc属性设置的时机在loadView之后，导致该属性无法从配置文件正确加载
        //a.使用自己的工厂函数创建视图控制器，可能增加构造的复杂度。
        //b.细化配置粒度，不再只是VC的配置，缺点是配置文件解析复杂度高
        self.personPickerTextField.placeholder = TTLocalizedString(@"Enter Conditions For Search", @"请输入查询条件");

        self.fields = @[self.personPickerTextField];
        //body初始为空，设置默认值时会使焦点跳转到text上。
        self.body = @" ";
    }
    return self;
}

@end
