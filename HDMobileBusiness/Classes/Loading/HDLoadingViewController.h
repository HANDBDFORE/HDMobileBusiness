//
//  HDViewController.h
//  ERROR
//
//  Created by mas apple on 7/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HDApplicationContext.h"
#import "HDHTTPRequestCenter.h"
#import "HDViewGuider.h"
@interface HDLoadingViewController : UIViewController{
    UILabel *_errorSummury;
    UILabel *_errorDetail;
    UIButton *_retryButton;
    UIImageView *_alertView;
    UIView *_customBackground;
}

@end
