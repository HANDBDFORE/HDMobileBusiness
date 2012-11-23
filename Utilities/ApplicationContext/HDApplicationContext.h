//
//  HDApplicationContext.h
//  Three20Lab
//
//  Created by Plato on 11/15/12.
//  Copyright (c) 2012 hand. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HDSingletonObject.h"
#import "HDXMLParser.h"

static NSString * kTodoListControllerIdentifier = @"todoListViewController";
static NSString * kDoneListControllerIdentifier = @"doneListViewController";

//附加到guider里面
@interface HDApplicationContext : HDSingletonObject <HDXMlParserDelegate>
{
    //对象配置模式，保存了对象id和相关属性，创建url等信息
    NSMutableDictionary * _objectPatterns;
    //共享属性的对象会被容器保持
    NSMutableDictionary * _objectMappings;
    //TT的对象工厂，通过注册url和class，可以通过url的方式创建对象
    TTURLMap * _objectFactoryMap;
}

//使用指定xml配置context，配置成功返回YES，失败返回NO。
+(BOOL)configApplicationContextForXmlPath:(NSString *) xmlPath;

//获取context对象
+(HDApplicationContext *)shareContext;

-(void)clearObjects;

//通过id获取指定对象
-(id)objectForIdentifier:(NSString *)identifier;

-(id)objectForIdentifier:(NSString *)identifier query:(NSDictionary *)query;

-(void) setPattern:(HDObjectPattern *) pattern forIdentifier:(NSString *)identifier;

//从nib创建视图控制器
- (UIViewController*)loadFromNib:(NSString *)nibName withClass:className;
- (UIViewController*)loadFromNib:(NSString*)className;


@end
