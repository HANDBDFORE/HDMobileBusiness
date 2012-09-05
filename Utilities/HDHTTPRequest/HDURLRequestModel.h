//
//  HDURLRequestModel.h
//  Three20Lab-2
//
//  Created by Rocky Lee on 5/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDRequestMap.h"
#import "HDResponseMap.h"

@interface HDURLRequestModel : TTURLRequestModel

//传入请求map开始发送请求,如果url,数据转换,发生错误 showError
-(void)requestWithMap:(HDRequestMap *) map;

//子类实现该方法获取转换后的数据
-(void)requestResultMap:(HDResponseMap *)map;

//返回结果为空，默认调用didFinishLoad
-(void)emptyResponse:(TTURLRequest *)request;

@end
