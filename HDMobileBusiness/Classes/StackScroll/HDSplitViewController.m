//
//  HDSplitViewController.m
//  StackScrollView
//
//  Created by Plato on 11/7/12.
//
//

#import "HDSplitViewController.h"
#import "StackScrollViewController.h"
#import "HDFunctionListViewController.h"

@interface UIViewExt : UIView {}
@end


@implementation UIViewExt
- (UIView *) hitTest: (CGPoint) pt withEvent: (UIEvent *) event
{
	
	UIView* viewToReturn=nil;
	CGPoint pointToReturn;
	
	UIView* rightView = (UIView*)[[self subviews] objectAtIndex:1];
	
//	if ([[rightView subviews] objectAtIndex:0]) {
		
//		UIView* uiStackScrollView = [[rightView subviews] objectAtIndex:0];
		
		if ([[rightView subviews] objectAtIndex:1]) {
			
			UIView* uiSlideView = [[rightView subviews] objectAtIndex:1];
			
			for (UIView* subView in [uiSlideView subviews]) {
				CGPoint point  = [subView convertPoint:pt fromView:self];
				if ([subView pointInside:point withEvent:event]) {
					viewToReturn = subView;
					pointToReturn = point;
				}
				
			}
		}
		
//	}
	
	if(viewToReturn != nil) {
		return [viewToReturn hitTest:pointToReturn withEvent:event];
	}
	
	return [super hitTest:pt withEvent:event];
	
}

@end

@interface HDSplitViewController ()

@end

@implementation HDSplitViewController
@synthesize leftViewController = _leftViewController;
@synthesize rightViewController = _rightViewController;
@synthesize leftViewPercentWidth = _leftViewPercentWidth,leftViewWidth = _leftViewWidth;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _leftViewPercentWidth = 0.5;
        _leftViewWidth = 320;
        
//        self.leftViewController =
        //        [[HDGuider guider]controllerWithKeyPath:kFunctionControllerPath query:nil];
//        [[HDGuider guider]controllerWithKeyPath:kFunctionControllerPath className:[HDFunctionListViewController class] nibName:nil];
        
//        self.rightViewController =
//        [[[UIViewController alloc]init]autorelease];
//        [self.rightViewController.view setBackgroundColor:[UIColor colorWithRed:0.5 green:0.5 blue:0 alpha:0.5]];
//        [[[StackScrollViewController alloc]init]autorelease];
    }
    return self;
}

-(void)setLeftViewController:(UIViewController *)leftViewController
{
    if (_leftViewController != leftViewController) {
        [_leftViewController release];
        [_leftView removeFromSuperview];
    }
    _leftViewController = [leftViewController retain];
    _leftView = _leftViewController.view;
}

-(void)setRightViewController:(UIViewController *)rightViewController
{
    if (_rightViewController != rightViewController) {
        [_rightViewController release];
        [_rightView removeFromSuperview];
    }
    _rightViewController = [rightViewController retain];
    _rightView = _rightViewController.view;
    _rightView.tag = 201;
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
    
    self.view = [[[UIViewExt alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)] autorelease];
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage: [UIImage imageNamed:@"backgroundImage_repeat.png"]]];
    
    [_leftViewController viewWillAppear:NO];
	[_leftViewController viewDidAppear:NO];
    _leftViewController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    
    [_rightViewController viewWillAppear:NO];
	[_rightViewController viewDidAppear:NO];

    [self resizeSubViews];
    [self.view insertSubview:_leftView atIndex:0];
    [self.view insertSubview:_rightView atIndex:1];

	// Do any additional setup after loading the view.
}

-(void)resizeSubViews
{
    CGFloat leftViewWidth = 0;
    
    if (_leftViewWidth) {
        leftViewWidth = _leftViewWidth;
    }else{
        leftViewWidth = self.view.frame.size.width * _leftViewPercentWidth;
    }
    _leftView.frame = CGRectMake(0, 0, leftViewWidth, CGRectGetHeight(self.view.frame));
    _rightView.frame = CGRectMake(leftViewWidth, 0, CGRectGetWidth(self.view.frame)-leftViewWidth, CGRectGetHeight(self.view.frame));
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
