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
#import "HDAutologinModel.h"

@interface HDLoadingViewController : TTModelViewController{
    UILabel *_errorSummury;
    UILabel *_errorDetail;
    UIButton *_retryButton;
    UIImageView *_alertView;
    UIView *_customBackground;
}
@property(nonatomic,retain) id<HDAutologinModel> autologinModel;
@end
