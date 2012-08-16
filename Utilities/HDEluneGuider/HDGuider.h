//
//  HDGuider.h
//  Three20GitCoreDataLab
//
//  Created by Rocky Lee on 6/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 *通过前缀+keyName可以通过Guider在视图控制器跳转时,加载配置项.
 */
//static NSString * kOpenViewController = @"open://vc/";

@interface HDGuider : NSObject

+(id)guider;

/*
 *跳转到指定路径的视图控制器,路径以 open://vc/ 开头后接控制器配置节点的key.
 *使用 [TTNavigator navigator]openURLAction: 打开
 */

-(void)guideToKeyPath:(NSString *) path query:(NSDictionary *)query;

/*
 *创建到指定路径的视图控制器,路径以 open://vc/ 开头后接控制器配置节点的key.
 *这个方法不会显示这个视图控制器的视图,只是创建并返回它.
 *使用 [TTNavigator navigator]viewControllerForURL: 创建
 */
-(UIViewController *)controllerWithKeyPath:(NSString *) keyPath
                                     query:(NSDictionary *) query;

@end
