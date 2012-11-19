//
//  HDApplicationContext.m
//  Three20Lab
//
//  Created by Plato on 11/15/12.
//  Copyright (c) 2012 hand. All rights reserved.
//

#import "HDApplicationContext.h"
#import "HDDoneListModel.h"
#import "HDObjectPattern.h"

#import "HDLoadingViewController.h"
#import "HDLoginViewController.h"

@implementation HDApplicationContext

+(BOOL)configApplicationContextForXmlPath:(NSString *)xmlPath
{
    return [[self shareObject]configWithXmlPath:xmlPath];
}

+(HDApplicationContext *)shareContext
{
    return [self shareObject];
}

- (id)init
{
    self = [super init];
    if (self) {
        //加载对象创建路径
        [self loadMap];
        
        //这些配置需要在获取配置文件前加载
        //配置bean
        [self setObject:[[[UIApplication sharedApplication] windows] objectAtIndex:0] forIdentifier:@"rootWindow"];

        //入口guider
        HDObjectPattern * rootGuiderPattern =
        [HDObjectPattern patternWithURL:@"tt://rootGuiderPattern/rootGuider"
                         propertyValues:nil
                       propertyRefBeans:@{@"sourceController" :@"rootWindow",
         @"destinationController":@"loadingViewCtrl"}
                             objectMode:HDObjectModeCreate];
        
        [self setPattern:rootGuiderPattern forIdentifier:@"rootGuider"];
        
        //初始化loading。。。
        HDObjectPattern * loading = [HDObjectPattern patternWithURL:@"tt://LoadingViewController" propertyValues:nil propertyRefBeans:nil objectMode:HDObjectModeShare];
        
        [self setPattern:loading forIdentifier:@"loadingViewCtrl"];
    }
    return self;
}

-(BOOL)configWithXmlPath:(NSString *) xmlPath
{
    if (![HDXMLParser hasParsedSuccess]) {
        return NO;
    }
    //login guider
    HDObjectPattern * loadingGuiderPattern =
    [HDObjectPattern patternWithURL:@"tt://rootGuiderPattern/rootGuider"
                     propertyValues:nil
                   propertyRefBeans:@{@"sourceController" :@"rootWindow",
     @"destinationController":@"loginViewCtrl"}
                         objectMode:HDObjectModeCreate];
    
    [self setPattern:loadingGuiderPattern forIdentifier:@"loadingGuider"];

    ///loginVC
    HDObjectPattern * loginPattern =
    [HDObjectPattern patternWithURL:@"tt://nib/HDLoginViewController/HDLoginViewController"
                     propertyValues:@{@"titleLabel.text" : @"hand"}
                   propertyRefBeans:@{@"loginModel":@"loginModel"}
                         objectMode:HDObjectModeShare];
    [self setPattern:loginPattern forIdentifier:@"loginViewCtrl"];
    
    //loginM
    HDObjectPattern * loginM = [HDObjectPattern patternWithURL:@"tt://loginModel" propertyValues:@{@"submitURL":@"${base_url}modules/ios/public/login_iphone.svc"} propertyRefBeans:nil objectMode:HDObjectModeShare];
    [self setPattern:loginM forIdentifier:@"loginModel"];
    
    return YES;
}

-(id)objectForIdentifier:(NSString *)identifier
{
    id object = nil;
    if (_objectMappings) {
        object = [_objectMappings objectForKey:identifier];
        if (object) {
            return object;
        }
    }
    
    HDObjectPattern * objectPattern =  [self objectPatternForIdentifier:identifier];
    if (objectPattern) {
        object = [_objectFactoryMap objectForURL:objectPattern.url];
        
        //set value properties
        for (NSString * keyPath in [objectPattern.values allKeys]) {
            NSString * value = [objectPattern.values valueForKey:keyPath];
            
            //如果是创建路径，从urlMap中获取对象
            id objectProperty = [_objectFactoryMap objectForURL:value];
            if (objectProperty) {
                [object setValue:objectProperty forKeyPath:keyPath];
            }else{
                //否则按照字符串处理
                [object setValue:value forKeyPath:keyPath];
            }
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
        _objectMappings = TTCreateNonRetainingDictionary();
    }
    [_objectMappings setObject:object forKey:identifier];
}

-(void) setPattern:(HDObjectPattern *) pattern forIdentifier:(NSString *)identifier
{
    if (nil == _objectPatterns) {
        _objectPatterns = TTCreateNonRetainingDictionary();
    }
    [_objectPatterns setObject:pattern forKey:identifier];
}


-(void)loadMap
{
    if (nil == _objectFactoryMap) {
        _objectFactoryMap = [[TTURLMap alloc]init];
    }
    
    [_objectFactoryMap from:@"tt://LoadingViewController" toViewController:[HDLoadingViewController class]];
    
    
    [_objectFactoryMap from:@"tt://(initWithNibName:)/(bundle:)" toViewController:[HDLoginViewController class]];
    
    [_objectFactoryMap from:@"tt://nib/(loadFromNib:)/(withClass:)"
    toViewController:[UIApplication sharedApplication].delegate];

    
    [_objectFactoryMap from:@"tt://loginModel" toViewController:[HDLoginModel class]];
    
    [_objectFactoryMap from:@"tt://rootGuiderPattern/(initWithKeyIdentifier:)" toViewController:[HDRootViewGuider class]];
    
}

@end
