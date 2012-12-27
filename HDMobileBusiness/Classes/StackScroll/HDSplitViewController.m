//
//  HDSplitViewController.m
//  StackScrollView
//
//  Created by Plato on 11/7/12.
//
//

#import "HDSplitViewController.h"
#import "UIViewWithShadow.h"

@implementation HDSplitViewController
@synthesize leftViewController = _leftViewController;
@synthesize rightViewController = _rightViewController;
@synthesize leftViewPercentWidth = _leftViewPercentWidth,leftViewWidth = _leftViewWidth;

-(void)viewDidUnload
{
    [super viewDidUnload];
    TT_RELEASE_SAFELY(_rightShadowView);
    TT_RELEASE_SAFELY(_leftViewController);
    TT_RELEASE_SAFELY(_rightViewController);
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _leftViewPercentWidth = 0.5;
        _leftViewWidth = 320;
        
        
    }
    return self;
}

-(void)setLeftViewController:(UIViewController *)leftViewController
{
    if (_leftViewController != leftViewController) {
        [_leftView removeFromSuperview];
        [_leftViewController release];
        
        _leftViewController = [leftViewController retain];
        _leftView = _leftViewController.view;
        [self resizeSubViews:YES];
        [self.view insertSubview:_leftView atIndex:0];
    }
}

-(void)setRightViewController:(UIViewController *)rightViewController
{
    if (_rightViewController != rightViewController) {
        [_rightShadowView removeFromSuperview];
        [_rightView removeFromSuperview];
        [_rightViewController release];
        
        _rightViewController = [rightViewController retain];
        _rightView = _rightViewController.view;
        _rightView.tag = 201;
        
        [_rightShadowView setFrame:CGRectMake(-40, 0, 40 , _rightView.height)];
        [_rightView addSubview:_rightShadowView];
        [self resizeSubViews:NO];
        
        [self.view insertSubview:_rightView atIndex:1];
    }
    UISwipeGestureRecognizer* recognizer;
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [_rightView addGestureRecognizer:recognizer];
    [recognizer release];
    recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [_rightView addGestureRecognizer:recognizer];
    [recognizer release];
}

- (void)handleSwipeFrom:(UISwipeGestureRecognizer*)recognizer {
    // 触发手勢事件后，在这里作些事情
    if (CGRectGetWidth(self.view.bounds)!=1024) {
        if(recognizer.direction == UISwipeGestureRecognizerDirectionRight){
            [UIView beginAnimations:@"moveright" context:nil];
            //动画持续时间
            [UIView setAnimationDuration:0.2];
            //设置动画的回调函数，设置后可以使用回调方法
            [UIView setAnimationDelegate:self];
            //设置动画曲线，控制动画速度
            [UIView  setAnimationCurve:UIViewAnimationCurveEaseOut];
            //设置动画方式，并指出动画发生的位置
            [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:_rightView  cache:YES];
            _rightView.frame = CGRectMake(_leftViewWidth, 0,_rightView.frame.size.width,_rightView.frame.size.height);
            //提交UIView动画
            [UIView commitAnimations];
            
        }else if (recognizer.direction == UISwipeGestureRecognizerDirectionLeft){
            [UIView beginAnimations:@"moveleft" context:nil];
            //动画持续时间
            [UIView setAnimationDuration:0.2];
            //设置动画的回调函数，设置后可以使用回调方法
            [UIView setAnimationDelegate:self];
            //设置动画曲线，控制动画速度
            [UIView  setAnimationCurve:UIViewAnimationCurveEaseOut];
            //设置动画方式，并指出动画发生的位置
            [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:_rightView  cache:YES];
            CGFloat rightViewWidth = 1024-_leftViewWidth;
            _rightView.frame = CGRectMake(CGRectGetWidth(self.view.bounds)-rightViewWidth, 0,_rightView.frame.size.width,_rightView.frame.size.height);
            //提交UIView动画
            [UIView commitAnimations];
        };
    }
}
#pragma -mark life cycle
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _rightShadowView = [[UIViewWithShadow alloc] init];
    [_rightShadowView setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
    [_rightShadowView setClipsToBounds:NO];
    [_rightShadowView setTag:2011];
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage: [UIImage imageNamed:@"backgroundImage_repeat.png"]]];  
    
    [_leftViewController viewWillAppear:NO];
	[_leftViewController viewDidAppear:NO];
    _leftViewController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    
    [_rightViewController viewWillAppear:NO];
	[_rightViewController viewDidAppear:NO];
}

-(void)resizeSubViews:(BOOL)animated
{
    CGFloat rightViewWidth = 1024-_leftViewWidth;
    _leftView.frame = CGRectMake(0, 0, _leftViewWidth, CGRectGetHeight(self.view.bounds));
    _leftView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    if (animated) {
        [UIView beginAnimations:@"move" context:nil];
        //动画持续时间
        [UIView setAnimationDuration:0.3];
        //设置动画的回调函数，设置后可以使用回调方法
        [UIView setAnimationDelegate:self];
        //设置动画曲线，控制动画速度
        [UIView  setAnimationCurve:UIViewAnimationCurveEaseOut];
        //设置动画方式，并指出动画发生的位置
        [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:_rightView  cache:YES];
        _rightView.frame = CGRectMake(CGRectGetWidth(self.view.bounds)-rightViewWidth, 0,rightViewWidth, CGRectGetHeight(self.view.bounds));
        _rightView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        //提交UIView动画
        [UIView commitAnimations];
    }else{
        _rightView.frame = CGRectMake(CGRectGetWidth(self.view.bounds)-rightViewWidth, 0,rightViewWidth, CGRectGetHeight(self.view.bounds));
        _rightView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    }
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	[_leftViewController didRotateFromInterfaceOrientation:fromInterfaceOrientation];
	[_rightViewController didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    [self resizeSubViews:YES];
}

-(void) willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
	[_leftViewController willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
	[_rightViewController willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
