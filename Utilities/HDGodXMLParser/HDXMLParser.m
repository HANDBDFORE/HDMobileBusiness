//
//  HDXMLParser.m
//  HDMobileBusiness
//
//  Created by Plato on 8/23/12.
//  Copyright (c) 2012 hand. All rights reserved.
//

#import "HDXMLParser.h"
#import "TouchXML.h"

#import "HDContainerConfigObject.h"
#import "HDNumberConfigObject.h"
#import "HDDictionaryConfigObject.h"
#import "HDArrayConfigObject.h"

@interface HDXMLParser()
{
    CXMLDocument * _document;
    NSDictionary * _dataTypeDictionary;
}

@end

@implementation HDXMLParser

- (void)dealloc
{
    TT_RELEASE_SAFELY(_configDictionary);
    TT_RELEASE_SAFELY(_dataTypeDictionary);
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        _dataTypeDictionary =
        @{
        @"NSString" : [HDBaseConfigObject class],
        @"NSNumber" : [HDNumberConfigObject class],
        @"NSArray" : [HDArrayConfigObject class],
        @"NSDictionary" : [HDDictionaryConfigObject class]
        };
        _configDictionary = [[NSMutableDictionary alloc]init];
        
        NSData * data = [NSData dataWithContentsOfFile:TTPathForDocumentsResource(@"ios-backend-config.xml")];
//        NSData * data = [NSData dataWithContentsOfFile:@"/Users/Leo/Projects/xcode/Hand/HDMobileBusiness/HDMobileBusiness/Documents/ConfigFiles/backend-config-hr-sprite.xml"];
        
        NSError * error = nil;
        _document = [[CXMLDocument alloc]initWithData:data encoding:NSUTF8StringEncoding options:0 error:&error];
        //解析配置文件
        if ([[[_document rootElement] name] isEqualToString:@"backend-config"]) {
            NSError * error = nil;
            NSArray * vcArray = [_document nodesForXPath:@"//viewController" error:&error];
            for (CXMLElement * element in vcArray) {
                [self parserConfigXML:element];
            }
        }
        TT_RELEASE_SAFELY(_document);
    }
    return self;
}

//
+(BOOL)hasParsedSuccess
{
    return [[[[HDXMLParser shareObject]configDictionary] allKeys] count] > 0;
}

-(NSDictionary *) configDictionary
{
    return _configDictionary;
}
//创建配置 PropertyDictionary
+(NSDictionary *)createPropertyDictionaryForKeyPath:(NSString *)keyPath
{
    return [[HDXMLParser shareObject] createPropertyDictionaryForKeyPath:keyPath];
}

-(NSDictionary *)createPropertyDictionaryForKeyPath:(NSString *)keyPath
{
    return [[_configDictionary valueForKey:keyPath] createPropertyDictionary];
}

//解析配置文件，生成配置对象放到配置映射记录
-(id <HDConfig>)parserConfigXML:(CXMLElement *) viewControllerElement
{
    //从缓存获取
    NSString * shareTo = [[viewControllerElement attributeForName:@"shareTo"] stringValue];
    NSString * keyPath = [[viewControllerElement attributeForName:@"keyPath"] stringValue];
    TTDASSERT(keyPath);
    id <HDConfig> sharedConfig = nil;
    
    sharedConfig = [_configDictionary valueForKey:keyPath];
    if (nil != sharedConfig) {
        return sharedConfig;
    }
    
    //如果没有设置共享，创建一个配置
    if (!shareTo) {
        sharedConfig = [self createConfigs:viewControllerElement];
        [_configDictionary setValue:sharedConfig forKey:keyPath];
        return sharedConfig;
    }
    
    //如果有设置共享，获取共享链接的配置
    NSString * searchPath = [NSString stringWithFormat:@"//viewController[@keyPath='%@']",shareTo];
    sharedConfig = [self parserConfigXML:(CXMLElement *)[_document nodeForXPath:searchPath error:nil]];
    [_configDictionary setValue:sharedConfig forKey:keyPath];
    
    return sharedConfig;
}

-(id<HDConfig>)createConfigs:(CXMLElement *) element
{
    //根据数据类型创建配置对象，如果没有数据类型，创建容器对象
    Class class = [_dataTypeDictionary valueForKey:[[element attributeForName:@"dataType"] stringValue]];
    if (!class) {
        class = [HDContainerConfigObject class];
    }
    
    HDBaseConfigObject * configObject = [[[class alloc]init]autorelease];
    [configObject setPropertyKey:[element name]];
    [configObject setPropertyValue:[[element attributeForName:@"value"] stringValue]];
    
    //设置子节点，容器，数组，字典,之后如果有复杂类型对象，在添加子类
    for (CXMLNode * childNode in [element children]) {
        if ([childNode isKindOfClass:[CXMLElement class]]) {
            [configObject addSubConfig:[self createConfigs:(CXMLElement *)childNode]];
        }
    }

    //viewControoler节点设置key为nil，容器对象会对每一个子节点的字典key添加自己的key
    if ([[element name] isEqualToString:@"viewController"]) {
        [configObject setPropertyKey:nil];
    }
    return configObject;
}

@end
