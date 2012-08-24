//
//  HDTableItemMaker.h
//  HDMobileBusiness
//
//  Created by Plato on 8/23/12.
//  Copyright (c) 2012 hand. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HDDateMaker;

@interface HDTableItemMaker : NSObject

@property(nonatomic,copy) NSString * itemClassName;
@property(nonatomic,copy) NSString * title;
@property(nonatomic,copy) NSString * text;
@property(nonatomic,retain) HDDateMaker * timestamp;
@property(nonatomic,copy) NSString * caption;


-(TTTableItem *) itemWithQuery:(NSDictionary *) query;

@end

@interface HDDateMaker : NSObject

@property(nonatomic,copy)NSString * format;
@property(nonatomic,copy)NSString * dateString;

-(NSDate *)date;

@end