//
//  HDXMLParser.h
//  HDMobileBusiness
//
//  Created by Plato on 8/23/12.
//  Copyright (c) 2012 hand. All rights reserved.
//


#import "HDBaseConfigObject.h"
#import "HDValueConfigObject.h"
#import "HDSingletonObject.h"

@interface HDXMLParser : HDSingletonObject
{
    NSMutableDictionary * _configDictionary;
}

+(NSDictionary *)createPropertyDictionaryForKeyPath:(NSString *) keyPath;

@end
