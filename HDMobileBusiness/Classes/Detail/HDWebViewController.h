//
//  HDWebViewController.h
//  HDMobileBusiness
//
//  Created by Plato on 10/9/12.
//  Copyright (c) 2012 hand. All rights reserved.
//

#import <Three20UI/Three20UI.h>

@interface HDWebViewController : TTModelViewController <UIWebViewDelegate> {
@protected
    UIWebView*        _webView;
    UIView*           _headerView;
    NSURL*            _loadingURL;
    TTActivityLabel*  _activityLabel;
    UIBarButtonItem* _activityItem;
    UIBarButtonItem * _refreshButtonItem;

}

/**
 * The current web view URL. If the web view is currently loading a URL, then the loading URL is
 * returned instead.
 */
@property (nonatomic, readonly) NSURL*  URL;

/**
 * A view that is inserted at the top of the web view, within the scroller.
 */
@property (nonatomic, retain)   UIView* headerView;

/**
 * Navigate to the given URL.
 */
- (void)openURL:(NSURL*)URL;

/**
 * Load the given request using UIWebView's loadRequest:.
 *
 * @param request  A URL request identifying the location of the content to load.
 */
- (void)openRequest:(NSURLRequest*)request;


@end
