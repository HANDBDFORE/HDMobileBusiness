//
//  HDURLRequestModel.h
//  Three20Lab-2
//
//  Created by Rocky Lee on 5/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDRequestMap.h"

@interface HDURLRequestModel : TTURLRequestModel

//传入请求map开始发送请求
-(void)requestWithMap:(HDRequestMap *) map;

//子类实现该方法获取转换后的数据
-(void)requestResultMap:(HDRequestResultMap *)map;

@end
