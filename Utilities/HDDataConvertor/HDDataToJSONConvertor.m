//
//  HDJSONParser.m
//  Three20Lab
//
//  Created by Rocky Lee on 5/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HDDataToJSONConvertor.h"

@implementation HDDataToJSONConvertor

-(id)convert:(id)data error:(NSError **) error
{
    return  [NSJSONSerialization JSONObjectWithData:data
                                    options:NSJSONReadingMutableLeaves
                                      error:error];
}

-(BOOL)validateData:(id)data
{
    return [data isKindOfClass:[NSData class]];
}

@end

