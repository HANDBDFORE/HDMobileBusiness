//
//  HDXMLParser.m
//  HDMobileBusiness
//
//  Created by MHJ on 8/23/12.
//  Copyright (c) 2012 hand. All rights reserved.
//
#import "HDXMLParser.h"
@interface HDXMLParser(){
    //xmlPath
    NSString *xmlPath;
    //当前bean的ID
    NSString *beanId;
    //当前Bean的Refbeans
    NSMutableDictionary *propertyRefbeans;
    //当前Bean的Values
    NSMutableDictionary *propertyValues;
    //当前的property
    NSString *currentProperty;
    //当前的数组
    NSMutableArray *currentArray;
    //当前的map
    NSMutableDictionary *currentDict;
    //是否继续解析
    BOOL isContinue;
}
@end
@implementation HDXMLParser
@synthesize patternes = _Patternes;
@synthesize parseError = _parseError;

-(id)initWithXmlPath:(NSString *)xmlpath{
    self = [super init];
    if (self) {
        _Patternes = [[NSMutableDictionary alloc]init];
        xmlPath = xmlpath;
    }
    return self;
}
- (void)dealloc
{
    [_Patternes release];
    [propertyRefbeans release];
    [propertyValues release];
    [currentArray release];
    [currentDict release];
    [super dealloc];
}

-(BOOL)parse{
    NSData * data = [NSData dataWithContentsOfFile:@"Users/Leo/Projects/xcode/Hand/HDMobileBusiness/HDMobileBusiness/Documents/ConfigFiles/backend-config-cola-pad.xml"];
//    NSData * data = [NSData dataWithContentsOfFile:TTPathForDocumentsResource(xmlPath)];
    NSXMLParser *parser = [[NSXMLParser alloc]initWithData:data]; //设置XML数据
    [parser setShouldProcessNamespaces:NO];
    [parser setShouldReportNamespacePrefixes:NO];
    [parser setShouldResolveExternalEntities:NO];
    [parser setDelegate:self];
    [parser parse];
    if(![self parseError]){
        return YES;
    }else{
        return NO;
    }
}
#pragma mark - bean
-(void)parserattribute:attributeDict{
    if ([attributeDict objectForKey:@"copy"]) {
        //复制参数
        propertyRefbeans = (NSMutableDictionary *)[(HDObjectPattern *)[_Patternes objectForKey:[attributeDict objectForKey:@"copy"]] beans];
        propertyValues = (NSMutableDictionary *)[(HDObjectPattern *)[_Patternes objectForKey:[attributeDict objectForKey:@"copy"]] values];
        [_Patternes setObject:[[(HDObjectPattern *)[_Patternes objectForKey:[attributeDict objectForKey:@"copy"]]copy] autorelease] forKey:[attributeDict objectForKey:@"id"]];
    }else if([attributeDict objectForKey:@"share"]){
        [_Patternes setObject:(HDObjectPattern *)[_Patternes objectForKey:[attributeDict objectForKey:@"share"]]forKey:[attributeDict objectForKey:@"id"]];
        isContinue = NO;
    }else{
        HDObjectPattern *newPattern =[HDObjectPattern patternWithURL:[attributeDict objectForKey:@"create-url"]propertyValues:nil propertyRefBeans:nil objectMode:[[attributeDict objectForKey:@"mode"] isEqualToString:@"create"]?HDObjectModeCreate:HDObjectModeShare];
        [_Patternes setObject:newPattern forKey:[attributeDict objectForKey:@"id"]];
    }
    
}
#pragma mark - NSXMLParserDelegate
//发现元素开始符的处理函数  （即报告元素的开始以及元素的属性）
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    //解析到BEAN标签则初始化数据
    if ([[elementName uppercaseString] isEqualToString:@"BEAN"] ) {
        isContinue = YES;
        propertyRefbeans = [[NSMutableDictionary alloc]init];
        propertyValues = [[NSMutableDictionary alloc]init];
        beanId = [attributeDict objectForKey:@"id"];
        [self parserattribute:attributeDict];
    }else if(isContinue&&[[elementName uppercaseString] isEqualToString:@"PROPERTY"] ){
        currentProperty = [attributeDict objectForKey:@"name"];
        if ([attributeDict objectForKey:@"value"]) {
            if ([[[attributeDict objectForKey:@"value"] uppercaseString]isEqualToString:@"TRUE"]) {
                [propertyValues setObject:[NSNumber numberWithBool:YES]  forKey:currentProperty];
            }else if ([[[attributeDict objectForKey:@"value"] uppercaseString]isEqualToString:@"FALSE"]) {
                [propertyValues setObject:[NSNumber numberWithBool:NO] forKey:currentProperty];
            }else{
                [propertyValues setObject:[attributeDict objectForKey:@"value"] forKey:currentProperty];
            }
        }else if ([attributeDict objectForKey:@"ref"]){
            [propertyRefbeans setObject:[attributeDict objectForKey:@"ref"] forKey:currentProperty];
        }
    }else if(isContinue&&[[elementName uppercaseString] isEqualToString:@"ARRAY"] ){
        currentArray = [[NSMutableArray alloc]init];
    }else if(isContinue&&[[elementName uppercaseString] isEqualToString:@"MAP"] ){
        currentDict = [[NSMutableDictionary alloc]init];
    }else if(isContinue&&[[elementName uppercaseString] isEqualToString:@"LIST"] ){
        [currentArray addObject:[attributeDict objectForKey:@"value"]];
    }else if(isContinue&&[[elementName uppercaseString] isEqualToString:@"ELEMENT"] ){
        [currentDict setValue:[attributeDict objectForKey:@"value"] forKey:[attributeDict objectForKey:@"key"]];
    }
}
//处理标签包含内容字符 （报告元素的所有或部分内容）
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    
}
//发现元素结束符的处理函数，保存元素各项目数据（即报告元素的结束标记）
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    //解析完bean
    if ([[elementName uppercaseString] isEqualToString:@"BEAN"] ) {
        if (isContinue) {
            [(HDObjectPattern *)[_Patternes objectForKey:beanId ] setValues:propertyValues];
            [(HDObjectPattern *)[_Patternes objectForKey:beanId ] setBeans:propertyRefbeans];
        }
        [propertyRefbeans release];
        propertyRefbeans = nil;
        [propertyValues release];
        propertyValues =nil;
    }else if([[elementName uppercaseString] isEqualToString:@"PROPERTY"] ){
        currentProperty = nil;
    }else if(isContinue&&[[elementName uppercaseString] isEqualToString:@"ARRAY"] ){
        [propertyValues setObject:currentArray forKey:currentProperty];
        [currentArray release];
        currentArray = nil;
    }else if(isContinue&&[[elementName uppercaseString] isEqualToString:@"MAP"] ){
        [propertyValues setObject:currentDict forKey:currentProperty];
        [currentDict release];
        currentDict = nil;
    }
    
}
//报告解析的结束
- (void)parserDidEndDocument:(NSXMLParser *)parser{
    [parser release];
    parser=nil;
}
//报告不可恢复的解析错误
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError{
    [self setParseError:parseError];
    [self setPatternes:nil];
}
@end

