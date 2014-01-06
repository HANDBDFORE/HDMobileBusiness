//
//  HDAuroraRequestConvertor.m
//  HDMobileBusiness
//
//  Created by Rocky Lee on 5/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDAuroraRequestConvertor.h"

@implementation HDAuroraRequestConvertor

-(id)convert:(id)data error:(NSError **)error
{
    return [NSDictionary dictionaryWithObject:(data == nil ? @"": data)
                                       forKey:@"parameter"];
}

-(BOOL)validateData:(id)data
{
    return [data isKindOfClass:[NSDictionary class]] ||
           [data isKindOfClass:[NSArray class]];
}

@end



