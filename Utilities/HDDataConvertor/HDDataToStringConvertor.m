//
//  HDDataToStringConvertor.m
//  HDMobileBusiness
//
//  Created by Plato on 8/13/12.
//  Copyright (c) 2012 hand. All rights reserved.
//

#import "HDDataToStringConvertor.h"

@implementation HDDataToStringConvertor

-(BOOL)validateData:(id)data
{
   return  [data isKindOfClass:[NSData class]];
}

-(id)convert:(id)data error:(NSError **)error
{
    return [[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding] autorelease];
}

@end
