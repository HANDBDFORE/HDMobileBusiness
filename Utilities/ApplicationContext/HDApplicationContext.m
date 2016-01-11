//
//  HDApplicationContext.m
//  Three20Lab
//
//  Created by Plato on 11/15/12.
//  Copyright (c) 2012 hand. All rights reserved.
//

#import "HDApplicationContext.h"
#import "HDClassLoader.h"

@implementation HDApplicationContext{
    //读取的时间
    int execTime ;
    //计时器
    NSTimer * timer;
    //根据是否配置了计时，判断是否打开

    
}

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
        
        NSArray* dirs = NSSearchPathForDirectoriesInDomains(
                                                            NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *  documentsPath = [dirs objectAtIndex:0];
        NSLog(@"%@",documentsPath);
        
        //加载对象创建路径
        [self loadFactoryMap];
        [self loadLocalPattern];
        //给时间一个初时值
        execTime = 0;
    }
    return self;
}

//Ma's edition
//-(BOOL)configWithXmlPath:(NSString *) xmlPath
//{
//    HDXMLParser *parser = [[HDXMLParser alloc]initWithXmlPath:xmlPath];
//    BOOL hasParsedSuccess = [parser parse];
//    if (hasParsedSuccess){
//        for (NSString*key in parser.patternes) {
//            [self setPattern:[parser.patternes objectForKey:key] forIdentifier:key];
//        }
//    }
//    [parser release];
//    return  hasParsedSuccess;
//}

-(void)refreshTimer
{
    //每次刷新的时候，停止之间的计时器
    
    
    //没有配置超时时间或则配置为0 则不开启计时器
    if(execTime == 0){
        
        return;
    }
    
    //关闭上次计时器
    if(timer !=nil){
        
        [timer invalidate];
        
    }
    
    //重新初始化计时器
    timer = [NSTimer scheduledTimerWithTimeInterval:execTime * 60 target:self selector:@selector(loginExec) userInfo:nil repeats:NO];
    
}

//返回loading模块
-(void)loginExec
{
    [timer invalidate];
    timer =nil;
    NSLog(@"exec time");
    HDViewGuider * guider = [self objectForIdentifier:@"rootGuider"];
    
    [guider perform];
    
}


//Emerson's parsing edition
-(BOOL)configWithXmlPath:(NSString *) xmlPath{
    NSDictionary *patternes= [HDXMLParserCenter getParsedPattensWithXMLPath:xmlPath];
    for (NSString*key in patternes) {
        //添加服务器配置超时时间
        if([key isEqualToString:@"execTime"]){
          HDObjectPattern * execPattern =   [patternes objectForKey:key];
            NSString * time =  execPattern.url;
            execTime = [time intValue];

            
        }
        
        [self setPattern:[patternes objectForKey:key] forIdentifier:key];
    }
    return  true;
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
    
    HDObjectPattern * helpViewGuiderPattern =
    [HDObjectPattern patternWithURL:@"tt://rootGuider/helpViewGuider"
                     propertyValues:nil
                   propertyRefBeans:@{@"sourceController" : @"rootWindow",
     @"destinationController":@"loadingViewCtrl"}
                         objectMode:HDObjectModeCreate];
    [self setPattern:helpViewGuiderPattern forIdentifier:@"helpViewGuider"];
    
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
    if (HDIsInch4()) {
        nibName = [NSString stringWithFormat:@"%@-568",nibName];
    }
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
