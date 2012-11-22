//
//  HDViewGuider.h
//  HDMobileBusiness
//
//  Created by Plato on 11/19/12.
//  Copyright (c) 2012 hand. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HDViewGuider : NSObject

+(id)guiderWithKeyIdentifier:(NSString *) identifier;

-(id)initWithKeyIdentifier:(NSString *) identifier;


@property (nonatomic, readonly) NSString *identifier;
//跳转源视图控制器
@property (nonatomic, retain) id sourceController;
//跳转目标视图控制器
@property (nonatomic, retain) id destinationController;
//是否动画
@property (nonatomic) BOOL animated;

//源控制器初始化query，需要调用query初始化方法，对于shareMode的视图控制器只在第一次调用时有效，用于传递运行时参数
@property (nonatomic,retain) NSDictionary* sourceQuery;
//目标控制器初始化query
@property (nonatomic,retain) NSDictionary* destinationQuery;


- (void)perform;

@end
