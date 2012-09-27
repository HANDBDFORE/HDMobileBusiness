//
//  HDXMLParser.m
//  HDMobileBusiness
//
//  Created by Plato on 8/23/12.
//  Copyright (c) 2012 hand. All rights reserved.
//

#import "HDXMLParser.h"
#import "TouchXML.h"
@interface HDXMLParser()
{
    CXMLDocument * _document;
}

@end

@implementation HDXMLParser

- (void)dealloc
{
    TT_RELEASE_SAFELY(_configDictionary);
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        _configDictionary = [[NSMutableDictionary alloc]init];
        
        //        NSData * data = [NSData dataWithContentsOfFile:TTPathForDocumentsResource(@"ios-backend-config.xml")];
        NSData * data = [NSData dataWithContentsOfFile:@"/Users/Leo/Projects/xcode/Hand/HDMobileBusiness/HDMobileBusiness/Documents/ConfigFiles/backend-config-hr-sprite.xml"];
        
        NSError * error = nil;
        _document = [[CXMLDocument alloc]initWithData:data encoding:NSUTF8StringEncoding options:0 error:&error];
        
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
        sharedConfig = [self createProperties:viewControllerElement];
        [_configDictionary setValue:sharedConfig forKey:keyPath];
        return sharedConfig;
    }
    
    NSString * searchPath = [NSString stringWithFormat:@"//viewController[@keyPath='%@']",shareTo];
    sharedConfig = [self parserConfigXML:(CXMLElement *)[_document nodeForXPath:searchPath error:nil]];
     [_configDictionary setValue:sharedConfig forKey:keyPath];
    
    return sharedConfig;
}

-(id<HDConfig>)createProperties:(CXMLElement *) node
{
    //TODO:先创建值对象
    //value节点
    if ([[[node attributeForName:@"dataType"] stringValue] isEqual:@"NSString"]) {
        return [HDValueConfigObject configWithKey:[node name]
                                            value:[[node attributeForName:@"value"] stringValue]];
    }

    //值容器对象，array和map
    if ([[[node attributeForName:@"dataType"] stringValue] isEqual:@"NSArray"]) {
        NSMutableArray * arrayValue = [NSMutableArray array];
        for (CXMLNode * childNode in [node children]) {
            if ([childNode isKindOfClass:[CXMLElement class]]) {
                [arrayValue addObject:[[(CXMLElement *)childNode attributeForName:@"value"] stringValue]];
            }
        }
        return [HDValueConfigObject configWithKey:[node name]
                                            value:arrayValue];
    }
    
       
    if ([[[node attributeForName:@"dataType"] stringValue] isEqual:@"NSDictionary"]) {
        NSError * error = nil;
        id value = [NSJSONSerialization JSONObjectWithData:[[[node attributeForName:@"value"] stringValue] dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&error];
        
        return [HDValueConfigObject configWithKey:[node name]
                                            value:value];
    }

    //创建配置容器对象,设定配置路径
    if ([node childCount] >0) {
        HDBaseConfigObject * baseConfig = nil;
        //如果是view节点，创建key为nil的配置，否则用节点名称创建配置key
        if ([[node name] isEqualToString:@"viewController"]) {
            baseConfig = [HDBaseConfigObject configWithKey:nil];
        }else{
            baseConfig = [HDBaseConfigObject configWithKey:[node name]];
        }
        
        for (CXMLNode * childNode in [node children]) {
            if ([childNode isKindOfClass:[CXMLElement class]]) {
                [baseConfig addPropertyConfig:[self createProperties:(CXMLElement *)childNode]];
            }
        }
        return baseConfig;
    }
    
    //防止程序挂掉，返回一个根容器
    return [HDBaseConfigObject configWithKey:nil];
}

@end
