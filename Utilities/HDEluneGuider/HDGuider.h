//
//  HDGuider.h
//  Three20GitCoreDataLab
//
//  Created by Rocky Lee on 6/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HDGuiderMap.h"
#import "HDSingletonObject.h"

static NSString * kPostControllerPath = @"POST_VC_PATH";
static NSString * kDeliverControllerPath = @"DELIVER_VC_PATH";
static NSString * kLoginControllerPath = @"HD_LOGIN_VC_PATH";
static NSString * kMainControllerPath = @"HD_MAIN_VC_PATH";

@interface HDGuider : HDSingletonObject

+(id)guider;

/*
 *跳转到指定路径的视图控制器,控制器显示之前会通过配置文件加载属性.
 *使用 [TTNavigator navigator]openURLAction: 打开
 */
-(UIViewController *)guideToKeyPath:(NSString *) keyPath
                              query:(NSDictionary *)query
                           animated:(BOOL) animated;

/*
 *创建到指定keyPathName对应的视图控制器.
 *这个方法不会显示这个视图控制器的视图,只是创建并返回它.
 *
 *  如果需要通过TTNavigator openURLAction的方式打开，一个视图控制器，通过下面的路径调用，并在配置文件中注册对应keyPathName的视图控制器
 *
 *  guide://modalViewControler/${keyPathName}
 *  guide://createViewControler/${keyPathName}
 *  guide://shareViewControler/${keyPathName}
 */
-(UIViewController *)controllerWithKeyPath:(NSString *) keyPath
                                     query:(NSDictionary *) query;

@end
