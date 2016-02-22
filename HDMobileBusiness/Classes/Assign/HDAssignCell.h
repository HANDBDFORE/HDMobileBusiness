//
//  HDDeleverCell.h
//  HDMobileBusiness
//
//  Created by jiangtiteng on 14-9-29.
//  Copyright (c) 2014年 hand. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HDAssignCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UILabel *userNameLbl;

@property (retain, nonatomic) IBOutlet UILabel *userNumerLbl;


@property (retain, nonatomic) IBOutlet UILabel *userJobLbl;


@property (retain, nonatomic) IBOutlet UILabel *userPhoneLbl;

@property (retain,nonatomic) NSString * delivereeid;


-(void)setCell:(NSDictionary *)record;

@end
