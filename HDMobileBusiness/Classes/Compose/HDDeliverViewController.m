//
//  HDDeliverViewController.m
//  HDMobileBusiness
//
//  Created by Plato on 9/18/12.
//  Copyright (c) 2012 hand. All rights reserved.
//

#import "HDDeliverViewController.h"
#import "HDMessageSingleRecipientField.h"

@interface HDDeliverViewController ()

@end

@implementation HDDeliverViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.fields = @[[[[HDMessageSingleRecipientField alloc] initWithTitle: TTLocalizedString(@"To:", @"") required: YES]autorelease]];
    }
    return self;
}

@end
