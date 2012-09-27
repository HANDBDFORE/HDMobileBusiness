//
//  HDConfig.h
//  HDMobileBusiness
//
//  Created by Plato on 9/25/12.
//  Copyright (c) 2012 hand. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HDConfig <NSObject>

@property(nonatomic,copy) NSString * key;

-(NSDictionary *)createPropertyDictionary;

-(void)addPropertyConfig:(id<HDConfig>)configObject;


@end
