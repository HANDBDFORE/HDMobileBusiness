//
//  HDDataAuroraResponseConvertor.m
//  Three20Lab-2
//
//  Created by Rocky Lee on 5/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDDataAuroraResponseConvertor.h"

//响应过滤
@interface HDDataAuroraResponseConvertor()

@property(nonatomic,retain) id dataSet;

@end

@implementation HDDataAuroraResponseConvertor
@synthesize dataSet = _dataSet;

-(void)dealloc
{
    TT_RELEASE_SAFELY(_dataSet);
    [super dealloc];
}

-(id)doConvertor:(id)data error:(NSError **)error
{
    if ([[data valueForKeyPath:@"success"] boolValue]) { 
        //重新组装数据为array-dictionary结构
        self.dataSet = [data valueForKeyPath:@"result.record"]; 
        if (nil == self.dataSet) {
            //如果record节点没有数据,表示为单条记录,从result节点取数据,包装成array
            self.dataSet = [data valueForKey:@"result"];
            if(nil != self.dataSet){
                self.dataSet= [NSMutableArray arrayWithObject:self.dataSet];
            }
        }else{
            if (![self.dataSet isKindOfClass:[NSArray class]]) {
                self.dataSet = [NSMutableArray arrayWithObject:self.dataSet]; 
            }            
        }
        return [self doNextConvertor:self.dataSet error:error];   
    }
    //失败处理
    return [self errorWithData:data error:error];
}

-(id)errorWithData:(id) data error:(NSError **)error
{
    if (error && !*error) {
        *error = [NSError errorWithDomain:kHDConvertErrorDomain
                                     code:kHDConvertErrorCode
                                 userInfo:[NSDictionary dictionaryWithObject:[data valueForKeyPath:@"error.message"] forKey:NSLocalizedDescriptionKey]];
    } 
    return nil; 
}
@end

