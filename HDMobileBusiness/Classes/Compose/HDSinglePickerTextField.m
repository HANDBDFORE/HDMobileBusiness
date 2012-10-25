//
//  HDSinglePickerTextField.m
//  HDMobileBusiness
//
//  Created by Plato on 9/12/12.
//  Copyright (c) 2012 hand. All rights reserved.
//

#import "HDSinglePickerTextField.h"

@implementation HDSinglePickerTextField

-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        //初始化text为@" ",因为textlength不为0,导致placehoder失效
        self.text = @"";
    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)addCellWithObject:(id)object {
    [super removeAllCells];
    [super addCellWithObject:object];
}

@end
