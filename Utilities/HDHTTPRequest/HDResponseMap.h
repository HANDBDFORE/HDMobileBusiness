//
//  HDResponseMap.h
//  HDMobileBusiness
//
//  Created by Plato on 8/15/12.
//  Copyright (c) 2012 hand. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HDResponseMap : NSObject

@property(nonatomic,retain) NSDictionary * result;

@property(nonatomic,retain) NSError * error;

@property (nonatomic, retain) NSDictionary * userInfo;

@property (nonatomic,copy) NSString * urlPath;

+(id)map;

@end