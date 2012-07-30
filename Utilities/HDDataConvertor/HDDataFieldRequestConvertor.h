//
//  HDDataFieldMapConvertor.h
//  Three20Lab-2
//
//  Created by Rocky Lee on 5/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDDataBaseConvertor.h"

//请求数据转换为服务器识别的filed
@interface HDDataFieldRequestConvertor : HDDataBaseConvertor

@property(nonatomic,retain)NSDictionary * filedDictionary;

@end
