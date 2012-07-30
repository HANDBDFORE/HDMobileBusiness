//
//  HDJSONParser.m
//  Three20Lab
//
//  Created by Rocky Lee on 5/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDDataToJSONConvertor.h"

@implementation HDDataToJSONConvertor

-(id)doConvertor:(id)data error:(NSError **)error
{
    if ([data isKindOfClass:[NSData class]]) {
        id object = [NSJSONSerialization JSONObjectWithData:data 
                                                    options:NSJSONReadingMutableLeaves 
                                                      error:error];
        if (nil != object) {
            [*error autorelease];
            return [self doNextConvertor:object error:error];
        }   
    }
    return [self errorWithData:data error:error];
}

@end

