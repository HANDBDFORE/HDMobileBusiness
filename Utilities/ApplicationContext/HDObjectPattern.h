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

@interface HDObjectPattern : NSObject <NSCopying>
//-(id)createObject;

+(id)patternWithURL:(NSString *) url propertyValues:(NSDictionary *) values propertyRefBeans:(NSDictionary *) beans objectMode:(NSInteger) mode;

@property(nonatomic,retain) NSDictionary * values;
@property(nonatomic,retain) NSDictionary * beans;
@property(nonatomic,retain) NSString * url;
@property(nonatomic,assign) NSInteger objectMode;


@end
