//
//  HDDeleverCommentViewController.h
//  HDMobileBusiness
//
//  Created by jiangtiteng on 14-9-29.
//  Copyright (c) 2014年 hand. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HDDetailToolbarViewController.h"

@interface HDAssignCommentViewController : UIViewController <UITextViewDelegate>

@property (retain, nonatomic) IBOutlet UIView *coverView;
@property (retain, nonatomic) IBOutlet UILabel *delivereeLbl;

@property (retain, nonatomic) IBOutlet UITextView *commentTv;

@property (retain, nonatomic) IBOutlet UILabel *viewholderLbl;

@property (retain,nonatomic)HDDetailToolbarViewController * delegate;

@property(retain,nonatomic) NSString * deliverId;
@property(retain,nonatomic) NSString * localId;


-(void)deliver:(NSString *)deliverid
          name:(NSString *)delivername;

@end
