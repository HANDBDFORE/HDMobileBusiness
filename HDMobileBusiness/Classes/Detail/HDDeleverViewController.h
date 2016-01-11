//
//  HDDeleverViewController.h
//  HDMobileBusiness
//
//  Created by jiangtiteng on 14-9-29.
//  Copyright (c) 2014年 hand. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HDDeleverCommentViewController.h"

@interface HDDeleverViewController : TTModelViewController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>

@property (retain, nonatomic) IBOutlet UITextField *keywordTf;

@property (retain, nonatomic) IBOutlet UIButton *queryBtn;

@property (retain, nonatomic) IBOutlet UILabel *hintLbl;

@property (retain, nonatomic) IBOutlet UITableView *delivereeTableView;


@property (retain,nonatomic) HDDeleverCommentViewController * superView;
@end
