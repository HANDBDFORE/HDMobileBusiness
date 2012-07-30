//
//  UserHelpPageController.m
//  hrms
//
//  Created by mas apple on 6/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDUserGuideViewController.h"

@interface HDUserGuideViewController ()

@end

@implementation HDUserGuideViewController

- (void)dealloc {
    _scrollView.delegate = nil;
    _scrollView.dataSource = nil;
    TT_RELEASE_SAFELY(_scrollView);
    TT_RELEASE_SAFELY(_pageControl);
    TT_RELEASE_SAFELY(_pages);
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[UIApplication sharedApplication] setStatusBarHidden:YES];

        NSArray *images = [[NSArray alloc]initWithObjects:[UIImage imageNamed:@"page1.jpg"],[UIImage imageNamed:@"page2.jpg"],[UIImage imageNamed:@"page3.jpg"],[UIImage imageNamed:@"page4.jpg"], nil];
        
        NSMutableArray *pageViews = [NSMutableArray arrayWithCapacity:[images count]];
        
        //前几步
        for (int i=0; i<images.count; i++) {
            UIImageView *imgView = [[UIImageView alloc]initWithImage:[images objectAtIndex:i]];
            [pageViews addObject:imgView];
            
            [imgView release];
        }
        
        //最后一步
//        UIView *view = [[UIView alloc]init];
//        UIButton *finishButton = [[UIButton buttonWithType:UIButtonTypeRoundedRect]retain];
//        [finishButton setTitle:@"开始吧" forState:UIControlStateNormal];
//        [finishButton setFrame:CGRectMake(100, 100, 100, 100)];
//        finishButton.opaque = false;
//        [finishButton addTarget:self action:@selector(finish) forControlEvents:UIControlEventTouchUpInside];
//        
//        [view addSubview:finishButton];
//        [view bringSubviewToFront:finishButton];
//        
//        view.backgroundColor = [UIColor redColor];
        
        UIImageView *lastView = [[UIImageView alloc]init];
        [lastView setImage:[UIImage imageNamed:@"page5.jpg"]];
        
        UIButton *finishButton = [[UIButton buttonWithType:UIButtonTypeCustom]retain];
        [finishButton setTitle:@"" forState:UIControlStateNormal];
        [finishButton setFrame:CGRectMake(53, 288, 214, 60)];
        [finishButton addTarget:self action:@selector(finish) forControlEvents:UIControlEventTouchUpInside];
        [lastView addSubview:finishButton];
        
        [pageViews addObject:lastView];
        [finishButton release];
        [lastView release];
        [images release];
        
        _pages = [pageViews retain];
        
    }
    return self;
}

-(void)loadView{
    
    CGRect appFrame = [UIScreen mainScreen].bounds;
    CGRect frame = CGRectMake(0, 0, appFrame.size.width, appFrame.size.height);
    self.view = [[[UIView alloc] initWithFrame:frame] autorelease];
    
    _scrollView = [[TTScrollView alloc] initWithFrame:CGRectMake(0,0, self.view.bounds.size.width, self.view.bounds.size.height)];
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _scrollView.dataSource = self;
    _scrollView.delegate = self;
    _scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_scrollView];
    
    _pageControl = [[TTPageControl alloc] initWithFrame:CGRectMake(0,(self.view.size.height-40), self.view.width, 20)];
    _pageControl.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _pageControl.backgroundColor = [UIColor clearColor];
    _pageControl.currentPage = 0;
    _pageControl.numberOfPages = [_pages count];
    [_pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_pageControl];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

///////////////////////////////////////////////////////////////////////////////////////////////////
// TTScrollViewDataSource

- (NSInteger)numberOfPagesInScrollView:(TTScrollView*)scrollView {
    return _pages.count;
}

- (UIView*)scrollView:(TTScrollView*)scrollView pageAtIndex:(NSInteger)pageIndex {
    UIView *pageView = [_pages objectAtIndex:pageIndex];

    return pageView;
}

- (CGSize)scrollView:(TTScrollView*)scrollView sizeOfPageAtIndex:(NSInteger)pageIndex {
    return (TTScreenBounds()).size;
}

#pragma mark -
#pragma mark TTScrollViewDelegate

- (void)scrollView:(TTScrollView*)scrollView didMoveToPageAtIndex:(NSInteger)pageIndex {
    _pageControl.currentPage = pageIndex;
}

- (IBAction)changePage:(id)sender {
    int page = _pageControl.currentPage;
    [_scrollView setCenterPageIndex:page];
}

-(void)finish{
    [[TTNavigator navigator]openURLAction:[TTURLAction actionWithURLPath:@"init://LoadingViewController"]];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

-(BOOL)scrollViewShouldZoom:(TTScrollView *)scrollView{
    return false;
}
@end
