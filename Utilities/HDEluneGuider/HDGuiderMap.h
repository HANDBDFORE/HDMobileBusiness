//
//  HDViewControllerMap.h
//  Three20GitCoreDataLab
//
//  Created by Rocky Lee on 6/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HDGuiderMap : NSObject

//实际创建view controller的路径
@property (nonatomic,copy) NSString * urlPath;

//重定向的路径，根据配置不同，使用modal，share，create方式打开
//@property (nonatomic,copy) NSString * redirectPath;

//
@property (nonatomic, retain) NSDictionary * propertyDictionary;

//-(id)propertyForkey:(NSString *)key query:(NSDictionary *) query;
@property (nonatomic,assign) BOOL shouldConfigWithQuery;

@end

//@protocol propertyMap <NSObject>

//-(id)propertyValueWithQuery;

//@end