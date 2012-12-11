//
//  HDTimeStampLabel.m
//  HDMobileBusiness
//
//  Created by Plato on 12/11/12.
//  Copyright (c) 2012 hand. All rights reserved.
//

#import "HDTimeStampLabel.h"

@implementation HDTimeStampLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.text  = @"...";
        TTDPRINT(@"frame");
        self.style = TTSTYLE(timeStampLabel);
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.text = @"...";
        TTDPRINT(@"init");
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void)setTimeStamp:(NSDate *)timeStamp
{    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    self.text = [NSString stringWithFormat:
                            TTLocalizedString(@"Last updated: %@",
                                              @"The last time the table view was updated."),
                            [formatter stringFromDate:timeStamp]];
    [formatter release];

}

@end
