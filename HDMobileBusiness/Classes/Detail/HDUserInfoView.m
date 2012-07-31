//
//  HDEmployeeView.m
//  hrms
//
//  Created by Rocky Lee on 7/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDUserInfoView.h"

@implementation HDUserInfoView
@synthesize employeeUrlPath = _employeeUrlPath;

- (void)dealloc
{
    TT_RELEASE_SAFELY(_employeeUrlPath);
    TT_RELEASE_SAFELY(_empWebView);
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _isPullDown = NO;
        _isFirstLoad = YES;
//        self.backgroundColor = RGBCOLOR(255, 255, 255);      
        //        CGSize floatWebViewSize = CGSizeMake(320, 140);
        CGRect screenFrame = TTScreenBounds();
        _empWebView = [[UIWebView alloc]initWithFrame:CGRectMake((screenFrame.size.width-310)/2,-140, 310, 140)];
        _empWebView.layer.shadowOpacity = 0.7f;
        _empWebView.layer.shadowOffset = CGSizeMake(0, 5);
        _empWebView.layer.shadowColor = [[UIColor darkGrayColor]CGColor];
        _empWebView.layer.borderWidth = 1;
        _empWebView.layer.borderColor = [[UIColor grayColor]CGColor];      
        _empWebView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
        
        [self insertSubview:_empWebView aboveSubview:self];
        
        [self addTarget:self action:@selector(show) forControlEvents:UIControlEventTouchUpInside];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        self.hidden = YES;
    }
    return self;
}

-(void)show{
    
    if (_isFirstLoad) {
        _isFirstLoad = NO;
        [_empWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.employeeUrlPath]]];
    }
    
    if (_isPullDown) {
        //名片动画
        _isPullDown = NO;   
        NSString *pullUpAnimationKey = @"pullUpAnimation";
        CALayer *floatWebLayer = _empWebView.layer;
        //        [floatWebLayer removeAnimationForKey:pullUpAnimationKey];
        [floatWebLayer addAnimation:[self pullUpAnimationsOnLayer:floatWebLayer] forKey:pullUpAnimationKey];
        
        [UIView animateWithDuration:0.35 animations:^{
//            self.alpha = 0.0;
            self.backgroundColor = RGBACOLOR(255, 255, 255,0);

        } completion:^(BOOL finished){
            self.userInteractionEnabled = false;
        } ]; 
    }else {  
        _isPullDown = YES;
        self.hidden = NO;
        NSString *pullDownAnimationKey = @"downAnimation";
        CALayer *floatWebLayer = _empWebView.layer;
        //        [floatWebLayer removeAnimationForKey:pullDownAnimationKey];
        [floatWebLayer addAnimation:[self pullDownAnimationsOnLayer:floatWebLayer] forKey:pullDownAnimationKey];
        
        [UIView animateWithDuration:0.35 animations:^{
            self.backgroundColor = RGBACOLOR(255, 255, 255,0.7);
        } completion:^(BOOL finished){
            self.userInteractionEnabled = YES;
        } ];
    }
}

-(CAAnimationGroup *)pullDownAnimationsOnLayer:(CALayer *)layer{
    CAAnimationGroup *grop = [CAAnimationGroup animation];
    grop.duration = 0.5;
    grop.repeatCount = 0 ;
    //    grop.removedOnCompletion = NO;
    grop.delegate = self;
    
    //下拉第一阶段，大幅下拉,超过目标点20px
    CABasicAnimation *aStage1 = [CABasicAnimation animationWithKeyPath:@"position"];
    aStage1.fromValue = [NSValue valueWithCGPoint:layer.position];
    aStage1.toValue = [NSValue valueWithCGPoint:CGPointMake(layer.position.x, layer.bounds.size.height/2+10)];
    aStage1.duration = 0.29f;
    aStage1.beginTime = 0;
    aStage1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    //回弹25
    CABasicAnimation *aStage2 = [CABasicAnimation animationWithKeyPath:@"position"];
    aStage2.fromValue = [NSValue valueWithCGPoint:CGPointMake(layer.position.x, layer.bounds.size.height/2+10)];
    aStage2.toValue = [NSValue valueWithCGPoint:CGPointMake(layer.position.x, layer.bounds.size.height/2-5)];
    aStage2.duration = 0.14f;
    aStage2.beginTime = 0.29f;
    aStage2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    //下降10，目的地
    CABasicAnimation *aStage3 = [CABasicAnimation animationWithKeyPath:@"position"];
    aStage3.fromValue = [NSValue valueWithCGPoint:CGPointMake(layer.position.x, layer.bounds.size.height/2-5)];
    aStage3.toValue = [NSValue valueWithCGPoint:CGPointMake(layer.position.x, layer.bounds.size.height/2)];
    aStage3.duration = 0.07f;
    aStage3.beginTime = 0.43f;
    aStage3.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    
    grop.animations = [NSArray arrayWithObjects:aStage1,aStage2,aStage3, nil];
    return grop;
}

-(CAAnimationGroup *)pullUpAnimationsOnLayer:(CALayer *)layer{
    CAAnimationGroup *grop = [CAAnimationGroup animation];
    grop.duration = 0.4;
    grop.repeatCount = 0 ;
    //    grop.removedOnCompletion = NO;
    grop.delegate = self;
    
    //向上第一阶段，小幅下降,10px
    CABasicAnimation *aStage1 = [CABasicAnimation animationWithKeyPath:@"position"];
    aStage1.fromValue = [NSValue valueWithCGPoint:layer.position];
    aStage1.toValue = [NSValue valueWithCGPoint:CGPointMake(layer.position.x, layer.position.y+10)];
    aStage1.duration = 0.15f;
    aStage1.beginTime = 0;
    aStage1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    //回弹25
    CABasicAnimation *aStage2 = [CABasicAnimation animationWithKeyPath:@"position"];
    aStage2.fromValue = [NSValue valueWithCGPoint:CGPointMake(layer.position.x, layer.position.y+10)];
    aStage2.toValue = [NSValue valueWithCGPoint:CGPointMake(layer.position.x, -layer.position.y)];
    aStage2.duration = 0.25f;
    aStage2.beginTime = 0.15f;
    aStage2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    grop.animations = [NSArray arrayWithObjects:aStage1,aStage2, nil];
    return grop;
}

-(void)animationDidStart:(CAAnimation *)anim{
    CALayer *pullDownLayer = _empWebView.layer;
    //    NSString *key = @"isPullDown";
    //    BOOL isPullDown = [[pullDownLayer valueForKey:key]boolValue];
    //    
    //调整位置
    if (_isPullDown) {
        pullDownLayer.position = CGPointMake(pullDownLayer.position.x, pullDownLayer.bounds.size.height/2);
    }else {
        pullDownLayer.position = CGPointMake(pullDownLayer.position.x, -pullDownLayer.position.y);
    }
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    //    CALayer *pullDownLayer = self.layer;
    //    NSString *key = @"isPullDown";
    //    BOOL isPullDown = [[pullDownLayer valueForKey:key]boolValue];
    
    if (_isPullDown) {
        self.hidden = NO;
    }else {
        self.hidden = YES;
    }
}
@end
