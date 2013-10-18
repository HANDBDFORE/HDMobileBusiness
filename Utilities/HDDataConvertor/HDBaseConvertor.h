//
//  HDDataBaseConvertor.h
//  HDMobileBusiness
//
//  Created by Rocky Lee on 5/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

@protocol HDDataConvertor <NSObject>

//开始转换
-(id)doConvertor:(id)data error:(NSError **) error;

//下一个转换器
@property (nonatomic,retain) id <HDDataConvertor> nextConvertor;

@end

//////////////////////////////////////////////////////////////////////////////////////////////////////
static NSString * kHDConvertErrorDomain = @"hand.convertor";
static const NSInteger kHDConvertErrorCode = -101;
static NSString * kHDConvertErrorDataKey = @"dataConvert";

static NSString * kHDDefaultErrorMessage = @"数据校验失败";

@protocol HDDataConvertor;

@interface HDBaseConvertor : NSObject <HDDataConvertor>

-(id)initWithNextConvertor:(id<HDDataConvertor>) next;

/*
 *对转入的数据进行校验,默认返回 YES ,返回 NO 则跳出转换,生成错误信息
 */
-(BOOL)validateData:(id) data;

/*
 *执行转换,返回转换后的结果,默认返回data
 */
-(id)convert:(id)data error:(NSError **) error;

/*
 *执行下一个转换,如果没有下一个转换器则返回data,暂时不开放
 */
//-(id)doNextConvertor:(id)data error:(NSError **) error;

/*
 *生成错误信息,返回一个nil值,默认生成 kHDDefaultErrorMessage 错误消息
 */
-(NSError *)errorWithData:(id) data;

@end


