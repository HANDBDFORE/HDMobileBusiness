//
//  HDTextFieldDelegate.m
//  HDMobileBusiness
//
//  Created by Plato on 10/19/12.
//  Copyright (c) 2012 hand. All rights reserved.
//

#import "HDTextFieldDelegate.h"

@implementation HDTextFieldDelegate

-(id)initWithTarget:(id) target selector:(SEL) selector
{
    if (self = [self init]) {
    _target = target;
    _selector = selector;
    }
    return self;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.text.length == 0) {
        return NO;
    }
    if ([_target respondsToSelector:_selector]) {
        [_target performSelector:_selector withObject:textField];
    }
    return YES;
}

@end
