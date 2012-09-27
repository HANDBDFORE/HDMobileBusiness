//
//  HDConfig.h
//  HDMobileBusiness
//
//  Created by Plato on 9/25/12.
//  Copyright (c) 2012 hand. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HDConfig <NSObject>

@property(nonatomic,copy) NSString * propertyKey;

@property(nonatomic,retain) id propertyValue;

+(id<HDConfig>)configWithKey:(NSString *) key value:(id) value;

-(id)initWithKey:(NSString *) key value:(id)value;

-(NSDictionary *)createPropertyDictionary;

-(void)addSubConfig:(id<HDConfig>)configObject;


@end
