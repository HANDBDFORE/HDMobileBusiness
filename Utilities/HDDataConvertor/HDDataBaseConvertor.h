//
//  HDDataParser.h
//  Three20Lab
//
//  Created by Rocky Lee on 5/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

@protocol HDDataConvertor <NSObject>

//开始过滤
-(id)doConvertor:(id)data error:(NSError **) error;

-(id)doNextConvertor:(id)data error:(NSError **) error;

//执行完下一个之后执行,可以对之后的执行结果进行进一步处理
-(id)afterDoNextConvertor:(id)data error:(NSError **)error;

//生成错误信息
-(id)errorWithData:(id) data error:(NSError **) error;

@end

//////////////////////////////////////////////////////////////////////////////////////////////////////
static NSString *kHDConvertErrorDomain = @"hand.convertor";
static const NSInteger kHDConvertErrorCode = 101;
static NSString *kHDConvertErrorDataKey = @"convertdata";

@protocol HDDataConvertor;

@interface HDDataBaseConvertor : NSObject <HDDataConvertor>

//下一个过滤器
@property (nonatomic,retain) id <HDDataConvertor> nextConvertor;

-(id)initWithNextConvertor:(id<HDDataConvertor>) next;

@end


