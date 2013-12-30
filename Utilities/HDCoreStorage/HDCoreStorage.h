//
//  HDCoreStorage.h
//  HDMobileBusiness
//
//  Created by Plato on 8/7/12.
//  Copyright (c) 2012 hand. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HDSQLCenter.h"
#import "../HDSingletonObject.h"

@interface HDCoreStorage : HDSingletonObject

+(id)shareStorage;

-(NSArray*)query:(SEL) handler conditions:(NSDictionary *) conditions;

-(BOOL)excute:(SEL) handler recordList:(NSArray *) recordList;

@end
