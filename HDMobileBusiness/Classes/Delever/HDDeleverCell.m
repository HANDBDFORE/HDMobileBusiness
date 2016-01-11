//
//  HDDeleverCell.m
//  HDMobileBusiness
//
//  Created by jiangtiteng on 14-9-29.
//  Copyright (c) 2014年 hand. All rights reserved.
//

#import "HDDeleverCell.h"

@implementation HDDeleverCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        NSArray * nibArray = [[NSBundle mainBundle] loadNibNamed:@"HDDeleverCell" owner:self options:nil ];
        self = [nibArray objectAtIndex:0];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}


-(void)setCell:(NSDictionary *)record
{
    
    if(record == nil){
        return;
    }
    
    self.userNameLbl.text  = [record valueForKey:@"name"];
    self.userNumerLbl.text = [record valueForKey:@"employee_code"];
    self.userJobLbl.text = [record valueForKey:@"job"];
    self.userPhoneLbl.text = [record valueForKey:@"mobile"];
    NSNumber * recordId = [record valueForKey:@"employee_id"];
    
    self.delivereeid = [recordId stringValue];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(callphone)];
    self.userPhoneLbl.userInteractionEnabled  = YES;
    [self.userPhoneLbl addGestureRecognizer:tap];
    
    
    
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    


    // Configure the view for the selected state
}

///////////////// tap listener//////////
-(void)callphone
{
       NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt:%@",self.userPhoneLbl.text];

    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    
}


- (void)dealloc {
    [_userNameLbl release];
    [_userNumerLbl release];
    [_userJobLbl release];
    [_userPhoneLbl release];
    [super dealloc];
}
@end
