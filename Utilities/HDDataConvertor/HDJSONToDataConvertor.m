//
//  HDJSONToDataConvertor.m
//  Three20Lab-2
//
//  Created by Rocky Lee on 5/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDJSONToDataConvertor.h"

@implementation HDJSONToDataConvertor

-(id)doConvertor:(id)data error:(NSError **)error
{
    if ([data isKindOfClass:[NSDictionary class]]||
        [data isKindOfClass:[NSArray class]]){
        id jsonData = [NSJSONSerialization dataWithJSONObject:data 
                                                      options:0
                                                        error:error];
        if (nil != jsonData) {
            return [self doNextConvertor:jsonData error:error];
        }
    }
    return [self errorWithData:data error:error];
}
@end
