//
//  HDDidApprovedDetailViewController.m
//  hrms
//
//  Created by Rocky Lee on 7/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDDetailInfoViewController.h"

#import "HDUserInfoView.h"
@interface HDDetailInfoViewController()

@property(nonatomic,copy) NSString * currentURL;

@property(nonatomic,retain) UIBarButtonItem * popoverItem;

@end

@implementation HDDetailInfoViewController

//单据明细页面URL模板
@synthesize webPageURLTemplate = _webPageURLTemplate;

//model
@synthesize currentURL = _currentURL;

#pragma mark - life cycle
#pragma mark -
-(void)viewDidUnload{
    TT_RELEASE_SAFELY(_webPageURLTemplate);
    TT_RELEASE_SAFELY(_pageTurningService);
    TT_RELEASE_SAFELY(_currentURL);
    TT_RELEASE_SAFELY(_popoverItem);
    
    TT_RELEASE_SAFELY(_nextButtonItem);
    TT_RELEASE_SAFELY(_prevButtonItem);
    
    TT_RELEASE_SAFELY(_emptyView);
    [super viewDidUnload];
}

- (void)loadView{
    [super loadView];
    
    //next button
    _nextButtonItem = [[UIBarButtonItem alloc]initWithImage:TTIMAGE(@"bundle://Three20.bundle/images/forwardIcon.png") style:UIBarButtonItemStyleBordered target:self action:@selector(nextRecord)];
    
    //prev button
    _prevButtonItem = [[UIBarButtonItem alloc]initWithImage:TTIMAGE(@"bundle://Three20.bundle/images/backIcon.png") style:UIBarButtonItemStyleBordered target:self action:@selector(prevRecord)];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (nil == [self.pageTurningService current]) {
        [self turnToEffectiveRecord];
    }else{
        [self loadCurrentRecord];
    }
}

#pragma mark -
#pragma mark page turnning
-(void)nextRecord{
    [self loadRecord:[self.pageTurningService next]];
}

-(void)prevRecord{
    [self loadRecord:[self.pageTurningService prev]];
}

-(void)loadCurrentRecord
{
    [self loadRecord:[self.pageTurningService current]];
}

-(void)turnToEffectiveRecord
{
    if ([self.pageTurningService hasNext]) {
        [self nextRecord];
    }else{
        [self prevRecord];
    }
}

-(void)loadRecord:(NSDictionary *)record{
    if (nil == record) {
        [self showEmpty:YES];
    }else{
        [self showEmpty:NO];
        self.title = nil;
        
        NSMutableDictionary * recordDictionary = [NSMutableDictionary dictionaryWithDictionary:record];
        [recordDictionary setValue:[HDHTTPRequestCenter baseURLPath] forKey:@"base_url"];
        [recordDictionary setValue:[[NSUserDefaults standardUserDefaults]stringForKey:@"Token"] forKey:@"token"];
        
        self.currentURL = [self.webPageURLTemplate stringByReplacingSpaceHodlerWithDictionary:recordDictionary];
        [self openURL:[NSURL URLWithString:self.currentURL]];
        [self updateNavigationItems];
    }
}

-(void)showError:(BOOL)show
{
    [self updateNavigationItems];
    [_webView loadHTMLString:@"<h1>Error</h1>" baseURL:nil];
}

-(void)showEmpty:(BOOL)show
{
    [self updateNavigationItems];
    self.currentURL = nil;
    if (show) {
        self.title = @"No Record";
        UIImage* image = TTIMAGE(@"bundle://Three20.bundle/images/empty.png");
        if (image) {
            TTErrorView* emptyView = [[[TTErrorView alloc] initWithTitle:self.title
                                                                subtitle:nil
                                                                   image:image] autorelease];
            emptyView.backgroundColor = TTSTYLEVAR(tablePlainBackgroundColor);
            self.emptyView = emptyView;
        } else {
            self.emptyView = nil;
        }
    } else {
        self.emptyView = nil;
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setEmptyView:(UIView*)view {
    if (view != _emptyView) {
        if (_emptyView) {
            [_emptyView removeFromSuperview];
            TT_RELEASE_SAFELY(_emptyView);
        }
        _emptyView = [view retain];
        if (_emptyView) {
            _emptyView.frame = self.view.frame;
            _emptyView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
            [self.view addSubview:_emptyView];
        }
    }
}

-(void)updateNavigationItems
{
    _nextButtonItem.enabled = [self.pageTurningService hasNext];
    _prevButtonItem.enabled = [self.pageTurningService hasPrev];
    
    self.navigationItem.leftBarButtonItems = [self createLeftNavigationItems];
    self.navigationItem.rightBarButtonItems = [self createRightNavigationItems];
}

-(NSMutableArray *)createLeftNavigationItems
{
    NSMutableArray * items = [NSMutableArray array];
    if (self.popoverItem) {
        [items addObject:self.popoverItem];
    }
    
    if ([self.pageTurningService currentIndexPath] && self.popoverItem) {
        [items addObjectsFromArray:@[_prevButtonItem,_nextButtonItem]];
    }
    return items;
}

-(NSMutableArray *)createRightNavigationItems
{
    NSMutableArray * items = [NSMutableArray array];
    if (!TTIsPad()) {
        [items addObjectsFromArray: @[_nextButtonItem,_prevButtonItem]];
    }
    
    if (_refreshButtonItem) {
        [items addObject:_refreshButtonItem];
    }
    return items;
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return TTIsSupportedOrientation(toInterfaceOrientation);
}

@end
