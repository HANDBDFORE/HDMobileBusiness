//
//  SFTableConfirmViewCell.h
//  Three20Lab
//
//  Created by Plato on 9/3/12.
//  Copyright (c) 2012 hand. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HDTableConfirmViewCell : UIControl
{
    TTButton * _confirmButton;
    TTStyledTextLabel * _confirmLabel;
    NSString * _lableText;
    NSString * _buttonTitle;
}

-(id)initWithlableText:(NSString *) lableText
           buttonTitle:(NSString *) buttonTitle;

@property(nonatomic,readonly) TTButton * confirmButton;
@property(nonatomic,readonly) TTStyledTextLabel * confirmLabel;

@end
