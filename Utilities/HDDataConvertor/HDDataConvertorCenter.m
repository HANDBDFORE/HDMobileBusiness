//
//  HDDataConvertorCenter.m
//  Three20Lab-2
//
//  Created by Rocky Lee on 5/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDDataConvertorCenter.h"

static NSString *kDefaultRequest = @"defaultRequest";
static NSString *kDefaultResponse = @"defaultResponse";
//json
static NSString *kJSONToDataConvertor = @"HDJSONToDataConvertor";
static NSString *kDataToJSONConvertor = @"HDDataToJSONConvertor";

//aurora
static NSString *kDataAuroraRequestConvertor = @"HDAuroraRequestConvertor";
static NSString *kDataAuroraResponseConvertor = @"HDAuroraResponseConvertor";

//field mapping
static NSString *kDataFieldRequestConvertor = @"HDFieldMapConvertor";

static HDDataConvertorCenter * _convertorCenter = nil;

@implementation HDDataConvertorCenter

+(id)shareFilterCenter
{
    @synchronized(self){
        if (_convertorCenter == nil) {
            _convertorCenter = [[self alloc] init];
        }
    }
    return  _convertorCenter;
}

+(id) allocWithZone:(NSZone *)zone{
    @synchronized(self){
        if (_convertorCenter == nil) {
            _convertorCenter = [super allocWithZone:zone];
            return  _convertorCenter;
        }
    }
    return nil;
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain
{
    return self;
}

-(id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

-(unsigned)retainCount
{
    return UINT_MAX;  //denotes an object that cannot be released
}

- (id)autorelease
{
    return self;
}

+(id<HDDataConvertor>)convertorChainWithURLName:(NSString *) urlName
                                           type:(HDDataConvertorType) type
{
    return [[HDDataConvertorCenter shareFilterCenter]convertorChainWithURLName:urlName type:type];    
}

-(id<HDDataConvertor>)convertorChainWithURLName:(NSString *) urlName
                                           type:(HDDataConvertorType) type
{
    //    NSString * dataFilterName = [[HDGodXMLFactory shareBeanFactory]dataConvertorNameForURLName:urlName type:type];
    //TODO:这个校验在切换为urlName校验后开启
//    if (!urlName) {
//        return [[[HDDataBaseConvertor alloc]init]autorelease];
//    }
    
    //TODO:这里暂时写死
    NSString * dataFilterName = nil;
    
    if (type == HDDataRequestConvertor) {
        dataFilterName = @"defaultRequest";
    }else {
        dataFilterName = @"defaultResponse";
    }
    
    //TODO:考虑从配置文件读取,暂时不处理请求时的map映射    
    NSArray * dataFilterConfig = [self dataFilterListWithFilterName:dataFilterName];   
    //    NSDictionary * fieldDictionary = [[HDGodXMLFactory shareBeanFactory]fieldDictionaryWithURLName:urlName type:type];
    
    return [self filterChainWithConfig:dataFilterConfig
                       fieldDictionary:nil];
    //TODO:注释警告部分,这个类暂时不用
    //    return nil;
}

#pragma -mark 根据convert名字生成转换器链数组 
-(NSArray *)dataFilterListWithFilterName:(NSString *) filterName
{
    if ([filterName isEqualToString:kDefaultRequest]) 
    {
        return [NSArray arrayWithObjects:@"HDDataToStringConvertor",kJSONToDataConvertor,kDataAuroraRequestConvertor,nil];
    }
    if ([filterName isEqualToString: kDefaultResponse]) {
        return [NSArray arrayWithObjects:kDataAuroraResponseConvertor,kDataToJSONConvertor, nil];
    }
    return nil;
}

-(id<HDDataConvertor>)filterChainWithConfig:(NSArray *) config 
                            fieldDictionary:(NSDictionary *) dictionary
{
    HDBaseConvertor * convertor = nil;
    for (NSString * filterClassName in config) {
        HDBaseConvertor * nextConvertor = [[[NSClassFromString(filterClassName) alloc]initWithNextConvertor:convertor]autorelease];
        if ([filterClassName isEqualToString:kDataFieldRequestConvertor]) {
            //set fieldDictionary
            [(HDFieldMapConvertor *)nextConvertor setFieldMap:dictionary];
        }
        convertor = nextConvertor;
    }
    return convertor;
}
@end
