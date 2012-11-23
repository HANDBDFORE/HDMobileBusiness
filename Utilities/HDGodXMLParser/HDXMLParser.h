//
//  HDXMLParser.h
//  HDMobileBusiness
//
//  Created by Plato on 8/23/12.
//  Copyright (c) 2012 hand. All rights reserved.
//

#import "HDSingletonObject.h"
#import "HDObjectPattern.h"

@protocol HDXMlParserDelegate;

@interface HDXMLParser : HDSingletonObject
{
    NSMutableDictionary * _configDictionary;
}

@property (nonatomic,assign) id <HDXMlParserDelegate> delegate;
//解析成功
+(BOOL)hasParsedSuccess;

-(BOOL)parserForXmlPath:(NSString *) xmlPath;



//创建配置 PropertyDictionary
+(NSDictionary *)createPropertyDictionaryForKeyPath:(NSString *) keyPath;

@end

@protocol HDXMlParserDelegate <NSObject>

-(void) setPattern:(HDObjectPattern *) pattern forIdentifier:(NSString *)identifier;

@end