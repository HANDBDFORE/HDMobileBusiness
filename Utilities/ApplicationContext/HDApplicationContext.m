//
//  HDApplicationContext.m
//  Three20Lab
//
//  Created by Plato on 11/15/12.
//  Copyright (c) 2012 hand. All rights reserved.
//

#import "HDApplicationContext.h"
#import "HDClassLoader.h"

@implementation HDApplicationContext

- (void)dealloc
{
    TT_RELEASE_SAFELY(_objectFactoryMap);
    TT_RELEASE_SAFELY(_objectMappings);
    TT_RELEASE_SAFELY(_objectPatterns);
    [super dealloc];
}

+(BOOL)configApplicationContextForXmlPath:(NSString *)xmlPath
{
    return [[self shareObject]configWithXmlPath:xmlPath];
}

+(HDApplicationContext *)shareContext
{
    return [self shareObject];
}

-(void)clearObjects
{
    [_objectMappings removeAllObjects];
    [self loadLocalPattern];
}

- (id)init
{
    self = [super init];
    if (self) {
        //加载对象创建路径
        [self loadFactoryMap];
        [self loadLocalPattern];
    }
    return self;
}

-(BOOL)configWithXmlPath:(NSString *) xmlPath
{
    HDXMLParser *Parser = [[HDXMLParser alloc]initWithXmlPath:xmlPath];
    BOOL hasParsedSuccess = [Parser parse];
    if (hasParsedSuccess){
        for (NSString*key in Parser.patternes) {
            [self setPattern:[Parser.patternes objectForKey:key] forIdentifier:key];
        }
    }
    [Parser release];
    return  hasParsedSuccess;
}

-(id)objectForIdentifier:(NSString *)identifier
{
    return [self objectForIdentifier:identifier query:nil];
}

-(id)objectForIdentifier:(NSString *)identifier query:(NSDictionary *)query
{
    id object = nil;
    if (_objectMappings) {
        object = [_objectMappings objectForKey:identifier];
        if (object) {
            return object;
        }
    }
    
    //如果是网页，返回一个网页视图控制器，这样后面的property就可以启用了
    if ([identifier hasPrefix:@"http://"]) {
        return [_objectFactoryMap objectForURL:identifier];
    }
    
    HDObjectPattern *objectPattern =  [self objectPatternForIdentifier:identifier];
    if (objectPattern) {
        object = [_objectFactoryMap objectForURL:objectPattern.url query:query];
        
        //set value properties
        for (NSString * keyPath in [objectPattern.values allKeys]) {
            id value = [objectPattern.values valueForKey:keyPath];
            [object setValue:value forKeyPath:keyPath];
        }
        
        //set ref properies
        for (NSString * keyPath in [objectPattern.beans allKeys]) {
            NSString * identifier = [objectPattern.beans valueForKey:keyPath];
            [object setValue:[self objectForIdentifier:identifier] forKeyPath:keyPath];
        }
        
        if (objectPattern.objectMode == HDObjectModeShare && object) {
            [self setObject:object forIdentifier:identifier];
        }
    }
    return object;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (HDObjectPattern*)objectPatternForIdentifier:(NSString *)identifier {
    return [_objectPatterns objectForKey:identifier];
}

-(void)setObject:(id)object forIdentifier:(NSString *)identifier
{
    if (nil == _objectMappings) {
        _objectMappings = [[NSMutableDictionary alloc]init];
    }
    [_objectMappings setObject:object forKey:identifier];
}

-(void) setPattern:(HDObjectPattern *) pattern forIdentifier:(NSString *)identifier
{
    if (nil == _objectPatterns) {
        _objectPatterns = [[NSMutableDictionary alloc]init];
    }
    [_objectPatterns setObject:pattern forKey:identifier];
}


-(void)loadFactoryMap
{
    if (nil == _objectFactoryMap) {
        _objectFactoryMap = [[TTURLMap alloc]init];
    }
    //基础服务 url 注册
    //从nib创建视图控制器
    [_objectFactoryMap from:@"tt://nib/(loadFromNib:)/(withClass:)"
           toViewController:self];
    
    [HDClassLoader loadURLMap:_objectFactoryMap];
}

-(void)loadLocalPattern
{
    //这些配置需要在获取配置文件前加载
    //配置bean
    [self setObject:[[[UIApplication sharedApplication] delegate]window] forIdentifier:@"rootWindow"];
    
    //第一次加载入口guider
    HDObjectPattern * firstRootGuiderPattern =
    [HDObjectPattern patternWithURL:@"tt://rootGuider/firstRootGuider"
                     propertyValues:nil
                   propertyRefBeans:@{@"sourceController" :@"rootWindow",
     @"destinationController":@"userHelpCtrl"}
                         objectMode:HDObjectModeCreate];
    [self setPattern:firstRootGuiderPattern forIdentifier:@"firstRootGuider"];
    
    //user help。。。
    HDObjectPattern * userHelpCtrl =
    [HDObjectPattern patternWithURL:@"tt://UserGuideViewController"
                     propertyValues:nil
                   propertyRefBeans:nil
                         objectMode:HDObjectModeCreate];
    
    [self setPattern:userHelpCtrl forIdentifier:@"userHelpCtrl"];
    
    //入口guider
    HDObjectPattern * rootGuiderPattern =
    [HDObjectPattern patternWithURL:@"tt://rootGuider/rootGuider"
                     propertyValues:nil
                   propertyRefBeans:@{@"sourceController" :@"rootWindow",
     @"destinationController":@"loadingViewCtrl"}
                         objectMode:HDObjectModeCreate];
    
    [self setPattern:rootGuiderPattern forIdentifier:@"rootGuider"];
    
    //初始化loading。。。
    HDObjectPattern * loading =
    [HDObjectPattern patternWithURL:@"tt://LoadingViewController"
                     propertyValues:nil
                   propertyRefBeans:nil
                         objectMode:HDObjectModeCreate];
    
    [self setPattern:loading forIdentifier:@"loadingViewCtrl"];
}

#pragma -mark load from nib
/**
 * Loads the given viewcontroller from the nib
 */
- (UIViewController*)loadFromNib:(NSString *)nibName withClass:className {
    UIViewController* newController = [[NSClassFromString(className) alloc]
                                       initWithNibName:nibName bundle:nil];
    
    return [newController autorelease];
}
/**
 * Loads the given viewcontroller from the the nib with the same name as the
 * class
 */
- (UIViewController*)loadFromNib:(NSString*)className {
    return [self loadFromNib:className withClass:className];
}

@end
