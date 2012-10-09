//
//  HDWebViewController.m
//  HDMobileBusiness
//
//  Created by Plato on 10/9/12.
//  Copyright (c) 2012 hand. All rights reserved.
//

#import "HDWebViewController.h"

@implementation HDWebViewController
@synthesize headerView  = _headerView;

- (void)dealloc {
    TT_RELEASE_SAFELY(_loadingURL);
    TT_RELEASE_SAFELY(_headerView);    
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (id)initWithNavigatorURL:(NSURL*)URL query:(NSDictionary*)query {
	self = [self initWithNibName:nil bundle:nil];
    if (self) {
        NSURLRequest* request = [query objectForKey:@"request"];
        if (nil != request) {
            [self openRequest:request];
            
        } else {
            [self openURL:URL];
        }
    }
    return self;
}

- (void)loadView {
    [super loadView];
    
    _webView = [[UIWebView alloc] initWithFrame:TTNavigationFrame()];
    _webView.delegate = self;
    _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth
    | UIViewAutoresizingFlexibleHeight;
    _webView.scalesPageToFit = YES;
    [self.view addSubview:_webView];
    
    UIActivityIndicatorView* spinner =
    [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:
      UIActivityIndicatorViewStyleWhite] autorelease];
    [spinner startAnimating];
    _activityItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
    
}


- (void)viewDidUnload {
    [super viewDidUnload];
    _webView.delegate = nil;
    
    TT_RELEASE_SAFELY(_webView);
    TT_RELEASE_SAFELY(_activityItem);
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)persistView:(NSMutableDictionary*)state {
    NSString* URL = self.URL.absoluteString;
    if (URL.length && ![URL isEqualToString:@"about:blank"]) {
        [state setObject:URL forKey:@"URL"];
        return YES;
        
    } else {
        return NO;
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)restoreView:(NSDictionary*)state {
    NSString* URL = [state objectForKey:@"URL"];
    if (URL.length && ![URL isEqualToString:@"about:blank"]) {
        [self openURL:[NSURL URLWithString:URL]];
    }
}

#pragma mark -
#pragma mark UIWebViewDelegate


///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request
 navigationType:(UIWebViewNavigationType)navigationType {
    
    if ([[TTNavigator navigator].URLMap isAppURL:request.URL]) {
        [_loadingURL release];
        _loadingURL = [[NSURL URLWithString:@"about:blank"] retain];
        [[UIApplication sharedApplication] openURL:request.URL];
        return NO;
    }
    
    [_loadingURL release];
    _loadingURL = [request.URL retain];
    return YES;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)webViewDidStartLoad:(UIWebView*)webView {
    
    self.title = TTLocalizedString(@"Loading...", @"");
    if (!self.navigationItem.rightBarButtonItem) {
        [self.navigationItem setRightBarButtonItem:_activityItem animated:YES];
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)webViewDidFinishLoad:(UIWebView*)webView {

    TT_RELEASE_SAFELY(_loadingURL);
    self.title = [_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    if (self.navigationItem.rightBarButtonItem == _activityItem) {
        [self.navigationItem setRightBarButtonItem:nil animated:YES];
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)webView:(UIWebView*)webView didFailLoadWithError:(NSError*)error {
    
    TT_RELEASE_SAFELY(_loadingURL);
    [self webViewDidFinishLoad:webView];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSURL*)URL {
    return _loadingURL ? _loadingURL : _webView.request.URL;
}
///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setHeaderView:(UIView*)headerView {
    if (headerView != _headerView) {
        BOOL addingHeader = !_headerView && headerView;
        BOOL removingHeader = _headerView && !headerView;
        
        [_headerView removeFromSuperview];
        [_headerView release];
        _headerView = [headerView retain];
        _headerView.frame = CGRectMake(0, 0, _webView.width, _headerView.height);
        
        [self view];
        UIView* scroller = [_webView descendantOrSelfWithClass:NSClassFromString(@"UIScroller")];
        UIView* docView = [scroller descendantOrSelfWithClass:NSClassFromString(@"UIWebDocumentView")];
        [scroller addSubview:_headerView];
        
        if (addingHeader) {
            docView.top += headerView.height;
            docView.height -= headerView.height;
            
        } else if (removingHeader) {
            docView.top -= headerView.height;
            docView.height += headerView.height;
        }
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)openURL:(NSURL*)URL {
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:URL];
    [self openRequest:request];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)openRequest:(NSURLRequest*)request {
    [self view];
    [_webView loadRequest:request];
}


@end
