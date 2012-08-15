//
//  HDJSONToDataConvertor.m
//  Three20Lab-2
//
//  Created by Rocky Lee on 5/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDJSONToDataConvertor.h"

@implementation HDJSONToDataConvertor

-(BOOL)validateData:(id)data
{
    return [data isKindOfClass:[NSDictionary class]]||
           [data isKindOfClass:[NSArray class]];
}

-(id)convert:(id)data error:(NSError **)error
{
    return [NSJSONSerialization dataWithJSONObject:data
                                           options:0
                                             error:error];
}

@end
