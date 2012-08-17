//
//  HDCoreStorage.h
//  HDMobileBusiness
//
//  Created by Plato on 8/7/12.
//  Copyright (c) 2012 hand. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HDSQLCenter.h"

@interface HDCoreStorage : NSObject

+(id)shareStorage;

-(id)query:(SEL) handler conditions:(id) conditions;

-(BOOL)excute:(SEL) handler recordSet:(id) recordSet;

@end
