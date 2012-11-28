//
//  HDSplitViewController.m
//  StackScrollView
//
//  Created by Plato on 11/7/12.
//
//

#import "HDSplitViewController.h"

@implementation HDSplitViewController
@synthesize leftViewController = _leftViewController;
@synthesize rightViewController = _rightViewController;
@synthesize leftViewPercentWidth = _leftViewPercentWidth,leftViewWidth = _leftViewWidth;

-(void)viewDidUnload
{
    [super viewDidUnload];
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
        [self resizeSubViews];
        [self.view insertSubview:_leftView atIndex:0];
    }
}

-(void)setRightViewController:(UIViewController *)rightViewController
{
    if (_rightViewController != rightViewController) {
        [_rightView removeFromSuperview];
        [_rightViewController release];
        
        _rightViewController = [rightViewController retain];
        _rightView = _rightViewController.view;
        _rightView.tag = 201;
        [self resizeSubViews];
        [self.view insertSubview:_rightView atIndex:1];
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
    
    self.view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)] autorelease];
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage: [UIImage imageNamed:@"backgroundImage_repeat.png"]]];
    
    [_leftViewController viewWillAppear:NO];
	[_leftViewController viewDidAppear:NO];
    _leftViewController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    
    [_rightViewController viewWillAppear:NO];
	[_rightViewController viewDidAppear:NO];
}

-(void)resizeSubViews
{
    CGFloat leftViewWidth = 0;
    
    if (_leftViewWidth) {
        leftViewWidth = _leftViewWidth;
    }else{
        leftViewWidth = self.view.frame.size.width * _leftViewPercentWidth;
    }
    UIColor * borderColor = TTSTYLEVAR(splitBorderColor);
        
    _leftView.frame = CGRectMake(0, 0, leftViewWidth, CGRectGetHeight(self.view.bounds));
    _leftView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [_leftView.layer setBorderWidth:1.5f];
    [_leftView.layer setCornerRadius:5];
    [_leftView.layer setBorderColor:borderColor.CGColor];
    
    
    _rightView.frame = CGRectMake(leftViewWidth, 0, CGRectGetWidth(self.view.bounds)-leftViewWidth, CGRectGetHeight(self.view.bounds));
    _rightView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [_rightView.layer setCornerRadius:5];
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	[_leftViewController didRotateFromInterfaceOrientation:fromInterfaceOrientation];
	[_rightViewController didRotateFromInterfaceOrientation:fromInterfaceOrientation];
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
