//
//  SFTableConfirmViewCell.m
//  Three20Lab
//
//  Created by Plato on 9/3/12.
//  Copyright (c) 2012 hand. All rights reserved.
//

#import "HDTableConfirmViewCell.h"

@implementation HDTableConfirmViewCell

@synthesize confirmLabel = _confirmLabel;
@synthesize confirmButton = _confirmButton;

- (void)dealloc
{
    TT_RELEASE_SAFELY(_confirmLabel);
    TT_RELEASE_SAFELY(_confirmButton);
    TT_RELEASE_SAFELY(_lableText);
    TT_RELEASE_SAFELY(_buttonTitle);
    [super dealloc];
}

-(id)initWithlableText:(NSString *) lableText
           buttonTitle:(NSString *) buttonTitle
{
    self = [self init];
    if (self) {
        _lableText = [lableText retain];
        _buttonTitle = [buttonTitle retain];
        self.frame = CGRectMake(0, 0,self.superview.width, 120);
        [self confirmLabel];
        [self confirmButton];
    }
    return self;
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    
    if (self.superview) {
        _confirmLabel.backgroundColor = self.backgroundColor;
        _confirmButton.backgroundColor = self.backgroundColor;
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    _confirmLabel.frame = CGRectMake(0, 20, self.width, 20);
    _confirmButton.frame = CGRectMake(self.width * 0.5 - 60, self.height * 0.4, 120, 32);
}

-(TTStyledTextLabel *) confirmLabel
{
    if (!_confirmLabel) {
        _confirmLabel = [[TTStyledTextLabel alloc]init];
        _confirmLabel.font = [UIFont systemFontOfSize:14];
        NSString * text = [NSString stringWithFormat:@"<b>%@</b>",_lableText];
        _confirmLabel.text = [TTStyledText textFromXHTML:text lineBreaks:YES URLs:YES];
        _confirmLabel.textAlignment = UITextAlignmentCenter;
        _confirmLabel.textColor = [UIColor blackColor];
        [_confirmLabel sizeToFit];
        [self addSubview:_confirmLabel];
    }
    return _confirmLabel;
}

-(TTButton *) confirmButton
{
    if (!_confirmButton) {
        _confirmButton = [[TTButton buttonWithStyle:@"confirmCellButton:"
                                              title:_buttonTitle] retain];
        [_confirmButton sizeToFit];
         [self addSubview:_confirmButton];
    }
    return _confirmButton;
}

-(void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    [_confirmButton addTarget:target action:action forControlEvents:controlEvents];
}

@end
