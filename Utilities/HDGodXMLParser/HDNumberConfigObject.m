//
//  HDValueConfigObject.m
//  HDMobileBusiness
//
//  Created by Plato on 9/25/12.
//  Copyright (c) 2012 hand. All rights reserved.
//

#import "HDNumberConfigObject.h"

@implementation HDNumberConfigObject

-(id)propertyValue
{
    NSNumberFormatter * formatter =[[[NSNumberFormatter alloc]init] autorelease];
    return [formatter numberFromString:_propertyValue];
}

@end
