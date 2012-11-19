//
//  HDBeanFactory.h
//  Three20Lab
//
//  Created by Plato on 11/16/12.
//  Copyright (c) 2012 hand. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    HDObjectModeCreate,            // a new view controller is created each time
    HDObjectModeShare,             // a new view controller is created, cached and re-used
} HDObjectMode;

@interface HDObjectPattern : NSObject

//-(id)createObject;

+(id)patternWithURL:(NSString *) url propertyValues:(NSDictionary *) values propertyRefBeans:(NSDictionary *) beans objectMode:(NSInteger) mode;

@property(nonatomic,readonly) NSDictionary * values;
@property(nonatomic,readonly) NSDictionary * beans;
@property(nonatomic,readonly) NSString * url;
@property(nonatomic,readonly) NSInteger objectMode;

@end
