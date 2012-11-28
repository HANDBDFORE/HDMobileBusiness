//
//  MyStyleSheet.h
//  HRMS
//
//  Created by Rocky Lee on 3/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HDDefaultStyleSheet : TTDefaultStyleSheet

//StatusTableCell状态为error时状态条的样式
-(TTStyle *)tableStatusLabelError;

//StatusTableCell状态为different时状态条的样式
-(TTStyle *)tableStatusLabelDifferent;

//confirm单元格按钮样式
- (TTStyle*)confirmCellButton:(UIControlState)state;

-(UIColor *)splitBorderColor;
@end
