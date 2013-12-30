//
//  HDXMLParserFactory.m
//  HDMobileBusiness
//
//  Created by Emerson Zhang on 13-5-24.
//  Copyright (c) 2013年 hand. All rights reserved.
//

#import "HDXMLParserCenter.h"

static HDXMLParserCenter *instance;
@interface HDXMLParserCenter() {
    //xml文件路径
    NSString *xmlpath;
    
    //xml文件解析时产生的错误
    NSError *parseError;
    
    //配置文件版本
    NSInteger configFileVersion;
    
    //是否找到版本号
    BOOL hasFoundVersion;
}

@end

@implementation HDXMLParserCenter


-(id)initWithXMLPath:(NSString*)path{
    self = [super init];
    if (self) {
        //加载配置文件路径
        xmlpath = path;
        hasFoundVersion=false;
    }
    return self;
}

+(NSDictionary*)getParsedPattensWithXMLPath:(NSString*)path{
    
    @synchronized(self){
        if (instance == nil) {
            instance=[[HDXMLParserCenter alloc]initWithXMLPath:path];
        }
    }
    
    if ([instance parse]) {
        id<HDParserProtocal> configParser = [self getParserInstanceWithXMLPath:path ByVersion:[instance getConfigFileVersion]];
        
        [configParser parse];
        return [configParser patternes];
    }
    
    else{
        return nil;
    }
}

+(id<HDParserProtocal>)getParserInstanceWithXMLPath:(NSString*)path ByVersion:(NSInteger)version{
    
    if (version<=1) {
        NSLog(@"初代");
        //初代配置文件解析器
        return [[[HDOriginalXMLParser alloc] initWithXmlPath:path]autorelease];
    }else{
        NSLog(@"spring like");
        //类似spring的配置文件格式解析器
        return [[[HDXMLParser alloc]initWithXmlPath:path]autorelease];
    }
    
}

//开始解析xml，为了解析出版本号
-(BOOL)parse{
    //    NSData * data = [NSData dataWithContentsOfFile:@"Users/Leo/Projects/xcode/Hand/HDMobileBusiness/HDMobileBusiness/Documents/ConfigFiles/backend-config-mocha.xml"];
    NSData * data = [NSData dataWithContentsOfFile:TTPathForDocumentsResource(xmlpath)];
    NSXMLParser *parser = [[NSXMLParser alloc]initWithData:data]; //设置XML数据
    [parser setShouldProcessNamespaces:NO];
    [parser setShouldReportNamespacePrefixes:NO];
    [parser setShouldResolveExternalEntities:NO];
    [parser setDelegate:self];
    [parser parse];
    if(!parseError){
        return YES;
    }else{
        return NO;
    }
}

-(NSInteger)getConfigFileVersion{
    return configFileVersion;
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    
    if ([[elementName lowercaseString] isEqualToString:@"backend-config"]) {
        hasFoundVersion = true;
        configFileVersion = [[attributeDict objectForKey:@"version"]intValue];
        [parser abortParsing];
        return;
    }
}


@end
