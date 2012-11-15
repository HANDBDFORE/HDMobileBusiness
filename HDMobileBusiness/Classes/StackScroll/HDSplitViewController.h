//
//  HDSplitViewController.h
//  StackScrollView
//
//  Created by Plato on 11/7/12.
//
//

#import <UIKit/UIKit.h>

@interface HDSplitViewController : TTViewController
{
    UIView * _leftView;
    UIView * _rightView;
}

@property (nonatomic) CGFloat leftViewWidth;
@property (nonatomic) CGFloat leftViewPercentWidth;

@property (nonatomic,retain) UIViewController * leftViewController;
@property (nonatomic,retain) UIViewController * rightViewController;

@end
