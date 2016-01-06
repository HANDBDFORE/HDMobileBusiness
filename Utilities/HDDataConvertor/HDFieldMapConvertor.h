//
//  HDDataFieldMapConvertor.h
//  HDMobileBusiness
//
//  Created by Rocky Lee on 5/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDBaseConvertor.h"

static NSString * kMapFrom = @"from";
static NSString * kMapTo = @"to";

//请求数据转换为服务器识别的field
@interface HDFieldMapConvertor : HDBaseConvertor

@property(nonatomic,retain) id fieldMapData;

@end
