//
//  HDXMLParser.h
//  HDMobileBusiness
//
//  Created by Plato on 8/23/12.
//  Copyright (c) 2012 hand. All rights reserved.
//

#import "HDSingletonObject.h"

@interface HDXMLParser : HDSingletonObject
{
    NSMutableDictionary * _configDictionary;
}

//创建配置 PropertyDictionary
+(NSDictionary *)createPropertyDictionaryForKeyPath:(NSString *) keyPath;

//解析成功
+(BOOL)hasParsedSuccess;

@end
